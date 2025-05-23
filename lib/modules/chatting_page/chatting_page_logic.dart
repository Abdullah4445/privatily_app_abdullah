// File: guest_chat_logic.dart (Or your logic file name)
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Assuming guest uses Auth
import 'package:get/get.dart';
import '../../models/messages.dart'; // Adjust import path

class GuestChatLogic extends GetxController {
  final FirebaseAuth myFbAuth = FirebaseAuth.instance; // Use your auth instance
  final FirebaseFirestore myFbFs = FirebaseFirestore.instance;

  // Function to send a message
  Future<void> sendMessage(String chatRoomId, String receiverId, String message,
      {String messageType = 'text', String? audioUrl}) async {
    final user = myFbAuth.currentUser;
    if (user == null) {
      print("Guest user not found. Cannot send message.");
      // Handle appropriately - maybe force login/name entry again?
      return;
    }

    final messageData = Messages(
      id: '', // Firestore will generate
      senderId: user.uid, // Guest's ID
      receiverId: receiverId, // Admin's ID
      messageText: message,
      messageType: messageType,
      timestamp: null, // Will be set by serverTimestamp
      audioUrl: audioUrl,
    ).toJson();

    // *** Use server timestamp for reliable ordering ***
    messageData['timestamp'] = FieldValue.serverTimestamp();

    try {
      await myFbFs
          .collection('ChatsRoomId')
          .doc(chatRoomId)
          .collection('messages')
          .add(messageData);
    } catch (e) {
      print("Error sending message (Guest): $e");
      // TODO: Handle error (e.g., show a snackbar)
    }
  }

  // *** Renamed & Refined: Function to update GUEST's status in Firestore ***
  Future<void> updateGuestStatus(String chatRoomId,
      {bool? isOnline, bool? isTyping}) async {

    // Get current user *before* potentially updating status
    final user = myFbAuth.currentUser;
    if (user == null) {
      print("Guest user not found. Cannot update status.");
      return; // Don't attempt update if no user
    }

    final statusData = <String, dynamic>{};

    if (isOnline != null) {
      statusData['guest_online'] = isOnline; // Use GUEST fields
      if (!isOnline) {
        // Set lastSeen only when going offline
        statusData['guest_lastSeen'] = FieldValue.serverTimestamp(); // Use GUEST fields
      }
    }
    if (isTyping != null) {
      statusData['guest_typing'] = isTyping; // Use GUEST fields
    }

    // Only update if there's something to change
    if (statusData.isEmpty) return;

    try {
      // Use set with merge:true to update only these fields
      await myFbFs.collection('ChatsRoomId').doc(chatRoomId).set(
        statusData,
        SetOptions(merge: true), // IMPORTANT: merge keeps other fields
      );
    } catch (e) {
      print("Error updating guest status: $e");
      // TODO: Handle error
    }
  }

  // Stream to get messages (Ensure Messages.fromJson handles Timestamp)
  Stream<List<Messages>> getMessages(String chatRoomId) {
    return myFbFs
        .collection('ChatsRoomId')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: true) // Order by server timestamp
        .snapshots()
        .map((snapshot) {
      try {
        return snapshot.docs.map((doc) {
          final data = doc.data(); // Get data as Map<String, dynamic>
          return Messages.fromJson(data , doc.id); // Pass data and ID
        }).toList();
      } catch (e) {
        print("Error mapping messages (Guest): $e");
        return <Messages>[]; // Return empty list on error
      }
    });
  }

  // *** Renamed & Refined: Stream to get the chat room document for status ***
  Stream<DocumentSnapshot<Map<String, dynamic>>> getChatRoomStream(String chatRoomId) {
    return myFbFs
        .collection('ChatsRoomId')
        .doc(chatRoomId)
        .snapshots()
    // Specify the type for clarity and type safety downstream
        .map((snapshot) => snapshot as DocumentSnapshot<Map<String, dynamic>>);
  }

  // Helper to get current user ID safely
  String? getCurrentUserId() {
    // Handle anonymous users if applicable.
    // For this example, assumes a signed-in user.
    return myFbAuth.currentUser?.uid;
  }
}