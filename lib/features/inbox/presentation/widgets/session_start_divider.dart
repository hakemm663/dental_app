import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SessionStartDivider extends StatelessWidget {
  const SessionStartDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
          decoration: BoxDecoration(
            color: ColorsManager.moreLighterGray,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            'Session Start',
            style: TextStyle(
              fontSize: 12.sp,
              color: ColorsManager.gray,
            ),
          ),
        ),
      ),
    );
  }
}
