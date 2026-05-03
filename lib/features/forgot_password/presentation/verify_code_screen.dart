import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerifyCodeScreen extends StatefulWidget {
  const VerifyCodeScreen({super.key});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  final List<TextEditingController> controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    for (final c in controllers) {
      c.dispose();
    }
    for (final f in focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  bool get _isFilled => controllers.every((c) => c.text.isNotEmpty);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF242424)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Enter OTP Code', style: TextStyles.font24BlueBold),
              verticalSpace(8),
              Text(
                'We\'ve sent a 6-digit verification code to your email.',
                style: TextStyles.font14GrayRegular,
              ),
              verticalSpace(40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) => _OtpBox(
                      controller: controllers[i],
                      focusNode: focusNodes[i],
                      onChanged: (v) {
                        if (v.isNotEmpty && i < 5) {
                          focusNodes[i + 1].requestFocus();
                        }
                        setState(() {});
                      },
                      onBackspace: () {
                        if (controllers[i].text.isEmpty && i > 0) {
                          focusNodes[i - 1].requestFocus();
                        }
                      },
                    )),
              ),
              verticalSpace(40),
              AppTextButton(
                buttonText: 'Verify',
                textStyle: TextStyles.font16WhiteSemiBold,
                backgroundColor:
                    _isFilled ? ColorsManager.mainBlue : ColorsManager.lightGray,
                onPressed: _isFilled
                    ? () =>
                        Navigator.of(context).pushNamed(Routes.newPassword)
                    : () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final VoidCallback onBackspace;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    required this.onBackspace,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  late final FocusNode _keyboardListenerFocus;

  @override
  void initState() {
    super.initState();
    _keyboardListenerFocus = FocusNode();
  }

  @override
  void dispose() {
    _keyboardListenerFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 46.w,
      height: 56.h,
      child: KeyboardListener(
        focusNode: _keyboardListenerFocus,
        onKeyEvent: (event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              widget.controller.text.isEmpty) {
            widget.onBackspace();
          }
        },
        child: TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(1),
            FilteringTextInputFormatter.digitsOnly,
          ],
          style: TextStyles.font18DarkBlueBold,
          decoration: InputDecoration(
            isDense: true,
            contentPadding: EdgeInsets.symmetric(vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: Color(0xFFEDEDED), width: 1.3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                  color: ColorsManager.mainBlue, width: 1.3),
            ),
            fillColor: const Color(0xFFFDFDFF),
            filled: true,
          ),
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
