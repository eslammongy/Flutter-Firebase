import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/core/errors/errors_enum.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

abstract class SignInRepo {
  Future<Either<AuthResultStatus, UserModel?>> signInWithGoogle(
      {required UserModel userModel});

  Future<Either<AuthResultStatus, UserModel>> signUpWithEmail(
      {required String email, required String password});

  Future<Either<AuthResultStatus, UserModel?>> signInWithEmailPass(
      {required String email, required String password});

  Future<Either<AuthResultStatus, bool>> resetUserPassword(
      {required String email});

  Future<Either<AuthResultStatus, UserModel?>> submitUserPhoneNumber(
      {required String phoneNumber});

  Future<Either<AuthResultStatus, UserModel?>> signInWithPhoneNumber(
      {required String otpCode,
      required String verificationId,
      required UserModel userModel});
}
