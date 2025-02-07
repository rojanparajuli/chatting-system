import 'package:audiocall/bloc/chat/replacement/chat_event.dart';
import 'package:audiocall/bloc/chat/replacement/chat_state.dart';
import 'package:audiocall/repository/chat/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc(this.chatRepository) : super(ChatInitial()) {
    on<LoadChatRooms>((event, emit) async {
      emit(ChatLoading());
      try {
        chatRepository.getChatRooms(event.userId).listen((snapshot) {
          emit(ChatLoaded(snapshot.docs));
        });
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });

    on<CreateChatRoom>((event, emit) async {
      try {
        await chatRepository.createChatRoom(
            event.userId1, event.userId2, event.name);
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}
