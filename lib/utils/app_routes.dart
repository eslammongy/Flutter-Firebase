import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/splash_screen.dart';
import 'package:flutter_firebase/utils/user_pref.dart';
import '../signin/presentation/views/signup_screen.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/signin/data/repository/signin_repo.dart';
import 'package:flutter_firebase/utils/services_locator.dart' as injectable;
import 'package:flutter_firebase/signin/data/repository/phone_auth_repo.dart';
import 'package:flutter_firebase/signin/presentation/views/login_screen.dart';
import 'package:flutter_firebase/signin/presentation/views/phone_auth_screen.dart';
import 'package:flutter_firebase/signin/presentation/views/verification_otp_screen.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/forget_password.dart';
import 'package:flutter_firebase/signin/presentation/viewModel/signIn/signin_cubit.dart';
import 'package:flutter_firebase/signin/presentation/viewModel/phoneAuth/phone_auth_cubit.dart';

abstract class AppRouter {
  static String onBoardingScreenRout = '/onboardingScreen';
  static String loginScreen = '/loginScreen';
  static String signUpScreen = '/signUpScreen';
  static String forgetPasswordScreen = '/forgetPasswordScreen';
  static String phoneAuthScreen = '/phoneAuthScreen';
  static String verifyingPhoneScreen = '/verifyingPhoneScreen';
  static String dashboardScreen = '/dashboardScreen';
  static String taskDetailsScreen = '/taskDetailsScree';
  static String taskScreen = '/taskScreen';
  static String habitDetailsScreen = '/habitDetailsScreen';
  static String budgetDetailsScreen = '/budgetDetailsScreen';
  static String settingScreen = '/settingScreen';
  static String profileScreen = '/profileScreen';
  static String searchScreen = '/searchScreen';

  static bool isUserLogin = false;
  static UserModel? currentUser;
  static setInitialRoute() async {
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
            return const SplashScreen();
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
