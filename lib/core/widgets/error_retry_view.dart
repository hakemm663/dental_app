import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Failure state used by data-loading screens. Always shows an error icon +
/// message; the Retry button is shown only when [onRetry] is provided.
class ErrorRetryView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorRetryView({super.key, required this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.r, color: ColorsManager.gray),
            SizedBox(height: 16.h),
            Text(
              message,
              style: TextStyles.font14GrayRegular,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              SizedBox(height: 16.h),
              TextButton(
                onPressed: onRetry,
                child: Text('Retry', style: TextStyles.font14BlueSemiBold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
