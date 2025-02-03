import 'package:audiocall/auth/bloc/auth_bloc.dart';
import 'package:audiocall/auth/bloc/auth_event.dart';
import 'package:audiocall/auth/bloc/auth_state.dart';
import 'package:audiocall/my_app.dart';
import 'package:audiocall/view/forget_password.dart';
import 'package:audiocall/view/sign_up_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailOrUsernameController =
      TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E6FA),
        resizeToAvoidBottomInset: false,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLoggedIn', true);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const OnBoard()),
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              bool isLoading = state is AuthLoading;

              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: const BoxDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),
                        SizedBox(
                          height: 200,
                          child: Image.asset('assets/logo.png',
                              fit: BoxFit.contain),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Welcome Back!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        buildTextField(
                          emailOrUsernameController,
                          'Email or Username',
                          icon: Icons.person,
                        ),
                        const SizedBox(height: 20),
                        buildPasswordField(
                          context,
                          passwordController,
                          'Password',
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (emailOrUsernameController.text.isEmpty ||
                                passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please fill in all fields'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return;
                            }else{
                            context.read<AuthBloc>().add(LoginRequested(
                                  emailOrUsername:
                                      emailOrUsernameController.text,
                                  password: passwordController.text,
                                ));
                          }},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 154, 154, 242),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 8,
                          ),
                          icon: const Icon(Icons.login, color: Colors.black),
                          label: const Text('Login',
                              style: TextStyle(color: Colors.black)),
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordScreen()),
                              );
                            },
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                  color: Colors.black54,
                                  decoration: TextDecoration.underline,),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Center(
                          child: Text(
                            'Don\'t have an account?',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            elevation: 4,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupScreen()),
                            );
                          },
                          child: const Text(
                            'Signup',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        const Spacer(flex: 2),
                      ],
                    ),
                  ),
                  if (isLoading)
                    Container(
                      // ignore: deprecated_member_use
                      color: Colors.black.withOpacity(0.5),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isPassword = false, IconData? icon}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        prefixIcon: Icon(icon, color: Colors.black),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget buildPasswordField(
      BuildContext context, TextEditingController controller, String label) {
    return BlocBuilder<PasswordVisibilityCubit, bool>(
      builder: (context, isObscured) {
        return TextField(
          controller: controller,
          obscureText: isObscured,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            prefixIcon: const Icon(Icons.lock, color: Colors.black),
            suffixIcon: IconButton(
              icon: Icon(
                isObscured ? Icons.visibility : Icons.visibility_off,
                color: Colors.black,
              ),
              onPressed: () =>
                  context.read<PasswordVisibilityCubit>().toggleVisibility(),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }
}