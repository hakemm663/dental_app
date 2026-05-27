import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/widgets/docdoc_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum HomeNavTab { home, chat, search, calendar, profile }

/// Single source of truth for what each bottom-nav tab does. Each shell
/// screen passes its own [active] tab so the helper knows which switch case
/// is a no-op (already on that tab) vs. a navigation.
///
/// Use from a screen as:
/// ```dart
/// HomeBottomNav.dispatch(context, tab, active: HomeNavTab.profile);
/// ```
void dispatchHomeNavTab(
  BuildContext context,
  HomeNavTab tab, {
  required HomeNavTab active,
}) {
  if (tab == active) return;
  switch (tab) {
    case HomeNavTab.home:
      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.homeScreen, (_) => false);
    case HomeNavTab.chat:
      Navigator.of(context).pushNamed(Routes.inboxScreen);
    case HomeNavTab.calendar:
      Navigator.of(context).pushNamed(Routes.appointments);
    case HomeNavTab.profile:
      Navigator.of(context).pushNamed(Routes.profile);
    case HomeNavTab.search:
      Navigator.of(context).pushNamed(Routes.search);
  }
}

class HomeBottomNav extends StatelessWidget {
  final HomeNavTab activeTab;
  final ValueChanged<HomeNavTab> onTabSelected;
  final VoidCallback onSearchTap;
  final String userName;
  final String? avatarUrl;

  const HomeBottomNav({
    super.key,
    required this.activeTab,
    required this.onTabSelected,
    required this.onSearchTap,
    this.userName = '',
    this.avatarUrl,
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
                    assetPath: 'assets/svgs/home_icon.svg',
                    semanticsLabel: 'Home',
                    isActive: activeTab == HomeNavTab.home,
                    onTap: () => onTabSelected(HomeNavTab.home),
                  ),
                  _NavIcon(
                    assetPath: 'assets/svgs/message_icon.svg',
                    semanticsLabel: 'Messages',
                    isActive: activeTab == HomeNavTab.chat,
                    showDot: true,
                    onTap: () => onTabSelected(HomeNavTab.chat),
                  ),
                  SizedBox(width: 70.w),
                  _NavIcon(
                    assetPath: 'assets/svgs/calendar_icon.svg',
                    semanticsLabel: 'Appointments',
                    isActive: activeTab == HomeNavTab.calendar,
                    onTap: () => onTabSelected(HomeNavTab.calendar),
                  ),
                  _ProfileNavIcon(
                    isActive: activeTab == HomeNavTab.profile,
                    userName: userName,
                    avatarUrl: avatarUrl,
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
  final String assetPath;
  final String semanticsLabel;
  final bool isActive;
  final bool showDot;
  final VoidCallback onTap;

  const _NavIcon({
    required this.assetPath,
    required this.semanticsLabel,
    required this.isActive,
    required this.onTap,
    this.showDot = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? ColorsManager.mainBlue : ColorsManager.gray;
    return Expanded(
      child: Semantics(
        button: true,
        label: semanticsLabel,
        selected: isActive,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: double.infinity,
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                SvgPicture.asset(
                  assetPath,
                  width: 26.r,
                  height: 26.r,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
                if (showDot)
                  Positioned(
                    top: 18.h,
                    right: 14.w,
                    child: Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: ColorsManager.notificationDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileNavIcon extends StatelessWidget {
  final bool isActive;
  final String userName;
  final String? avatarUrl;
  final VoidCallback onTap;

  const _ProfileNavIcon({
    required this.isActive,
    required this.userName,
    required this.avatarUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Semantics(
        button: true,
        label: 'Profile',
        selected: isActive,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            height: double.infinity,
            child: Center(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: isActive
                      ? Border.all(color: ColorsManager.mainBlue, width: 2)
                      : null,
                ),
                padding: EdgeInsets.all(isActive ? 2.r : 0),
                child: DocDocAvatar(
                  imageUrl: avatarUrl,
                  name: userName,
                  size: 30,
                  backgroundColor: isActive
                      ? ColorsManager.mainBlue
                      : ColorsManager.moreLighterGray,
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
        child: Semantics(
          button: true,
          label: 'Search doctors',
          child: Container(
            width: 60.r,
            height: 60.r,
            alignment: Alignment.center,
            child: Icon(Icons.search_rounded, color: Colors.white, size: 28.r),
          ),
        ),
      ),
    );
  }
}
