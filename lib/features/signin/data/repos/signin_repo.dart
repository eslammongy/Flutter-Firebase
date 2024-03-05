import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/core/errors/errors_enum.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

abstract class UserSignInRepo {
  Future<Either<AuthResultStatus, UserModel?>> userSignInWithGoogle(
      {required UserModel userModel});

  Future<Either<AuthResultStatus, UserModel>> userRegisterWithEmail(
      {required String email, required String password});

  Future<Either<AuthResultStatus, UserModel?>> userSignINWithEmail(
      {required String email, required String password});

  Future<Either<AuthResultStatus, bool>> userResetPassword(
      {required String email});
}
