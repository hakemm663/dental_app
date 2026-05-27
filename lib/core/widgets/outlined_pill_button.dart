import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Small blue-bordered pill button used as a trailing action in cards —
/// "Get Location" on the booking-confirmed screen, "Change" on the booking
/// summary row, "Get Link" on the reschedule-confirmed screen, etc.
class OutlinedPillButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry? padding;

  const OutlinedPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: ColorsManager.mainBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding:
            padding ?? EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      ),
      child: Text(label, style: TextStyles.font13BlueSemiBold),
    );
  }
}
