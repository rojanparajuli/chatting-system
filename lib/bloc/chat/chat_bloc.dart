import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;
  ChatBloc({required this.firestore}) : super(ChatInitial()) {
    on<LoadMessages>((event, emit) async {
      emit(ChatLoading());
      List<Map<String, dynamic>> messages = [];

      try {
          firestore
            .collection('chats')
            .doc(event.chatId)
            .collection('messages')
            .orderBy('timestamp').snapshots().listen((snapshot){
              print("Snapshot: $snapshot");

            messages = snapshot.docs.map((doc) => doc.data()).toList();
            print("Messages: $messages");
            });
        // List<Map<String, dynamic>> messages =
        //     snapshot.docs.map((doc) => doc.data()).toList();
        emit(ChatLoaded(messages));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        print("Sending message: ${event.message} to chatId: ${event.chatId}");
        await firestore
            .collection('chats')
            .doc(event.chatId)
            .collection('messages')
            .add({
          'senderId': event.senderId,
          'message': event.message,
          'timestamp': FieldValue.serverTimestamp(),
        });
        print("Message sent successfully");
      } catch (e) {
        print("Error sending message: $e");
        emit(ChatError(e.toString()));
      }
    });
  }
}
