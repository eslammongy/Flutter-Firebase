import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../view_model/signin_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/build_login_option_btn.dart';

class SignInWithSocialAccounts extends StatelessWidget {
  const SignInWithSocialAccounts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final signInCubit = SignInCubit.get(context);
    return BlocBuilder<SignInCubit, SignInStates>(
      builder: (context, state) {
        return Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.surfaceTint,
                      thickness: 3,
                    ),
                  ),
                  Card(
                    color: theme.scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                        side: BorderSide(
                            width: 2, color: theme.colorScheme.secondary)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "OR",
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: theme.colorScheme.surfaceTint,
                      thickness: 3,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SignInOptionBtn(
              iconPath: AppAssetsManager.facebookIcon,
              btnText: "SignIn With Facebook",
              signInOption: SignInOption.facebook,
              onPressed: () async {
                ///TODO: implement facebook login
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SignInOptionBtn(
              iconPath: AppAssetsManager.googleIcon,
              btnText: "SignIn With Google",
              signInOption: SignInOption.google,
              onPressed: () async {
                signInCubit.signInWithGoogleAccount();
              },
            ),
            const SizedBox(
              height: 10,
            ),
            SignInOptionBtn(
              iconPath: AppAssetsManager.phoneIcon,
              btnText: "SignIn With Phone Number",
              signInOption: SignInOption.phone,
              onPressed: () async {
                GoRouter.of(context).push(AppRouter.verifyingPhoneScreen);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account",
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.signUpScreen);
                    },
                    child: Text(
                      "Sign up",
                      style: theme.textTheme.titleLarge!.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.secondary),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }
}
