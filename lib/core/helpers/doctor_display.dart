/// Returns a doctor's name with a single "Dr." title prefix, regardless of
/// whether the stored name already begins with "Dr." or "Dr" — guards against
/// the "Dr. Dr. X" rendering when seed data carries the prefix.
///
/// Used by every place that displays a doctor name in the UI, so the data
/// layer is free to store the title or not without breaking the screens.
String doctorDisplayName(String? rawName, {String fallback = 'Doctor'}) {
  final trimmed = rawName?.trim() ?? '';
  if (trimmed.isEmpty) return 'Dr. $fallback';
  final lower = trimmed.toLowerCase();
  if (lower == 'dr.' || lower == 'dr') return 'Dr. $fallback';
  if (lower.startsWith('dr. ')) return trimmed;
  if (lower.startsWith('dr ')) return 'Dr. ${trimmed.substring(3).trim()}';
  return 'Dr. $trimmed';
}
