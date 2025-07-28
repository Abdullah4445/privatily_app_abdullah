import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../chatting_page/chatting_page_view.dart';
import '../models/students.dart';
import '../dashboard/dashboard_logic.dart';

class LogicadminHome extends GetxController {
  var getStudents = <Students>[].obs;

  var currentUserId;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // ✅ Global Chat Info to be used in Dashboard
  var selectedChatRoomId = ''.obs;
  var selectedReceiverId = ''.obs;
  var selectedReceiverName = ''.obs;

  Future<List<Students>> getUserOnFirebase() async {
    try {
      QuerySnapshot data = await firestore.collection("Users").get();
      for (var element in data.docs) {
        Students students =
        Students.fromJson(element.data() as Map<String, dynamic>);
        getStudents.add(students);
      }
      return getStudents;
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch users: $e");
      return [];
    }
  }

  Future<void> createChatRoomId(String otherUserId, String receiverName) async {
    try {
      if (auth.currentUser == null || otherUserId.isEmpty) {
        Get.snackbar("Error", "❌ User ID is missing!");
        return;
      }

      String currentUserId = auth.currentUser!.uid;
      String chatRoomId = currentUserId.hashCode <= otherUserId.hashCode
          ? "$currentUserId-$otherUserId"
          : "$otherUserId-$currentUserId";

      print('Creating chat room with ID: $chatRoomId');

      DocumentSnapshot chatRoomDoc =
      await firestore.collection("ChatsRoomId").doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await firestore.collection('ChatsRoomId').doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [currentUserId, otherUserId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
  Get.to(AdminChattingPage(chatRoomId: chatRoomId, receiverName: receiverName, receiverId: otherUserId));
      // ✅ Save chat data globally
      selectedChatRoomId.value = chatRoomId;
      selectedReceiverId.value = otherUserId;
      selectedReceiverName.value = receiverName;

      // ✅ ONLY navigate if all values are set
      if (selectedChatRoomId.value.isNotEmpty &&
          selectedReceiverId.value.isNotEmpty &&
          selectedReceiverName.value.isNotEmpty) {
        Get.find<AdminDashboardLogic>().selectedScreenIndex.value = 6;
      } else {
        print("❌ Some chat data is still missing");
        Get.snackbar("Error", "⚠️ Failed to open chat. Try again.");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
