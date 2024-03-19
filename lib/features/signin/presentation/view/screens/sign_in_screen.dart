import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/user_pref.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/signin_from.dart';
import 'package:flutter_firebase/features/profile/presentation/view_model/user_info_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/sign_in_options.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/login_screen_intro_section.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordTxtController = TextEditingController();
    final emailTxtController = TextEditingController();
    final userInfoCubit = UserInfoCubit.get(context);
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoSuccessfulState) {
          Future(() async {
            await UserPref.keepUserAuthenticated(isLogged: true)
                .then((value) async {
              GoRouter.of(context).pushReplacement(AppRouter.profileScreen);
            });
          });
        }
        if (state is UserInfoFailureState) {
          displaySnackBar(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8.h,
                    ),
                    const LoginScreenIntroSection(
                      introText: "Welcome Back",
                      subIntroText: "Sign in to continue",
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SingInFrom(
                      emailTxtController: emailTxtController,
                      passTxtController: passwordTxtController,
                      onPressed: () async {
                        await userSignInWithEmail(
                          context,
                          emailTxtController,
                          passwordTxtController,
                        );
                      },
                    ),
                    const SizedBox(height: 20),
                    BlocListener<SignInCubit, SignInStates>(
                      listener: (context, state) async {
                        if (state is SignInLoadingState) {
                          showLoadingDialog(context);
                        }
                        if (state is SignInWithGoogleSuccessState) {
                          await userInfoCubit
                              .createNewUser(user: state.userModel)
                              .then((value) async {
                            await _keepUserLoggedIn(context);
                          });
                        }
                        if (state is SignInSuccessState) {
                          Future(() async {
                            await _getUserInfo(context);
                          });
                        }
                        if (state is SignInGenericFailureState) {
                          Future(() {
                            //pop the loading dialog
                            GoRouter.of(context).pop();
                            displaySnackBar(context, state.errorMsg);
                          });
                        }
                      },
                      child: const SizedBox(),
                    ),
                    const SignInOptions()
                  ]),
            ),
          ),
        );
      },
    );
  }

  Future<void> _getUserInfo(BuildContext context) async {
    await UserInfoCubit.get(context).getUserInfo().then((value) async {
      await _keepUserLoggedIn(context);
    });
  }

  Future<void> _keepUserLoggedIn(BuildContext context) async {
    await UserPref.keepUserAuthenticated(isLogged: true).then((value) {
      GoRouter.of(context).pushReplacement(AppRouter.profileScreen);
    });
  }

  userSignInWithEmail(
    BuildContext context,
    TextEditingController emailController,
    TextEditingController passwordController,
  ) async {
    final signInCubit = SignInCubit.get(context);
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      displaySnackBar(context, "please make sure you entered all info!");
      return;
    }
    if (!isValidEmail(emailController.text)) {
      displaySnackBar(context, "please make sure you entered a valid email!");
      return;
    }
    await signInCubit.signInWithEmailPassword(
        email: emailController.text, password: passwordController.text);
  }
}
