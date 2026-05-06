import 'package:flutter/material.dart';

enum AppointmentType {
  inPerson('In Person', 'in_person', Icons.local_hospital_outlined),
  videoCall('Video Call', 'video_call', Icons.videocam_outlined),
  phoneCall('Phone Call', 'phone_call', Icons.call_outlined);

  final String label;
  final String wireKey;
  final IconData icon;
  const AppointmentType(this.label, this.wireKey, this.icon);
}
