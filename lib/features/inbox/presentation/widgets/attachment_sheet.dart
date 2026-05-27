import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AttachmentSheet extends StatelessWidget {
  final VoidCallback onCamera;
  final VoidCallback onDocument;
  final VoidCallback onAttachFile;

  const AttachmentSheet({
    super.key,
    required this.onCamera,
    required this.onDocument,
    required this.onAttachFile,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _AttachmentOption(
              icon: Icons.camera_alt_outlined,
              label: 'Camera',
              color: ColorsManager.mainBlue,
              bgColor: const Color(0xFFE3F2FD),
              onTap: onCamera,
            ),
            _AttachmentOption(
              icon: Icons.description_outlined,
              label: 'Document',
              color: const Color(0xFF4CAF50),
              bgColor: ColorsManager.successGreenBg,
              onTap: onDocument,
            ),
            _AttachmentOption(
              icon: Icons.attach_file_rounded,
              label: 'Attach File',
              color: const Color(0xFFF44336),
              bgColor: ColorsManager.dangerRedBg,
              onTap: onAttachFile,
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;
  final VoidCallback onTap;

  const _AttachmentOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 26.r),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: ColorsManager.darkBlue),
          ),
        ],
      ),
    );
  }
}
