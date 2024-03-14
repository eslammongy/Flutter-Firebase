import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_text_input_filed.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_firebase/features/signin/presentation/view_model/signin_cubit.dart';
import 'package:flutter_firebase/features/signin/presentation/view/widgets/custom_text_button.dart';

class PhoneAuthScreen extends StatelessWidget {
  const PhoneAuthScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final phoneNumController = TextEditingController();
    final theme = Theme.of(context);

    String countryCode = '+20';
    return BlocConsumer<SignInCubit, SignInStates>(
      listener: (context, state) {
        if (state is SignInLoadingState) {
          showLoadingDialog(context);
        }
        if (state is PhoneNumberSubmittedState) {
          // pop the loading dialog
          GoRouter.of(context).pop();
          GoRouter.of(context).pushReplacement(AppRouter.verifyingPhoneScreen);
        }
        if (state is SignInGenericFailureState) {
          // pop the loading dialog
          GoRouter.of(context).pop();
          displaySnackBar(context, state.errorMsg);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  width: 120,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Icon(Icons.phone_android_rounded),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                      borderRadius: publicRoundedRadius,
                      color: theme.colorScheme.surface),
                  child: Row(
                    children: [
                      CountryCodePicker(
                        initialSelection: 'EG',
                        favorite: const ['+20', 'EG'],
                        showCountryOnly: false,
                        backgroundColor: theme.colorScheme.surface,
                        dialogBackgroundColor: theme.colorScheme.onBackground,
                        showOnlyCountryWhenClosed: false,
                        dialogTextStyle: theme.textTheme.bodyMedium,
                        textStyle: theme.textTheme.titleMedium,
                        barrierColor:
                            theme.colorScheme.surface.withOpacity(0.3),
                        alignLeft: false,
                        dialogSize: const Size(300, 450),
                        onChanged: (value) {
                          countryCode = value.dialCode!.trim();
                          debugPrint("Country Code${value.dialCode!.trim()}");
                        },
                      ),
                      SizedBox(
                        width: 120,
                        child: CustomTextInputField(
                          textEditingController: phoneNumController,
                          hint: "enter your phone",
                          textInputType: TextInputType.phone,
                          isTextPassword: false,
                          autoFocus: false,
                          maxLines: 1,
                          prefix: const SizedBox(),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 5.h,
                ),
                CustomTextButton(
                  backgroundColor: theme.colorScheme.primary,
                  text: "Send Code",
                  onPressed: () async {
                    if (phoneNumController.text.isEmpty ||
                        phoneNumController.text.length < 10) {
                      displaySnackBar(
                          context, "please enter the correct phone number..");
                    } else {
                      final String phoneWithCountryCode =
                          "$countryCode${phoneNumController.value.text}";
                      await SignInCubit.get(context)
                          .submitUserPhoneNumber(phoneWithCountryCode);
                    }
                  },
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
