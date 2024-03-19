import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_button.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_input_filed.dart';

class SingInFrom extends StatelessWidget {
  const SingInFrom({
    super.key,
    required this.emailTxtController,
    required this.passTxtController,
    required this.onPressed,
  });

  final Function() onPressed;
  final TextEditingController emailTxtController;
  final TextEditingController passTxtController;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
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
          height: 15,
        ),
        CustomTextInputField(
          textEditingController: passTxtController,
          hint: "enter your password",
          maxLines: 1,
          prefix: const Icon(
            Icons.lock_rounded,
          ),
          isTextPassword: true,
          autoFocus: false,
          textInputType: TextInputType.visiblePassword,
        ),
        const SizedBox(
          height: 20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: CustomTextButton(
              backgroundColor: theme.colorScheme.primary,
              text: "Sign In",
              textColor: theme.colorScheme.background,
              onPressed: onPressed),
        ),
        const SizedBox(height: 15),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            borderRadius: publicRoundedRadius,
            onTap: () {
              GoRouter.of(context).push(
                AppRouter.forgetPasswordScreen,
              );
            },
            child: Text(
              "forgot your password ?",
              textAlign: TextAlign.start,
              style: theme.textTheme.titleMedium,
            ),
          ),
        ),
      ],
    );
  }
}
