import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/helper/helper.dart';
import 'package:flutter_firebase/utils/user_pref.dart';
import 'package:flutter_firebase/utils/app_routes.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/signin/presentation/viewModel/signIn/signin_cubit.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/user_login_options.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/custom_text_button.dart';
import 'package:flutter_firebase/signin/presentation/viewModel/userInfo/user_info_cubit.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/custom_text_input_filed.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/login_screen_intro_section.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final etPasswordController = TextEditingController();
  final etEmailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userInfoCubit = UserInfoCubit.get(context);
    final theme = Theme.of(context);
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: (context, state) {
        if (state is UserInfoSuccessfulState) {
          Future(() async {
            await UserPref.saveUserLoggedIn(isLogged: true).then((value) async {
              GoRouter.of(context).pushReplacement(AppRouter.dashboardScreen);
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
                              textEditingController: etEmailController,
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
                              textEditingController: etPasswordController,
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
                    CustomLoginBtn(
                        backgroundColor: theme.colorScheme.primary,
                        text: "Sign In",
                        textColor: theme.colorScheme.background,
                        onPressed: () async {
                          await userSignInWithEmail(
                              context,
                              etEmailController.text,
                              etPasswordController.text);
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
                    BlocListener<SignInCubit, SignInState>(
                      listenWhen: (previous, current) {
                        return previous != current;
                      },
                      listener: (context, state) async {
                        if (state is SignInLoadingState) {
                          showLoadingDialog(context);
                        }
                        if (state is SignInWithGoogleSuccessState) {
                          if (userInfoCubit.userModel == null) {
                            Future(() async {
                              await userInfoCubit
                                  .createNewUser(user: state.userModel)
                                  .then((value) async {
                                await _saveUserInfoLocally(
                                    context, state.userModel);
                              });
                            });
                          }
                        }
                        if (state is SignInSuccessState) {
                          final userInfoCubit = UserInfoCubit.get(context);
                          if (userInfoCubit.userModel == null) {
                            await _fetchUserInfo(context);
                          } else {
                            await _saveUserInfoLocally(
                                context, state.userModel);
                          }
                        }
                        if (state is SignInFailureState) {
                          Future(() {
                            GoRouter.of(context).pop();
                            displaySnackBar(context, state.errorMsg);
                          });
                        }
                      },
                      child: const SizedBox(),
                    ),
                    const SizedBox(height: 20),
                    const UserLoginOptions(currentPage: "Sign Up")
                  ]),
            ),
          ),
        );
      },
    );
  }

  Future<void> _fetchUserInfo(BuildContext context) async {
    await UserInfoCubit.get(context).getUserInfo().then((value) async {
      await _saveUserInfoLocally(
          context, UserInfoCubit.get(context).userModel ?? UserModel());
    });
  }

  Future<void> _saveUserInfoLocally(
      BuildContext context, UserModel userModel) async {
    await UserPref.saveUserInfoLocally(userModel: userModel).then((value) {
      GoRouter.of(context).pushReplacement(AppRouter.dashboardScreen);
    });
  }

  userSignInWithEmail(
    BuildContext context,
    String email,
    String password,
  ) async {
    final signInCubit = SignInCubit.get(context);

    if (email.isEmpty || password.isEmpty) {
      displaySnackBar(context, "please make sure you entered all info!");
      return;
    }
    if (!isValidEmail(email)) {
      displaySnackBar(context, "please make sure you entered a valid email!");
      return;
    }

    await signInCubit.userSignINWithEmailPassword(
        email: etEmailController.text, password: etPasswordController.text);
  }
}
