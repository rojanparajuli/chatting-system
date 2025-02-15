import 'package:audiocall/bloc/people_list/people_list_bloc.dart';
import 'package:audiocall/bloc/people_list/people_list_state.dart';
import 'package:audiocall/constant/image.dart';
import 'package:audiocall/util/drawer.dart';
import 'package:audiocall/view/chat/chat_view.dart';
// import 'package:audiocall/view/chat_view.dart';
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

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning';
    } else if (hour < 17) {
      return 'Good Afternoon';
    } else {
      return 'Good Evening';
    }
  }

  final currentUser = FirebaseAuth.instance.currentUser;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>(); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          '${getGreeting()} ${currentUser?.displayName ?? 'User'}',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 154, 154, 242),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer(); 
            },
          ),
        ],
      ),
      endDrawer: DrawerItem(
        image: getUserImage(''), 
      ),
      body: BlocBuilder<PeopleListBloc, PeopleListState>(
        builder: (context, state) {
          if (state is PeopleListUserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is PeopleListUserLoaded) {
            return Stack(
              children: [
                // Opacity(
                //   opacity: 0.8,
                //   child: Image.network(
                //    AppImage.home,
                //     width: double.infinity,
                //     height: double.infinity,
                //     fit: BoxFit.cover,
                //   ),
                // ),
                Text('${getGreeting()} ${currentUser?.displayName ?? 'User'}',     style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),),
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
                              name: '${user['name']} ${user['surname']}',
                              senderId: currentUser?.uid ?? '',
                              image: imageUrl,
                              age: user['age'],
                              bio: user['bio'],
                              email: user['email'],
                              username: user['username'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: Column(
                          children: [
                            const SizedBox(height: 30),
                            ListTile(
                              leading: imageUrl.isNotEmpty
                                  ? CircleAvatar(
                                      backgroundImage: NetworkImage(imageUrl),
                                    )
                                  : null,
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'Name: ',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                    TextSpan(
                                      text: '${user['name']} ${user['surname']}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color.fromARGB(255, 154, 154, 242),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Email: ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: user['email'] ?? 'No Email',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 154, 154, 242),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        const TextSpan(
                                          text: 'Username: ',
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        TextSpan(
                                          text: user['username'] ?? 'No Username',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(255, 154, 154, 242),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          } else {
            return const Center(child: Text('Error loading users'));
          }
        },
      ),
    );
  }
}
