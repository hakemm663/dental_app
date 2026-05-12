import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/appointment_model.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_summary_view.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class RescheduleConfirmedArgs {
  final AppointmentModel appointment;
  final DateTime selectedDay;
  final String selectedTime;
  final AppointmentType appointmentType;

  const RescheduleConfirmedArgs({
    required this.appointment,
    required this.selectedDay,
    required this.selectedTime,
    required this.appointmentType,
  });
}

class RescheduleConfirmedScreen extends StatelessWidget {
  final RescheduleConfirmedArgs args;

  const RescheduleConfirmedScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    final doctor = args.appointment.doctor;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _DetailsAppBar(onBack: () => Navigator.of(context).pop()),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    const Center(child: _SuccessCheck()),
                    SizedBox(height: 16.h),
                    Center(
                      child: Text(
                        'Booking Rescheduled',
                        style: TextStyles.font24BlackBold,
                      ),
                    ),
                    SizedBox(height: 36.h),
                    Text(
                      'Booking Information',
                      style: TextStyles.font18DarkBlueBold,
                    ),
                    SizedBox(height: 12.h),
                    BookingInfoRow(
                      icon: Icons.calendar_today_outlined,
                      iconBg: ColorsManager.lightBlue,
                      iconColor: ColorsManager.mainBlue,
                      title: 'Date & Time',
                      subtitle:
                          '${DateFormat('EEEE, dd MMM yyyy').format(args.selectedDay)}\n${args.selectedTime}',
                    ),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    BookingInfoRow(
                      icon: Icons.assignment_outlined,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF22C55E),
                      title: 'Appointment Type',
                      subtitle: args.appointmentType.label,
                      trailing: args.appointmentType == AppointmentType.videoCall
                          ? _GetLinkButton(onTap: () {})
                          : null,
                    ),
                    if (doctor != null) ...[
                      SizedBox(height: 28.h),
                      Text(
                        'Doctor Information',
                        style: TextStyles.font18DarkBlueBold,
                      ),
                      SizedBox(height: 12.h),
                      DoctorInfoCard(doctor: doctor),
                    ],
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: AppTextButton(
                buttonText: 'Done',
                textStyle: TextStyles.font16WhiteSemiBold,
                borderRadius: 16,
                onPressed: () => Navigator.of(context).popUntil(
                  (route) =>
                      route.settings.name == Routes.appointments ||
                      route.settings.name == Routes.homeScreen,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailsAppBar extends StatelessWidget {
  final VoidCallback onBack;

  const _DetailsAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          AppBarIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: onBack,
          ),
          Expanded(
            child: Text(
              'Details',
              textAlign: TextAlign.center,
              style: TextStyles.font18DarkBlueBold,
            ),
          ),
          SizedBox(width: 36.w),
        ],
      ),
    );
  }
}

class _SuccessCheck extends StatelessWidget {
  const _SuccessCheck();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.r,
      height: 100.r,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF22C55E),
      ),
      child: Icon(Icons.check_rounded, color: Colors.white, size: 56.r),
    );
  }
}

class _GetLinkButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GetLinkButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: ColorsManager.mainBlue),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      ),
      child: Text('Get Link', style: TextStyles.font13BlueSemiBold),
    );
  }
}
