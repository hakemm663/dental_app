import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/models/payment_method.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class BookingSummaryView extends StatelessWidget {
  final DoctorModel doctor;
  final DateTime selectedDay;
  final String selectedTime;
  final AppointmentType appointmentType;
  final PaymentMethod paymentMethod;
  final VoidCallback onChangePayment;

  const BookingSummaryView({
    super.key,
    required this.doctor,
    required this.selectedDay,
    required this.selectedTime,
    required this.appointmentType,
    required this.paymentMethod,
    required this.onChangePayment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking Information', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 16.h),
        BookingInfoRow(
          icon: Icons.calendar_today_outlined,
          iconBg: ColorsManager.lightBlue,
          iconColor: ColorsManager.mainBlue,
          title: 'Date & Time',
          subtitle:
              '${DateFormat('EEEE, dd MMM yyyy').format(selectedDay)}\n$selectedTime',
        ),
        const _ThinDivider(),
        BookingInfoRow(
          icon: Icons.assignment_outlined,
          iconBg: const Color(0xFFE8F5E9),
          iconColor: const Color(0xFF22C55E),
          title: 'Appointment Type',
          subtitle: appointmentType.label,
        ),
        SizedBox(height: 28.h),
        Text('Doctor Information', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 16.h),
        DoctorInfoCard(doctor: doctor),
        SizedBox(height: 28.h),
        Text('Payment Information', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 16.h),
        _PaymentRow(
          method: paymentMethod,
          onChange: onChangePayment,
        ),
      ],
    );
  }
}

class BookingInfoRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget? trailing;

  const BookingInfoRow({
    super.key,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 44.r,
            height: 44.r,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 22.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font14DarkBlueBold),
                SizedBox(height: 4.h),
                Text(subtitle, style: TextStyles.font13GrayRegular),
              ],
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

class _ThinDivider extends StatelessWidget {
  const _ThinDivider();

  @override
  Widget build(BuildContext context) =>
      Divider(height: 1, color: ColorsManager.lighterGray);
}

class _PaymentRow extends StatelessWidget {
  final PaymentMethod method;
  final VoidCallback onChange;

  const _PaymentRow({required this.method, required this.onChange});

  // TODO(backend): replace with masked card stored on the user profile.
  static const String _stubMaskedNumber = '***** ***** ***** 37842';

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            color: const Color(0xFFE3E7EE),
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: Icon(
            _iconFor(method),
            color: const Color(0xFF1A2B5C),
            size: 22.r,
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(method.label, style: TextStyles.font14DarkBlueBold),
              SizedBox(height: 4.h),
              Text(_stubMaskedNumber, style: TextStyles.font13GrayRegular),
            ],
          ),
        ),
        OutlinedButton(
          onPressed: onChange,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: ColorsManager.mainBlue),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
          ),
          child: Text('Change', style: TextStyles.font13BlueSemiBold),
        ),
      ],
    );
  }

  IconData _iconFor(PaymentMethod m) => switch (m) {
        CreditCardPayment() => Icons.credit_card_rounded,
        BankTransferPayment() => Icons.account_balance_rounded,
        PayPalPayment() => Icons.account_balance_wallet_rounded,
      };
}
