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

  //New variables
  var isLoading = false.obs;

  // ✅ Create User with Email and Password and save details
  Future<void> createUserWithEmailAndPassword(String email, String password, String name,String course ,{required bool isStudent}) async {
    try {
      if(email.isEmpty || name.isEmpty || password.isEmpty ){
        Get.snackbar("Error", "Everything is Required");
        return;
      }
      isLoading.value = true; // Move isLoading.value = true outside the if statement
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = FirebaseAuth.instance.currentUser!.uid; // final userId = credential.user!.uid;
      // final userName = email.split('@')[0];
      final role = isStudent ? 'student' : 'client'; // Set the role

      // ✅ Store User data in "Users" collection
      await firestore.collection("Users").doc(userId).set({
        'name':name,
        'id': userId,
        'email': email,
        'role': role,
        'course': course,
      });
      // Generate chatRoomId
      String chatRoomId = generateChatRoomId(userId, fixedAdminId);

      chatRoomIdForPopup.value = chatRoomId;
      receiverIdForPopup.value = fixedAdminId;
      receiverNameForPopup.value = adminName;
      showChatScreen.value = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar("Error", "The password provided is too weak.");
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar("Error", "The account already exists for that email.");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to create user: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ✅ Sign In with Email and Password
  Future<void> signInWithEmailAndPassword(String email, String password, {required bool isStudent}) async {
    try {
      isLoading.value = true;
      final credential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final userId = credential.user!.uid;
      // Generate chatRoomId
      String chatRoomId = generateChatRoomId(userId, fixedAdminId);

      chatRoomIdForPopup.value = chatRoomId;
      receiverIdForPopup.value = fixedAdminId;
      receiverNameForPopup.value = adminName;
      showChatScreen.value = true;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        Get.snackbar("Error", "No user found for that email.");
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Error", "Wrong password provided for that email.");
      }
    } catch (e) {
      Get.snackbar("Error", "❌ Failed to sign in: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      await auth.signOut();
      // Clear the chat screen state
      showChatScreen.value = false;
      Get.snackbar('Success', 'Successfully logged out');
    } catch (e) {
      Get.snackbar('Error', 'Failed to log out');
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
  String generateChatRoomId(String userId1, String userId2) {
    return userId1.hashCode <= userId2.hashCode
        ? "$userId1-$userId2"
        : "$userId2-$userId1";
  }
}