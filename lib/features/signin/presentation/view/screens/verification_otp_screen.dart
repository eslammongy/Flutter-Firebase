import 'package:sizer/sizer.dart';
import 'package:pinput/pinput.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/user_pref.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/profile/presentation/view_model/user_info_cubit.dart';

class VerificationOtpScreen extends StatelessWidget {
  final String verifyId;

  const VerificationOtpScreen({
    Key? key,
    required this.verifyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pinController = TextEditingController();
    final focusNode = FocusNode();
    final formKey = GlobalKey<FormState>();
    final theme = Theme.of(context);

    return BlocConsumer<ProfileInfoCubit, ProfileInfoStates>(
      listener: (context, state) async {
        if (state is ProfileInfoCreatedState) {
          await UserPref.keepUserAuthenticated(isLogged: true).then((value) {
            GoRouter.of(context).pushReplacement(AppRouter.profileScreen);
          });
        }
        if (state is ProfileInfoFailureState) {
          Future(() {
            GoRouter.of(context).pop();
            displaySnackBar(context, state.errorMsg);
          });
        }
      },
      builder: (context, state) {
        SignInCubit.get(context).verificationId = verifyId;

        final PinTheme defaultPinTheme = PinTheme(
          width: 56,
          height: 56,
          textStyle: TextStyle(
            fontSize: 22,
            color: theme.scaffoldBackgroundColor,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.w),
            border:
                Border.all(color: theme.scaffoldBackgroundColor, width: 1.5),
          ),
        );
        return Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                children: [
                  SizedBox(height: 5.h),
                  Text(
                    "Verification",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                  Text(
                    "Code",
                    textAlign: TextAlign.center,
                    style: theme.textTheme.displaySmall,
                  ),
                  SizedBox(
                      width: 90.w,
                      height: 30.h,
                      child: SvgPicture.asset(
                        AppAssetsManager.verificationCodeImg,
                        fit: BoxFit.cover,
                      )),
                  SizedBox(height: 8.h),
                  Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Pinput(
                          controller: pinController,
                          focusNode: focusNode,
                          length: 6,
                          androidSmsAutofillMethod:
                              AndroidSmsAutofillMethod.smsUserConsentApi,
                          listenForMultipleSmsOnAndroid: true,
                          defaultPinTheme: defaultPinTheme,
                          hapticFeedbackType: HapticFeedbackType.lightImpact,
                          onCompleted: (code) {
                            showLoadingDialog(context);
                            SignInCubit.get(context)
                                .signInWithPhoneNumber(code);
                          },
                          cursor: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 9),
                                width: 22,
                                height: 1,
                                color: theme.colorScheme.primary,
                              ),
                            ],
                          ),
                          focusedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                          submittedPinTheme: defaultPinTheme.copyWith(
                            decoration: defaultPinTheme.decoration!.copyWith(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(19),
                              border: Border.all(
                                color: Colors.white,
                              ),
                            ),
                          ),
                          errorPinTheme: defaultPinTheme.copyBorderWith(
                            border: Border.all(color: theme.colorScheme.error),
                          ),
                        ),
                        BlocListener<SignInCubit, SignInStates>(
                          listenWhen: (previous, current) {
                            return previous != current;
                          },
                          listener: (context, state) async {
                            if (state is PhoneOtpCodeVerifiedState) {
                              await ProfileInfoCubit.get(context)
                                  .createNewUserProfile(user: state.userModel);
                            }
                            if (state is SignInGenericFailureState) {
                              Future(() {
                                GoRouter.of(context).pop();
                                displaySnackBar(context, state.errorMsg);
                              });
                            }
                          },
                          child: const SizedBox(),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
