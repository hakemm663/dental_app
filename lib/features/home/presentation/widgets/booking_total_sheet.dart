import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BookingTotalSheet extends StatelessWidget {
  final double subtotal;
  final double tax;
  final bool isLoading;
  final VoidCallback onBookNow;

  const BookingTotalSheet({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.isLoading,
    required this.onBookNow,
  });

  double get _total => subtotal + tax;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: ColorsManager.lighterGray,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 16.h),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Payment Info', style: TextStyles.font18DarkBlueBold),
          ),
          SizedBox(height: 16.h),
          _Row(label: 'Subtotal', value: _format(subtotal), bold: false),
          SizedBox(height: 10.h),
          _Row(label: 'Tax', value: _format(tax), bold: false),
          SizedBox(height: 12.h),
          Divider(height: 1, color: ColorsManager.lighterGray),
          SizedBox(height: 12.h),
          _Row(label: 'Payment Total', value: _format(_total), bold: true),
          SizedBox(height: 16.h),
          AppTextButton(
            buttonText: isLoading ? 'Booking...' : 'Book Now',
            textStyle: TextStyles.font16WhiteSemiBold,
            borderRadius: 16,
            onPressed: isLoading ? () {} : onBookNow,
          ),
        ],
      ),
    );
  }

  String _format(double value) => '\$${value.toStringAsFixed(0)}';
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _Row({required this.label, required this.value, required this.bold});

  @override
  Widget build(BuildContext context) {
    final style =
        bold ? TextStyles.font18DarkBlueBold : TextStyles.font14GrayRegular;
    final valueStyle = bold
        ? TextStyles.font18DarkBlueBold
        : TextStyles.font14DarkBlueMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: valueStyle),
      ],
    );
  }
}
