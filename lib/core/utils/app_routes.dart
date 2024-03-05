import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/user_pref.dart';
import '../../features/signin/presentation/view/screens/signup_screen.dart';
import 'package:flutter_firebase/features/signin/data/repos/signin_repo.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
import 'package:flutter_firebase/core/utils/services_locator.dart' as injectable;
import 'package:flutter_firebase/features/signin/data/repos/phone_auth_repo.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/screens/login_screen.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/phone_auth_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/forget_password.dart';
import 'package:flutter_firebase/features/profile/presentation/view/screens/profile_screen.dart';
import 'package:flutter_firebase/features/signin/presentation/view/screens/phone_auth_screen.dart';
import 'package:flutter_firebase/features/signin/presentation/view/screens/verification_otp_screen.dart';

abstract class AppRouter {
  static String onBoardingScreenRout = '/onboardingScreen';
  static String loginScreen = '/loginScreen';
  static String signUpScreen = '/signUpScreen';
  static String forgetPasswordScreen = '/forgetPasswordScreen';
  static String phoneAuthScreen = '/phoneAuthScreen';
  static String verifyingPhoneScreen = '/verifyingPhoneScreen';
  static String profileScreen = '/profileScreen';

  static bool isUserLogin = false;
  static UserModel? currentUser;
  static setInitialRoute() async {
    await UserPref.init();
    await UserPref.getUserInfoLocally().then((user) {
      isUserLogin = user?.name != null;
      currentUser = user;
    });
  }

  static GoRouter appRoutes() {
    return GoRouter(routes: [
      GoRoute(
        path: '/',
        builder: (context, state) {
          if (isUserLogin) {
            return LoginScreen();
          } else {
            return const ProfileScreen();
          }
        },
      ),
      GoRoute(
        path: loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => SignInCubit(
            userSignInRepo: injectable.getIt<UserSignInRepo>(),
          ),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
          path: forgetPasswordScreen,
          builder: (context, state) => BlocProvider(
                create: (context) => SignInCubit(
                  userSignInRepo: injectable.getIt<UserSignInRepo>(),
                ),
                child: ForgetPasswordScreen(),
              )),
      GoRoute(
          path: phoneAuthScreen,
          builder: (context, state) => BlocProvider(
                create: (context) => PhoneAuthCubit(
                  userPhoneAuthRepo: injectable.getIt<UserPhoneAuthRepo>(),
                ),
                child: PhoneAuthScreen(),
              )),
      GoRoute(
        path: verifyingPhoneScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => PhoneAuthCubit(
            userPhoneAuthRepo: injectable.getIt<UserPhoneAuthRepo>(),
          ),
          child: VerificationOtpScreen(
            verifyId: state.extra.toString(),
          ),
        ),
      ),
      GoRoute(
        path: signUpScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => SignInCubit(
            userSignInRepo: injectable.getIt<UserSignInRepo>(),
          ),
          child: SignUpScreen(),
        ),
      ),
      /*  GoRoute(
        path: profileScreen,
        builder: (context, state) => const ProfileScreen(),
      ), */
    ]);
  }
}
