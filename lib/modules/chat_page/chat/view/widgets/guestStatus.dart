import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:privatily_app/modules/chat_page/chat/view/widgets/typing_indicator.dart';
import 'package:privatily_app/modules/chat_page/chat/view/widgets/variables/globalVariables.dart';

class AdminStatus extends StatelessWidget {
  final String adminUserId;

  const AdminStatus({Key? key, required this.adminUserId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
        .collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus")
          .doc(adminUserId)
          .snapshots(),
      builder: (context, snapshot) {
        // Debug log
        print("StreamBuilder snapshot: ${snapshot.data?.data()}");

        if (snapshot.hasData && snapshot.data!.exists) {
          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final isOnline = userData['isOnline'] ?? false;
          final isTyping = userData['isTyping'] ?? false;
          final lastSeen = userData['lastSeen'] as Timestamp?;

          if (isTyping) {
            return const TypingIndicator(); // ✅ Animated typing effect
          } else if (isOnline) {
            return const Text(
              "Admin is Online",
              style: TextStyle(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            );
          } else {
            if (lastSeen != null) {
              DateTime dateTime = lastSeen.toDate();
              String formattedDate =
              DateFormat('dd/MM/yyyy hh:mm a').format(dateTime);
              return Text(
                "Admin last seen: $formattedDate",
                style: const TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              );
            } else {
              return const Text(
                "Admin is Offline",
                style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
              );
            }
          }
        } else {
          return const Text(
            "Loading admin status...",
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
          );
        }
      },
    );
  }
}
