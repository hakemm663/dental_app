import 'package:camera/camera.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;
  FlashMode _flashMode = FlashMode.off;
  bool _isInitialized = false;
  bool _permissionDenied = false;
  bool _isCapturing = false;
  String? _initError;
  final _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isDenied || status.isPermanentlyDenied) {
      setState(() => _permissionDenied = true);
      return;
    }

    try {
      _cameras = await availableCameras();
      if (!mounted) return;

      if (_cameras.isEmpty) {
        setState(() => _initError = 'No cameras available on this device.');
        return;
      }

      await _startController(_selectedCameraIndex);
    } catch (e) {
      if (!mounted) return;
      setState(() => _initError = 'Failed to initialize camera.');
    }
  }

  Future<void> _startController(int cameraIndex) async {
    final previous = _controller;
    if (previous != null) {
      await previous.dispose();
    }

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = controller;

    try {
      await controller.initialize();
      if (!mounted) return;
      if (controller != _controller) return;
      await controller.setFlashMode(_flashMode);
      if (!mounted) return;
      setState(() {
        _isInitialized = true;
        _initError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _initError = 'Camera error: ${e.toString()}');
    }
  }

  Future<void> _capturePhoto() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized || _isCapturing) {
      return;
    }

    setState(() => _isCapturing = true);
    try {
      final file = await controller.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(file.path);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _flipCamera() async {
    if (_cameras.length < 2) return;
    final nextIndex = (_selectedCameraIndex + 1) % _cameras.length;
    setState(() {
      _selectedCameraIndex = nextIndex;
      _isInitialized = false;
    });
    await _startController(nextIndex);
  }

  Future<void> _cycleFlash() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;

    final next = switch (_flashMode) {
      FlashMode.off => FlashMode.auto,
      FlashMode.auto => FlashMode.always,
      _ => FlashMode.off,
    };

    await controller.setFlashMode(next);
    setState(() => _flashMode = next);
  }

  Future<void> _openGallery() async {
    final file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (!mounted || file == null) return;
    Navigator.of(context).pop(file.path);
  }

  IconData get _flashIcon => switch (_flashMode) {
        FlashMode.auto => Icons.flash_auto_rounded,
        FlashMode.always => Icons.flash_on_rounded,
        _ => Icons.flash_off_rounded,
      };

  @override
  void dispose() {
    final controller = _controller;
    _controller = null;
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _TopBar(
              flashIcon: _flashIcon,
              onBack: () => Navigator.of(context).pop(),
              onFlash: _cycleFlash,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: ColorsManager.gray.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                clipBehavior: Clip.hardEdge,
                child: _buildPreviewArea(),
              ),
            ),
            _BottomBar(
              onGallery: _openGallery,
              onCapture: _capturePhoto,
              onFlip: _flipCamera,
              captureEnabled: _isInitialized && !_isCapturing,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewArea() {
    if (_permissionDenied) {
      return _MessageView(
        icon: Icons.no_photography_outlined,
        message: 'Camera permission is required.',
        buttonLabel: 'Open Settings',
        onButton: openAppSettings,
      );
    }

    if (_initError != null) {
      return _MessageView(
        icon: Icons.error_outline_rounded,
        message: _initError!,
      );
    }

    final controller = _controller;
    if (!_isInitialized || controller == null) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white54),
      );
    }

    return CameraPreview(controller);
  }
}

class _TopBar extends StatelessWidget {
  final IconData flashIcon;
  final VoidCallback onBack;
  final VoidCallback onFlash;

  const _TopBar({
    required this.flashIcon,
    required this.onBack,
    required this.onFlash,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: Colors.white,
              size: 20.r,
            ),
          ),
          Expanded(
            child: Text(
              'Camera',
              textAlign: TextAlign.center,
              style: TextStyles.font18WhiteMedium,
            ),
          ),
          GestureDetector(
            onTap: onFlash,
            child: Icon(
              flashIcon,
              color: Colors.white,
              size: 22.r,
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCapture;
  final VoidCallback onFlip;
  final bool captureEnabled;

  const _BottomBar({
    required this.onGallery,
    required this.onCapture,
    required this.onFlip,
    required this.captureEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 32.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _CircleButton(
            icon: Icons.photo_library_outlined,
            size: 50.r,
            onTap: onGallery,
          ),
          GestureDetector(
            onTap: captureEnabled ? onCapture : null,
            child: Opacity(
              opacity: captureEnabled ? 1.0 : 0.4,
              child: Container(
                width: 70.r,
                height: 70.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white,
                    width: 4.r,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.all(4.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          _CircleButton(
            icon: Icons.flip_camera_ios_outlined,
            size: 50.r,
            onTap: onFlip,
          ),
        ],
      ),
    );
  }
}

class _MessageView extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? buttonLabel;
  final VoidCallback? onButton;

  const _MessageView({
    required this.icon,
    required this.message,
    this.buttonLabel,
    this.onButton,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white54, size: 64.r),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyles.font16WhiteMedium.copyWith(
                color: Colors.white54,
              ),
            ),
            if (buttonLabel != null && onButton != null) ...[
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: onButton,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Text(
                    buttonLabel!,
                    style: TextStyles.font16WhiteMedium,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.2),
        ),
        child: Icon(icon, color: Colors.white, size: size * 0.5),
      ),
    );
  }
}
