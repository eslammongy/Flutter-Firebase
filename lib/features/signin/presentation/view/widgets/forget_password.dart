import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_button.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_input_filed.dart';

class ForgetPasswordScreen extends StatelessWidget {
  ForgetPasswordScreen({super.key});
  final eTextEmailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Forget Password"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                height: 10,
              ),
              Image.asset(
                AppAssetsManager.emailSendImage,
                height: 100,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                  "Enter the email associated with your account and we well send an email with instructions to reset your password.",
                  style: theme.textTheme.bodyLarge),
              const SizedBox(
                height: 10,
              ),
              CustomTextInputField(
                  textEditingController: eTextEmailController,
                  hint: "enter your email",
                  isTextPassword: false,
                  prefix: const Icon(
                    Icons.email_rounded,
                  ),
                  textInputType: TextInputType.emailAddress,
                  autoFocus: false,
                  maxLines: 1),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: 120,
                child: CustomLoginBtn(
                  backgroundColor: theme.colorScheme.primary,
                  text: "Send Email",
                  onPressed: () async {
                    await SignInCubit.get(context)
                        .userResetPassword(eTextEmailController.text);
                  },
                ),
              ),
              BlocListener<SignInCubit, SignInState>(
                listenWhen: (previous, current) {
                  return previous != current;
                },
                listener: (context, state) {
                  if (state is UserResetPasswordLoading) {
                    showLoadingDialog(context);
                  }
                  if (state is UserResetPasswordSuccess) {
                    GoRouter.of(context).pushReplacement(AppRouter.loginScreen);
                  }
                  if (state is UserResetPasswordError) {
                    displaySnackBar(context, state.errorMsg);
                    GoRouter.of(context).pop();
                  }
                },
                child: const SizedBox(),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
