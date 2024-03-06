import 'package:flutter/material.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';

class LoginScreenIntroSection extends StatelessWidget {
  const LoginScreenIntroSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(
          child: Image.asset(
            AppAssetsManager.appLogoSvg,
            width: 100,
            fit: BoxFit.contain,
          ),
        ),
        Text(
          "Welcome Back!",
          style: theme.textTheme.headlineMedium!
              .copyWith(fontWeight: FontWeight.w600),
        ),
        Text(
          "sing in to continue",
          style: theme.textTheme.bodyMedium!
              .copyWith(color: theme.colorScheme.surfaceTint),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
