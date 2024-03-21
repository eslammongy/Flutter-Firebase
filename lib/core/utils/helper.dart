import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';

/// this is the default box shadow for the card items
get defBoxShadows => [
      BoxShadow(
        color: const Color(0xFF000000).withOpacity(0.8),
        blurRadius: 1,
        spreadRadius: 0,
        offset: const Offset(2, 2), // vertical shadow distance
      ),
    ];

/// define the public rounded radius in all project
get publicRoundedRadius => BorderRadius.circular(14);

/// displaying a customized snackbar
void displaySnackBar(BuildContext context, String msg) {
  final theme = Theme.of(context);
  final snackBar = SnackBar(
    content: Text(
      msg,
      style: theme.textTheme.bodyMedium,
    ),
    margin: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    backgroundColor: theme.colorScheme.secondary,
    duration: const Duration(milliseconds: 6000),
    behavior: SnackBarBehavior.floating,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

/// Shows a loading dialog in the given [BuildContext].
///
/// The [context] parameter is the [BuildContext] in which the dialog is shown.
/// This function does not return anything.
void showLoadingDialog(BuildContext context) {
  showDialog(
      useSafeArea: true,
      barrierDismissible: false,
      barrierColor: Colors.grey.withOpacity(0.3),
      context: context,
      builder: (context) {
        return generateAlertDialog();
      });
}

AlertDialog generateAlertDialog() {
  return AlertDialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: SizedBox(
      height: 140,
      width: 140,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            AppAssetsManager.loading,
            width: 100,
          ),
        ),
      ),
    ),
  );
}

/// Checks if the given [value] is a valid email address.
/// The [value] parameter should be a string representing the email address to validate.
/// Returns `true` if the [value] is a valid email address, `false` otherwise.
bool isValidEmail(String value) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(value);
}
