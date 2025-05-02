// lib/utils/chat_utils.dart

String generateChatRoomId(String userA, String userB) {
  final ids = [userA, userB]..sort();
  return ids.join("-");
}