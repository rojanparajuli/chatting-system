import 'package:audiocall/bloc/people_list/people_list_event.dart';
import 'package:audiocall/bloc/people_list/people_list_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PeopleListBloc extends Bloc<PeopleListEvent, PeopleListState> {
  final FirebaseFirestore firestore;
  PeopleListBloc(this.firestore) : super(PeopleListUserLoading()) {
    on<PeopleListLoadUsers>((event, emit) async {
      try {
        var snapshot = await firestore.collection('users').get();
        var users = snapshot.docs.map((doc) => doc.data()).toList();
        emit(PeopleListUserLoaded(users));
      } catch (e) {
        emit(UserError());
      }
    });
  }
}
