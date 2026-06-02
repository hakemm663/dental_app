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
        crossAxisAlignment: isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: 260.w),
            decoration: BoxDecoration(
              color: isMe
                  ? ColorsManager.mainBlue
                  : ColorsManager.moreLighterGray,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.r),
                topRight: Radius.circular(16.r),
                bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
                bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
              ),
            ),
            child: _buildContent(isMe),
          ),
          SizedBox(height: 4.h),
          Text(
            DateFormat('HH:mm').format(message.timestamp),
            style: TextStyle(fontSize: 11.sp, color: ColorsManager.gray),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(bool isMe) {
    return switch (message.type) {
      MessageType.image => _ImageContent(
        imageUrl: message.imageUrl ?? '',
        isMe: isMe,
      ),
      MessageType.attachment => _AttachmentContent(
        fileName: message.fileName ?? 'File',
        fileSize: message.fileSize,
        isMe: isMe,
      ),
      MessageType.text => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: 14.sp,
            color: isMe ? Colors.white : ColorsManager.darkBlue,
            height: 1.4,
          ),
        ),
      ),
    };
  }
}

class _ImageContent extends StatelessWidget {
  final String imageUrl;
  final bool isMe;

  const _ImageContent({required this.imageUrl, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16.r),
        topRight: Radius.circular(16.r),
        bottomLeft: isMe ? Radius.circular(16.r) : Radius.zero,
        bottomRight: isMe ? Radius.zero : Radius.circular(16.r),
      ),
      child: Image.network(
        imageUrl,
        width: 200.w,
        fit: BoxFit.cover,
        loadingBuilder: (_, child, progress) {
          if (progress == null) return child;
          return SizedBox(
            width: 200.w,
            height: 150.h,
            child: const Center(child: CircularProgressIndicator()),
          );
        },
        errorBuilder: (_, _, _) => SizedBox(
          width: 200.w,
          height: 150.h,
          child: Center(
            child: Icon(Icons.broken_image, size: 40.r, color: Colors.grey),
          ),
        ),
      ),
    );
  }
}

class _AttachmentContent extends StatelessWidget {
  final String fileName;
  final int? fileSize;
  final bool isMe;

  const _AttachmentContent({
    required this.fileName,
    required this.fileSize,
    required this.isMe,
  });

  String _formatSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  @override
  Widget build(BuildContext context) {
    final textColor = isMe ? Colors.white : ColorsManager.darkBlue;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.r,
            height: 36.r,
            decoration: BoxDecoration(
              color: (isMe ? Colors.white : ColorsManager.mainBlue).withValues(
                alpha: 0.2,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.insert_drive_file_outlined,
              size: 20.r,
              color: textColor,
            ),
          ),
          SizedBox(width: 10.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (fileSize != null && fileSize! > 0)
                  Text(
                    _formatSize(fileSize!),
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: textColor.withValues(alpha: 0.7),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
