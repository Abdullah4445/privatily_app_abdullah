import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../logic.dart';
import 'widgets/message_bubble.dart';
import 'widgets/message_input_field.dart';
import 'widgets/common_questions.dart';
import 'widgets/date_label.dart';

class ChattingPage extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  const ChattingPage({
    Key? key,
    required this.chatRoomId,
    required this.receiverId,
    required this.receiverName,
  }) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ChattingPageLogic logic = Get.put(ChattingPageLogic());
  final TextEditingController _messageController = TextEditingController();
  final RxBool showCommonQuestions = true.obs;
  String? guestName;
  bool hasAskedName = false;
  Timer? _typingTimer;
  RxString receiverStatusText = ''.obs;

  @override
  void initState() {
    super.initState();
    _loadGuestName();
    _updateOnlineStatus(true);
    _listenToReceiverStatus();
  }

  @override
  void dispose() {
    _updateOnlineStatus(false);
    _setTyping(false);
    _typingTimer?.cancel();
    super.dispose();
  }

  Future<void> _loadGuestName() async {
    final prefs = await SharedPreferences.getInstance();
    guestName = prefs.getString('guest_name');
  }

  void _setTyping(bool isTyping) async {
    final uid = logic.myFbAuth.currentUser!.uid;
    print("Setting typing status for user $uid to $isTyping");

    try {
      // Get the current typing status from Firestore
      final docSnapshot = await logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).get();
      final typingStatus = docSnapshot.data()?['typingStatus'] as Map<String, dynamic>?;
      final currentTypingStatus = typingStatus?[uid] as bool?;

      // If the current typing status is the same as the new status, then don't update
      if (currentTypingStatus == isTyping) {
        print("Typing status is already $isTyping, not updating");
        return;
      }

      // Update the typing status in Firestore
      await logic.myFbFs
          .collection('ChatsRoomId')
          .doc(widget.chatRoomId)
          .update({'typingStatus.$uid': isTyping});

      print("Typing status updated successfully in Firestore.");
    } catch (error) {
      print("Error setting typing status: $error");
      // If 'typingStatus' map is not present on the doc, create it with the initial value
      logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set({
        'typingStatus': {uid: isTyping}
      }, SetOptions(merge: true)).then((_) {
        print("Created typingStatus map successfully");
      }).catchError((e) {
        print("Error creating typingStatus map: $e");
      });
    }
  }

  void _updateOnlineStatus(bool online) async {
    final uid = logic.myFbAuth.currentUser!.uid;
    print("Setting online status for user $uid to $online");
    try {
      await logic.myFbFs
          .collection('ChatsRoomId')
          .doc(widget.chatRoomId)
          .update({
        'onlineStatus.$uid': online,
        if (!online) 'lastSeen.$uid': Timestamp.now(), // Conditionally add lastSeen
      });
      print("Online status updated successfully");
    } catch (e) {
      print("Error updating online status: $e");
      // If 'onlineStatus' or 'lastSeen' is not present, create them with initial values.
      Map<String, dynamic> initialData = {'onlineStatus': {uid: online}};
      if (!online) {
        initialData['lastSeen'] = {uid: Timestamp.now()};
      }
      logic.myFbFs.collection('ChatsRoomId').doc(widget.chatRoomId).set(
          initialData, SetOptions(merge: true)).then((_) {
        print("Created onlineStatus and lastSeen successfully");
      }).catchError((e) {
        print("Error creating onlineStatus and lastSeen: $e");
      }); // set with merge.
    }
  }

  void _listenToReceiverStatus() {
    print("Listening to receiver status for chatRoomId: ${widget.chatRoomId}, receiverId: ${widget.receiverId}");

    logic.myFbFs
        .collection('ChatsRoomId')
        .doc(widget.chatRoomId)
        .snapshots()
        .listen((doc) {
      if (!mounted) {
        print("Widget is not mounted.  Exiting _listenToReceiverStatus.");
        return; // Check if the widget is still in the tree
      }

      final data = doc.data();
      if (data != null) {
        final onlineStatusMap = data['onlineStatus'] as Map<String, dynamic>?;
        final typingStatusMap = data['typingStatus'] as Map<String, dynamic>?;
        final lastSeenMap = data['lastSeen'] as Map<String, dynamic>?;

        final isAdminOnline = onlineStatusMap?[widget.receiverId] == true;
        final isAdminTyping = typingStatusMap?[widget.receiverId] == true;
        final lastSeenTimestamp = lastSeenMap?[widget.receiverId];

        print("Admin status data: onlineStatus=$onlineStatusMap, typingStatus=$typingStatusMap, lastSeen=$lastSeenMap");
        print("Computed values: isAdminOnline=$isAdminOnline, isAdminTyping=$isAdminTyping");

        String newStatusText = 'Offline'; // Default status

        if (isAdminTyping) {
          newStatusText = 'Typing...';
          print("Setting receiverStatusText to 'Typing...'");
        } else if (isAdminOnline) {
          newStatusText = 'Online';
          print("Setting receiverStatusText to 'Online'");
        } else if (lastSeenTimestamp != null && lastSeenTimestamp is Timestamp) {
          final dt = lastSeenTimestamp.toDate();
          final timeString = DateFormat('hh:mm a').format(dt); // Use intl for time formatting
          newStatusText = 'Last seen at $timeString';
          print("Setting receiverStatusText to 'Last seen at $timeString'");
        }

        // Only update if the status has changed
        if (receiverStatusText.value != newStatusText) {
          receiverStatusText.value = newStatusText;
        }

      } else {
        if (receiverStatusText.value != 'Offline') {
          receiverStatusText.value = 'Offline';
          print("Setting receiverStatusText to 'Offline' (no data)");// Default status when data is null
        }

      }
    }, onError: (error) {
      print("Error listening to receiver status: $error");
      if (receiverStatusText.value != 'Error') {
        receiverStatusText.value = 'Error';
        print("Setting receiverStatusText to 'Error'");// Set an error status
      }
    });
  }

  Future<void> sendWithNameCheck(String message) async {
    if (guestName == null) await _loadGuestName();

    if (guestName == null && !hasAskedName) {
      hasAskedName = true;
      final name = await showDialog<String>(
        context: context,
        builder: (context) {
          final controller = TextEditingController();
          return AlertDialog(
            title: const Text("Enter your name"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Your name"),
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () =>
                      Navigator.pop(context, controller.text.trim()),
                  child: const Text("Continue")),
            ],
          );
        },
      );

      if (name == null || name.isEmpty) {
        hasAskedName = false;
        return;
      }

      guestName = name;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('guest_name', guestName!);
      await logic.myFbFs
          .collection('ChatsRoomId')
          .doc(widget.chatRoomId)
          .set({'guestName': guestName}, SetOptions(merge: true));
    }

    await logic.sendMessage(widget.chatRoomId, widget.receiverId, message);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9FB),
      child: Column(
        children: [
          Obx(() {
            return Text(
              receiverStatusText.value,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            );
          }),

          Expanded(
            child: StreamBuilder(
              stream: logic.getMessages(widget.chatRoomId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                }

                final messages = snapshot.data ?? [];
                if (messages.isEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showCommonQuestions.value = true;
                  });
                  return const Center(child: Text("No messages yet."));
                }

                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showCommonQuestions.value = false;
                });

                return ListView.builder(
                  padding: const EdgeInsets.all(12),
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe =
                        msg.senderId == logic.myFbAuth.currentUser?.uid;
                    final current = msg.timestamp!;

                    final next = index + 1 < messages.length
                        ? messages[index + 1].timestamp
                        : null;

                    final showDate = next == null ||
                        current.day != next.day ||
                        current.month != next.month ||
                        current.year != next.year;

                    return Column(
                      children: [
                        if (showDate) DateLabel(timestamp: current),
                        MessageBubble(message: msg.messageText, isMe: isMe),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CommonQuestions(
                onSelect: sendWithNameCheck, showToggle: showCommonQuestions),
          ),
          MessageInputField(
            controller: _messageController,
            onSend: (text) async {
              if (text.trim().isNotEmpty) {
                await sendWithNameCheck(text.trim());
                _setTyping(false);
                _messageController.clear();
              }
            },
            onChanged: (text) {
              print("onChanged called. Text: $text");
              final isTyping = text.trim().isNotEmpty;

              if (isTyping) {
                _setTyping(true);
              } else {
                _setTyping(false);
              }

              _typingTimer?.cancel(); // Cancel previous timer
              _typingTimer = Timer(const Duration(seconds: 2), () {
                print("Timer fired. Setting typing to false.");
                _setTyping(false);
              });
            },
          ),
        ],
      ),
    );
  }
}