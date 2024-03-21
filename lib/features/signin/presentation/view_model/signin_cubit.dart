import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/signin/data/repos/signin_repo.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
part 'signin_state.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit({required this.signInRepo}) : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);
  final SignInRepo signInRepo;

  Future<void> signInWithGoogleAccount() async {
    emit(SignInLoadingState());
    try {
      var result = await signInRepo.signInWithGoogle();
      result.fold((errorCode) {
        var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorCode);
        emit(SignInGenericFailureState(errorMsg));
      }, (user) async {
        emit(SignInWithGoogleSuccessState(userModel: user));
      });
    } catch (exp) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(exp);
      emit(SignInGenericFailureState(errorMsg));
    }
  }

  Future<void> signUpWithEmailPassword({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingState());
    var result =
        await signInRepo.signUpWithEmail(email: email, password: password);
    result.fold((errorCode) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(errorCode);
      emit(SignInGenericFailureState(errorMsg));
    }, (userModel) async {
      emit(SignUpSuccessState(userModel: userModel));
    });
  }

  Future<void> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    emit(SignInLoadingState());
    var result =
        await signInRepo.signInWithEmailPass(email: email, password: password);
    result.fold((errorCode) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(errorCode);
      emit(SignInGenericFailureState(errorMsg));
    }, (userModel) async {
      emit(SignInSuccessState(userModel: userModel));
    });
  }

  Future resetUserPassword(String email) async {
    emit(SignInLoadingState());
    var result = await signInRepo.resetUserPassword(email: email);
    result.fold((errorCode) {
      final errorMsg = AuthExceptionHandler.generateExceptionMessage(errorCode);
      emit(SignInGenericFailureState(errorMsg));
    }, (right) {
      emit(ResetPasswordSuccessState());
    });
  }

  Future<void> submitUserPhoneNumber(String phoneNumber) async {
    emit(SignInLoadingState());
    await signInRepo.submitUserPhoneNumber(
      phoneNumber: phoneNumber,
      setVerificationCode: (verifyCode) {
        debugPrint("#submitUserPhoneNumber verificationId: $verifyCode");
        emit(PhoneNumberSubmittedState(verificationId: verifyCode));
      },
      verificationFailed: (authException) {
        final errorMsg =
            AuthExceptionHandler.generateExceptionMessage(authException);
        emit(SignInGenericFailureState(errorMsg));
      },
    );
  }

  Future<void> signInWithPhoneNumber(
      String otpCode, String verificationId) async {
    emit(SignInLoadingState());

    debugPrint(
        "Verify Code:: verificationId: $verificationId--otpCode: $otpCode");
    var result = await signInRepo.signInWithPhoneNumber(
      otpCode: otpCode,
      verificationId: verificationId,
    );
    result.fold((errorCode) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorCode);
      emit(SignInGenericFailureState(errorMsg));
    }, (userModel) async {
      emit(PhoneOtpCodeVerifiedState(userModel: userModel));
    });
  }
}
