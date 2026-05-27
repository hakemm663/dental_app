import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DoctorContactTile extends StatelessWidget {
  final DoctorModel doctor;
  final VoidCallback onTap;

  const DoctorContactTile({
    super.key,
    required this.doctor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24.r,
              backgroundColor: ColorsManager.moreLighterGray,
              backgroundImage: doctor.image != null
                  ? NetworkImage(doctor.image!)
                  : null,
              child: doctor.image == null
                  ? Text(doctor.name[0], style: TextStyles.font18DarkBlueBold)
                  : null,
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctor.name,
                    style: TextStyles.font15DarkBlueMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    '${doctor.specializationName ?? 'General Doctor'} | ${doctor.address ?? ''}',
                    style: TextStyles.font12GrayRegular,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
