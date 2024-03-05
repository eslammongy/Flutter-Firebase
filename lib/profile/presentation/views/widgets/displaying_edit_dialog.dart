import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/signin/data/models/user_model.dart';
import 'package:flutter_firebase/profile/presentation/views/widgets/info_dialog_title.dart';
import 'package:flutter_firebase/signin/presentation/views/widgets/custom_text_input_filed.dart';

Future displayingEditInfoDialog(BuildContext context,
    {required UserModel userModel}) async {
  var etNameController = TextEditingController();
  var etEmailController = TextEditingController();
  etNameController.text = userModel.name ?? "";
  etEmailController.text = userModel.email ?? "";
  final theme = Theme.of(context);
  await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (BuildContext buildContext, Animation animation,
          Animation secondaryAnimation) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 20.h, horizontal: 5.w),
          child: Material(
            animationDuration: const Duration(milliseconds: 400),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            color: theme.scaffoldBackgroundColor,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(children: [
                SizedBox(
                  height: 2.h,
                ),
                InfoDialogTitleRow(
                  dialogTitle: "enter your info",
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                SizedBox(
                  height: 4.h,
                ),
                CustomTextInputField(
                  textEditingController: etNameController,
                  hint: "enter your name",
                  maxLines: 1,
                  prefix: Icon(
                    Icons.person,
                    size: 6.w,
                  ),
                  autoFocus: false,
                  textInputType: TextInputType.name,
                ),
                SizedBox(
                  height: 2.h,
                ),
                CustomTextInputField(
                  textEditingController: etEmailController,
                  hint: "enter your email",
                  maxLines: 1,
                  prefix: Icon(
                    Icons.email_rounded,
                    size: 6.w,
                  ),
                  isTextPassword: false,
                  autoFocus: false,
                  textInputType: TextInputType.emailAddress,
                ),
                const Spacer(),
                SizedBox(
                  height: 4.h,
                ),
              ]),
            ),
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween(begin: const Offset(0, 1), end: const Offset(0, 0))
              .animate(anim1),
          child: child,
        );
      });
}
