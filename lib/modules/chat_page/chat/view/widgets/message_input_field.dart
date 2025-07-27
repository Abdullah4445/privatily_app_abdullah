import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../logic.dart';

class MessageInputField extends StatefulWidget {
  final TextEditingController controller;
  final Function(String) onSend;
  final ValueChanged<String> onChanged;
  final String chatRoomId;
  final String receiverId;// Added

  const MessageInputField({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onChanged,
    required this.chatRoomId,

    required this.receiverId,// Added
  });

  @override
  State<MessageInputField> createState() => _MessageInputFieldState();
}

class _MessageInputFieldState extends State<MessageInputField> {
  final ChattingPageLogic logic = Get.put(ChattingPageLogic());
// ✅ Declare and initialize FocusNode
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus(); // Automatically focuses the text field
  }

  @override
  void dispose() {
    _focusNode.dispose(); // ✅ Important to prevent memory leaks
    super.dispose();
  }


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
            child: TextFormField(
              focusNode: _focusNode,
              controller: widget.controller,
              onChanged: widget.onChanged,
              textInputAction: TextInputAction.send, // 👈 Hint to show 'Send' key on keyboard
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
              onFieldSubmitted: (value) {
                String messageText = value.trim();
                if (messageText.isNotEmpty) {
                  setState(() {
                    logic.isLoading = true;
                  });
                  logic.sendMessage(
                    widget.chatRoomId,
                    widget.receiverId,
                    messageText,
                  );
                  widget.controller.clear(); // ✅ use widget.controller instead of logic.messageController
                  setState(() {
                    logic.isLoading = false;
                  });
                  _focusNode.requestFocus(); // 👈 Optional: refocus to keep typing
                }
              },
            ),
          ),

          const SizedBox(width: 8),
          CircleAvatar(
            backgroundColor: const Color(0xFF4B2EDF),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white, size: 20),
              onPressed: () => widget.onSend(widget.controller.text),
            ),
          )
        ],
      ),
    );
  }
}
