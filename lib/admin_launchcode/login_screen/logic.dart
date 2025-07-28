
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../dashboard/dashboard_view.dart';

import '../models/students.dart';

class Login_pageLogic extends GetxController {
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();
  TextEditingController nameC = TextEditingController();
  var fbAu = FirebaseAuth.instance;
  var fbIn = FirebaseFirestore.instance;

  Future<void> createUser() async {
    try {
      if (emailC.text.isEmpty || passC.text.isEmpty || nameC.text.isEmpty) {
        Get.snackbar('Error', 'All fields are required');
      } else {
        UserCredential userCredential =
        await fbAu.createUserWithEmailAndPassword(
            email: emailC.text, password: passC.text);
        print(fbAu.currentUser!.uid);
        if (userCredential.user != null) {
          String name = nameC.text;
          String id = userCredential.user!.uid;

          Students students = Students(
            name: name,
            id: id,
            createdAt: DateTime.now().microsecondsSinceEpoch,
          );
          await fbIn.collection("Students").doc(id).set(students.toJson());
        }

        Get.to(() => AdminDashboardPage());
        print("saim");
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'An error occurred');
    } catch (e) {
      print(e);
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  Future<void> signIn() async {
    if (emailC.text.isEmpty || passC.text.isEmpty) {
      Get.snackbar('Error', 'Both fields are required');
    } else {
      try {
        await fbAu.signInWithEmailAndPassword(email: emailC.text, password: passC.text);
        print(fbAu.currentUser!.uid);

        Get.to(() =>AdminDashboardPage());
        print("saim");
      } on FirebaseAuthException catch (e) {
        Get.snackbar('Error', e.message ?? 'An error occurred');
      } catch (e) {
        print(e);
        Get.snackbar('Error', 'Something went wrong');
      }
    }
  }


}
