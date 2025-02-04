
// States
import 'package:equatable/equatable.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchFieldClosed extends SearchState {}

class SearchFieldOpened extends SearchState {}

class SearchResults extends SearchState {
  final List<Map<String, dynamic>> filteredUsers;
  SearchResults(this.filteredUsers);
  
  @override
  List<Object?> get props => [filteredUsers];
}