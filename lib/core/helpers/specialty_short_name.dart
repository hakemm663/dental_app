/// Compact label for the home horizontal specialty strip — keeps cards
/// readable without ellipsis. The See-All grid keeps the full names from
/// the database.
String specialtyShortName(String fullName) {
  final n = fullName.toLowerCase();
  if (n.contains('prosthodont')) return 'Prostho';
  if (n.contains('periodont')) return 'Perio';
  if (n.contains('endodont')) return 'Endo';
  if (n.contains('pediatric') || n.contains('pedo') || n.contains('child')) {
    return 'Pediatric';
  }
  if (n.contains('orthodont')) return 'Ortho';
  if (n.contains('cosmetic')) return 'Cosmetic';
  if (n.contains('oral') || n.contains('maxillo') || n.contains('surg')) {
    return 'Oral Surgery';
  }
  if (n.contains('general')) return 'General';
  return fullName;
}
