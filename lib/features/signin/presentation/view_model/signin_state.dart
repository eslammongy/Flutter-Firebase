part of 'signin_cubit.dart';

abstract class SignInState {}

class SignInInitial extends SignInState {}

class SignInLoadingState extends SignInState {}

class SignInSuccessState extends SignInState {
  final UserModel userModel;

  SignInSuccessState({required this.userModel});
}

class SignUpUserSuccessState extends SignInState {
  final UserModel userModel;

  SignUpUserSuccessState({required this.userModel});
}

class SignInWithGoogleSuccessState extends SignInState {
  final UserModel userModel;

  SignInWithGoogleSuccessState({required this.userModel});
}

class SignInFailureState extends SignInState {
  final String errorMsg;

  SignInFailureState(this.errorMsg);
}

class UserResetPasswordLoading extends SignInState {}

class UserResetPasswordSuccess extends SignInState {}

class UserResetPasswordError extends SignInState {
  final String errorMsg;

  UserResetPasswordError(this.errorMsg);
}
