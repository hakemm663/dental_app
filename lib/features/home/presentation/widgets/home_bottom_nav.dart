import 'package:docdoc/core/theming/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum HomeNavTab { home, chat, calendar, profile }

class HomeBottomNav extends StatelessWidget {
  final HomeNavTab activeTab;
  final ValueChanged<HomeNavTab> onTabSelected;
  final VoidCallback onSearchTap;
  final String userName;

  const HomeBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.onSearchTap,
    this.userName = '',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(color: ColorsManager.lighterGray, width: 1.h),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Row(
                children: [
                  _NavIcon(
                    icon: Icons.home_outlined,
                    isActive: activeTab == HomeNavTab.home,
                    onTap: () => onTabSelected(HomeNavTab.home),
                  ),
                  _NavIcon(
                    icon: Icons.chat_bubble_outline_rounded,
                    isActive: activeTab == HomeNavTab.chat,
                    showDot: true,
                    onTap: () => onTabSelected(HomeNavTab.chat),
                  ),
                  SizedBox(width: 70.w),
                  _NavIcon(
                    icon: Icons.calendar_today_outlined,
                    isActive: activeTab == HomeNavTab.calendar,
                    onTap: () => onTabSelected(HomeNavTab.calendar),
                  ),
                  _ProfileNavIcon(
                    isActive: activeTab == HomeNavTab.profile,
                    userName: userName,
                    onTap: () => onTabSelected(HomeNavTab.profile),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: -20.h,
            child: _SearchFab(onTap: onSearchTap),
          ),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final bool showDot;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                size: 26.r,
                color: isActive ? ColorsManager.mainBlue : ColorsManager.gray,
              ),
              if (showDot)
                Positioned(
                  top: 18.h,
                  right: 14.w,
                  child: Container(
                    width: 8.r,
                    height: 8.r,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF4D6D),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileNavIcon extends StatelessWidget {
  final bool isActive;
  final String userName;
  final VoidCallback onTap;

  const _ProfileNavIcon({
    required this.isActive,
    required this.userName,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initial = userName.isNotEmpty ? userName[0].toUpperCase() : '?';
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: double.infinity,
          child: Center(
            child: Container(
              width: 30.r,
              height: 30.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? ColorsManager.mainBlue
                    : ColorsManager.moreLighterGray,
                border: isActive
                    ? Border.all(color: ColorsManager.mainBlue, width: 2)
                    : null,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.white : ColorsManager.gray,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SearchFab extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: ColorsManager.mainBlue,
      borderRadius: BorderRadius.circular(20.r),
      elevation: 6,
      shadowColor: ColorsManager.mainBlue.withValues(alpha: 0.4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: 60.r,
          height: 60.r,
          alignment: Alignment.center,
          child: Icon(
            Icons.search_rounded,
            color: Colors.white,
            size: 28.r,
          ),
        ),
      ),
    );
  }
}
