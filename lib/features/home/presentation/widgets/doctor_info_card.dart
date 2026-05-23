import 'package:docdoc/core/helpers/doctor_display.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
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
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 80.r,
            height: 80.r,
            color: ColorsManager.moreLighterGray,
            child: doctor.image != null && doctor.image!.isNotEmpty
                ? Image.network(
                    doctor.image!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _Initial(name: doctor.name),
                  )
                : _Initial(name: doctor.name),
          ),
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
              Row(
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: const Color(0xFFFFB800),
                    size: 16.r,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    doctor.rating != null
                        ? '${doctor.rating!.toStringAsFixed(1)} (${doctor.reviewsCount ?? 0} reviews)'
                        : '—',
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
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
