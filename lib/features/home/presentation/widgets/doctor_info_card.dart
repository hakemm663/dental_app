import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/docdoc_avatar.dart';
import 'package:docdoc/core/widgets/star_rating.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorInfoCard extends StatelessWidget {
  final DoctorModel doctor;

  const DoctorInfoCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DocDocAvatar(
          imageUrl: doctor.image,
          name: doctor.name,
          size: 80,
          cornerRadius: 12,
          backgroundColor: ColorsManager.moreLighterGray,
          initialStyle: TextStyles.font24BlueBold,
        ),
        SizedBox(width: 14.w),
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
              SizedBox(height: 4.h),
              Text(
                [
                  doctor.specializationName ?? 'General',
                  if (doctor.address != null && doctor.address!.isNotEmpty)
                    doctor.address!,
                ].join('  |  '),
                style: TextStyles.font13GrayRegular,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6.h),
              StarRating(
                value: doctor.rating,
                reviewsCount: doctor.reviewsCount ?? 0,
                iconSize: 16,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
