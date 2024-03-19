import 'profile_info_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_firebase/core/errors/exp_enum.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

class ProfileInfoRepoImpl implements ProfileInfoRepo {
  final FirebaseAuth firebaseAuth;
  final DatabaseReference databaseReference =
      FirebaseDatabase.instance.ref().child('users');

  ProfileInfoRepoImpl({required this.firebaseAuth});

  @override
  Future<Either<AuthExceptionsTypes, UserModel>> createNewUserProfile(
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
  Future<Either<AuthExceptionsTypes, UserModel>> fetchUserProfileInfo() async {
    UserModel userModel = UserModel();
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
