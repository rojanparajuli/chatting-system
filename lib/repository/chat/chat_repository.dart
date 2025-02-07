import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  Future<void> createChatRoom(
      String Userid1, String Userid2, String name) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .doc(Userid1 + "_" + Userid2)
          .set({
        "createdAt": FieldValue.serverTimestamp(),
        "name": name,
        "users": [Userid1, Userid2],
        "chatRoomId": Userid1 + "_" + Userid2,
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> GetChatRoom(String Userid1) async {
    try {
      await FirebaseFirestore.instance
          .collection("chatRoom")
          .where("users", arrayContains: Userid1)
          .get();
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
