import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../models/messages.dart';
import 'chatting_page_logic.dart';

class ChattingPage extends StatefulWidget {
  final String chatRoomId;
  final String receiverId;
  final String receiverName;

  const ChattingPage({
    Key? key,
    required this.chatRoomId,
    required this.receiverName,
    required this.receiverId,
  }) : super(key: key);

  @override
  State<ChattingPage> createState() => _ChattingPageState();
}

class _ChattingPageState extends State<ChattingPage> {
  final ChattingPageLogic logic = Get.put(ChattingPageLogic());
  final TextEditingController _messageController = TextEditingController();
  final RxBool showCommonQuestions = true.obs;

  @override
  void initState() {
    super.initState();
    logic.getMessages(widget.chatRoomId).listen((newMessages) {
      logic.updateMessages(newMessages);
    });
  }

  Widget buildCommonQuestions() {
    final commonQuestions = [
      "Hello 👋",
      "How are you?",
      "What are you doing?",
      "Where are you from?",
      "Can we talk?",
      "Are you available?",
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text("Common questions", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            const SizedBox(width: 8),
            Obx(() => GestureDetector(
              onTap: () => showCommonQuestions.value = !showCommonQuestions.value,
              child: Icon(
                showCommonQuestions.value ? Icons.expand_less : Icons.expand_more,
                size: 20,
                color: Colors.grey.shade700,
              ),
            )),
          ],
        ),
        const SizedBox(height: 6),
        Obx(() => showCommonQuestions.value
            ? Wrap(
          spacing: 10,
          runSpacing: 10,
          children: commonQuestions.map((question) {
            return InkWell(
              onTap: () async {
                await logic.sendMessage(widget.chatRoomId, widget.receiverId, question);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
                child: Text(question, style: const TextStyle(fontSize: 13)),
              ),
            );
          }).toList(),
        )
            : const SizedBox.shrink()),
        const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 8,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/doodles.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: Obx(() {
                  if (logic.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'No messages',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
                      ),
                    );
                  }
                  return ListView.builder(
                    reverse: true,
                    padding: const EdgeInsets.all(10),
                    itemCount: logic.messages.length,
                    itemBuilder: (context, i) {
                      Messages message = logic.messages[i];
                      bool isMe = message.senderId == logic.myFbAuth.currentUser!.uid;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(12),
                          constraints: const BoxConstraints(maxWidth: 260),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.deepPurple : Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              )
                            ],
                          ),
                          child: Text(
                            message.messageText,
                            style: TextStyle(
                              fontSize: 16,
                              color: isMe ? Colors.white : Colors.black87,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),

              // ✅ Common Questions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                child: buildCommonQuestions(),
              ),

              // ✅ Message Input
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Type a message...",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {
                        String messageText = _messageController.text.trim();
                        if (messageText.isNotEmpty) {
                          logic.sendMessage(widget.chatRoomId, widget.receiverId, messageText);
                          _messageController.clear();
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Colors.deepPurple, Colors.purpleAccent],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: const Icon(Icons.send, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
