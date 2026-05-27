import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Single source of truth for user/doctor avatars across the app.
///
/// Render order: `imageUrl` (network image) → first letter of `name` →
/// neutral [Icons.person_rounded]. Pass `showEditIcon: true` for an
/// overlayed camera badge tappable via `onEditTap`.
///
/// `cornerRadius` controls the shape: `null` (default) → circle; otherwise
/// a rounded rectangle with that radius (e.g. 12 for doctor cards, 16 for
/// the larger doctor-details avatar).
///
/// `initialStyle` overrides the fallback initial's text style. When unset,
/// scales from `size` automatically (good for the profile avatar). Callers
/// that need a specific size/colour (doctor cards, reviewer chip, etc.)
/// pass a concrete TextStyle.
class DocDocAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final double size;
  final bool showEditIcon;
  final VoidCallback? onEditTap;
  final Color? backgroundColor;
  final double? cornerRadius;
  final TextStyle? initialStyle;

  const DocDocAvatar({
    super.key,
    this.imageUrl,
    this.name,
    this.size = 56,
    this.showEditIcon = false,
    this.onEditTap,
    this.backgroundColor,
    this.cornerRadius,
    this.initialStyle,
  });

  @override
  Widget build(BuildContext context) {
    final s = size.r;
    final clipped = _clip(
      Container(
        width: s,
        height: s,
        color: backgroundColor ?? ColorsManager.lightBlue,
        child: _buildContent(s),
      ),
    );
    if (!showEditIcon) return clipped;
    final badgeSize = (s * 0.32).clamp(20.0, 32.0);
    return Stack(
      clipBehavior: Clip.none,
      children: [
        clipped,
        Positioned(
          right: -2,
          bottom: -2,
          child: GestureDetector(
            onTap: onEditTap,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: Colors.white,
                size: (s * 0.18).clamp(12.0, 18.0),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _clip(Widget child) {
    if (cornerRadius == null) return ClipOval(child: child);
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius!.r),
      child: child,
    );
  }

  Widget _buildContent(double s) {
    final url = imageUrl?.trim() ?? '';
    if (url.isNotEmpty) {
      return Image.network(
        url,
        fit: BoxFit.cover,
        width: s,
        height: s,
        errorBuilder: (_, _, _) => _fallback(s),
      );
    }
    return _fallback(s);
  }

  Widget _fallback(double s) {
    final initial = (name ?? '').trim();
    if (initial.isEmpty) {
      return Icon(
        Icons.person_rounded,
        color: ColorsManager.mainBlue,
        size: s * 0.55,
      );
    }
    return Center(
      child: Text(
        initial[0].toUpperCase(),
        style:
            initialStyle ??
            TextStyle(
              fontSize: (s * 0.4),
              fontWeight: FontWeight.w600,
              color: ColorsManager.mainBlue,
            ),
      ),
    );
  }
}
