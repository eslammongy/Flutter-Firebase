import 'user_info_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/errors/errors_enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/errors/auth_exceptions_handler.dart';





class UserInfoRepoImpl implements UserInfoRepo {
  final FirebaseAuth firebaseAuth;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  UserInfoRepoImpl({required this.firebaseAuth});

  @override
  Future<Either<AuthResultStatus, UserModel>> createNewUser(
      {required UserModel userModel}) async {
    try {
      await databaseReference
          .child(firebaseAuth.currentUser!.uid)
          .set(userModel.toMap());
      return right(userModel);
    } on FirebaseException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    }
  }

  @override
  Future<Either<AuthResultStatus, UserModel>> retrieveUserInfo(
      {required UserModel userModel}) async {
    try {
      await databaseReference
          .child(firebaseAuth.currentUser!.uid)
          .once()
          .then((event) {
        userModel =
            UserModel.fromJson(event.snapshot.value as Map<Object?, Object?>);
      });
      return right(userModel);
    } on FirebaseException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    } on Exception catch (error) {
      return left(AuthExceptionHandler.handleException(error));
    }
  }
}
