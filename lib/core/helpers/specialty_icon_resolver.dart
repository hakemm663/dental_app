import 'package:flutter/material.dart';

/// Maps a (dental) specialization name to a representative Material icon.
/// Specific dental specialities are matched before the generic fallbacks.
IconData specialtyIconFor(String name) {
  final n = name.toLowerCase();

  // ── Dental specialities ──
  if (n.contains('orthodont')) return Icons.straighten_outlined;
  if (n.contains('endodont')) return Icons.healing_outlined;
  if (n.contains('periodont')) return Icons.spa_outlined;
  if (n.contains('prosthodont')) return Icons.construction_outlined;
  if (n.contains('pedi') || n.contains('child')) {
    return Icons.child_care_outlined;
  }
  if (n.contains('surg') || n.contains('maxillo') || n.contains('oral')) {
    return Icons.medical_information_outlined;
  }
  if (n.contains('cosmetic') || n.contains('aesthet')) {
    return Icons.auto_awesome_outlined;
  }
  if (n.contains('general') || n.contains('dent')) {
    return Icons.medical_services_outlined;
  }

  // ── Generic medical fallbacks ──
  if (n.contains('neuro')) return Icons.psychology_outlined;
  if (n.contains('cardio') || n.contains('heart')) {
    return Icons.favorite_outline;
  }
  if (n.contains('eye') || n.contains('ophth') || n.contains('optom')) {
    return Icons.remove_red_eye_outlined;
  }
  if (n.contains('skin') || n.contains('derma')) return Icons.face_outlined;
  if (n.contains('ent') || n.contains('ear')) return Icons.hearing_outlined;

  return Icons.medical_services_outlined;
}
