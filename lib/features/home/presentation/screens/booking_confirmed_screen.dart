import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/presentation/widgets/booking_summary_view.dart';
import 'package:docdoc/features/home/presentation/widgets/date_time_step.dart';
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
            const _DetailsAppBar(),
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
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF22C55E),
                      title: 'Appointment Type',
                      subtitle: args.appointmentType.label,
                      trailing: _GetLocationButton(
                        onTap: () => Navigator.of(context).pushNamed(
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
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
              child: AppTextButton(
                buttonText: 'Done',
                textStyle: TextStyles.font16WhiteSemiBold,
                borderRadius: 16,
                onPressed: () => Navigator.of(context).popUntil(
                  (route) => route.settings.name == Routes.homeScreen,
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
  const _DetailsAppBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Material(
            color: ColorsManager.lighterGray,
            borderRadius: BorderRadius.circular(10.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(10.r),
              onTap: () => Navigator.of(context).pop(),
              child: Padding(
                padding: EdgeInsets.all(8.r),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
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

class _GetLocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const _GetLocationButton({required this.onTap});

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
      child: Text('Get Location', style: TextStyles.font13BlueSemiBold),
    );
  }
}

