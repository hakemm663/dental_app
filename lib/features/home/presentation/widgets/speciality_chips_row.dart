import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SpecialityChipsRow extends StatelessWidget {
  final List<SpecializationModel> specializations;
  final int? selectedId;
  final ValueChanged<int?> onSelected;

  const SpecialityChipsRow({
    super.key,
    required this.specializations,
    required this.selectedId,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(
            label: 'All',
            isSelected: selectedId == null,
            onTap: () => onSelected(null),
          ),
          ...specializations.map(
            (s) => Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _Chip(
                label: s.name,
                isSelected: selectedId == s.id,
                onTap: () => onSelected(s.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.mainBlue
              : ColorsManager.moreLighterGray,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Text(
          label,
          style: TextStyles.font13DarkBlueMedium.copyWith(
            color: isSelected ? Colors.white : ColorsManager.gray,
          ),
        ),
      ),
    );
  }
}
