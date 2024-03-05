import 'errors_enum.dart';

class AuthExceptionHandler {
  static handleException(error) {
    AuthResultStatus status;
    switch (error) {
      case "invalid-email":
        status = AuthResultStatus.invalidEmail;
        break;
      case "weak-password":
        status = AuthResultStatus.weekPassword;
        break;
      case "wrong-password":
        status = AuthResultStatus.wrongPassword;
        break;
      case "user-not-found":
        status = AuthResultStatus.userNotFound;
        break;
      case "user-disabled":
        status = AuthResultStatus.userDisabled;
        break;
      case "invalid-verification-code":
        status = AuthResultStatus.tooManyRequests;
        break;
      case "operation-not-allowed":
        status = AuthResultStatus.operationNotAllowed;
        break;
      case "email-already-in-use":
        status = AuthResultStatus.emailAlreadyExists;
        break;
      case "notValidUserInput":
        status = AuthResultStatus.notValidUserInput;
        break;
      case "auth/invalid-continue-uri":
        status = AuthResultStatus.authInvalidContinueUri;
        break;
      case "auth/unauthorized-continue-uri":
        status = AuthResultStatus.authUnauthorizedContinueUri;
        break;
      case "auth/missing-ios-bundle-id":
        status = AuthResultStatus.authMissingIosBundleId;
        break;
      case " auth/invalid-email":
        status = AuthResultStatus.authInvalidEmail;
        break;

      default:
        status = AuthResultStatus.undefined;
    }
    return status;
  }

  static String generateExceptionMessage(exceptionCode) {
    String errorMessage;
    switch (exceptionCode) {
      case AuthResultStatus.invalidEmail:
        errorMessage = "Your email address appears to be malformed.";
        break;
      case AuthResultStatus.wrongPassword:
        errorMessage =
            "The password is invalid or the user does not have a password.";
        break;
      case AuthResultStatus.weekPassword:
        errorMessage =
            "The password is invalid or the user does not have a password.";
        break;
      case AuthResultStatus.userNotFound:
        errorMessage = "User with this email doesn't exist.";
        break;
      case AuthResultStatus.userDisabled:
        errorMessage = "User with this email has been disabled.";
        break;
      case AuthResultStatus.tooManyRequests:
        errorMessage = "Too many requests. Try again later.";
        break;
      case AuthResultStatus.operationNotAllowed:
        errorMessage = "Signing in with Email and Password is not enabled.";
        break;
      case AuthResultStatus.emailAlreadyExists:
        errorMessage =
            "The email has already been registered. Please login or reset your password.";
        break;
      case AuthResultStatus.notValidUserInput:
        errorMessage =
            "please make sure you entered all info or correct wrong info...";
        break;
      case AuthResultStatus.authInvalidContinueUri:
        errorMessage = "The continue URL provided in the request is invalid.";
        break;
      case AuthResultStatus.authUnauthorizedContinueUri:
        errorMessage =
            "The domain of the continue URL is not whitelisted. Whitelist the domain in the Firebase console.";
        break;
      case AuthResultStatus.authMissingIosBundleId:
        errorMessage =
            "An iOS Bundle ID must be provided if an App Store ID is provided.";
        break;
      case AuthResultStatus.authInvalidEmail:
        errorMessage = "Thrown if the email address is not valid.";
        break;
      default:
        errorMessage = "An undefined Error happened.";
    }

    return errorMessage;
  }
}
