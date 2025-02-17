// import 'package:audiocall/bloc/chat/replacement/chat_bloc.dart';
// import 'package:audiocall/bloc/chat/replacement/chat_event.dart';
// import 'package:audiocall/bloc/chat/replacement/chat_state.dart';
// import 'package:audiocall/repository/chat/chat_repository.dart';
// import 'package:audiocall/view/chat/chat_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class ChatListScreen extends StatelessWidget {
//   final String userId;

//   const ChatListScreen({required this.userId});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Chats")),
//       body: BlocProvider(
//         create: (context) => ChatBloc(ChatRepository())..add(LoadChatRooms(userId)),
//         child: BlocBuilder<ChatBloc, ChatState>(
//           builder: (context, state) {
//             if (state is ChatLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is ChatLoaded) {
//               return ListView.builder(
//                 itemCount: state.chatRooms.length,
//                 itemBuilder: (context, index) {
//                   var chat = state.chatRooms[index];
//                   return ListTile(
//                     title: Text(chat["name"]),
//                     onTap: () => Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) => ChatScreen(chatRoomId: chat["chatRoomId"]),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return Center(child: Text("No Chats Available"));
//             }
//           },
//         ),
//       ),
//     );
//   }
// }