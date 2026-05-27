import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/colored_icon_badge.dart';
import 'package:docdoc/core/widgets/outlined_pill_button.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/home/data/models/payment_method.dart';
import 'package:docdoc/features/home/data/models/appointment_type.dart';
import 'package:docdoc/features/home/presentation/widgets/doctor_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          iconBg: ColorsManager.successGreenBg,
          iconColor: ColorsManager.successGreen,
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
        _PaymentRow(method: paymentMethod, onChange: onChangePayment),
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
          ColoredIconBadge(
            icon: icon,
            backgroundColor: iconBg,
            iconColor: iconColor,
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
        _MethodIcon(method: method),
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
        OutlinedPillButton(
          label: 'Change',
          onPressed: onChange,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 8.h),
        ),
      ],
    );
  }
}

class _MethodIcon extends StatelessWidget {
  final PaymentMethod method;

  const _MethodIcon({required this.method});

  String? get _svgAsset => switch (method) {
    CreditCardPayment(:final brand) => switch (brand) {
      CardBrand.mastercard => 'assets/svgs/mastercard.svg',
      CardBrand.amex => 'assets/svgs/american_express.svg',
      CardBrand.capitalOne => 'assets/svgs/capital_one.svg',
      CardBrand.barclays => 'assets/svgs/barclays.svg',
    },
    _ => null,
  };

  IconData get _fallbackIcon => switch (method) {
    CreditCardPayment() => Icons.credit_card_rounded,
    BankTransferPayment() => Icons.account_balance_rounded,
    PayPalPayment() => Icons.account_balance_wallet_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final svg = _svgAsset;
    return Container(
      width: 44.r,
      height: 44.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: ColorsManager.lighterGray),
      ),
      alignment: Alignment.center,
      child: svg != null
          ? SvgPicture.asset(
              svg,
              width: 28.r,
              height: 28.r,
              fit: BoxFit.contain,
            )
          : Icon(_fallbackIcon, color: ColorsManager.darkBlue, size: 22.r),
    );
  }
}
