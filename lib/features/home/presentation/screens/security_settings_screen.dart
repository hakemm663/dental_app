import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/features/home/presentation/cubit/security_prefs_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<SecurityPrefsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                children: [
                  AppBarIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'Security',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18DarkBlueBold,
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SecurityPrefsCubit, SecurityPrefsState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                    children: [
                      _ToggleTile(
                        title: 'Remember Password',
                        subtitle: 'Stay logged in on this device',
                        value: state.rememberPassword,
                        onChanged: (v) => context
                            .read<SecurityPrefsCubit>()
                            .toggle('rememberPassword', v),
                      ),
                      _ToggleTile(
                        title: 'Face ID / Biometrics',
                        subtitle: 'Use biometrics to unlock the app',
                        value: state.faceId,
                        onChanged: (v) => context
                            .read<SecurityPrefsCubit>()
                            .toggle('faceId', v),
                      ),
                      _ToggleTile(
                        title: 'PIN Lock',
                        subtitle: 'Require PIN to open the app',
                        value: state.pin,
                        onChanged: (v) =>
                            context.read<SecurityPrefsCubit>().toggle('pin', v),
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
