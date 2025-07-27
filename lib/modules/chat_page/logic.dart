import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/messages.dart';
import 'chat/view/widgets/variables/globalVariables.dart';

class ChattingPageLogic extends GetxController {
  final TextEditingController messageController = TextEditingController();
 bool  isLoading = false;
  var messages = <Messages>[].obs;
  final FirebaseFirestore myFbFs = FirebaseFirestore.instance;
  final FirebaseAuth myFbAuth = FirebaseAuth.instance;

  // ✅ Send Message to chatoom → chatRoomId → Messages
  Future<void> sendMessage(String chatRoomId, String receiverId, String messageText) async {
    print("sendMessage called with chatRoomId: $chatRoomId, messageText: $messageText");
    try {
      String senderId = myFbAuth.currentUser!.uid;
      print("Sender ID: $senderId");
      print("Receiver ID: $receiverId");

      DocumentSnapshot userDoc = await myFbFs.collection('Users').doc(senderId).get();
      String name = (userDoc.data() as Map<String, dynamic>)['name'] ?? 'Unknown User';
      print("Sender Name: $name");

      DocumentReference chatRoomRef = myFbFs.collection('ChatsRoomId').doc(chatRoomId);
      DocumentSnapshot chatRoomDoc = await chatRoomRef.get();
      print("Chat Room Exists: ${chatRoomDoc.exists}");

      if (!chatRoomDoc.exists) { //Fix - used ! instead of chatRoomDoc.exists
        print("Creating new chat room: $chatRoomId");
        await chatRoomRef.set({
          'id': senderId,
          'chatRoomId': chatRoomId,
          'participants': [senderId, receiverId],
          'createdAt': FieldValue.serverTimestamp(),
          'name': name
        });
        print("Chat room created successfully.");
      }

      print("Adding message to chat room: $chatRoomId");
      await myFbFs
          .collection('ChatsRoomId')
          .doc(chatRoomId)
          .collection('Messages')
          .add({
        'senderId': senderId,
        'messageText': messageText,
        'receiverId': receiverId,
        'timestamp': FieldValue.serverTimestamp(),
        'isSeen': false, // Set to false when sending the message
        'isDelivered': false, // Set to false when sending the message
      });
      print("Message added successfully.");

    } catch (e) {
      print("Error sending message: $e");
      Get.snackbar('Error', 'Failed to send message: $e');
    }
  }

  // ✅ Get Messages from chatoom → chatRoomId → Messages
  Stream<List<Messages>> getMessages(String chatRoomId) {
    return myFbFs
        .collection('ChatsRoomId')
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

  Future<void> markMessageAsSeen(String chatRoomId, String messageId) async {
    try {
      await myFbFs
          .collection('ChatsRoomId')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({'isSeen': true});
      print("Message $messageId marked as seen in chat room $chatRoomId");
    } catch (e) {
      print("Error marking message as seen: $e");
      Get.snackbar('Error', 'Failed to mark message as seen: $e');
    }
  }

  Future<void> markMessageAsDelivered(String chatRoomId, String messageId) async {
    try {
      await myFbFs
          .collection('ChatsRoomId')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(messageId)
          .update({'isDelivered': true});
      print("Message $messageId marked as delivered in chat room $chatRoomId");
    } catch (e) {
      print("Error marking message as delivered: $e");
      Get.snackbar('Error', 'Failed to mark message as delivered: $e');
    }
  }

  Future<void> markMessagesAsRead(String chatRoomId, String currentUserId) async {
    WriteBatch batch = FirebaseFirestore.instance.batch();

    QuerySnapshot unreadMessages = await FirebaseFirestore.instance
        .collection('ChatsRoomId')
        .doc(chatRoomId)
        .collection('Messages')
        .where('receiverId', isEqualTo: currentUserId)
        .where('isSeen', isEqualTo: false)
        .get();

    unreadMessages.docs.forEach((doc) {
      DocumentReference docRef = FirebaseFirestore.instance
          .collection('ChatsRoomId')
          .doc(chatRoomId)
          .collection('Messages')
          .doc(doc.id);

      batch.update(docRef, {'isSeen': true});
    });

    await batch.commit();
  }

  // setUserOffline, didChangeAppLifecycleState, setTypingStatus, setUserOnline functions - NO CHANGES NEEDED HERE (unless you want to also change collection name here)
  Future<void> setUserOffline() async {
    final user = myFbAuth.currentUser;
    if (user != null) {
      await myFbFs.collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus").doc(user.uid).set({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  void setTypingStatus(bool isTyping) async {
    final user = myFbAuth.currentUser;
    if (user != null) {
      print("setTypingStatus called with isTyping: $isTyping");
      await myFbFs.collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus").doc(user.uid).set({
        'isTyping': isTyping,
      }, SetOptions(merge: true));
    }
  }
}