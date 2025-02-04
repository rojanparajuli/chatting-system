import 'package:audiocall/bloc/chat/chat_bloc.dart';
import 'package:audiocall/bloc/chat/chat_event.dart';
import 'package:audiocall/bloc/chat/chat_state.dart';
import 'package:audiocall/view/call_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String senderId;
  final String image;

  const ChatScreen(
      {super.key,
      required this.chatId,
      required this.userName,
      required this.senderId,
      required this.image});

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
      appBar: AppBar(
        title: Row(
          children: [
             CircleAvatar(
            backgroundImage: NetworkImage(widget.image),
          ),
          SizedBox(width: 20),
            Text(widget.userName,
                style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ],
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 4,
        centerTitle: true,
        leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
            )),
        actions: [
         
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CallScreen(
                          chatId: widget.chatId,
                          callerId: widget.senderId,
                          receiverId: widget.userName)));
            },
            icon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(Icons.phone),
            ),
            color: Colors.white,
            iconSize: 30,
          ),
        ],
      ),
      body: Stack(
        children: [
          Opacity(
            opacity: 0.1,
            child: Image.asset(
              'assets/logo.png',
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: BlocBuilder<ChatBloc, ChatState>(
                  builder: (context, state) {
                    if (state is ChatLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is ChatLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: state.messages.length,
                        itemBuilder: (context, index) {
                          var msg = state.messages[index];
                          bool isMe = msg['senderId'] == widget.senderId;
                          return Align(
                            alignment: isMe
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              margin: const EdgeInsets.symmetric(vertical: 5),
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.75),
                              decoration: BoxDecoration(
                                color:
                                    isMe ? Colors.blueAccent : Colors.grey[300],
                                borderRadius: BorderRadius.circular(15),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    msg['message'],
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      color:
                                          isMe ? Colors.white : Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    (() {
                                      try {
                                        if (msg['timestamp'] != null) {
                                          return DateFormat('hh:mm a').format(
                                              (msg['timestamp'] as Timestamp)
                                                  .toDate());
                                        } else {
                                          return 'N/A';
                                        }
                                      } catch (e) {
                                        return 'Error';
                                      }
                                    })(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: isMe
                                          ? Colors.white70
                                          : Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return Center(
                        child: Text(
                          'No messages yet',
                          style: GoogleFonts.poppins(
                              fontSize: 16, color: Colors.grey),
                        ),
                      );
                    }
                  },
                ),
              ),
              _buildMessageInput(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: messageController,
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
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
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.send, color: Colors.white, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
