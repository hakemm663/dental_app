import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// White footer that hosts a primary action button (Continue, Done, Save,
/// Book Now, etc.). Standardises the 24/12/24/32 padding budget so every
/// screen lands the button at the same visual height above the home
/// indicator / system nav bar.
class BottomActionBar extends StatelessWidget {
  final Widget child;

  const BottomActionBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 32.h),
      child: child,
    );
  }
}
