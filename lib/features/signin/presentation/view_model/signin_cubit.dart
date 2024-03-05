import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/validation_input.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/signin/data/repos/signin_repo.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
part 'signin_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit({required this.userSignInRepo}) : super(SignInInitial());

  static SignInCubit get(context) => BlocProvider.of(context);
  final UserSignInRepo userSignInRepo;
  UserModel userModel = UserModel();

  Future<void> signInWithGoogleAccount() async {
    emit(SignInLoadingState());
    try {
      var result =
          await userSignInRepo.userSignInWithGoogle(userModel: userModel);
      result.fold((errorStatus) {
        var errorMsg =
            AuthExceptionHandler.generateExceptionMessage(errorStatus);
        emit(SignInFailureState(errorMsg));
      }, (user) async {
        userModel = user!;
        emit(SignInWithGoogleSuccessState(userModel: userModel));
      });
    } catch (e) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(e);
      emit(SignInFailureState(errorMsg));
    }
  }

  Future<void> userRegisterWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    final errorText = isValidUserInput(email: email, password: password);
    if (errorText != null) {
      debugPrint("Email->$email\nPassword->$password");
      emit(SignInFailureState(
          "please make sure you write valid email and valid password."));
      return;
    }
    emit(SignInLoadingState());
    var result = await userSignInRepo.userRegisterWithEmail(
        email: email, password: password);

    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInFailureState(errorMsg));
    }, (userModel) async {
      userModel.name = name;
      this.userModel = userModel;
      emit(SignUpUserSuccessState(userModel: userModel));
    });
  }

  Future<void> userSignINWithEmailPassword(
      {required String email, required String password}) async {
    emit(SignInLoadingState());
    var result = await userSignInRepo.userSignINWithEmail(
        email: email, password: password);

    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(SignInFailureState(errorMsg));
    }, (userModel) async {
      this.userModel = userModel!;
      emit(SignInSuccessState(userModel: this.userModel));
    });
  }

  Future userResetPassword(String email) async {
    emit(UserResetPasswordLoading());
    var result = await userSignInRepo.userResetPassword(email: email);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(UserResetPasswordError(errorMsg));
    }, (right) {
      emit(UserResetPasswordSuccess());
    });
  }
}
