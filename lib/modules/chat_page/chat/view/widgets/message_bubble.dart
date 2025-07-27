import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final String messagetime;
  final bool isDelivered; // Track if message is delivered
  final bool isSeen; // Track if message is seen

  const MessageBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.messagetime,
    required this.isDelivered,
    required this.isSeen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5),
        padding: const EdgeInsets.all(12),
        constraints: const BoxConstraints(maxWidth: 260),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFF4B2EDF) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Flexible(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 260 - (12 * 2) - 30,
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: isMe ? Colors.white : Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 5),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  messagetime,
                  style: TextStyle(
                    fontSize: 9,
                    color: isMe ? Colors.white70 : Colors.grey[600],
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (isMe) // Display read receipt only for the sender
                  _buildReadReceiptIcon(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReadReceiptIcon() {
    if (!isDelivered) {
      return Icon(
        Icons.check, // Single tick
        size: 12,
        color: Colors.white70,
      );
    } else if (!isSeen) {
      return Icon(
        Icons.done_all, // Double tick
        size: 12,
        color: Colors.white70,
      );
    } else {
      return Icon(
        Icons.done_all, // Double tick filled
        size: 12,
        color: Colors.blue[400],
      );
    }
  }
}