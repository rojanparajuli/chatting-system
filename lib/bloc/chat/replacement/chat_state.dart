import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object> get props => [];
}

class ChatInitial extends ChatState {}

class ChatLoading extends ChatState {}

class ChatLoaded extends ChatState {
  final List<QueryDocumentSnapshot> chatRooms;
  ChatLoaded(this.chatRooms);
}

class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}