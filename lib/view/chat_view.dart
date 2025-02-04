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
  final String name;
  final String senderId;
  final String image;
  final String age;
  final String bio;
  final String email;
  final String username;

  const ChatScreen(
      {super.key,
      required this.chatId,
      required this.name,
      required this.senderId,
      required this.image,
      required this.age,
      required this.bio,
      required this.email,
      required this.username});

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
            GestureDetector(
              onTap: () {
                showUserDetails(context, widget.image, widget.name, widget.age,
                    widget.bio, widget.email, widget.username);
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.image),
              ),
            ),
            SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                showUserDetails(context, widget.image, widget.name, widget.age,
                    widget.bio, widget.email, widget.username);
              },
              child: Text(
                widget.name,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
        backgroundColor: const Color.fromARGB(255, 154, 154, 242),
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
                          receiverId: widget.name)));
            },
            icon: Icon(Icons.phone),
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
                            child: Row(
                              mainAxisAlignment: isMe
                                  ? MainAxisAlignment.end
                                  : MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isMe)
                                  GestureDetector(
                                    onTap: () {
                                      showUserDetails(
                                          context,
                                          widget.image,
                                          widget.name,
                                          widget.age,
                                          widget.bio,
                                          widget.email,
                                          widget.username);
                                    },
                                    child: CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(widget.image),
                                    ),
                                  ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.75,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? const Color.fromARGB(255, 154, 154, 242)
                                        : Colors.grey[300],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        msg['message'] ?? '',
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          color: isMe
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Text(
                                        (() {
                                          try {
                                            if (msg['timestamp'] != null) {
                                              return DateFormat('hh:mm a')
                                                  .format((msg['timestamp']
                                                          as Timestamp)
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
                              ],
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

  void showUserDetails(BuildContext context, String image, String name,
      String age, String bio, String email, String username) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.grey[300],
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(image),
                ),
              ),
              SizedBox(height: 12),

              // Name
              Text(
                name,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              Divider(thickness: 1.2, color: Colors.grey[300]),

              SizedBox(height: 8),

              _buildDetailRow(Icons.cake, "Age", age),
              _buildDetailRow(Icons.info, "Bio", bio),
              _buildDetailRow(Icons.email, "Email", email),
              _buildDetailRow(Icons.person, "Username", username),

              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blueGrey, size: 22),
          SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                text: "$label: ",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                children: [
                  TextSpan(
                    text: value,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
