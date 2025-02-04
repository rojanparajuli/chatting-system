import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'chat_event.dart';
import 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final FirebaseFirestore firestore;
  StreamSubscription? chatSubscription;

  ChatBloc({required this.firestore}) : super(ChatInitial()) {
    on<LoadMessages>(_onLoadMessages);
    on<SendMessage>(_onSendMessage);
    on<CloseChat>(_onCloseChat);
    on<ChatUpdated>(_onChatUpdated); 
  }

 Future<void> _onLoadMessages(LoadMessages event, Emitter<ChatState> emit) async {
  emit(ChatLoading());

  try {
    await chatSubscription?.cancel();

    chatSubscription = firestore
        .collection('chats')
        .doc(event.chatId)
        .collection('messages')
        .orderBy('timestamp')
        .snapshots()
        .listen((snapshot) {
      List<Map<String, dynamic>> messages = snapshot.docs.map((doc) => doc.data()).toList();

      if (!isClosed) { 
        add(ChatUpdated(messages)); 
      }
    });
  } catch (e) {
    if (!isClosed) emit(ChatError(e.toString())); 
  }
}


  void _onChatUpdated(ChatUpdated event, Emitter<ChatState> emit) {
    emit(ChatLoaded(List.from(event.messages))); 
  }

 Future<void> _onSendMessage(SendMessage event, Emitter<ChatState> emit) async {
  try {
    await firestore
        .collection('chats')
        .doc(event.chatId) 
        .collection('messages')
        .add({
      'senderId': event.senderId,
      'message': event.message,
      'timestamp': FieldValue.serverTimestamp(),
    });
  } catch (e) {
    emit(ChatError(e.toString()));
  }
}


  Future<void> _onCloseChat(CloseChat event, Emitter<ChatState> emit) async {
    await chatSubscription?.cancel();
    chatSubscription = null;
    emit(ChatInitial());
  }

  @override
  Future<void> close() async {
    await chatSubscription?.cancel();
    return super.close();
  }
}
