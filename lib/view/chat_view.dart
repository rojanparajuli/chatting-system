import 'package:audiocall/bloc/chat/chat_bloc.dart';
import 'package:audiocall/bloc/chat/chat_event.dart';
import 'package:audiocall/bloc/chat/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String senderId;

  const ChatScreen({super.key, required this.chatId, required this.userName, required this.senderId});

  @override
  ChatScreenState createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ChatBloc>(context).add(LoadMessages(widget.chatId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<ChatBloc, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is ChatLoaded) {
                  return ListView.builder(
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      var msg = state.messages[index];
                      bool isMe = msg['senderId'] == widget.senderId;
                      return Align(
                        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                          decoration: BoxDecoration(
                            color: isMe ? Colors.blue : Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(msg['message']),
                        ),
                      );
                    },
                  );
                } else {
                  return Center(child: Text('No messages yet'));
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(hintText: 'Type a message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      BlocProvider.of<ChatBloc>(context).add(
                        SendMessage(
                          chatId: widget.chatId,
                          message: messageController.text,
                          senderId: widget.senderId,
                        ),
                      );
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
