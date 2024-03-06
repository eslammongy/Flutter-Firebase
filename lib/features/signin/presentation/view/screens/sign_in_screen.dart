import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/user_pref.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/profile/presentation/view_model/user_info_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/sign_in_options.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_button.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_input_filed.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/login_screen_intro_section.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final passwordTxtController = TextEditingController();
    final emailTxtController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    final userInfoCubit = UserInfoCubit.get(context);
    final theme = Theme.of(context);
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoSuccessfulState) {
          Future(() async {
            await UserPref.saveUserLoggedIn(isLogged: true).then((value) async {
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
                    const SizedBox(
                      height: 10,
                    ),
                    const LoginScreenIntroSection(),
                    Form(
                        key: formKey,
                        child: Column(
                          children: [
                            CustomTextInputField(
                              textEditingController: emailTxtController,
                              hint: "enter your email",
                              maxLines: 1,
                              prefix: const Icon(
                                Icons.email_rounded,
                              ),
                              isTextPassword: false,
                              autoFocus: false,
                              textInputType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CustomTextInputField(
                              textEditingController: passwordTxtController,
                              hint: "enter your password",
                              maxLines: 1,
                              prefix: const Icon(
                                Icons.lock_rounded,
                              ),
                              isTextPassword: true,
                              autoFocus: false,
                              textInputType: TextInputType.visiblePassword,
                            )
                          ],
                        )),
                    const SizedBox(height: 20),
                    CustomTextButton(
                        backgroundColor: theme.colorScheme.primary,
                        text: "Sign In",
                        textColor: theme.colorScheme.background,
                        onPressed: () async {
                          await userSignInWithEmail(
                            context,
                            emailTxtController,
                            passwordTxtController,
                          );
                        }),
                    const SizedBox(height: 15),
                    InkWell(
                      onTap: () {
                        GoRouter.of(context).push(
                          AppRouter.forgetPasswordScreen,
                        );
                      },
                      child: Text(
                        "forgot your password ?",
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    BlocListener<SignInCubit, SignInStates>(
                      listener: (context, state) async {
                        if (state is SignInLoadingState) {
                          showLoadingDialog(context);
                        }
                        if (state is SignInWithGoogleSuccessState) {
                          if (userInfoCubit.userModel == null) {
                            await userInfoCubit
                                .createNewUser(user: state.userModel)
                                .then((value) async {
                              await _saveUserInfoLocally(
                                  context, state.userModel);
                            });
                          }
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
                    const SizedBox(height: 20),
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
      await _saveUserInfoLocally(
          context, UserInfoCubit.get(context).userModel ?? UserModel());
    });
  }

  Future<void> _saveUserInfoLocally(
      BuildContext context, UserModel userModel) async {
    await UserPref.saveUserInfoLocally(userModel: userModel).then((value) {
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
