import 'package:dartz/dartz.dart';
import 'package:flutter_firebase/errors/errors_enum.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';


abstract class UserInfoRepo {
  Future<Either<AuthResultStatus, UserModel>> createNewUser({required UserModel userModel});
  Future<Either<AuthResultStatus, UserModel>> retrieveUserInfo({required UserModel userModel});
}
