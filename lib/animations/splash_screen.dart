import 'package:audiocall/bloc/splash/splash_bloc.dart';
import 'package:audiocall/bloc/splash/splash_event.dart';
import 'package:audiocall/bloc/splash/splash_state.dart';
import 'package:audiocall/my_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashCompletedState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const OnBoard()),
            );
          }
        },
        child: BlocBuilder<SplashBloc, SplashState>(
          builder: (context, state) {
            final ValueNotifier<double> progressNotifier =
                ValueNotifier<double>(
              state is InternetAvailableState ? state.progress / 100 : 0.0,
            );

            if (state is InternetAvailableState) {
              progressNotifier.value = state.progress / 100;
            }

            return Container(
              decoration: const BoxDecoration(color: Colors.white),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      height: 400,
                      width: 400,
                    ),
                    const SizedBox(height: 40),
                    if (state is CheckingInternetState) ...[
                      const Text(
                        'Checking Internet Connection...',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 20),
                      const CircularProgressIndicator(
                        color: Colors.green,
                      ),
                    ] else if (state is InternetNotAvailableState) ...[
                      const Icon(
                        Icons.wifi_off,
                        size: 80,
                        color: Colors.redAccent,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Internet Connection',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          context.read<SplashBloc>().add(CheckInternetEvent());
                        },
                        child: const Text('Retry'),
                      ),
                    ] else if (state is InternetAvailableState) ...[
                      Text(
                        '${state.progress}%',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      AnimatedBuilder(
                        animation: progressNotifier,
                        builder: (context, _) {
                          return Container(
                            height: 6,
                            width: 200,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              gradient: const LinearGradient(
                                colors: [Colors.greenAccent, Colors.lightGreen],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  // ignore: deprecated_member_use
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(2, 2),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: LinearProgressIndicator(
                                value: progressNotifier.value,
                                backgroundColor: Colors.transparent,
                                minHeight: 6,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
