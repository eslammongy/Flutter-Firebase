import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_firebase/errors/errors_enum.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/signin/data/repository/phone_auth_repo.dart';


class UserPhoneAuthRepoImpl implements UserPhoneAuthRepo {
  final FirebaseAuth firebaseAuth;

  UserPhoneAuthRepoImpl({required this.firebaseAuth});
  @override
  Future<Either<AuthResultStatus, UserModel?>> userSignInWithPhoneNumber(
      {required String otpCode,
      required String verificationId,
      required UserModel userModel}) async {
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: otpCode);
      var user =
          (await firebaseAuth.signInWithCredential(phoneAuthCredential)).user;

      if (user != null) {
        userModel = UserModel(
            uId: user.uid,
            image: "",
            phone: user.phoneNumber,
            password: "",
            email: "");
        debugPrint("User Phone Number ${userModel.phone}");
        return right(userModel);
      } else {
        return left(AuthResultStatus.undefined);
      }
    } on FirebaseAuthException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    } catch (error) {
      return left(AuthResultStatus.undefined);
    }
  }
}
