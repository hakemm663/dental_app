/// Cascading name resolver used in places that show "Hi, {name}" or the
/// profile header. Tries the explicit `fullName` first, then a metadata
/// fallback, then the email's local part with the first letter capitalised.
///
/// Returns `fallback` (default `'there'`) when every source is empty.
String resolveDisplayName({
  String? fullName,
  String? email,
  String fallback = 'there',
}) {
  final name = fullName?.trim() ?? '';
  if (name.isNotEmpty) return name.split(' ').first;
  return emailLocalPart(email) ?? fallback;
}

/// Capitalised local part of an email (`hakem@x.com` -> `Hakem`). Returns
/// `null` if the email is null/empty or has no local part.
String? emailLocalPart(String? email) {
  if (email == null || email.isEmpty) return null;
  final local = email.split('@').first;
  if (local.isEmpty) return null;
  return '${local[0].toUpperCase()}${local.substring(1)}';
}
