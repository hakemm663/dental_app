import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordChangedScreen extends StatelessWidget {
  const PasswordChangedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.r,
                height: 100.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorsManager.lightBlue,
                ),
                child: Icon(
                  Icons.check_rounded,
                  size: 56.r,
                  color: ColorsManager.mainBlue,
                ),
              ),
              verticalSpace(32),
              Text(
                'Password Changed!',
                style: TextStyles.font24BlueBold,
                textAlign: TextAlign.center,
              ),
              verticalSpace(12),
              Text(
                'Your password has been changed successfully. You can now log in with your new password.',
                style: TextStyles.font14GrayRegular,
                textAlign: TextAlign.center,
              ),
              verticalSpace(48),
              AppTextButton(
                buttonText: 'Back to Login',
                textStyle: TextStyles.font16WhiteSemiBold,
                onPressed: () => Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil(Routes.loginScreen, (route) => false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
