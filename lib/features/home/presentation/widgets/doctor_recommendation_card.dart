import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorRecommendationCard extends StatelessWidget {
  final DoctorModel doctor;
  final String? specialityLabel;
  final VoidCallback? onTap;

  const DoctorRecommendationCard({
    super.key,
    required this.doctor,
    this.specialityLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _DoctorAvatar(image: doctor.image, name: doctor.name),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctorDisplayName(doctor.name),
                      style: TextStyles.font18DarkBlueBold,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 6.h),
                    _SpecialityRow(
                      speciality: specialityLabel ?? 'General',
                      address: doctor.address,
                    ),
                    SizedBox(height: 8.h),
                    _RatingRow(rating: doctor.rating),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DoctorAvatar extends StatelessWidget {
  final String? image;
  final String name;

  const _DoctorAvatar({required this.image, required this.name});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 90.r,
        height: 90.r,
        color: ColorsManager.moreLighterGray,
        child: image == null || image!.isEmpty
            ? _Initial(name: name)
            : Image.network(
                image!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _Initial(name: name),
              ),
      ),
    );
  }
}

class _Initial extends StatelessWidget {
  final String name;

  const _Initial({required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyles.font24BlueBold,
      ),
    );
  }
}

class _SpecialityRow extends StatelessWidget {
  final String speciality;
  final String? address;

  const _SpecialityRow({required this.speciality, this.address});

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null && address!.isNotEmpty;
    return Row(
      children: [
        Flexible(
          child: Text(
            speciality,
            style: TextStyles.font13GrayRegular,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (hasAddress) ...[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Text('|', style: TextStyles.font13GrayRegular),
          ),
          Flexible(
            child: Text(
              address!,
              style: TextStyles.font13GrayRegular,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ],
    );
  }
}

class _RatingRow extends StatelessWidget {
  final double? rating;

  const _RatingRow({this.rating});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.star_rounded, color: const Color(0xFFFFB800), size: 18.r),
        SizedBox(width: 4.w),
        Text(
          rating != null ? rating!.toStringAsFixed(1) : '—',
          style: TextStyles.font14DarkBlueMedium,
        ),
      ],
    );
  }
}
