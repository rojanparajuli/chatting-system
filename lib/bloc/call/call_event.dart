import 'package:equatable/equatable.dart';

abstract class CallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class StartCall extends CallEvent {
  final String chatId;
  final String callerId;
  final String receiverId;

  StartCall({required this.chatId, required this.callerId, required this.receiverId});

  @override
  List<Object> get props => [chatId, callerId, receiverId];
}

class EndCall extends CallEvent {}