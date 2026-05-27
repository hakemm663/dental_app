import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Empty-list placeholder used by every screen that loads collections —
/// medical records, appointments, payment methods, search results, etc.
class EmptyStateView extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyStateView({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64.r, color: ColorsManager.lighterGray),
          SizedBox(height: 16.h),
          Text(message, style: TextStyles.font14GrayRegular),
        ],
      ),
    );
  }
}
