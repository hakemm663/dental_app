import 'package:docdoc/core/widgets/bottom_action_bar.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/core/widgets/outlined_pill_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_summary_view.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookingConfirmedArgs {
  final DoctorModel doctor;
  final DateTime selectedDay;
  final String selectedTime;
  final AppointmentType appointmentType;

  const BookingConfirmedArgs({
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
    required this.appointmentType,
  });
}

class BookingConfirmedScreen extends StatelessWidget {
  final BookingConfirmedArgs args;

  const BookingConfirmedScreen({super.key, required this.args});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const DocDocAppBar(title: 'Details'),
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
                        'Booking Confirmed',
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
                      iconBg: ColorsManager.successGreenBg,
                      iconColor: ColorsManager.successGreen,
                      title: 'Appointment Type',
                      subtitle: args.appointmentType.label,
                      trailing: OutlinedPillButton(
                        label: 'Get Location',
                        onPressed: () => Navigator.of(context).pushNamed(
                          Routes.findNearby,
                          arguments: args.doctor.id,
                        ),
                      ),
                    ),
                    SizedBox(height: 28.h),
                    Text(
                      'Doctor Information',
                      style: TextStyles.font18DarkBlueBold,
                    ),
                    SizedBox(height: 12.h),
                    DoctorInfoCard(doctor: args.doctor),
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            BottomActionBar(
              child: AppTextButton(
                buttonText: 'Done',
                textStyle: TextStyles.font16WhiteSemiBold,
                borderRadius: 16,
                onPressed: () => Navigator.of(
                  context,
                ).popUntil((route) => route.settings.name == Routes.homeScreen),
              ),
            ),
          ],
        ),
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
        color: ColorsManager.successGreen,
      ),
      child: Icon(Icons.check_rounded, color: Colors.white, size: 56.r),
    );
  }
}
