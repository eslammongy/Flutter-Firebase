import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/utils/helper.dart';

class CustomTextInputField extends StatelessWidget {
  const CustomTextInputField({
    Key? key,
    required this.textEditingController,
    this.hint,
    this.prefix,
    this.autoFocus = false,
    this.textInputType = TextInputType.text,
    this.onSaved,
    this.maxLines = 1,
    this.isTextPassword = false,
    this.hintColor,
    this.suffix,
    this.text,
  }) : super(key: key);

  final TextEditingController textEditingController;
  final String? text;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType textInputType;
  final bool autoFocus;
  final bool? isTextPassword;
  final int? maxLines;
  final Color? hintColor;
  final Function(String?)? onSaved;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: publicRoundedRadius),
      margin: EdgeInsets.zero,
      elevation: 0,
      child: SizedBox(
        height: 55,
        child: TextFormField(
          autofocus: autoFocus,
          expands: false,
          obscureText: isTextPassword ?? false,
          maxLines: maxLines,
          textAlign: TextAlign.start,
          textAlignVertical: TextAlignVertical.center,
          controller: textEditingController,
          style: theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintStyle: theme.textTheme.bodyMedium
                ?.copyWith(color: theme.colorScheme.surfaceTint),
            focusColor: theme.colorScheme.primary,
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: theme.colorScheme.secondary,
                width: 1,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 25.0, horizontal: 10.0),
            hintText: hint,
            border: InputBorder.none,
            prefixIcon: prefix,
            prefixIconColor: hintColor ?? theme.colorScheme.surfaceTint,
          ),
          cursorColor: theme.colorScheme.primary,
          keyboardType: textInputType,
          onFieldSubmitted: onSaved,
        ),
      ),
    );
  }
}
