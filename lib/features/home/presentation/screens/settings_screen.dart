import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/adaptive.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/features/home/presentation/widgets/profile_menu_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const DocDocAppBar(title: 'Settings'),
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
                      iconBg: ColorsManager.warningOrangeBg,
                      iconColor: ColorsManager.warningOrange,
                      title: 'Notification Settings',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(Routes.notificationSettings),
                    ),
                    ProfileMenuItem(
                      icon: Icons.lock_outline_rounded,
                      iconBg: ColorsManager.successGreenBg,
                      iconColor: ColorsManager.successGreen,
                      title: 'Security',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(Routes.securitySettings),
                    ),
                    ProfileMenuItem(
                      icon: Icons.language_rounded,
                      iconBg: ColorsManager.lightBlue,
                      iconColor: ColorsManager.mainBlue,
                      title: 'Language',
                      onTap: () => Navigator.of(
                        context,
                      ).pushNamed(Routes.languageSettings),
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
                      onTap: () => Navigator.of(context).pushNamed(Routes.faq),
                    ),
                    SizedBox(height: 8.h),
                    Divider(height: 1, color: ColorsManager.lighterGray),
                    SizedBox(height: 8.h),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      iconBg: ColorsManager.dangerRedBg,
                      iconColor: ColorsManager.dangerRed,
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
    final confirmed = await showDocDocAdaptiveDialog(
      context: context,
      title: 'Logout',
      message: 'Are you sure you want to logout?',
      confirmText: 'Logout',
      cancelText: 'Cancel',
      destructive: true,
    );
    if (confirmed == true && context.mounted) {
      final navigator = Navigator.of(context);
      try {
        await Supabase.instance.client.auth.signOut();
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
