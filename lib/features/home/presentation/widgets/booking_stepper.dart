import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingStepper extends StatelessWidget {
  final int currentStep;

  const BookingStepper({super.key, required this.currentStep});

  static const List<String> _labels = ['Date & Time', 'Payment', 'Summary'];
  static const Color _doneColor = ColorsManager.successGreen;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(_labels.length * 2 - 1, (i) {
        if (i.isOdd) {
          final stepIndex = i ~/ 2;
          final filled = stepIndex < currentStep;
          return Expanded(
            child: Container(
              height: 2.h,
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              color: filled ? _doneColor : ColorsManager.lighterGray,
            ),
          );
        }
        final stepIndex = i ~/ 2;
        final isActive = stepIndex == currentStep;
        final isDone = stepIndex < currentStep;
        return _StepCircle(
          index: stepIndex,
          label: _labels[stepIndex],
          isActive: isActive,
          isDone: isDone,
        );
      }),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final String label;
  final bool isActive;
  final bool isDone;

  const _StepCircle({
    required this.index,
    required this.label,
    required this.isActive,
    required this.isDone,
  });

  @override
  Widget build(BuildContext context) {
    final Color circleColor;
    final Color labelColor;
    if (isDone) {
      circleColor = BookingStepper._doneColor;
      labelColor = BookingStepper._doneColor;
    } else if (isActive) {
      circleColor = ColorsManager.mainBlue;
      labelColor = ColorsManager.darkBlue;
    } else {
      circleColor = ColorsManager.lighterGray;
      labelColor = ColorsManager.gray;
    }

    return Column(
      children: [
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(shape: BoxShape.circle, color: circleColor),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: labelColor,
            fontWeight: isActive || isDone ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
