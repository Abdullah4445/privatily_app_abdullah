import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:privatily_app/modules/chat_page/chat/view/widgets/guestStatus.dart';
import 'package:privatily_app/modules/chat_page/chat/view/widgets/msgAnim_Icon.dart';
import 'package:privatily_app/modules/chat_page/chat/view/widgets/variables/globalVariables.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../../firebase_utils.dart';
import '../../../../models/messages.dart';
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

class _ChattingPageState extends State<ChattingPage> with WidgetsBindingObserver {
  final ChattingPageLogic logic = Get.put(ChattingPageLogic());
  final RxBool showCommonQuestions = true.obs;
  String? guestName;

  Timer? _typingTimer;
  final _firestore = FirebaseFirestore.instance; // Keep this if used elsewhere, otherwise it's redundant here.

  @override
  void initState() {
    super.initState();
    globalChatRoomId = widget.chatRoomId;
    WidgetsBinding.instance.addObserver(this);
    setUserOnline(globalChatRoomId);

    // Call _loadMessages to set up the stream listener
    _loadMessages();

    // IMPORTANT: Mark all unread messages as seen when the chat page is opened
    // This ensures that as soon as the user enters the chat, messages meant for them are marked as read.
    _markAllUnreadMessagesAsSeen();
  }

  @override
  void dispose() {
    logic.setUserOffline();
    WidgetsBinding.instance.removeObserver(this);
    _typingTimer?.cancel();
    Get.delete<ChattingPageLogic>();
    super.dispose();
  }

  // Load messages from the database and handle delivery/seen status
  void _loadMessages() {
    logic.getMessages(widget.chatRoomId).listen((newMessages) {
      // Update the messages list in the logic controller
      logic.updateMessages(newMessages);

      // After updating the messages, process them for delivery and seen status
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentUserId = FirebaseAuth.instance.currentUser?.uid;
        if (currentUserId == null) return; // Ensure current user is logged in

        for (var message in newMessages) {
          // Mark messages as delivered if they are for the current user and not yet delivered
          if (message.receiverId == currentUserId && !message.isDelivered) {
            logic.markMessageAsDelivered(widget.chatRoomId, message.id);
          }
        }
        // After processing delivery, also mark all unread messages as seen
        // This handles cases where new messages arrive while the user is already on the screen.
        _markAllUnreadMessagesAsSeen();
      });
    });
  }

  // Helper function to mark all unread messages for the current user as seen
  Future<void> _markAllUnreadMessagesAsSeen() async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId != null) {
      await logic.markMessagesAsRead(widget.chatRoomId, currentUserId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9FB),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AdminStatus(adminUserId: widget.receiverId),
          ),
          Expanded(
            child: StreamBuilder<List<Messages>>( // Explicitly define type for clarity
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
                  reverse: true, // Show latest messages at the bottom
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isMe = msg.senderId == FirebaseAuth.instance.currentUser?.uid;

                    // Ensure timestamp is not null before formatting
                    final String formattedTime = msg.timestamp != null
                        ? DateFormat('hh:mm a').format(msg.timestamp!)
                        : DateFormat('hh:mm a').format(DateTime.now()); // Fallback to current time

                    return Column(
                      children: [
                        // Show date label only if the date changes from the previous message
                        if (showDate(msg, index, messages)) DateLabel(timestamp: msg.timestamp!),
                        MessageBubble(
                          message: msg.messageText,
                          isMe: isMe,
                          messagetime: formattedTime,
                          isDelivered: msg.isDelivered,
                          isSeen: msg.isSeen,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          MsgAnimIcon(guestUserId: widget.receiverId),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: CommonQuestions(
              onSelect: (String message) {
                logic.sendMessage(widget.chatRoomId, widget.receiverId, message);
              },
              showToggle: showCommonQuestions,
            ),
          ),
          MessageInputField(
            controller: logic.messageController,
            onSend: (text) async {
              if (text.trim().isNotEmpty) {
                await logic.sendMessage(widget.chatRoomId, widget.receiverId, text.trim());
                logic.messageController.clear();
              }
            },
            onChanged: (text) {
              final isTyping = text.trim().isNotEmpty;
              print("onChanged called. text: '$text', isTyping: $isTyping");

              logic.setTypingStatus(isTyping);

              if (_typingTimer != null && _typingTimer!.isActive) {
                print("Timer cancelled");
                _typingTimer!.cancel();
              }

              if (isTyping) {
                _typingTimer = Timer(const Duration(seconds: 1), () {
                  print("Timer expired, setting isTyping to false");
                  logic.setTypingStatus(false);
                });
              } else {
                print("Text field is empty");
              }
            }, chatRoomId: widget.chatRoomId, receiverId: widget.receiverId,
          ),
          if (logic.isLoading) const Center(child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  // Helper function to determine if a date label should be shown
  bool showDate(Messages msg, int index, List<Messages> messages) {
    // If timestamp is null, treat it as now for comparison, though ideally it should always be present.
    final current = msg.timestamp ?? DateTime.now();
    // Check if there's a next message and its timestamp
    final next = index + 1 < messages.length ? messages[index + 1].timestamp : null;

    // Show date if it's the last message (no next message) or if the date changes from the next message
    return next == null ||
        current.day != next.day ||
        current.month != next.month ||
        current.year != next.year;
  }
}
