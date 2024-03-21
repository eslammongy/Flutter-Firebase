part of 'signin_cubit.dart';

abstract class SignInStates {}

class SignInInitial extends SignInStates {}

class SignInLoadingState extends SignInStates {}

class SignInSuccessState extends SignInStates {
  final UserModel userModel;

  SignInSuccessState({required this.userModel});
}

class SignUpSuccessState extends SignInStates {
  final UserModel userModel;

  SignUpSuccessState({required this.userModel});
}

class SignInWithGoogleSuccessState extends SignInStates {
  final UserModel userModel;

  SignInWithGoogleSuccessState({required this.userModel});
}

class ResetPasswordSuccessState extends SignInStates {}

class PhoneNumberSubmittedState extends SignInStates {
  final String verificationId;

  PhoneNumberSubmittedState({required this.verificationId});
}

class PhoneOtpCodeVerifiedState extends SignInStates {
  final UserModel userModel;

  PhoneOtpCodeVerifiedState({required this.userModel});
}

class SignInGenericFailureState extends SignInStates {
  final String errorMsg;

  SignInGenericFailureState(this.errorMsg);
}
