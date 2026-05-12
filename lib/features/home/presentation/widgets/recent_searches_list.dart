import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecentSearchesList extends StatelessWidget {
  final List<String> searches;
  final ValueChanged<String> onTap;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const RecentSearchesList({
    super.key,
    required this.searches,
    required this.onTap,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (searches.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Search', style: TextStyles.font18DarkBlueBold),
            GestureDetector(
              onTap: onClearAll,
              child: Text(
                'Clear All History',
                style: TextStyles.font13BlueSemiBold,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        ...searches.map((q) => _RecentSearchItem(
              query: q,
              onTap: () => onTap(q),
              onRemove: () => onRemove(q),
            )),
      ],
    );
  }
}

class _RecentSearchItem extends StatelessWidget {
  final String query;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  const _RecentSearchItem({
    required this.query,
    required this.onTap,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Icon(
              Icons.access_time_rounded,
              size: 20.r,
              color: ColorsManager.gray,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(query, style: TextStyles.font14DarkBlueMedium),
            ),
            GestureDetector(
              onTap: onRemove,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.all(4.r),
                child: Icon(
                  Icons.close_rounded,
                  size: 18.r,
                  color: ColorsManager.gray,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
