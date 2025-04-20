import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ToAdminChat extends StatefulWidget {
  const ToAdminChat({Key? key}) : super(key: key);

  @override
  State<ToAdminChat> createState() => _ToAdminChatState();
}

class _ToAdminChatState extends State<ToAdminChat> {
  bool _open = false;
  final _questionSuggestions = [
    'chat_suggestion_website'.tr,
    'chat_suggestion_migrate'.tr,
    'chat_suggestion_plan'.tr,
  ];
  final _inputController = TextEditingController();

  void _toggleOpen() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: 320,
      height: 420,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 20),
        ],
      ),
      child: Scaffold(
        body: Column(
          children: [
            // Header bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'chat_title'.tr,
                      style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: _toggleOpen,
                  ),
                ],
              ),
            ),

            // Suggestions
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _questionSuggestions.map((q) {
                    return ActionChip(
                      label: Text(q, style: const TextStyle(color: Colors.deepPurple)),
                      backgroundColor: const Color(0xFFF1F1FF),
                      onPressed: () {
                        print('User tapped suggestion: $q');
                      },
                    );
                  }).toList(),
                ),
              ),
            ),

            // Input field
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _inputController,
                      decoration: InputDecoration(
                        hintText: 'chat_input_hint'.tr,
                        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                        filled: true,
                        fillColor: const Color(0xFFF3F6FD),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: Colors.deepPurple,
                    borderRadius: BorderRadius.circular(8),
                    child: InkWell(
                      onTap: () {
                        final text = _inputController.text.trim();
                        if (text.isNotEmpty) {
                          print('Send user message: $text');
                          _inputController.clear();
                        }
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.send, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
