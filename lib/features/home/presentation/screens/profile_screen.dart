import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/services/media_picker_service.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/docdoc_avatar.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:docdoc/features/home/presentation/cubit/profile_cubit.dart';
import 'package:docdoc/features/home/presentation/widgets/home_bottom_nav.dart';
import 'package:docdoc/features/home/presentation/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().getUserProfile();
  }

  Future<void> _pickAndUploadAvatar() async {
    final cubit = context.read<ProfileCubit>();
    final filePath = await getIt<MediaPickerService>().pickImageWithSheet(
      context,
    );
    if (filePath == null) return;
    await cubit.updateAvatar(filePath);
  }

  void _onTabSelected(HomeNavTab tab) =>
      dispatchHomeNavTab(context, tab, active: HomeNavTab.profile);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.moreLightGray,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (p, c) =>
                    p.user != c.user ||
                    p.isLoading != c.isLoading ||
                    p.isUpdating != c.isUpdating,
                builder: (context, state) {
                  final user = state.user;
                  final name = user?.name.trim().isNotEmpty == true
                      ? user!.name
                      : 'Loading…';
                  final email = user?.email ?? '';
                  return Column(
                    children: [
                      _ProfileHeader(
                        name: name,
                        email: email,
                        avatarUrl: user?.avatarUrl,
                        isUpdating: state.isUpdating,
                        onEditAvatar: _pickAndUploadAvatar,
                      ),
                      SizedBox(height: 24.h),
                      const _ProfileShortcutTabs(),
                      SizedBox(height: 16.h),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24.w),
                        child: Column(
                          children: [
                            ProfileMenuItem(
                              icon: Icons.person_outline_rounded,
                              iconBg: ColorsManager.lightBlue,
                              iconColor: ColorsManager.mainBlue,
                              title: 'Personal Information',
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(Routes.personalInformation),
                            ),
                            ProfileMenuItem(
                              icon: Icons.folder_outlined,
                              iconBg: const Color(0xFFF0FAF1),
                              iconColor: ColorsManager.successGreen,
                              title: 'Medical Records',
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(Routes.medicalRecords),
                            ),
                            ProfileMenuItem(
                              icon: Icons.credit_card_outlined,
                              iconBg: const Color(0xFFFEF2F2),
                              iconColor: ColorsManager.dangerRed,
                              title: 'Payment Methods',
                              onTap: () => Navigator.of(
                                context,
                              ).pushNamed(Routes.paymentMethods),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],
                  );
                },
              ),
            ),
          ),
          BlocSelector<ProfileCubit, ProfileState, UserModel?>(
            selector: (s) => s.user,
            builder: (context, user) => HomeBottomNav(
              activeTab: HomeNavTab.profile,
              onTabSelected: _onTabSelected,
              userName: user?.name ?? '',
              avatarUrl: user?.avatarUrl,
              onSearchTap: () => Navigator.of(context).pushNamed(Routes.search),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String email;
  final String? avatarUrl;
  final bool isUpdating;
  final VoidCallback onEditAvatar;

  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.isUpdating,
    required this.onEditAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final headerHeight = 240.h;
    const avatarSize = 110.0;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topCenter,
      children: [
        // Blue header with curved bottom corners.
        Container(
          height: headerHeight,
          decoration: BoxDecoration(
            color: ColorsManager.mainBlue,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 98.h),
              child: Row(
                children: [
                  _HeaderIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  Expanded(
                    child: Text(
                      'Profile',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18WhiteMedium,
                    ),
                  ),
                  _HeaderIcon(
                    icon: Icons.settings_outlined,
                    tooltip: 'Settings',
                    onTap: () =>
                        Navigator.of(context).pushNamed(Routes.settings),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Avatar overlaps the header / white area boundary.
        Positioned(
          top: headerHeight - (avatarSize.r) / 2,
          child: Container(
            padding: EdgeInsets.all(6.r),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                DocDocAvatar(
                  imageUrl: avatarUrl,
                  name: name,
                  size: avatarSize,
                  showEditIcon: !isUpdating,
                  onEditTap: onEditAvatar,
                ),
                if (isUpdating)
                  SizedBox(
                    width: (avatarSize / 3).r,
                    height: (avatarSize / 3).r,
                    child: const CircularProgressIndicator(strokeWidth: 2.5),
                  ),
              ],
            ),
          ),
        ),
        // Name + email below the avatar; pad enough to clear the overlap.
        Padding(
          padding: EdgeInsets.only(
            top: headerHeight + (avatarSize.r) / 2 + 16.h,
          ),
          child: Column(
            children: [
              Text(
                name,
                style: TextStyles.font24BlackBold,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 4.h),
              Text(
                email,
                style: TextStyles.font14GrayRegular,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;

  const _HeaderIcon({
    required this.icon,
    required this.onTap,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip,
      child: InkResponse(
        onTap: onTap,
        radius: 24.r,
        child: SizedBox(
          width: 40.r,
          height: 40.r,
          child: Icon(icon, color: Colors.white, size: 22.r),
        ),
      ),
    );
  }
}

class _ProfileShortcutTabs extends StatelessWidget {
  const _ProfileShortcutTabs();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: ColorsManager.moreLighterGray,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: _ShortcutTab(
                label: 'My Appointment',
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.appointments),
              ),
            ),
            Container(width: 1, height: 22.h, color: ColorsManager.lighterGray),
            Expanded(
              child: _ShortcutTab(
                label: 'Medical records',
                onTap: () =>
                    Navigator.of(context).pushNamed(Routes.medicalRecords),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ShortcutTab extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ShortcutTab({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyles.font14DarkBlueMedium,
      ),
    );
  }
}
