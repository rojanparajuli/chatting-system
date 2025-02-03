import 'package:audiocall/bloc/people_list/people_list_bloc.dart';
import 'package:audiocall/bloc/people_list/people_list_state.dart';
import 'package:audiocall/constant/image.dart';
import 'package:audiocall/view/chat_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserListScreen extends StatelessWidget {
   UserListScreen({super.key});

  String getUserImage(String? gender) {
    if (gender == 'Male') {
      return AppImage.maleImage;
    } else if (gender == 'Female') {
      return AppImage.femaleImage;
    } else if (gender == 'Others') {
      return AppImage.othersImage;
    } else {
      return '';
    }
  }
  final currentUserId = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Users')),
      body: BlocBuilder<PeopleListBloc, PeopleListState>(
        builder: (context, state) {
          if (state is PeopleListUserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is PeopleListUserLoaded) {
            return Stack(
              children: [
                Opacity(
                  opacity: 0.1,
                  child: Image.asset(
                    'assets/logo.png',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                ListView.builder(
                  itemCount: state.users.length,
                  itemBuilder: (context, index) {
                    var user = state.users[index];
                    String imageUrl = getUserImage(user['gender']);
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              chatId: user['id'],
                              userName: user['name'],
                              senderId: currentUserId.toString(),
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: imageUrl.isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: NetworkImage(imageUrl),
                                )
                              : null,
                          title: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Name: ',
                                  style: TextStyle(color: Colors.black),
                                ),
                                TextSpan(
                                  text: '${user['name']} ${user['surname']}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          subtitle: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Email: ${user['email'] ?? 'No Email'}',
                                  style: TextStyle(color: Colors.black)),
                              Text(
                                  'Username: ${user['username'] ?? 'No Username'}'),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return Center(child: Text('Error loading users'));
          }
        },
      ),
    );
  }
}
