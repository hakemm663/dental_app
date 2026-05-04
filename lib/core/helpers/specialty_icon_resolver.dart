import 'package:flutter/material.dart';

IconData specialtyIconFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('neuro')) return Icons.psychology_outlined;
  if (n.contains('pedi') || n.contains('child')) return Icons.child_care_outlined;
  if (n.contains('radio')) return Icons.medical_information_outlined;
  if (n.contains('cardio') || n.contains('heart')) return Icons.favorite_outline;
  if (n.contains('dental') || n.contains('dent')) return Icons.health_and_safety_outlined;
  if (n.contains('eye') || n.contains('ophth') || n.contains('optom')) {
    return Icons.remove_red_eye_outlined;
  }
  if (n.contains('skin') || n.contains('derma')) return Icons.face_outlined;
  if (n.contains('ent') || n.contains('ear')) return Icons.hearing_outlined;
  if (n.contains('urol')) return Icons.water_drop_outlined;
  if (n.contains('gastro') || n.contains('intest')) return Icons.air_outlined;
  if (n.contains('hepat') || n.contains('liver')) return Icons.local_hospital_outlined;
  if (n.contains('pulmon') || n.contains('lung')) return Icons.air_outlined;
  if (n.contains('histo')) return Icons.biotech_outlined;
  if (n.contains('general')) return Icons.medical_services_outlined;
  return Icons.medical_services_outlined;
}
