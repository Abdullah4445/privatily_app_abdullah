import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String id;
  String senderId;
  String messageText;
  String receiverId;
  String messageType; // 'text', 'voice', or 'image'
  DateTime? timestamp;
  String? audioUrl;
  String? name;
  String? imageUrl; // Added for image messages
  bool isDelivered; // New: Track if message is delivered
  bool isSeen; // New: Track if message is seen

  Messages({
    required this.id,
    required this.senderId,
    required this.messageText,
    required this.receiverId,
    required this.messageType,
    this.timestamp,
    this.audioUrl,
    this.name,
    this.imageUrl,
    this.isDelivered = false, // Default to false
    this.isSeen = false, // Default to false
  });

  factory Messages.fromJson(Map<String, dynamic> json, String id) {
    return Messages(
      id: id,
      senderId: json['senderId'] ?? '',
      name: json['name'] ?? '',
      messageText: json['messageText'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      audioUrl: json['audioUrl'],
      imageUrl: json['imageUrl'] as String?,
      isDelivered: json['isDelivered'] ?? false, // Parse from Firestore
      isSeen: json['isSeen'] ?? false, // Parse from Firestore
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'name': name,
      'messageText': messageText,
      'receiverId': receiverId,
      'messageType': messageType,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'isDelivered': isDelivered,
      'isSeen': isSeen,
    };
  }
}