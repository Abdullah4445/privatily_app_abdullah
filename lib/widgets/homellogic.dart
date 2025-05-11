import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../firebase_utils.dart';
import '../modules/chat_page/chat/view/widgets/variables/globalVariables.dart';
import '../utils/utils.dart';  // Assuming utils.dart contains generateChatRoomId()
// Import for setUserOnline()


class HomeLogic extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final String fixedAdminId = 'bnS6fNg9srhKktTSufF2AA9tdQZ2';
  final String adminName = 'Admin';

  var showChatScreen = false.obs;
  var chatRoomIdForPopup = ''.obs;
  var receiverIdForPopup = ''.obs;
  var receiverNameForPopup = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Call setUserOnline after the controller is initialized (if user is signed in)
    checkAndSetUserOnline();
  }

  Future<void> checkAndSetUserOnline() async {
    if (auth.currentUser != null) {
      await setUserOnline(globalChatRoomId);  // Set online if already signed in
    }
  }

  Future<void> initGuestChat() async {
    try {
      if (auth.currentUser == null) {
        await auth.signInAnonymously().then((value) async {  // Use .then() to execute code after signInAnonymously completes
          if (auth.currentUser != null) {
            await setUserOnline(globalChatRoomId); // Set online after signing in anonymously
          }
        });
      }

      final guestId = auth.currentUser!.uid;
      final adminId = fixedAdminId;

      String chatRoomId = generateChatRoomId(guestId, adminId);

      DocumentSnapshot chatRoomDoc = await firestore
          .collection("ChatsRoomId")
          .doc(chatRoomId)
          .get();

      if (!chatRoomDoc.exists) {
        await firestore.collection("ChatsRoomId").doc(chatRoomId).set({
          "id":guestId,
          'chatRoomId': chatRoomId,
          'participants': [guestId, adminId],
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      chatRoomIdForPopup.value = chatRoomId;
      receiverIdForPopup.value = adminId;
      receiverNameForPopup.value = adminName;
      showChatScreen.value = true;
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create chat room: $e");
      print("❌ Error (Guest Side): $e");
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}