import 'package:docdoc/core/di/dependency_injection.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/networking/api_service.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/features/home/presentation/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  AppBarIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Settings',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18DarkBlueBold,
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Preferences', style: TextStyles.font12GrayMedium),
                    SizedBox(height: 4.h),
                    ProfileMenuItem(
                      icon: Icons.notifications_outlined,
                      iconBg: const Color(0xFFFFF3E0),
                      iconColor: const Color(0xFFF59E0B),
                      title: 'Notification Settings',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.notificationSettings),
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      iconBg: const Color(0xFFE8F5E9),
                      iconColor: const Color(0xFF22C55E),
                      title: 'Security',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.securitySettings),
                    ),
                    ProfileMenuItem(
                      icon: Icons.language_rounded,
                      iconBg: ColorsManager.lightBlue,
                      iconColor: ColorsManager.mainBlue,
                      title: 'Language',
                      onTap: () => Navigator.of(context)
                          .pushNamed(Routes.languageSettings),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    SizedBox(height: 8.h),
                    Text('Support', style: TextStyles.font12GrayMedium),
                    SizedBox(height: 4.h),
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      iconBg: ColorsManager.moreLighterGray,
                      iconColor: ColorsManager.gray,
                      title: 'FAQ',
                      onTap: () =>
                          Navigator.of(context).pushNamed(Routes.faq),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    SizedBox(height: 8.h),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      iconBg: const Color(0xFFFFEBEE),
                      iconColor: const Color(0xFFEF4444),
                      title: 'Logout',
                      trailing: const SizedBox.shrink(),
                      onTap: () => _LogoutDialog.show(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoutDialog {
  static Future<void> show(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        title: Text('Logout', style: TextStyles.font18DarkBlueBold),
        content: Text(
          'Are you sure you want to logout?',
          style: TextStyles.font14GrayRegular,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel', style: TextStyles.font14DarkBlueMedium),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Logout',
              style: TextStyles.font14BlueSemiBold.copyWith(
                color: const Color(0xFFEF4444),
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      final navigator = Navigator.of(context);
      try {
        await getIt<ApiService>().logout();
      } catch (_) {}
      await _clearStorage();
      navigator.pushNamedAndRemoveUntil(Routes.loginScreen, (_) => false);
    }
  }

  static Future<void> _clearStorage() async {
    await SharedPrefHelper.clearAllData();
    await SharedPrefHelper.clearAllSecuredData();
  }
}
