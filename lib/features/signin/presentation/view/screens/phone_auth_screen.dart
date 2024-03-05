import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/custom_text_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/custom_text_input_filed.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/utils/app_routes.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/core/utils/services_locator.dart' as injectable;
import 'package:flutter_firebase/features/signin/presentation/view_model/phone_auth_cubit.dart';


class PhoneAuthScreen extends StatelessWidget {
  PhoneAuthScreen({super.key});
  final phoneNumberController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String countryCode = '+20';
    return BlocConsumer<PhoneAuthCubit, PhoneAuthState>(
      listener: (context, state) {
        if (state is PhoneAuthLoading) {
          showLoadingDialog(context);
        }
        if (state is PhoneNumberSubmitted) {
          GoRouter.of(context).pop();

          GoRouter.of(context).pushReplacement(AppRouter.verifyingPhoneScreen,
              extra: injectable.getIt<PhoneAuthCubit>().verificationId);
        }
        if (state is PhoneAuthErrorOccurred) {
          GoRouter.of(context).pop();
          String errorMeg = state.message;

          displaySnackBar(context, errorMeg);
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width:120,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Image.asset(AppAssetsManager.phoneAuthImages),
                  ),
                ),
                SizedBox(
                  height:20,
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
                          textEditingController: phoneNumberController,
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
                CustomLoginBtn(
                  backgroundColor: theme.colorScheme.primary,
                  text: "Send Code",
                  onPressed: () async {
                    if (phoneNumberController.value.text.isEmpty ||
                        phoneNumberController.value.text.length < 10) {
                      displaySnackBar(
                          context, "please enter the correct phone number..");
                    } else {
                      await injectable
                          .getIt<PhoneAuthCubit>()
                          .submitUserPhoneNumber(
                              "$countryCode${phoneNumberController.value.text}");
                    }
                  },
                ),
                SizedBox(
                  height: 3.h,
                ),
              ],
            ),
          ),
        ));
      },
    );
  }
}
