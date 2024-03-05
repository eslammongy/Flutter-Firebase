part of 'phone_auth_cubit.dart';

@immutable
abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthErrorOccurred extends PhoneAuthState {
  final String message;

  PhoneAuthErrorOccurred({required this.message});
}

class PhoneNumberSubmitted extends PhoneAuthState {}

class PhoneOtpCodeVerified extends PhoneAuthState {
  final UserModel userModel;

  PhoneOtpCodeVerified({required this.userModel});
}
