import 'package:docdoc/core/widgets/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralised permission-handler flow. Each `ensure*` method returns `true`
/// when granted; otherwise it shows an adaptive dialog (with an Open Settings
/// affordance when the permission is permanently denied) and returns `false`.
class DevicePermissionsService {
  const DevicePermissionsService();

  Future<bool> ensureCameraPermission(BuildContext context) =>
      _ensureSingle(context, Permission.camera, 'Camera');

  Future<bool> ensureMicrophonePermission(BuildContext context) =>
      _ensureSingle(context, Permission.microphone, 'Microphone');

  Future<bool> ensureCameraAndMicrophone(BuildContext context) async {
    final statuses = await [Permission.camera, Permission.microphone].request();
    final camOk = statuses[Permission.camera]?.isGranted ?? false;
    final micOk = statuses[Permission.microphone]?.isGranted ?? false;
    if (camOk && micOk) return true;
    if (!context.mounted) return false;

    final permanent =
        (statuses[Permission.camera]?.isPermanentlyDenied ?? false) ||
        (statuses[Permission.microphone]?.isPermanentlyDenied ?? false);
    await _showDeniedDialog(context, 'Camera and microphone', permanent);
    return false;
  }

  Future<bool> _ensureSingle(
    BuildContext context,
    Permission permission,
    String label,
  ) async {
    final status = await permission.request();
    if (status.isGranted) return true;
    if (!context.mounted) return false;
    await _showDeniedDialog(context, label, status.isPermanentlyDenied);
    return false;
  }

  Future<void> _showDeniedDialog(
    BuildContext context,
    String label,
    bool permanent,
  ) async {
    final confirmed = await showDocDocAdaptiveDialog(
      context: context,
      title: '$label access required',
      message: permanent
          ? '$label access is turned off for DocDoc. Open Settings to enable it.'
          : 'DocDoc needs $label access to continue. Please allow it.',
      confirmText: permanent ? 'Open Settings' : 'OK',
      cancelText: 'Cancel',
    );
    if (confirmed == true && permanent) {
      await openAppSettings();
    }
  }
}
