// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../chat_page/view.dart';
// import '../models/students.dart';
// import 'logic.dart'; // HomeLogic
//
// class Homes extends StatefulWidget {
//   const Homes({super.key});
//
//   @override
//   State<Homes> createState() => _HomesState();
// }
//
// class _HomesState extends State<Homes> {
//   final HomeLogic logic = Get.put(HomeLogic());
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Users",
//           style: TextStyle(
//               fontWeight: FontWeight.bold, fontSize: 22, color: Colors.white),
//         ),
//         backgroundColor: Colors.red,
//         actions: [
//           IconButton(
//             onPressed: () {
//               FirebaseAuth.instance.signOut(); // Sign out logic
//             },
//             icon: const Icon(Icons.logout, color: Colors.white),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: StreamBuilder<List<Students>>(
//               // Stream to listen for user data changes in Firestore
//               stream: FirebaseFirestore.instance
//                   .collection('Students')
//                   .snapshots()
//                   .map((snapshot) => snapshot.docs
//                   .map((doc) => Students.fromJson(doc.data()))
//                   .toList()),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (snapshot.hasError) {
//                   return Center(child: Text('Error: ${snapshot.error}'));
//                 } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                   return const Center(child: Text("No users found"));
//                 }
//
//                 return ListView.builder(
//                   itemCount: snapshot.data!.length,
//                   itemBuilder: (context, i) {
//                     final user = snapshot.data![i];
//                     final currentUserId =
//                         FirebaseAuth.instance.currentUser?.uid;
//
//                     // Skip self from list
//                     if (user.id == currentUserId) return const SizedBox();
//
//                     return Card(
//                       elevation: 6.0,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12)),
//                       margin: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 6),
//                       child: ListTile(
//                         contentPadding: const EdgeInsets.all(12),
//                         onTap: () async {
//                           final selectedUserId = user.id;
//                           final selectedUserName = user.name;
//                           final chatRoomId =
//                               "$currentUserId-$selectedUserId";
//
//                           final chatDoc = await logic.firestore
//                               .collection("Chating")
//                               .doc(chatRoomId)
//                               .get();
//
//                           if (!chatDoc.exists) {
//                             await logic.firestore
//                                 .collection("Chating")
//                                 .doc(chatRoomId)
//                                 .set({
//                               'chatRoomId': chatRoomId,
//                               'participants': [currentUserId, selectedUserId],
//                               'createdAt':
//                               DateTime.now().millisecondsSinceEpoch,
//                             });
//                           }
//
//                           // Open Chat Page
//                           Get.to(() => ChattingPage(
//                             chatRoomId: chatRoomId,
//                             receiverId: selectedUserId,
//                             receiverName: selectedUserName,
//                           ));
//                         },
//                         leading: CircleAvatar(
//                           backgroundColor: Colors.red,
//                           child: Text(
//                             user.name[0].toUpperCase(),
//                             style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         title: Text(
//                           user.name,
//                           style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.deepPurple),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
