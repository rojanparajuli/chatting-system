import 'package:audiocall/constant/image.dart';
import 'package:audiocall/view/change_pass_view.dart';
import 'package:audiocall/view/login_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DrawerItem extends StatelessWidget {
  final String image;
  const DrawerItem({
    super.key,
    required this.image,
  });

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

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Column(
        children: [
          _buildDrawerHeader(user),
          Expanded(child: _buildMenuList(context)),
          _buildLogoutButton(context),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader(User? user) {
  String imageUrl = '';

  return FutureBuilder<DocumentSnapshot>(
    future: FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const CircularProgressIndicator();
      }
      if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
        return const UserAccountsDrawerHeader(
          decoration: BoxDecoration(color: Color.fromARGB(255, 154, 154, 242)),
          accountName: Text('Guest User'),
          accountEmail: Text('No Email'),
          currentAccountPicture: CircleAvatar(
            child: Icon(Icons.person, size: 50),
          ),
        );
      }

      String? gender = snapshot.data?['gender'];
      imageUrl = getUserImage(gender);

      return UserAccountsDrawerHeader(
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 154, 154, 242)),
        accountName: Text(
          user?.displayName ?? 'Guest User',
          style: GoogleFonts.lora(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        accountEmail: Text(
          user?.email ?? 'No Email',
          style: GoogleFonts.lora(fontSize: 14),
        ),
        currentAccountPicture: CircleAvatar(
          backgroundColor: Colors.white,
          child: imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: 90,
                    height: 90,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.person, size: 50),
                  ),
                )
              : const Icon(Icons.person, size: 50),
        ),
      );
    },
  );
}

  Widget _buildMenuList(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        _buildMenuItem(
          context,
          icon: Icons.password,
          title: 'Change Password',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ChangePasswordScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuItem(BuildContext context,
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        title,
        style: GoogleFonts.lora(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.exit_to_app, color: Colors.redAccent),
      title: Text(
        'Logout',
        style: GoogleFonts.lora(
            fontSize: 16, fontWeight: FontWeight.w600, color: Colors.red),
      ),
      onTap: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout', style: GoogleFonts.lora()),
          content: Text('Are you sure you want to logout?',
              style: GoogleFonts.lora()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: GoogleFonts.lora()),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                // ignore: use_build_context_synchronously
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: Text('Logout',
                  style: GoogleFonts.lora(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }
}
