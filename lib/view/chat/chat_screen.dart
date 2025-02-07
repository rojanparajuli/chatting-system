import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String chatRoomId;

  const ChatScreen({super.key, required this.chatRoomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Chat Room")),
      body: Center(
        child: Text("Chat Room: $chatRoomId"),
      ),
    );
  }
}