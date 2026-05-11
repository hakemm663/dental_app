import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class AppointmentDoctorAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const AppointmentDoctorAvatar({
    super.key,
    required this.name,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        width: 48.r,
        height: 48.r,
        color: ColorsManager.moreLighterGray,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _buildInitial(),
              )
            : _buildInitial(),
      ),
    );
  }

  Widget _buildInitial() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyles.font18DarkBlueBold
            .copyWith(color: ColorsManager.mainBlue),
      ),
    );
  }
}

String formatAppointmentDateTime(String dateTime) {
  try {
    final dt = DateTime.parse(dateTime);
    return DateFormat('EEE, dd MMM | hh:mm a').format(dt);
  } catch (_) {
    return dateTime;
  }
}
