import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';


class HomeLogic extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Admin Config
  final String fixedAdminId = 'bnS6fNg9srhKktTSufF2AA9tdQZ2';
  final String adminName = 'Admin';

  // Chat Popup Reactive States
  var showChatScreen = false.obs;
  var chatRoomIdForPopup = ''.obs;
  var receiverIdForPopup = ''.obs;
  var receiverNameForPopup = ''.obs;

  // 🔁 Initialize chat between guest & admin
  Future<void> initGuestChat() async {
    try {
      // Anonymous login if not already
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }

      final guestId = auth.currentUser!.uid;
      final adminId = fixedAdminId;

      // Create guest user in Firestore
      await _createGuestUser(guestId);

      // Consistent chatRoomId
      String chatRoomId = guestId.hashCode <= adminId.hashCode
          ? "$guestId-$adminId"
          : "$adminId-$guestId";

      // Create chatRoom if not exists
      DocumentSnapshot chatRoomDoc =
      await firestore.collection("ChatsRoomId").doc(chatRoomId).get();

      if (!chatRoomDoc.exists) {
        await firestore.collection("ChatsRoomId").doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [guestId, adminId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // Set reactive state for popup
      chatRoomIdForPopup.value = chatRoomId;
      receiverIdForPopup.value = adminId;
      receiverNameForPopup.value = adminName;
      showChatScreen.value = true;
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
    }
  }

  // Create guest user in Firestore under "Guests" collection
  Future<void> _createGuestUser(String guestId) async {
    try {
      DocumentSnapshot guestDoc = await firestore.collection("Guests").doc(guestId).get();

      // If the guest user does not exist, create a new document
      if (!guestDoc.exists) {
        await firestore.collection("Guests").doc(guestId).set({
          'name': 'Guest $guestId',  // You can replace this with the actual guest name
          'id': guestId,
          'createdAt': FieldValue.serverTimestamp(),  // Use the server timestamp
        });
        print("Guest user created with ID: $guestId");
      } else {
        print("Guest user already exists.");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create guest user: $e");
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
