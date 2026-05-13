import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 100.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24.h),
                    _ProfileHeader(),
                    SizedBox(height: 28.h),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    SizedBox(height: 8.h),
                    Text('Account', style: TextStyles.font12GrayMedium),
                    SizedBox(height: 4.h),
                    ProfileMenuItem(
                      icon: Icons.person_outline_rounded,
                      iconBg: ColorsManager.lightBlue,
                      iconColor: ColorsManager.mainBlue,
                      title: 'Personal Information',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.personalInformation),
                    ),
                    ProfileMenuItem(
                      icon: Icons.calendar_today_outlined,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF22C55E),
                      title: 'My Appointments',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.appointments),
                    ),
                    ProfileMenuItem(
                      icon: Icons.folder_outlined,
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Medical Records',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.medicalRecords),
                    ),
                    ProfileMenuItem(
                      icon: Icons.credit_card_outlined,
                      iconBg: const Color(0xFFF3E8FF),
                      iconColor: const Color(0xFF8B5CF6),
                      title: 'Payment Methods',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.paymentMethods),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    SizedBox(height: 8.h),
                    Text('More', style: TextStyles.font12GrayMedium),
                    SizedBox(height: 4.h),
                    ProfileMenuItem(
                      icon: Icons.settings_outlined,
                      iconBg: ColorsManager.moreLighterGray,
                      iconColor: ColorsManager.gray,
                      title: 'Settings',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.settings),
                    ),
                  ],
                ),
              ),
            ),
            HomeBottomNav(
              activeTab: HomeNavTab.profile,
              onTabSelected: (tab) {
                switch (tab) {
                  case HomeNavTab.home:
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(Routes.homeScreen, (_) => false);
                  case HomeNavTab.chat:
                    Navigator.of(context).pushNamed(Routes.inboxScreen);
                  case HomeNavTab.calendar:
                    Navigator.of(context).pushNamed(Routes.appointments);
                  case HomeNavTab.profile:
                    break;
                }
              },
              onSearchTap: () =>
                  Navigator.of(context).pushNamed(Routes.search),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (p, c) => p.user != c.user || p.isLoading != c.isLoading,
      builder: (_, state) {
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        final user = state.user;
        final name = user?.name ?? '—';
        final email = user?.email ?? '—';
        final initial = name.isNotEmpty ? name[0].toUpperCase() : '?';
        return Row(
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.mainBlue,
              ),
              alignment: Alignment.center,
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: TextStyles.font18DarkBlueBold),
                  SizedBox(height: 4.h),
                  Text(email, style: TextStyles.font13GrayRegular),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
