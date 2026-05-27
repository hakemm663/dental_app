import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Yellow star + numeric rating ("4.8"), optionally suffixed with a review
/// count ("4.8 (12 reviews)"). When [value] is null, renders an em-dash so
/// the row stays the same height.
///
/// Defaults match the design system: 18pt star, `font14DarkBlueMedium` label,
/// 4pt spacer.
class StarRating extends StatelessWidget {
  final double? value;
  final int? reviewsCount;
  final double iconSize;
  final TextStyle? labelStyle;

  const StarRating({
    super.key,
    required this.value,
    this.reviewsCount,
    this.iconSize = 18,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    final label = value == null
        ? '—'
        : reviewsCount != null
        ? '${value!.toStringAsFixed(1)} ($reviewsCount reviews)'
        : value!.toStringAsFixed(1);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.star_rounded,
          color: ColorsManager.ratingStar,
          size: iconSize.r,
        ),
        SizedBox(width: 4.w),
        Text(label, style: labelStyle ?? TextStyles.font14DarkBlueMedium),
      ],
    );
  }
}
