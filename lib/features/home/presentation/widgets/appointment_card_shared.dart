import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/docdoc_avatar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppointmentDoctorAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;

  const AppointmentDoctorAvatar({super.key, required this.name, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return DocDocAvatar(
      imageUrl: imageUrl,
      name: name,
      size: 48,
      cornerRadius: 12,
      backgroundColor: ColorsManager.moreLighterGray,
      initialStyle: TextStyles.font18DarkBlueBold.copyWith(
        color: ColorsManager.mainBlue,
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
