// // chatting_page.dart
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../logic.dart';
// import 'widgets/message_bubble.dart';
// import 'widgets/message_input_field.dart';
// import 'widgets/common_questions.dart';
// import 'widgets/date_label.dart';
//
// class ChattingPage extends StatefulWidget {
//   final String chatRoomId;
//   final String receiverId;
//   final String receiverName;
//
//   const ChattingPage({
//     Key? key,
//     required this.chatRoomId,
//     required this.receiverId,
//     required this.receiverName,
//   }) : super(key: key);
//
//   @override
//   State<ChattingPage> createState() => _ChattingPageState();
// }
//
// class _ChattingPageState extends State<ChattingPage> {
//   final ChattingPageLogic logic = Get.put(ChattingPageLogic());
//   final TextEditingController _messageController = TextEditingController();
//   final RxBool showCommonQuestions = true.obs;
//   String? guestName;
//   bool hasAskedName = false;
//   Timer? _typingTimer;
//   RxBool isReceiverTyping = false.obs;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadGuestName();
//     _updateOnlineStatus(true);
//     _listenToTypingStatus();
//   }
//
//   @override
//   void dispose() {
//     _updateOnlineStatus(false);
//     _setTyping(false);
//     _typingTimer?.cancel();
//     super.dispose();
//   }
//
//   Future<void> _loadGuestName() async {
//     final prefs = await SharedPreferences.getInstance();
//     guestName = prefs.getString('guest_name');
//   }
//
//   void _setTyping(bool isTyping) {
//     logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({
//       'typingStatus': {
//         logic.myFbAuth.currentUser!.uid: isTyping,
//       }
//     }, SetOptions(merge: true));
//   }
//
//   void _updateOnlineStatus(bool online) async {
//     await logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({
//       'onlineStatus': {
//         logic.myFbAuth.currentUser!.uid: online,
//       }
//     }, SetOptions(merge: true));
//   }
//
//   void _listenToTypingStatus() {
//     logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).snapshots().listen((doc) {
//       final typingData = doc.data()?['typingStatus'];
//       if (typingData != null) {
//         final otherId = widget.receiverId;
//         isReceiverTyping.value = typingData[otherId] == true;
//       }
//     });
//   }
//
//   Future<void> sendWithNameCheck(String message) async {
//     if (guestName == null) await _loadGuestName();
//
//     if (guestName == null && !hasAskedName) {
//       hasAskedName = true;
//       final name = await showDialog<String>(
//         context: context,
//         builder: (context) {
//           final controller = TextEditingController();
//           return AlertDialog(
//             title: const Text("Enter your name"),
//             content: TextField(
//               controller: controller,
//               decoration: const InputDecoration(hintText: "Your name"),
//             ),
//             actions: [
//               TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
//               TextButton(onPressed: () => Navigator.pop(context, controller.text.trim()), child: const Text("Continue")),
//             ],
//           );
//         },
//       );
//
//       if (name == null || name.isEmpty) {
//         hasAskedName = false;
//         return;
//       }
//
//       guestName = name;
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('guest_name', guestName!);
//       await logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({'guestName': guestName}, SetOptions(merge: true));
//     }
//
//     await logic.sendMessage(widget.chatRoomId, widget.receiverId, message);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: const Color(0xFFF9F9FB),
//       child: Column(
//         children: [
//           Obx(() => isReceiverTyping.value
//               ? const Padding(
//             padding: EdgeInsets.only(top: 6, bottom: 4),
//             child: Text("Typing...", style: TextStyle(fontStyle: FontStyle.italic)),
//           )
//               : const SizedBox.shrink()),
//           Expanded(
//             child: StreamBuilder(
//               stream: logic.getMessages(widget.chatRoomId),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text("Error: ${snapshot.error}"));
//                 }
//
//                 final messages = snapshot.data ?? [];
//                 if (messages.isEmpty) {
//                   WidgetsBinding.instance.addPostFrameCallback((_) {
//                     showCommonQuestions.value = true;
//                   });
//                   return const Center(child: Text("No messages yet."));
//                 }
//
//                 WidgetsBinding.instance.addPostFrameCallback((_) {
//                   showCommonQuestions.value = false;
//                 });
//
//                 return ListView.builder(
//                   padding: const EdgeInsets.all(12),
//                   reverse: true,
//                   itemCount: messages.length,
//                   itemBuilder: (context, index) {
//                     final msg = messages[index];
//                     final isMe = msg.senderId == logic.myFbAuth.currentUser?.uid;
//                     final current = msg.timestamp!;
//                     final next = index + 1 < messages.length ? messages[index + 1].timestamp : null;
//
//                     final showDate = next == null ||
//                         current.day != next.day ||
//                         current.month != next.month ||
//                         current.year != next.year;
//
//                     return Column(
//                       children: [
//                         if (showDate) DateLabel(timestamp: current),
//                         MessageBubble(message: msg.messageText, isMe: isMe),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: CommonQuestions(onSelect: sendWithNameCheck, showToggle: showCommonQuestions),
//           ),
//           MessageInputField(
//             controller: _messageController,
//             onSend: (text) async {
//               if (text.trim().isNotEmpty) {
//                 await sendWithNameCheck(text.trim());
//                 _setTyping(false);
//                 _messageController.clear();
//               }
//             },
//             onChanged: (text) {
//               _setTyping(true);
//               _typingTimer?.cancel();
//               _typingTimer = Timer(const Duration(seconds: 2), () {
//                 _setTyping(false);
//               });
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
// is code ka hisb sa
// import 'package:admin_privatily/chatting_page/widgets/chat_bubble.dart';
// import 'package:admin_privatily/chatting_page/widgets/date_header.dart';
// import 'package:admin_privatily/chatting_page/widgets/message_input_field.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
//
// import '../models/messages.dart';
// import 'chatting_page_logic.dart';
//
// class ChattingPage extends StatefulWidget {
//   final String chatRoomId;
//   final String receiverId;
//   final String receiverName;
//
//   const ChattingPage({
//     Key? key,
//     required this.chatRoomId,
//     required this.receiverName,
//     required this.receiverId,
//   }) : super(key: key);
//
//   @override
//   State<ChattingPage> createState() => _ChattingPageState();
// }
//
// class _ChattingPageState extends State<ChattingPage> {
//   final ChattingPageLogic logic = Get.put(ChattingPageLogic());
//   final TextEditingController _messageController = TextEditingController();
//   final RxBool isReceiverTyping = false.obs;
//   bool isLoading = false;
//   Timer? _typingTimer;
//
//   @override
//   void initState() {
//     super.initState();
//     logic.getMessages(widget.chatRoomId).listen((newMessages) {
//       logic.updateMessages(newMessages);
//     });
//     _updateOnlineStatus(true);
//     _listenToChatStatus();
//   }
//
//   @override
//   void dispose() {
//     _updateOnlineStatus(false);
//     _setTyping(false);
//     _typingTimer?.cancel();
//     super.dispose();
//   }
//
//   void _updateOnlineStatus(bool online) {
//     logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({
//       'onlineStatus': {
//         logic.myFbAuth.currentUser!.uid: online,
//       }
//     }, SetOptions(merge: true));
//   }
//
//   void _setTyping(bool isTyping) {
//     logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({
//       'typingStatus': {
//         logic.myFbAuth.currentUser!.uid: isTyping,
//       }
//     }, SetOptions(merge: true));
//   }
//
//   void _listenToChatStatus() {
//     logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).snapshots().listen((doc) {
//       final data = doc.data();
//       if (data != null) {
//         final typingData = data['typingStatus'];
//         final onlineData = data['onlineStatus'];
//
//         if (typingData != null && typingData is Map) {
//           isReceiverTyping.value = typingData[widget.receiverId] == true;
//         }
//
//         if (onlineData != null && onlineData is Map) {
//           logic.receiverOnlineStatus.value = onlineData[widget.receiverId] == true;
//         }
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.receiverName, style: const TextStyle(color: Colors.white)),
//             Obx(() {
//               final typing = isReceiverTyping.value;
//               final onlineStatus = logic.receiverOnlineStatus.value;
//               String subtitle = '';
//
//               if (typing) {
//                 subtitle = 'Typing...';
//               } else if (onlineStatus) {
//                 subtitle = 'Online';
//               } else {
//                 subtitle = 'Offline';
//               }
//
//               return Text(
//                 subtitle,
//                 style: const TextStyle(fontSize: 12, color: Colors.white70),
//               );
//             }),
//           ],
//         ),
//         backgroundColor: Colors.deepPurple,
//       ),
//       body: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: Obx(() {
//                   final messages = logic.messages;
//                   if (messages.isEmpty) {
//                     return const Center(child: Text('No messages'));
//                   }
//
//                   return ListView.builder(
//                     reverse: true,
//                     itemCount: messages.length,
//                     itemBuilder: (context, index) {
//                       final message = messages[index];
//                       final isMe = message.senderId == logic.myFbAuth.currentUser?.uid;
//                       final showDateHeader = index == messages.length - 1 ||
//                           message.timestamp!.day != messages[index + 1].timestamp!.day;
//                       return Column(
//                         children: [
//                           if (showDateHeader) DateHeader(date: message.timestamp!),
//                           ChatBubble(message: message, isMe: isMe),
//                         ],
//                       );
//                     },
//                   );
//                 }),
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: MessageInputField(
//                   controller: _messageController,
//                   onSendPressed: () {
//                     final text = _messageController.text.trim();
//                     if (text.isNotEmpty) {
//                       setState(() => isLoading = true);
//                       logic.sendMessage(widget.chatRoomId, widget.receiverId, text);
//                       _setTyping(false);
//                       _messageController.clear();
//                       setState(() => isLoading = false);
//                     }
//                   },
//                   onImagePressed: () async {
//                     setState(() => isLoading = true);
//                     await logic.pickImage(widget.chatRoomId, widget.receiverId);
//                     setState(() => isLoading = false);
//                   },
//                   onChanged: (text) {
//                     _setTyping(true);
//                     _typingTimer?.cancel();
//                     _typingTimer = Timer(const Duration(seconds: 2), () {
//                       _setTyping(false);
//                     });
//                   },
//                 ),
//               ),
//             ],
//           ),
//           if (isLoading) const Center(child: CircularProgressIndicator()),
//         ],
//       ),
//     );
//   }
// }