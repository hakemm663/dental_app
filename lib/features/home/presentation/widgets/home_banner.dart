import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeBanner extends StatelessWidget {
  final VoidCallback? onFindNearbyTap;

  const HomeBanner({super.key, this.onFindNearbyTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.h,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.r),
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF4093FF), ColorsManager.mainBlue],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 170.w,
                        child: Text(
                          'Book and schedule\nwith nearest doctor',
                          style: TextStyles.font18WhiteMedium.copyWith(
                            height: 1.3,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      _FindNearbyButton(onTap: onFindNearbyTap),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 8.w,
            bottom: 0,
            top: -28.h,
            child: Image.asset(
              'assets/images/doc_home_screen.png',
              fit: BoxFit.fitHeight,
              errorBuilder: (_, _, _) => const SizedBox.shrink(),
            ),
          ),
        ],
      ),
    );
  }
}

class _FindNearbyButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _FindNearbyButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Text(
            'Find Nearby',
            style: TextStyles.font14BlueSemiBold,
          ),
        ),
      ),
    );
  }
}
