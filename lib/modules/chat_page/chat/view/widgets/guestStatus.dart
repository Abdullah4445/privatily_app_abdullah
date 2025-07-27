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
          // Debug logs for extracted values
          print("AdminStatus: isOnline = $isOnline");
          print("AdminStatus: isTyping = $isTyping");
          print("AdminStatus: lastSeen (Timestamp) = $lastSeen");

          if (isTyping) {
            // If admin is typing, show typing indicator.
            return const TypingIndicator();
          } else if (isOnline) {
            // If admin is online (and not typing), show "Online".
            return const Text(
              "Online",
              style: TextStyle(
                color: Colors.green,
                fontStyle: FontStyle.italic,
              ),
            );
          } else {
            // This 'else' block is reached ONLY IF:
            // 1. isTyping is false
            // 2. AND isOnline is false
            // This means the admin is OFFLINE.

            if (lastSeen != null) {
              // If admin is offline AND lastSeen data is available,
              // then format and display the "Admin last seen: [time]" message.
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
              // If admin is offline AND lastSeen data is NOT available (null),
              // then display "Admin is Offline".
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
