import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_firebase/helper/helper.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Widget buildLoginOptionBtn(BuildContext context,
    {String? iconPath, String? btnText, required Function()? onPressed}) {
  final theme = Theme.of(context);
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
                  child: iconPath != null
                      ? SvgPicture.asset(
                          iconPath,
                          width: 20,
                          fit: BoxFit.scaleDown,
                        )
                      : Icon(
                          FontAwesomeIcons.phone,
                          size: 20,
                          color: theme.colorScheme.primary,
                        )),
              Text(
                btnText ?? "",
                style: theme.textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ));
}
