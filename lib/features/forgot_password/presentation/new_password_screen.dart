import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/core/widgets/app_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isObscurePassword = true;
  bool isObscureConfirm = true;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

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
              Text('New Password', style: TextStyles.font24BlueBold),
              verticalSpace(8),
              Text(
                'Your new password must be different from previous passwords.',
                style: TextStyles.font14GrayRegular,
              ),
              verticalSpace(36),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    AppTextFormField(
                      hintText: 'New Password',
                      controller: passwordController,
                      isObscureText: isObscurePassword,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => isObscurePassword = !isObscurePassword),
                        child: Icon(isObscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      validator: (value) {
                        if (value == null || value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(18),
                    AppTextFormField(
                      hintText: 'Confirm Password',
                      controller: confirmController,
                      isObscureText: isObscureConfirm,
                      suffixIcon: GestureDetector(
                        onTap: () => setState(
                            () => isObscureConfirm = !isObscureConfirm),
                        child: Icon(isObscureConfirm
                            ? Icons.visibility_off
                            : Icons.visibility),
                      ),
                      validator: (value) {
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    verticalSpace(40),
                    AppTextButton(
                      buttonText: 'Save Password',
                      textStyle: TextStyles.font16WhiteSemiBold,
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            Routes.passwordChanged,
                            (route) => false,
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
