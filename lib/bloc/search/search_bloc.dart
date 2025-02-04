import 'package:audiocall/bloc/search/search_event.dart';
import 'package:audiocall/bloc/search/search_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final List<Map<String, dynamic>> allUsers;

  SearchBloc(this.allUsers) : super(SearchFieldClosed()) {
    on<SearchQueryChanged>((event, emit) {
      final filteredUsers = allUsers
          .where((user) =>
              ('${user['name']} ${user['surname']}')
                  .toLowerCase()
                  .contains(event.query.toLowerCase()) ||
              (user['email'] ?? '').toLowerCase().contains(event.query.toLowerCase()) ||
              (user['username'] ?? '').toLowerCase().contains(event.query.toLowerCase()))
          .toList();
      emit(SearchResults(filteredUsers));
    });

    on<ToggleSearchField>((event, emit) {
      if (state is SearchFieldClosed) {
        emit(SearchFieldOpened());
      } else {
        emit(SearchFieldClosed());
      }
    });
  }
}
