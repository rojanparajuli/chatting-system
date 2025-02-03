import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<void> signUp({
    required String name,
    required String surname,
    required String age,
    required String gender,
    required String username,
    required String email,
    required String password,
    required String bio,
    required bool verified,
  }) async {
    UserCredential userCredential =
        await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await userCredential.user?.updateDisplayName('$name $surname');

    print('user created with email and password');

    await _firestore.collection('users').doc(userCredential.user?.uid).set({
      'name': name,
      'surname': surname,
      'age': age,
      'gender': gender,
      'username': username,
      'email': email,
      'bio': bio,
      'verified': verified,
      'id': userCredential.user?.uid,
    });

    print('user created');
  }

  Future<User?> loginWithEmailOrUsername(
      String emailOrUsername, String password) async {
    try {
      if (emailOrUsername.contains('@')) {
        return (await _firebaseAuth.signInWithEmailAndPassword(
          email: emailOrUsername,
          password: password,
        ))
            .user;
      } else {
        final query = await _firestore
            .collection('users')
            .where('username', isEqualTo: emailOrUsername)
            .get();
        if (query.docs.isEmpty) throw Exception('User not found');
        final email = query.docs.first['email'];
        return (await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: password,
        ))
            .user;
      }
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  Future<void> logout() async {
    await _firebaseAuth.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }

  Future<void> saveToken(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', user.uid);
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<void> forgotPassword(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('No user is currently signed in');
    }

    final email = user.email;
    if (email == null) {
      throw Exception('User email not found');
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );

    try {
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception('Failed to change password: ${e.toString()}');
    }
  }
}
