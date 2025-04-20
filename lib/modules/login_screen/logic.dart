// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../home_page/logic.dart';
// import '../models/students.dart';
//
// class Login_pageLogic extends GetxController {
//   TextEditingController emailC = TextEditingController();
//   TextEditingController passC = TextEditingController();
//   TextEditingController NameC = TextEditingController();
//
//   var fbAu = FirebaseAuth.instance;
//   var fbIn = FirebaseFirestore.instance;
//
//   var showHomeScreen = false.obs;
//
//   Future<void> createUser() async {
//     try {
//       if (emailC.text.isEmpty || passC.text.isEmpty || NameC.text.isEmpty) {
//         Get.snackbar('Error', 'All fields are required');
//         return;
//       }
//
//       UserCredential userCredential = await fbAu.createUserWithEmailAndPassword(
//         email: emailC.text,
//         password: passC.text,
//       );
//
//       if (userCredential.user != null) {
//         String name = NameC.text;
//         String id = userCredential.user!.uid;
//
//         Students student = Students(
//           name: name,
//           id: id,
//           createdAt: DateTime.now().microsecondsSinceEpoch,
//         );
//         await fbIn.collection("Students").doc(id).set(student.toJson());
//
//         showHomeScreen.value = true;
//
//         await Get.find<HomeLogic>().createOrGetAdminChatRoom(
//           currentUserId: id,
//           currentUserName: name,
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
//
//   Future<void> signIn() async {
//     try {
//       await fbAu.signInWithEmailAndPassword(
//         email: emailC.text,
//         password: passC.text,
//       );
//
//       String userId = fbAu.currentUser!.uid;
//
//       // Fetch name from Firestore
//       DocumentSnapshot doc =
//       await fbIn.collection("Students").doc(userId).get();
//       String name = doc.exists ? doc.get("name") : "User";
//
//       showHomeScreen.value = true;
//
//       await Get.find<HomeLogic>().createOrGetAdminChatRoom(
//         currentUserId: userId,
//         currentUserName: name,
//       );
//     } catch (e) {
//       Get.snackbar('Error', e.toString());
//     }
//   }
// }
