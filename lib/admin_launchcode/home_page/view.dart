import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/students.dart';
import 'logic.dart';

class AdminChatHome extends StatefulWidget {
  const AdminChatHome({Key? key}) : super(key: key);

  @override
  State<AdminChatHome> createState() => _AdminChatHomeState();
}

class _AdminChatHomeState extends State<AdminChatHome> {
  final LogicadminHome logic = Get.put(LogicadminHome());

  @override
  void initState() {
    super.initState();
    logic.getUserOnFirebase(); // ✅ Fetch students when page opens
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Users",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () {
              logic.signOut();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (logic.getStudents.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.red),
                );
              }

              return ListView.builder(
                itemCount: logic.getStudents.length,
                itemBuilder: (context, i) {
                  final user = logic.getStudents[i];
                  bool isCurrentUser =
                      user.id == FirebaseAuth.instance.currentUser?.uid;

                  return isCurrentUser
                      ? const SizedBox()
                      : Card(
                    elevation: 6.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      onTap: () async {
                        await logic.createChatRoomId(user.id, user.name);

                        // ✅ Optional: Safety log
                        print("🔁 Tapped: ${user.name} | Room ID: ${logic.selectedChatRoomId.value}");
                      },
                      leading: CircleAvatar(
                        backgroundColor: Colors.red,
                        child: Text(
                          user.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
