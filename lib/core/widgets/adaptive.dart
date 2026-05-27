import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Adaptive confirmation dialog. Returns `true` on confirm, `false` on cancel.
/// iOS renders a [CupertinoAlertDialog]; Android renders a Material [AlertDialog].
Future<bool?> showDocDocAdaptiveDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmText = 'OK',
  String? cancelText,
  bool destructive = false,
}) {
  if (Platform.isIOS) {
    return showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(title),
        content: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(message),
        ),
        actions: [
          if (cancelText != null)
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(cancelText),
            ),
          CupertinoDialogAction(
            isDestructiveAction: destructive,
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      content: Text(message),
      actions: [
        if (cancelText != null)
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(cancelText),
          ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(
            confirmText,
            style: destructive
                ? const TextStyle(color: Color(0xFFEF4444))
                : null,
          ),
        ),
      ],
    ),
  );
}

class AdaptiveAction<T> {
  final String label;
  final T value;
  final bool destructive;
  const AdaptiveAction({
    required this.label,
    required this.value,
    this.destructive = false,
  });
}

/// Adaptive action sheet. iOS → [CupertinoActionSheet]; Android → modal bottom
/// sheet with a list of [ListTile] actions.
Future<T?> showDocDocAdaptiveActionSheet<T>({
  required BuildContext context,
  String? title,
  required List<AdaptiveAction<T>> actions,
  bool showCancel = true,
  String cancelText = 'Cancel',
}) {
  if (Platform.isIOS) {
    return showCupertinoModalPopup<T>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: title != null ? Text(title) : null,
        actions: [
          for (final a in actions)
            CupertinoActionSheetAction(
              isDestructiveAction: a.destructive,
              onPressed: () => Navigator.of(ctx).pop(a.value),
              child: Text(a.label),
            ),
        ],
        cancelButton: showCancel
            ? CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop(),
                child: Text(cancelText),
              )
            : null,
      ),
    );
  }
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          for (final a in actions)
            ListTile(
              title: Text(
                a.label,
                style: TextStyle(
                  color: a.destructive ? const Color(0xFFEF4444) : null,
                ),
              ),
              onTap: () => Navigator.of(ctx).pop(a.value),
            ),
          if (showCancel) ...[
            const Divider(height: 1),
            ListTile(
              title: Text(cancelText, textAlign: TextAlign.center),
              onTap: () => Navigator.of(ctx).pop(),
            ),
          ],
        ],
      ),
    ),
  );
}

/// Platform-adaptive loading indicator (Cupertino spinner on iOS, Material on
/// Android). `CircularProgressIndicator.adaptive` already does the right thing.
class AdaptiveLoadingIndicator extends StatelessWidget {
  final double? size;
  const AdaptiveLoadingIndicator({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: const CircularProgressIndicator.adaptive(strokeWidth: 2),
    );
  }
}
