import 'package:flutter/material.dart';

class MessageInputField extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final ValueChanged<String> onChanged; // Added

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onChanged, // Added
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged, // Properly used here
              decoration: InputDecoration(
                hintText: "Type a message...",
                contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                fillColor: const Color(0xFFF2F2F5),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF4B2EDF),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => onSend(controller.text),
            ),
          )
        ],
      ),
    );
  }
}
