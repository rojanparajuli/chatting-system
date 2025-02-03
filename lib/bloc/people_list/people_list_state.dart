abstract class PeopleListState {}
class PeopleListUserLoading extends PeopleListState {}
class PeopleListUserLoaded extends PeopleListState {
  final List<Map<String, dynamic>> users;
  PeopleListUserLoaded(this.users);
}
class UserError extends PeopleListState {}