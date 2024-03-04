import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/signin/data/repository/phone_auth_repo.dart';
part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  PhoneAuthCubit({
    required this.userPhoneAuthRepo,
  }) : super(PhoneAuthInitial());

  static PhoneAuthCubit get(context) => BlocProvider.of(context);
  final UserPhoneAuthRepo userPhoneAuthRepo;

  String verificationId = '';
  final firebaseAuth = FirebaseAuth.instance;
  var userModel = UserModel();

  Future<void> submitUserPhoneNumber(String phoneNumber) async {
    emit(PhoneAuthLoading());
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {},
      timeout: const Duration(seconds: 60),
      codeSent: (verificationId, reSendCode) {
        this.verificationId = verificationId;
        emit(PhoneNumberSubmitted());
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
        //  emit(PhoneNumberSubmitted());
      },
      verificationFailed: verificationFailed,
    );
  }

  void verificationFailed(FirebaseAuthException exception) {
    var authErrorStatus = AuthExceptionHandler.handleException(exception);
    var errorMsg =
        AuthExceptionHandler.generateExceptionMessage(authErrorStatus);

    emit(PhoneAuthErrorOccurred(message: errorMsg));
  }

  Future<void> submitOtbCode(String otpCode) async {
    emit(PhoneAuthLoading());

    var result = await userPhoneAuthRepo.userSignInWithPhoneNumber(
       
        otpCode: otpCode,
        userModel: userModel,
        verificationId: verificationId);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(PhoneAuthErrorOccurred(message: errorMsg));
    }, (user) async {
      userModel = user!;
      emit(PhoneOtpCodeVerified(userModel: userModel));
    });
  }
}
