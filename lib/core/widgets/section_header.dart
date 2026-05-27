import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Section heading with bold title and an optional trailing "See All" link.
/// Used by the home recommendation strip, the specialty section, and any
/// future list section that mirrors the Figma pattern.
class SectionHeader extends StatelessWidget {
  final String title;
  final double titleFontSize;
  final VoidCallback? onSeeAll;
  final String seeAllText;

  const SectionHeader({
    super.key,
    required this.title,
    this.titleFontSize = 18,
    this.onSeeAll,
    this.seeAllText = 'See All',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.font18DarkBlueBold.copyWith(
            fontSize: titleFontSize.sp,
          ),
        ),
        if (onSeeAll != null)
          GestureDetector(
            onTap: onSeeAll,
            child: Text(seeAllText, style: TextStyles.font13BlueSemiBold),
          ),
      ],
    );
  }
}
