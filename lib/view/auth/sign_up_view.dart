import 'package:audiocall/auth/bloc/auth_bloc.dart';
import 'package:audiocall/auth/bloc/auth_event.dart';
import 'package:audiocall/auth/bloc/auth_state.dart';
import 'package:audiocall/view/auth/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController bioController = TextEditingController();

  String selectedGender = 'Male';
  bool verified = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFE6E6FA),
        resizeToAvoidBottomInset: false,
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            print('state is $state');
            if (state is AuthLoading) {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) =>
                    const Center(child: CircularProgressIndicator()),
              );
            }
                          print('state is $state');

            if (state is AuthSuccess) {
              print('state is $state');
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.green),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            }
                            print('state is $state');

            if (state is AuthFailure) {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              }
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(state.message), backgroundColor: Colors.red),
              );
            }
          },
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: const BoxDecoration(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 200,
                      child:
                          Image.asset('assets/logo.png', fit: BoxFit.contain),
                    ),
                    const SizedBox(height: 20),
                    buildTextField(nameController, 'Name'),
                    const SizedBox(height: 12),
                    buildTextField(surnameController, 'Surname'),
                    const SizedBox(height: 12),
                    buildTextField(bioController, 'Bio', maxLines: 3),
                    const SizedBox(height: 12),
                    buildTextField(ageController, 'Age',
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: selectedGender,
                      items: ['Male', 'Female', 'Others']
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text(gender,
                                    style:
                                        const TextStyle(color: Colors.black)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        selectedGender = value!;
                      },
                      decoration: InputDecoration(
                        labelText: 'Gender',
                        labelStyle: const TextStyle(color: Colors.black),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    buildTextField(usernameController, 'Username'),
                    const SizedBox(height: 12),
                    buildTextField(emailController, 'Email',
                        keyboardType: TextInputType.emailAddress),
                    const SizedBox(height: 12),
                    buildPasswordField(context, passwordController, 'Password'),
                    const SizedBox(height: 12),
                    buildPasswordField(
                        context, confirmPasswordController, 'Confirm Password'),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
                        if (passwordController.text !=
                            confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Passwords do not match')),
                          );
                          return;
                        } else if (nameController.text.isEmpty &&
                            surnameController.text.isEmpty &&
                            ageController.text.isEmpty &&
                            usernameController.text.isEmpty &&
                            emailController.text.isEmpty &&
                            passwordController.text.isEmpty &&
                            bioController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please fill all the fields')),
                          );
                          return;
                        } else {
                          context.read<AuthBloc>().add(SignUpRequested(
                                name: nameController.text,
                                surname: surnameController.text,
                                age: ageController.text,
                                gender: selectedGender,
                                username: usernameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                                verified: false,
                                bio: bioController.text,
                                // id: '',
                              ));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 154, 154, 242),
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String label,
      {bool isPassword = false,
      int maxLines = 1,
      TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        filled: true,
        fillColor: Colors.white,
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
