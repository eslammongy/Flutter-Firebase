import 'package:sizer/sizer.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/utils/helper.dart';
import 'package:flutter_firebase/core/constants/app_assets.dart';
import 'package:flutter_firebase/features/profile/presentation/view_model/user_info_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var userModel = UserInfoCubit.get(context).userModel;
    return BlocConsumer<UserInfoCubit, UserInfoState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Column(
          children: <Widget>[
            SizedBox(
              height: 2.h,
            ),
            Container(
              width: 40.w,
              height: 40.w,
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(100),
                border:
                    Border.all(width: 3, color: theme.colorScheme.surfaceTint),
                boxShadow: defBoxShadows,
              ),
              child: SvgPicture.asset(
                AppAssetsManager.takeNotesImg,
                width: 30.w,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            Text(
              userModel!.name ?? 'Fox Tracker',
            ),
            SizedBox(
              height: 3.h,
            ),
            SizedBox(
              height: 1.h,
            ),
          ],
        );
      },
    );
  }
}
