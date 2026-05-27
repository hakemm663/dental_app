import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/onboarding/widgets/doc_logo_and_name.dart';
import 'package:docdoc/features/onboarding/widgets/doctor_image_and_text.dart';
import 'package:docdoc/features/onboarding/widgets/get_started_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // Bottom safe-area is respected so Get Started never sits under the
        // iPhone home indicator or the Android nav gesture bar.
        minimum: EdgeInsets.only(bottom: 24.h),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.h),
                  child: Column(
                    children: [
                      const DocLogoAndName(),
                      SizedBox(height: 24.h),
                      const DoctorImageAndText(),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          children: [
                            Text(
                              'Manage and schedule all of your medical appointments easily with Docdoc to get a new experience.',
                              style: TextStyles.font13GrayRegular,
                              textAlign: TextAlign.center,
                              maxLines: 3,
                            ),
                            SizedBox(height: 32.h),
                            const GetStartedButton(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
