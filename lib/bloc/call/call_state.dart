import 'package:equatable/equatable.dart';

abstract class CallState extends Equatable {
  @override
  List<Object> get props => [];
}

class CallInitial extends CallState {}

class CallInProgress extends CallState {
  final String chatId;
  final String callerId;
  final String receiverId;

  CallInProgress(
      {required this.chatId, required this.callerId, required this.receiverId});

  @override
  List<Object> get props => [chatId, callerId, receiverId];
}

class CallEnded extends CallState {}
