import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;

  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 260.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isMe ? ColorsManager.mainBlue : ColorsManager.moreLighterGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
              ),
            ),
            child: Text(
              message.text,
              style: TextStyle(
                fontSize: 14.sp,
                color: isMe ? Colors.white : ColorsManager.darkBlue,
                height: 1.4,
              ),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            DateFormat('HH:mm').format(message.timestamp),
            style: TextStyle(
              fontSize: 11.sp,
              color: ColorsManager.gray,
            ),
          ),
        ],
      ),
    );
  }
}
