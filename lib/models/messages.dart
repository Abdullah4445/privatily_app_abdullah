import 'package:cloud_firestore/cloud_firestore.dart';

class Messages {
  String id;
  String senderId;
  String messageText;
  String receiverId;
  String messageType; // 'text' or 'voice'
  DateTime? timestamp;
  String? audioUrl;

  Messages({
    required this.id,
    required this.senderId,
    required this.messageText,
    required this.receiverId,
    required this.messageType,
    this.timestamp,
    this.audioUrl,
  });

  factory Messages.fromJson(Map<String, dynamic> json, String id) {
    return Messages(
      id: id,
      senderId: json['senderId'] ?? '',
      messageText: json['messageText'] ?? '',
      receiverId: json['receiverId'] ?? '',
      messageType: json['messageType'] ?? 'text',
      timestamp: (json['timestamp'] as Timestamp?)?.toDate(),
      audioUrl: json['audioUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'messageText': messageText,
      'receiverId': receiverId,
      'messageType': messageType,
      'timestamp': timestamp != null ? Timestamp.fromDate(timestamp!) : FieldValue.serverTimestamp(),
      'audioUrl': audioUrl,
    };
  }
}
