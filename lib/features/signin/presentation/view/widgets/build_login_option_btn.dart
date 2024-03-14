import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_firebase/core/utils/helper.dart';

class SignInOptionBtn extends StatelessWidget {
  const SignInOptionBtn({
    super.key,
    required this.onPressed,
    required this.iconPath,
    required this.btnText,
  });
  final Function() onPressed;
  final String iconPath;
  final String btnText;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return InkWell(
        onTap: onPressed,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(100)),
            boxShadow: defBoxShadows,
            color: theme.scaffoldBackgroundColor,
            border: Border.all(color: theme.colorScheme.surfaceTint, width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                    width: 60,
                    height: 60,
                    child: SvgPicture.asset(
                      iconPath,
                      width: 20,
                      fit: BoxFit.scaleDown,
                    )),
                Text(
                  btnText,
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
          ),
        ));
  }
}
