import 'package:flutter/material.dart';
import 'package:flutter_firebase/helper/helper.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    Key? key,
    required this.textEditingController,
    required this.hint,
    required this.prefix,
    required this.autoFocus,
    required this.textInputType,
    this.onSaved,
    this.maxLines = 1,
    this.isTextPassword = false,
    this.hintColor,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String hint;
  final Widget prefix;
  final TextInputType textInputType;
  final bool autoFocus;
  final bool? isTextPassword;
  final int? maxLines;
  final Color? hintColor;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
        height: 60,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: publicRoundedRadius),
          margin: EdgeInsets.zero,
          elevation: 0,
          child: Align(
            alignment: Alignment.centerLeft,
            child: TextFormField(
              autofocus: autoFocus,
              obscureText: isTextPassword ?? false,
              maxLines: maxLines,
              textAlign: TextAlign.start,
              textAlignVertical: TextAlignVertical.center,
              controller: textEditingController,
              style: theme.textTheme.titleMedium!.copyWith(),
              decoration: InputDecoration(
                hintStyle: theme.textTheme.bodyMedium!
                    .copyWith(color: theme.colorScheme.surfaceTint),
                contentPadding:
                    const EdgeInsets.only(top: 4, bottom: 8, left: 5, right: 5),
                hintText: hint,
                border: InputBorder.none,
                isCollapsed: true,
                isDense: true,
                prefixIcon: prefix,
                prefixIconColor: hintColor ?? theme.colorScheme.surfaceTint,
              ),
              cursorColor: theme.colorScheme.primary,
              keyboardType: textInputType,
              onFieldSubmitted: onSaved,
            ),
          ),
        ));
  }
}
