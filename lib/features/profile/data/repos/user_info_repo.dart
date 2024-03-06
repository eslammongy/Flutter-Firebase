import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/core/errors/exp_enum.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

abstract class UserInfoRepo {
  Future<Either<AuthExceptionsTypes, UserModel>> createNewUser(
      {required UserModel userModel});
  Future<Either<AuthExceptionsTypes, UserModel>> retrieveUserInfo(
      {required UserModel userModel});
}
