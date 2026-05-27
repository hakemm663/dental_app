import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatInputBar extends StatefulWidget {
  final ValueChanged<String> onSend;
  final VoidCallback onAttachmentTap;
  final VoidCallback onCameraTap;

  const ChatInputBar({
    super.key,
    required this.onSend,
    required this.onAttachmentTap,
    required this.onCameraTap,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final has = _controller.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: ColorsManager.lighterGray, width: 1.h),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _handleSend(),
                decoration: InputDecoration(
                  hintText: 'Type a message ...',
                  hintStyle: TextStyle(
                    fontSize: 14.sp,
                    color: ColorsManager.lightGray,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 10.h),
                ),
              ),
            ),
            if (!_hasText) ...[
              GestureDetector(
                onTap: widget.onAttachmentTap,
                child: Icon(
                  Icons.attach_file,
                  color: ColorsManager.lightGray,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              GestureDetector(
                onTap: widget.onCameraTap,
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: ColorsManager.lightGray,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                width: 40.r,
                height: 40.r,
                decoration: const BoxDecoration(
                  color: ColorsManager.mainBlue,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.mic, color: Colors.white, size: 20.r),
              ),
            ] else
              GestureDetector(
                onTap: _handleSend,
                child: Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: const BoxDecoration(
                    color: ColorsManager.mainBlue,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20.r,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
