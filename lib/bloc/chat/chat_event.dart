import 'package:equatable/equatable.dart';

abstract class ChatEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadMessages extends ChatEvent {
  final String chatId;
  LoadMessages(this.chatId);

  @override
  List<Object?> get props => [chatId];
}

class SendMessage extends ChatEvent {
  final String chatId;
  final String message;
  final String senderId;

  SendMessage(
      {required this.chatId, required this.message, required this.senderId});

  @override
  List<Object?> get props => [chatId, message, senderId];
}

class CloseChat extends ChatEvent {}

class ChatUpdated extends ChatEvent {
  final List<Map<String, dynamic>> messages;
  ChatUpdated(this.messages);

  @override
  List<Object?> get props => [messages];
}
