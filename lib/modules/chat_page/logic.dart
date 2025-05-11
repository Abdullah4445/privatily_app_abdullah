import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../firebase_utils.dart';
import '../../models/messages.dart';
import 'chat/view/widgets/variables/globalVariables.dart';

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

  Future<void> setUserOffline() async {
    final user = myFbAuth.currentUser;
    if (user != null) {
      await myFbFs.collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus").doc(user.uid).set({
        'isOnline': false,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setUserOnline(globalChatRoomId);
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      setUserOffline();
    }
  }
  void setTypingStatus(bool isTyping) async {
    final user = myFbAuth.currentUser;
    if (user != null) {
      print("setTypingStatus called with isTyping: $isTyping"); //ADDED
      await myFbFs.collection('ChatsRoomId').doc(globalChatRoomId).collection("usersStatus").doc(user.uid).set({
        'isTyping': isTyping,
      }, SetOptions(merge: true));
    }
  }
  // Future<void> setUserOnline() async {
  //   final user = FirebaseAuth.instance.currentUser;
  //   if (user != null) {
  //     try {
  //       await myFbFs.collection('users').doc(user.uid).set({
  //         'isOnline': true,
  //         'lastSeen': FieldValue.serverTimestamp(),
  //       }, SetOptions(merge: true));
  //       print("User ${user.uid} set to online");
  //     } catch (e) {
  //       print("Error setting user online: $e");
  //     }
  //   } else {
  //     print("No user logged in, cannot set online status.");
  //   }
  // }


}
//2891627 0308