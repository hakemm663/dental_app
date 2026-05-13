import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/features/home/presentation/cubit/notification_prefs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationPrefsCubit>().load();
  }

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
                      'Notification Settings',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18DarkBlueBold,
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<NotificationPrefsCubit,
                  NotificationPrefsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    padding:
                        EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                    children: [
                      _SectionLabel('General'),
                      _ToggleTile(
                        title: 'Push Notifications',
                        subtitle: 'Receive push notifications',
                        value: state.push,
                        onChanged: (v) => context
                            .read<NotificationPrefsCubit>()
                            .toggle('push', v),
                      ),
                      _ToggleTile(
                        title: 'Sound',
                        subtitle: 'Play sound for notifications',
                        value: state.sound,
                        onChanged: (v) => context
                            .read<NotificationPrefsCubit>()
                            .toggle('sound', v),
                      ),
                      _ToggleTile(
                        title: 'Vibration',
                        subtitle: 'Vibrate for notifications',
                        value: state.vibrate,
                        onChanged: (v) => context
                            .read<NotificationPrefsCubit>()
                            .toggle('vibrate', v),
                      ),
                      SizedBox(height: 8.h),
                      Divider(height: 1, color: ColorsManager.lighterGray),
                      SizedBox(height: 8.h),
                      _SectionLabel('Content'),
                      _ToggleTile(
                        title: 'App Updates',
                        subtitle: 'Get notified about app updates',
                        value: state.appUpdates,
                        onChanged: (v) => context
                            .read<NotificationPrefsCubit>()
                            .toggle('appUpdates', v),
                      ),
                      _ToggleTile(
                        title: 'Special Offers',
                        subtitle: 'Receive special offers and promotions',
                        value: state.specialOffers,
                        onChanged: (v) => context
                            .read<NotificationPrefsCubit>()
                            .toggle('specialOffers', v),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;

  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 4.h),
      child: Text(text, style: TextStyles.font12GrayMedium),
    );
  }
}

class _ToggleTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyles.font14DarkBlueMedium),
                SizedBox(height: 2.h),
                Text(subtitle, style: TextStyles.font12GrayRegular),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: ColorsManager.mainBlue,
            activeTrackColor: ColorsManager.mainBlue.withValues(alpha: 0.4),
          ),
        ],
      ),
    );
  }
}
