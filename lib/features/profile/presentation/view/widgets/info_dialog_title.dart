import 'package:sizer/sizer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class InfoDialogTitleRow extends StatelessWidget {
  const InfoDialogTitleRow({
    Key? key,
    required this.dialogTitle,
    this.onPressed,
  }) : super(key: key);
  final String dialogTitle;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Material(
          color: theme.scaffoldBackgroundColor,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Text(
              dialogTitle,
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(100),
          color: theme.scaffoldBackgroundColor,
          child: SizedBox(
            height: 10.w,
            width: 10.w,
            child: Center(
              child: IconButton(
                onPressed: onPressed,
                icon: Icon(
                  FontAwesomeIcons.solidCircleXmark,
                  color: Colors.red,
                  size: 8.w,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
