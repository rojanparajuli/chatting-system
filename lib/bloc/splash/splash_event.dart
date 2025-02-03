import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class CheckInternetEvent extends SplashEvent {}

class IncrementProgressEvent extends SplashEvent {}