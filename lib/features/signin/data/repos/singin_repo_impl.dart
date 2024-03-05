import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_firebase/core/errors/errors_enum.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/signin/data/repos/signin_repo.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';

class SignInRepoImplementation implements SignInRepo {
  FirebaseAuth firebaseAuth;
  SignInRepoImplementation({
    required this.firebaseAuth,
  });

  @override
  Future<Either<AuthResultStatus, UserModel?>> signInWithGoogle(
      {required UserModel userModel}) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleAccount = await googleSignIn.signIn();
      GoogleSignInAuthentication? authentication =
          await googleAccount?.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: authentication?.idToken,
          accessToken: authentication?.accessToken);
      User? user;

      await firebaseAuth.signInWithCredential(credential).then((value) {
        user = value.user!;
        debugPrint("additional user info=> ${value.additionalUserInfo}");
      });

      if (user != null) {
        userModel = UserModel(
            uId: user!.uid,
            name: user!.displayName,
            email: user!.email,
            image: user!.photoURL,
            phone: user!.phoneNumber);

        return right(userModel);
      } else {
        return left(AuthResultStatus.undefined);
      }
    } on PlatformException catch (ex) {
      return left(AuthExceptionHandler.handleException(ex.message));
    } on FirebaseAuthException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    }
  }

  @override
  Future<Either<AuthResultStatus, UserModel>> signUpWithEmail(
      {required String email, required String password}) async {
    try {
      var userModel = UserModel();
      await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((userCredential) {
        userModel = UserModel(
          uId: userCredential.user!.uid,
          name: userCredential.user?.displayName,
          email: email,
          phone: userCredential.user?.phoneNumber,
          password: password,
        );
      });

      return right(userModel);
    } on FirebaseAuthException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    } catch (error) {
      return left(
          AuthExceptionHandler.handleException(AuthResultStatus.undefined));
    }
  }

  @override
  Future<Either<AuthResultStatus, UserModel?>> signInWithEmailPass(
      {required String email, required String password}) async {
    try {
      var user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user;
      if (user != null) {
        var userModel = UserModel(
            uId: user.uid,
            name: user.displayName,
            email: user.email,
            image: user.photoURL,
            phone: user.phoneNumber);

        return right(userModel);
      } else {
        return left(AuthResultStatus.undefined);
      }
    } on FirebaseAuthException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    } catch (error) {
      debugPrint("when user sign in => ${error.toString()}");
      return left(
          AuthExceptionHandler.handleException(AuthResultStatus.undefined));
    }
  }

  @override
  Future<Either<AuthResultStatus, bool>> resetUserPassword(
      {required String email}) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email).then((value) {
        return right(true);
      });
      return right(true);
    } on FirebaseAuthException catch (error) {
      return left(AuthExceptionHandler.handleException(error.code));
    } catch (e) {
      return left(
          AuthExceptionHandler.handleException(AuthResultStatus.undefined));
    }
  }

  @override
  Future<Either<AuthResultStatus, UserModel?>> submitUserPhoneNumber(
      {required String phoneNumber}) async {
    await firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (credential) async {},
      timeout: const Duration(seconds: 30),
      codeSent: (verificationId, reSendCode) {
        this.verificationId = verificationId;
      
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        this.verificationId = verificationId;
      },
      verificationFailed: verificationFailed,
    );
  }

  @override
  Future<Either<AuthResultStatus, UserModel?>> signInWithPhoneNumber(
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
