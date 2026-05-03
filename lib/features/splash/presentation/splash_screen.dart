import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    final token =
        await SharedPrefHelper.getSecuredString(SharedPrefKeys.userToken);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(
      token.isNotEmpty ? Routes.homeScreen : Routes.onBoardingScreen,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/images/splash.png',
            fit: BoxFit.contain,
          ),
          Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svgs/docdoc_logo.svg',
                  width: 72.r,
                  height: 72.r,
                ),
                SizedBox(width: 15.w),
                Text('Docdoc', style: TextStyles.font24BlackBold),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
