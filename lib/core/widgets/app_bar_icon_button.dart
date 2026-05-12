import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Bordered icon button used in app bars — white background + lighterGray border.
class AppBarIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double? iconSize;

  const AppBarIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(10.r),
        onTap: onTap,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ColorsManager.lighterGray),
          ),
          child: Icon(
            icon,
            size: iconSize ?? 18.r,
            color: ColorsManager.darkBlue,
          ),
        ),
      ),
    );
  }
}
