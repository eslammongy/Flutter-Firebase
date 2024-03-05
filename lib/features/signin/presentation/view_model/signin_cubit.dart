import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/core/utils/validation_input.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/signin/data/repos/signin_repo.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
part 'signin_state.dart';

class SignInCubit extends Cubit<SignInStates> {
  SignInCubit({required this.signInRepo}) : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);
  final SignInRepo signInRepo;
  UserModel userModel = UserModel();
  String verificationId = '';

  Future<void> signInWithGoogleAccount() async {
    emit(SignInLoadingState());
    try {
      var result = await signInRepo.signInWithGoogle(userModel: userModel);
      result.fold((errorStatus) {
        var errorMsg =
            AuthExceptionHandler.generateExceptionMessage(errorStatus);
        emit(SignInGenericFailureState(errorMsg));
      }, (user) async {
        userModel = user!;
        emit(SignInWithGoogleSuccessState(userModel: userModel));
      });
    } catch (e) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(e);
      emit(SignInGenericFailureState(errorMsg));
    }
  }

  Future<void> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    final errorText = isValidUserInput(email: email, password: password);
    if (errorText != null) {
      emit(SignInGenericFailureState(
          "please make sure you write valid email and valid password."));
      return;
    }
    emit(SignInLoadingState());
    var result =
        await signInRepo.signUpWithEmail(email: email, password: password);

    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInGenericFailureState(errorMsg));
    }, (userModel) async {
      userModel.name = name;
      this.userModel = userModel;
      emit(SignUpSuccessState(userModel: userModel));
    });
  }

  Future<void> signInWithEmailPassword(
      {required String email, required String password}) async {
    emit(SignInLoadingState());
    var result =
        await signInRepo.signInWithEmailPass(email: email, password: password);

    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInGenericFailureState(errorMsg));
    }, (userModel) async {
      this.userModel = userModel!;
      emit(SignInSuccessState(userModel: this.userModel));
    });
  }

  Future resetUserPassword(String email) async {
    emit(SignInLoadingState());
    var result = await signInRepo.resetUserPassword(email: email);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInGenericFailureState(errorMsg));
    }, (right) {
      emit(ResetPasswordSuccessState());
    });
  }

  Future<void> submitUserPhoneNumber(String phoneNumber) async {
    emit(SignInLoadingState());
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {},
      timeout: const Duration(seconds: 60),
      codeSent: (verificationId, reSendCode) {
        this.verificationId = verificationId;
        emit(PhoneNumberSubmittedState());
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

    emit(SignInGenericFailureState(errorMsg));
  }

  Future<void> signInWithPhoneNumber(String otpCode) async {
    emit(SignInLoadingState());

    var result = await signInRepo.signInWithPhoneNumber(
        otpCode: otpCode, userModel: userModel, verificationId: verificationId);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInGenericFailureState(errorMsg));
    }, (user) async {
      userModel = user!;
      emit(PhoneOtpCodeVerifiedState(userModel: userModel));
    });
  }
}
