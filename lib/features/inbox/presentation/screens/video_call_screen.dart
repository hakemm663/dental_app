import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VideoCallScreen extends StatelessWidget {
  final ConversationModel conversation;

  const VideoCallScreen({super.key, required this.conversation});

  @override
  Widget build(BuildContext context) {
    final doctor = conversation.doctor;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: Stack(
        children: [
          // Doctor's video (full screen placeholder)
          Positioned.fill(
            child: Container(
              color: const Color(0xFFF0F0F0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 60.r,
                      backgroundColor: ColorsManager.moreLighterGray,
                      backgroundImage: doctor.image != null
                          ? NetworkImage(doctor.image!)
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      doctor.name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: ColorsManager.darkBlue,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'Video Call',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: ColorsManager.gray,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            left: 16.w,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 18.r,
                  color: ColorsManager.darkBlue,
                ),
              ),
            ),
          ),

          // Self-view PIP
          Positioned(
            top: MediaQuery.of(context).padding.top + 12.h,
            right: 16.w,
            child: Container(
              width: 100.w,
              height: 130.h,
              decoration: BoxDecoration(
                color: ColorsManager.moreLighterGray,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: Center(
                  child: Icon(
                    Icons.person,
                    size: 40.r,
                    color: ColorsManager.gray,
                  ),
                ),
              ),
            ),
          ),

          // Bottom controls
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _CallControl(
                    icon: Icons.volume_up_rounded,
                    bgColor: Colors.white.withValues(alpha: 0.8),
                    iconColor: ColorsManager.darkBlue,
                    onTap: () {},
                  ),
                  _CallControl(
                    icon: Icons.videocam_rounded,
                    bgColor: Colors.white.withValues(alpha: 0.8),
                    iconColor: ColorsManager.darkBlue,
                    onTap: () {},
                  ),
                  _CallControl(
                    icon: Icons.mic_rounded,
                    bgColor: Colors.white.withValues(alpha: 0.8),
                    iconColor: ColorsManager.darkBlue,
                    onTap: () {},
                  ),
                  _CallControl(
                    icon: Icons.call_end_rounded,
                    bgColor: const Color(0xFFFF4D6D),
                    iconColor: Colors.white,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CallControl({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.r,
        height: 56.r,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 26.r),
      ),
    );
  }
}
