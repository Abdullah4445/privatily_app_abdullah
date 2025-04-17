import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/students.dart';
import 'logic.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final HomeLogic logic = Get.put(HomeLogic());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "home_title".tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
        ),
        backgroundColor: Colors.red,
        actions: [
          IconButton(
            onPressed: () {
              logic.sigout();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Students>>(
              future: logic.getUserOnFirebase(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      '${'error_label'.tr} ${snapshot.error}',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                    ),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                    child: Text(
                      "home_no_users".tr,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    final user = snapshot.data![i];
                    bool isCurrentUser = user.id == FirebaseAuth.instance.currentUser?.uid;
                    return isCurrentUser
                        ? const SizedBox()
                        : Card(
                      elevation: 6.0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        onTap: () {
                          logic.createChatRoomId(user.id, user.name);
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.red,
                          child: Text(
                            user.name[0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          user.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.deepPurple),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
