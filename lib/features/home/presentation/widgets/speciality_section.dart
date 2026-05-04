import 'package:docdoc/core/helpers/specialty_icon_resolver.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialitySection extends StatelessWidget {
  final List<SpecializationModel> specializations;
  final VoidCallback? onSeeAll;
  final ValueChanged<SpecializationModel>? onSpecialityTap;

  const SpecialitySection({
    super.key,
    required this.specializations,
    this.onSeeAll,
    this.onSpecialityTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Doctor Speciality', onSeeAll: onSeeAll),
        SizedBox(height: 16.h),
        SizedBox(
          height: 110.h,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: specializations.length,
            separatorBuilder: (_, _) => SizedBox(width: 20.w),
            itemBuilder: (context, index) {
              final spec = specializations[index];
              return _SpecialityItem(
                spec: spec,
                onTap: onSpecialityTap == null
                    ? null
                    : () => onSpecialityTap!(spec),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSeeAll;

  const _SectionHeader({required this.title, this.onSeeAll});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyles.font18DarkBlueBold.copyWith(fontSize: 20.sp),
        ),
        GestureDetector(
          onTap: onSeeAll,
          child: Text('See All', style: TextStyles.font13BlueSemiBold),
        ),
      ],
    );
  }
}

class _SpecialityItem extends StatelessWidget {
  final SpecializationModel spec;
  final VoidCallback? onTap;

  const _SpecialityItem({required this.spec, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 70.r,
            height: 70.r,
            decoration: const BoxDecoration(
              color: ColorsManager.lightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              specialtyIconFor(spec.name),
              color: ColorsManager.mainBlue,
              size: 32.r,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 80.w,
            child: Text(
              spec.name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyles.font14DarkBlueMedium,
            ),
          ),
        ],
      ),
    );
  }
}
