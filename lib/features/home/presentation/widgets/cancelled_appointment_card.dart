import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/presentation/widgets/appointment_card_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CancelledAppointmentCard extends StatelessWidget {
  final AppointmentModel appointment;

  const CancelledAppointmentCard({
    super.key,
    required this.appointment,
  });

  @override
  Widget build(BuildContext context) {
    final doctor = appointment.doctor;
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.cancel_rounded,
                  color: const Color(0xFFEF4444),
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  'Appointment cancelled',
                  style: TextStyles.font13DarkBlueMedium
                      .copyWith(color: const Color(0xFFEF4444)),
                ),
                const Spacer(),
                Icon(
                  Icons.more_horiz_rounded,
                  color: ColorsManager.gray,
                  size: 20.r,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                AppointmentDoctorAvatar(
                  name: doctor?.name ?? '',
                  imageUrl: doctor?.image,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dr. ${doctor?.name ?? 'Doctor'}',
                        style: TextStyles.font15DarkBlueMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        doctor?.specializationName ?? 'General',
                        style: TextStyles.font13GrayRegular,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.h),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: ColorsManager.moreLighterGray,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    size: 16.r,
                    color: ColorsManager.gray,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    formatAppointmentDateTime(appointment.appointmentTime),
                    style: TextStyles.font13GrayRegular,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
