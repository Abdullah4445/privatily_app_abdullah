import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../models/messages.dart';

class ChattingPageLogic extends GetxController {
  var messages = <Messages>[].obs;
  final FirebaseFirestore myFbFs = FirebaseFirestore.instance;
  final FirebaseAuth myFbAuth = FirebaseAuth.instance;

  // ✅ Send Message to ChatsRoomId → chatRoomId → Messages
  Future<void> sendMessage(String chatRoomId, String receiverId, String messageText) async {
    try {
      String senderId = myFbAuth.currentUser!.uid;
      await myFbFs
          .collection('ChatsRoomId') // 🔁 Updated path
          .doc(chatRoomId)
          .collection('Messages')
          .add({
        'senderId': senderId,
        'messageText': messageText,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  // ✅ Get Messages from ChatsRoomId → chatRoomId → Messages
  Stream<List<Messages>> getMessages(String chatRoomId) {
    return myFbFs
        .collection('ChatsRoomId') // 🔁 Updated path
        .doc(chatRoomId)
        .collection('Messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Messages.fromJson(doc.data(), doc.id))
        .toList());
  }

  void updateMessages(List<Messages> newMessages) {
    messages.value = newMessages;
  }
}
