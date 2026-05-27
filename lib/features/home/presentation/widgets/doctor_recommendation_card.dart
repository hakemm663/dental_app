import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/docdoc_avatar.dart';
import 'package:docdoc/core/widgets/star_rating.dart';
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
              DocDocAvatar(
                imageUrl: doctor.image,
                name: doctor.name,
                size: 90,
                cornerRadius: 12,
                backgroundColor: ColorsManager.moreLighterGray,
                initialStyle: TextStyles.font24BlueBold,
              ),
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
                    StarRating(value: doctor.rating),
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
