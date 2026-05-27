import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Rounded-square badge with a coloured background and a single icon — the
/// pattern used by [ProfileMenuItem], booking info rows, settings sub-rows,
/// notification tiles, etc. Defaults match the design system (44pt box,
/// 12pt radius, 22pt icon).
class ColoredIconBadge extends StatelessWidget {
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;
  final double boxSize;
  final double iconSize;
  final double radius;

  const ColoredIconBadge({
    super.key,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
    this.boxSize = 44,
    this.iconSize = 22,
    this.radius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boxSize.r,
      height: boxSize.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius.r),
      ),
      alignment: Alignment.center,
      child: Icon(icon, color: iconColor, size: iconSize.r),
    );
  }
}
