import 'package:audiocall/animations/splash_screen.dart';
import 'package:audiocall/auth/bloc/auth_bloc.dart';
import 'package:audiocall/bloc/chat/chat_bloc.dart';
import 'package:audiocall/bloc/people_list/people_list_bloc.dart';
import 'package:audiocall/bloc/people_list/people_list_event.dart';
import 'package:audiocall/bloc/splash/splash_bloc.dart';
import 'package:audiocall/bloc/splash/splash_event.dart';
import 'package:audiocall/repository/auth_respository.dart';
import 'package:audiocall/view/auth/login_view.dart';
import 'package:audiocall/view/home/people_list_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    final AuthRepository authRepository = AuthRepository();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authRepository)),
        BlocProvider(create: (context) => PasswordVisibilityCubit()),
        BlocProvider(
          create: (context) => SplashBloc()..add(CheckInternetEvent()),
        ),
        BlocProvider(
            create: (context) => PeopleListBloc(FirebaseFirestore.instance)
              ..add(PeopleListLoadUsers())),
      BlocProvider(
          create: (context) => ChatBloc(firestore: FirebaseFirestore.instance),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}

class OnBoard extends StatelessWidget {
  const OnBoard({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return StreamBuilder(
      stream: firebaseAuth.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          User? user = snapshot.data;
          if (user != null) {
            return UserListScreen(
            );
          }
        }
        return LoginScreen();
      },
    );
  }
}
