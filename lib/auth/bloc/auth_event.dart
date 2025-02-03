abstract class AuthEvent {}

class SignUpRequested extends AuthEvent {
  final String name;
  final String surname;
  final String age;
  final String gender;
  final String username;
  final String email;
  final String password;
  final bool verified;
  final String bio;
  // final String id;

  SignUpRequested({
    required this.name,
    required this.surname,
    required this.age,
    required this.gender,
    required this.username,
    required this.email,
    required this.password,
    required this.bio,
    required this.verified,
    // required this.id,
  });
}

class LoginRequested extends AuthEvent {
  final String emailOrUsername;
  final String password;

  LoginRequested({
    required this.emailOrUsername,
    required this.password,
  });
}

class LogoutEvent extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested({required this.email});
}

class ChangePasswordRequested extends AuthEvent {
  final String currentPassword;
  final String newPassword;

  ChangePasswordRequested({
    required this.currentPassword,
    required this.newPassword,
  });
}
