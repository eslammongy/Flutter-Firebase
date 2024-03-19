import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/core/errors/exp_enum.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

abstract class ProfileInfoRepo {
  Future<Either<AuthExceptionsTypes, UserModel>> createNewUserProfile(
      {required UserModel userModel});
  Future<Either<AuthExceptionsTypes, UserModel>> fetchUserProfileInfo();
}
