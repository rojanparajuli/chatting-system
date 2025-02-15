import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  Future<void> createChatRoom(String userId1, String userId2, String name) async {
    try {
      await FirebaseFirestore.instance.collection("chatRoom").doc("${userId1}_$userId2").set({
        "createdAt": FieldValue.serverTimestamp(),
        "name": name,
        "users": [userId1, userId2],
        "chatRoomId": "${userId1}_$userId2",
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getChatRooms(String userId) {
    return FirebaseFirestore.instance
        .collection("chatRoom")
        .where("users", arrayContains: userId)
        .snapshots();
  }
}