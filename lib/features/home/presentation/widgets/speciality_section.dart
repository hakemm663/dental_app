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

  IconData _iconFor(String name) {
    final n = name.toLowerCase();
    if (n.contains('neuro')) return Icons.psychology_outlined;
    if (n.contains('pedi') || n.contains('child')) {
      return Icons.child_care_outlined;
    }
    if (n.contains('radio')) return Icons.medical_information_outlined;
    if (n.contains('cardio') || n.contains('heart')) {
      return Icons.favorite_outline;
    }
    if (n.contains('dental') || n.contains('dent')) {
      return Icons.health_and_safety_outlined;
    }
    if (n.contains('eye') || n.contains('ophth')) {
      return Icons.remove_red_eye_outlined;
    }
    if (n.contains('skin') || n.contains('derma')) return Icons.face_outlined;
    return Icons.medical_services_outlined;
  }

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
              _iconFor(spec.name),
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
