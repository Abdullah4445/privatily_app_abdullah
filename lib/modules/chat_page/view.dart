// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../../widgets/myProgressIndicator.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'logic.dart';
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
//   final TextEditingController _messageController = TextEditingController();
//   final ChattingPageLogic logic = Get.put(ChattingPageLogic());
//   final RxBool showCommonQuestions = true.obs;
//
//   String? guestName;
//   bool hasAskedName = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadGuestName();
//   }
//
//   Future<void> _loadGuestName() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     guestName = prefs.getString('guest_name');
//   }
//
//   Widget buildCommonQuestions() {
//     final commonQuestions = [
//       "Hello",
//       "How are you?",
//       "What are you doing?",
//       "Where are you from?",
//       "Can we talk?",
//       "Are you available?",
//     ];
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             const Text("Common questions", style: TextStyle(fontWeight: FontWeight.bold)),
//             const SizedBox(width: 8),
//             Obx(() => GestureDetector(
//               onTap: () => showCommonQuestions.value = !showCommonQuestions.value,
//               child: Icon(
//                 showCommonQuestions.value ? Icons.expand_less : Icons.expand_more,
//                 size: 20,
//                 color: Colors.grey.shade700,
//               ),
//             )),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Obx(() => showCommonQuestions.value
//             ? Wrap(
//           spacing: 10,
//           runSpacing: 10,
//           children: commonQuestions.map((question) {
//             return InkWell(
//               onTap: () async {
//                 await sendWithNameCheck(question);
//               },
//               borderRadius: BorderRadius.circular(30),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(color: Colors.grey.shade300),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.grey.withOpacity(0.1),
//                       blurRadius: 5,
//                       offset: const Offset(0, 2),
//                     )
//                   ],
//                 ),
//                 child: Text(question, style: const TextStyle(fontSize: 13)),
//               ),
//             );
//           }).toList(),
//         )
//             : const SizedBox.shrink()),
//       ],
//     );
//   }
//
//   Future<void> sendWithNameCheck(String message) async {
//     if (guestName == null) await _loadGuestName();
//
//     if (guestName == null && !hasAskedName) {
//       hasAskedName = true;
//
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
//               TextButton(
//                   onPressed: () => Navigator.pop(context, controller.text.trim()),
//                   child: const Text("Continue")),
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
//
//       // ✅ Save guest name in ChatsRoomId doc
//       await logic.myFbFs
//           .collection('ChatsRoomId')
//           .doc(widget.chatRoomId)
//           .set({'guestName': guestName}, SetOptions(merge: true));
//
//       // ✅ Save locally
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.setString('guest_name', guestName!);
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
//
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
//                     final messageDate = msg.timestamp!;
//                     bool showDateHeader = false;
//                     if (index == messages.length - 1) {
//                       showDateHeader = true;
//                     } else {
//                       final nextMessageDate =
//                       messages[index + 1].timestamp!;
//                       showDateHeader =
//                           messageDate.day != nextMessageDate.day ||
//                               messageDate.month != nextMessageDate.month ||
//                               messageDate.year != nextMessageDate.year;
//                     }
//
//                     String getDateLabel(DateTime date) {
//                       final now = DateTime.now();
//                       final today = DateTime(
//                         now.year,
//                         now.month,
//                         now.day,
//                       );
//                       final yesterday = today.subtract(
//                         const Duration(days: 1),
//                       );
//                       final messageDay = DateTime(
//                         date.year,
//                         date.month,
//                         date.day,
//                       );
//                       if (messageDay == today) return "Today";
//                       if (messageDay == yesterday) return "Yesterday";
//                       return DateFormat('MMMM d, yyyy').format(date);
//                     }
//                     return Column(
//                       children: [
//                         if (showDateHeader)
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                               vertical: 8.0,
//                             ),
//                             child: Text(
//                               getDateLabel(messageDate),
//                               style: const TextStyle(
//                                 fontSize: 13,
//                                 color: Colors.grey,
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ),
//                         Align(
//                           alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(vertical: 5),
//                             padding: const EdgeInsets.all(12),
//                             constraints: const BoxConstraints(maxWidth: 260),
//                             decoration: BoxDecoration(
//                               color: isMe ? const Color(0xFF4B2EDF) : Colors.white,
//                               borderRadius: BorderRadius.circular(16),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.05),
//                                   blurRadius: 6,
//                                   offset: const Offset(0, 2),
//                                 )
//                               ],
//                             ),
//                             child: Text(
//                               msg.messageText,
//                               style: TextStyle(
//                                 color: isMe ? Colors.white : Colors.black87,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ],
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 12.0),
//             child: buildCommonQuestions(),
//           ),
//           Container(
//             padding: const EdgeInsets.all(12),
//             decoration: const BoxDecoration(
//               color: Colors.white,
//               border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _messageController,
//                     decoration: InputDecoration(
//                       hintText: "Type a message...",
//                       contentPadding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//                       fillColor: const Color(0xFFF2F2F5),
//                       filled: true,
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(25),
//                         borderSide: BorderSide.none,
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 CircleAvatar(
//                   backgroundColor: const Color(0xFF4B2EDF),
//                   child: IconButton(
//                     icon: const Icon(Icons.send, color: Colors.white, size: 20),
//                     onPressed: () async {
//                       String text = _messageController.text.trim();
//                       if (text.isNotEmpty) {
//                         await sendWithNameCheck(text);
//                         _messageController.clear();
//                       }
//                     },
//                   ),
//                 )
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }