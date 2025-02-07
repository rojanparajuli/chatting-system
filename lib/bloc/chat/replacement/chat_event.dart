import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadChatRooms extends ChatEvent {
  final String userId;

  LoadChatRooms(this.userId);
}

class CreateChatRoom extends ChatEvent {
  final String userId1;
  final String userId2;
  final String name;

  CreateChatRoom(this.userId1, this.userId2, this.name);
}
