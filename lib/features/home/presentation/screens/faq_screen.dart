import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_bar_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FaqScreen extends StatelessWidget {
  const FaqScreen({super.key});

  static const _faqs = [
    (
      'How do I book an appointment?',
      'Browse the recommended doctors on the home screen or search for a specific doctor. Tap on a doctor\'s card and select "Book Appointment" to choose a date and time.',
    ),
    (
      'How do I cancel an appointment?',
      'Go to My Appointments, find the upcoming appointment you want to cancel, and tap "Cancel Appointment". You\'ll be asked to confirm before the cancellation is processed.',
    ),
    (
      'Can I reschedule an appointment?',
      'Yes. In the Upcoming tab of My Appointments, tap "Reschedule" on any appointment card to pick a new date and time.',
    ),
    (
      'How do I update my personal information?',
      'Go to Profile → Personal Information. You can update your name, email, phone number, and gender there.',
    ),
    (
      'Is my data secure?',
      'Yes. All communication is encrypted and your sensitive data is stored securely. We never share your personal information with third parties without your consent.',
    ),
    (
      'How do I contact support?',
      'You can reach us via the in-app chat feature by tapping the chat icon in the bottom navigation bar.',
    ),
  ];

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
                      'FAQ',
                      textAlign: TextAlign.center,
                      style: TextStyles.font18DarkBlueBold,
                    ),
                  ),
                  SizedBox(width: 36.w),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                itemCount: _faqs.length,
                separatorBuilder: (_, _) =>
                    Divider(height: 1, color: ColorsManager.lighterGray),
                itemBuilder: (_, i) =>
                    _FaqTile(question: _faqs[i].$1, answer: _faqs[i].$2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const _FaqTile({required this.question, required this.answer});

  @override
  State<_FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<_FaqTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.question,
                    style: TextStyles.font14DarkBlueMedium,
                  ),
                ),
                Icon(
                  _expanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  color: ColorsManager.gray,
                  size: 22.r,
                ),
              ],
            ),
            if (_expanded) ...[
              SizedBox(height: 8.h),
              Text(widget.answer, style: TextStyles.font13GrayRegular),
            ],
          ],
        ),
      ),
    );
  }
}
