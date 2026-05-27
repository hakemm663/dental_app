import 'dart:io';

import 'package:docdoc/core/widgets/adaptive.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class MediaPickerService {
  final ImagePicker _imagePicker = ImagePicker();

  Future<String?> pickImageFromGallery() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    return file?.path;
  }

  /// Opens the OS's native camera (not a custom in-app UI). Used by chat,
  /// signup, profile, personal information and medical-records flows.
  Future<String?> pickImageFromCamera() async {
    final XFile? file = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    return file?.path;
  }

  /// Adaptive Camera/Gallery action sheet. Returns the picked file path or
  /// null if the user cancels.
  Future<String?> pickImageWithSheet(BuildContext context) async {
    final source = await showDocDocAdaptiveActionSheet<ImageSource>(
      context: context,
      title: 'Add photo',
      actions: const [
        AdaptiveAction(label: 'Take Photo', value: ImageSource.camera),
        AdaptiveAction(
          label: 'Choose from Gallery',
          value: ImageSource.gallery,
        ),
      ],
    );
    if (source == null) return null;
    final XFile? file = await _imagePicker.pickImage(
      source: source,
      imageQuality: 85,
    );
    return file?.path;
  }

  /// Android: recover an image lost when the activity was killed mid-pick.
  /// Safe to call at app start. No-op on iOS.
  Future<String?> retrieveLostData() async {
    if (!Platform.isAndroid) return null;
    final response = await _imagePicker.retrieveLostData();
    if (response.isEmpty || response.file == null) return null;
    return response.file!.path;
  }

  Future<String?> pickVideoFromGallery() async {
    final XFile? file = await _imagePicker.pickVideo(
      source: ImageSource.gallery,
    );
    return file?.path;
  }

  Future<String?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'txt',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
      ],
      allowMultiple: false,
    );
    return result?.files.single.path;
  }

  Future<({String path, String name, int size})?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final file = result.files.single;
    final path = file.path;
    if (path == null) return null;

    return (path: path, name: file.name, size: file.size);
  }
}
