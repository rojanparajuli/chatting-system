import 'package:audiocall/constant/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audiocall/auth/bloc/auth_bloc.dart';
import 'package:audiocall/auth/bloc/auth_event.dart';
import 'package:audiocall/auth/bloc/auth_state.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ChangePasswordScreenState createState() => ChangePasswordScreenState();
}

class ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Change Password"),
      backgroundColor: AppColors.primary,
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _currentPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Current Password"),
                  validator: (value) => value!.isEmpty ? "Enter current password" : null,
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "New Password"),
                  validator: (value) => value!.length < 6 ? "Password too short" : null,
                  
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: InputDecoration(labelText: "Confirm New Password"),
                  validator: (value) {
                    if (value!.isEmpty) return "Confirm your password";
                    if (value != _newPasswordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                SizedBox(height: 20),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is AuthLoading
                          ? null
                          : () {
                              if (_formKey.currentState!.validate()) {
                                BlocProvider.of<AuthBloc>(context).add(
                                  ChangePasswordRequested(
                                    currentPassword: _currentPasswordController.text,
                                    newPassword: _newPasswordController.text,
                                  ),
                                );
                              }
                            },
                      child: state is AuthLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Change Password"),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
