import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/specialization_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SortFilterResult {
  final int? specializationId;
  final double? minRating;

  const SortFilterResult({this.specializationId, this.minRating});
}

class SortFilterSheet extends StatefulWidget {
  final List<SpecializationModel> specializations;
  final int? initialSpecializationId;
  final double? initialMinRating;

  const SortFilterSheet({
    super.key,
    required this.specializations,
    this.initialSpecializationId,
    this.initialMinRating,
  });

  @override
  State<SortFilterSheet> createState() => _SortFilterSheetState();
}

class _SortFilterSheetState extends State<SortFilterSheet> {
  int? _selectedSpecializationId;
  double? _selectedMinRating;

  static const List<double> _ratingOptions = [5, 4, 3, 2];

  @override
  void initState() {
    super.initState();
    _selectedSpecializationId = widget.initialSpecializationId;
    _selectedMinRating = widget.initialMinRating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: ColorsManager.lighterGray,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Center(child: Text('Sort By', style: TextStyles.font18DarkBlueBold)),
          Divider(height: 24.h, color: ColorsManager.lighterGray),
          Text('Speciality', style: TextStyles.font18DarkBlueBold),
          SizedBox(height: 12.h),
          _SpecialityChips(
            specializations: widget.specializations,
            selected: _selectedSpecializationId,
            onSelected: (id) => setState(() => _selectedSpecializationId = id),
          ),
          SizedBox(height: 20.h),
          Text('Rating', style: TextStyles.font18DarkBlueBold),
          SizedBox(height: 12.h),
          _RatingChips(
            selected: _selectedMinRating,
            options: _ratingOptions,
            onSelected: (r) => setState(() => _selectedMinRating = r),
          ),
          SizedBox(height: 28.h),
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorsManager.mainBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
              ),
              onPressed: () => Navigator.of(context).pop(
                SortFilterResult(
                  specializationId: _selectedSpecializationId,
                  minRating: _selectedMinRating,
                ),
              ),
              child: Text('Done', style: TextStyles.font16WhiteSemiBold),
            ),
          ),
        ],
      ),
    );
  }
}

class _SpecialityChips extends StatelessWidget {
  final List<SpecializationModel> specializations;
  final int? selected;
  final ValueChanged<int?> onSelected;

  const _SpecialityChips({
    required this.specializations,
    required this.selected,
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
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          ...specializations.map(
            (s) => Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _Chip(
                label: s.name,
                isSelected: selected == s.id,
                onTap: () => onSelected(s.id),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingChips extends StatelessWidget {
  final double? selected;
  final List<double> options;
  final ValueChanged<double?> onSelected;

  const _RatingChips({
    required this.selected,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _RatingChip(
            rating: null,
            label: 'All',
            isSelected: selected == null,
            onTap: () => onSelected(null),
          ),
          ...options.map(
            (r) => Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: _RatingChip(
                rating: r,
                isSelected: selected == r,
                onTap: () => onSelected(r),
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

class _RatingChip extends StatelessWidget {
  final double? rating;
  final String? label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RatingChip({
    this.rating,
    this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: isSelected
              ? ColorsManager.mainBlue
              : ColorsManager.moreLighterGray,
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_rounded,
              size: 16.r,
              color: isSelected ? Colors.white : ColorsManager.gray,
            ),
            SizedBox(width: 4.w),
            Text(
              label ?? rating!.toStringAsFixed(0),
              style: TextStyles.font13DarkBlueMedium.copyWith(
                color: isSelected ? Colors.white : ColorsManager.gray,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
