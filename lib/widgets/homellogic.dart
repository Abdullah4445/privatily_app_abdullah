import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeLogic extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String fixedAdminId = 'bnS6fNg9srhKktTSufF2AA9tdQZ2';
  final String adminName = 'Admin';

  var showChatScreen = false.obs;
  var chatRoomIdForPopup = ''.obs;
  var receiverIdForPopup = ''.obs;
  var receiverNameForPopup = ''.obs;

  // 🔁 Called from Floating Button
  Future<void> initGuestChat() async {
    try {
      if (auth.currentUser == null) {
        await auth.signInAnonymously();
      }

      final guestId = auth.currentUser!.uid;
      final adminId = fixedAdminId;

      // ✅ Create Guest in Firestore
      await _createGuestUser(guestId);

      // ✅ Generate chatRoomId
      String chatRoomId = guestId.hashCode <= adminId.hashCode
          ? "$guestId-$adminId"
          : "$adminId-$guestId";

      // ✅ Create chatroom if not exists
      DocumentSnapshot chatRoomDoc = await firestore.collection("ChatsRoomId").doc(chatRoomId).get();
      if (!chatRoomDoc.exists) {
        await firestore.collection("ChatsRoomId").doc(chatRoomId).set({
          'chatRoomId': chatRoomId,
          'participants': [guestId, adminId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      // ✅ Update state
      chatRoomIdForPopup.value = chatRoomId;
      receiverIdForPopup.value = adminId;
      receiverNameForPopup.value = adminName;
      showChatScreen.value = true;
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
    }
  }

  // ✅ Create "Guests" Collection Entry
  Future<void> _createGuestUser(String guestId) async {
    try {
      DocumentSnapshot guestDoc = await firestore.collection("Guests").doc(guestId).get();

      if (!guestDoc.exists) {
        await firestore.collection("Guests").doc(guestId).set({
          'name': 'Guest $guestId',
          'id': guestId,
          'createdAt': FieldValue.serverTimestamp(),
        });
        print("✅ Guest created: $guestId");
      } else {
        print("ℹ️ Guest already exists: $guestId");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create guest: $e");
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
