import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:docdoc/features/home/presentation/cubit/language_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LanguageSettingsScreen extends StatefulWidget {
  const LanguageSettingsScreen({super.key});

  @override
  State<LanguageSettingsScreen> createState() =>
      _LanguageSettingsScreenState();
}

class _LanguageSettingsScreenState extends State<LanguageSettingsScreen> {
  static const _languages = [
    ('en', 'English'),
    ('ar', 'العربية'),
    ('fr', 'Français'),
    ('es', 'Español'),
  ];

  @override
  void initState() {
    super.initState();
    context.read<LanguageCubit>().load();
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
                      'Language',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18DarkBlueBold,
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<LanguageCubit, LanguageState>(
                builder: (context, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ListView(
                    padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                    children: _languages.map((lang) {
                      final (code, label) = lang;
                      final selected = state.code == code;
                      return _LanguageTile(
                        label: label,
                        selected: selected,
                        onTap: () {
                          context.read<LanguageCubit>().setLanguage(code);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Language changed to $label. Restart the app to apply.',
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
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

class _LanguageTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: selected ? ColorsManager.lightBlue : ColorsManager.moreLighterGray,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? ColorsManager.mainBlue : ColorsManager.lighterGray,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyles.font14DarkBlueMedium.copyWith(
                  color: selected ? ColorsManager.mainBlue : ColorsManager.darkBlue,
                ),
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded,
                  color: ColorsManager.mainBlue, size: 20.r),
          ],
        ),
      ),
    );
  }
}
