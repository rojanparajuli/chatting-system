import 'package:audiocall/auth/bloc/auth_event.dart';
import 'package:audiocall/auth/bloc/auth_state.dart';
import 'package:audiocall/repository/auth_respository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc(this.authRepository) : super(AuthInitial()) {
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.signUp(
          name: event.name,
          surname: event.surname,
          age: event.age,
          gender: event.gender,
          username: event.username,
          email: event.email,
          password: event.password,
          bio: event.bio,
          verified: event.verified,
        );
        emit(AuthSuccess(message: "Signup successful!"));
      } catch (e) {
        emit(AuthFailure("Signup failed: ${e.toString()}"));
      }
    });

    on<LoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await authRepository.loginWithEmailOrUsername(
          event.emailOrUsername,
          event.password,
        );
        if (user != null) {
          await authRepository.saveToken(user);
          emit(AuthSuccess(message: "Login successful!"));
        } else {
          emit(AuthFailure('Invalid credentials'));
        }
      } catch (e) {
        emit(AuthFailure("Login failed: ${e.toString()}"));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.logout();
        emit(AuthInitial());
      } catch (e) {
        emit(AuthFailure("Logout failed: ${e.toString()}"));
      }
    });

    on<ForgotPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.forgotPassword(event.email);
        emit(AuthSuccess(message: 'Password reset email sent!'));
      } catch (e) {
        emit(AuthFailure("Error: ${e.toString()}"));
      }
    });

    on<ChangePasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await authRepository.changePassword(
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(AuthSuccess(message: 'Password changed successfully!'));
      } catch (e) {
        emit(AuthFailure("Change password failed: ${e.toString()}"));
      }
    });
  }
}

class PasswordVisibilityCubit extends Cubit<bool> {
  PasswordVisibilityCubit() : super(true);

  void toggleVisibility() => emit(!state);
}
