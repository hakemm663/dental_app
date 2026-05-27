import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelAppointmentDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const CancelAppointmentDialog({super.key, required this.onConfirm});

  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => CancelAppointmentDialog(
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.dangerRedBg,
              ),
              child: Icon(
                Icons.calendar_today_outlined,
                color: ColorsManager.dangerRed,
                size: 28.r,
              ),
            ),
            SizedBox(height: 20.h),
            Text('Cancel Appointment', style: TextStyles.font18DarkBlueBold),
            SizedBox(height: 8.h),
            Text(
              'Are you sure you want to cancel\nyour appointment?',
              textAlign: TextAlign.center,
              style: TextStyles.font14GrayRegular,
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: ColorsManager.lighterGray),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Keep It',
                      style: TextStyles.font14DarkBlueMedium,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsManager.dangerRed,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes, Cancel',
                      style: TextStyles.font14DarkBlueMedium.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
