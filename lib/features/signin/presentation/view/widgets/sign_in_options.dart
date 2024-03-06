import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../view_model/signin_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/build_login_option_btn.dart';

class SignInOptions extends StatelessWidget {
  const SignInOptions({
    Key? key,
    required this.currentPage,
  }) : super(key: key);

  final String currentPage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<SignInCubit, SignInStates>(
      builder: (context, state) {
        return Column(
          children: [
            const SizedBox(
              height: 20,
            ),
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildLoginOptionBtn(context, onPressed: () async {
                  GoRouter.of(context).push(AppRouter.phoneAuthScreen);
                }, btnText: "Phone"),
                buildLoginOptionBtn(context,
                    iconPath: AppAssetsManager.googleLogo, onPressed: () async {
                  await SignInCubit.get(context).signInWithGoogleAccount();
                }, btnText: "Google")
              ],
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
                      currentPage,
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
