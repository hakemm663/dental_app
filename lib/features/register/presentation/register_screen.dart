import 'package:docdoc/core/helpers/spacing.dart';
import 'package:docdoc/core/routing/routes.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/core/widgets/app_text_form_field.dart';
import 'package:docdoc/features/register/presentation/cubit/register_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isObscurePassword = true;
  bool isObscureConfirm = true;
  int selectedGender = 1;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterCubit, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.of(context).pushReplacementNamed(Routes.homeScreen);
        } else if (state is RegisterError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.errMsg)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Create Account', style: TextStyles.font24BlueBold),
                    verticalSpace(8),
                    Text(
                      'Sign up now and start exploring all that our app has to offer.',
                      style: TextStyles.font14GrayRegular,
                    ),
                    verticalSpace(36),
                    Form(
                      key: formKey,
                      child: Column(
                        children: [
                          AppTextFormField(
                            hintText: 'Full Name',
                            controller: nameController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                          ),
                          verticalSpace(18),
                          AppTextFormField(
                            hintText: 'Email',
                            controller: emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              return null;
                            },
                          ),
                          verticalSpace(18),
                          AppTextFormField(
                            hintText: 'Phone',
                            controller: phoneController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your phone';
                              }
                              return null;
                            },
                          ),
                          verticalSpace(18),
                          _GenderSelector(
                            selected: selectedGender,
                            onChanged: (v) =>
                                setState(() => selectedGender = v),
                          ),
                          verticalSpace(18),
                          AppTextFormField(
                            hintText: 'Password',
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
                            controller: confirmPasswordController,
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
                          state is RegisterLoading
                              ? const CircularProgressIndicator()
                              : AppTextButton(
                                  buttonText: 'Create Account',
                                  textStyle: TextStyles.font16WhiteSemiBold,
                                  onPressed: () {
                                    if (formKey.currentState!.validate()) {
                                      context.read<RegisterCubit>().register(
                                            name: nameController.text,
                                            email: emailController.text,
                                            phone: phoneController.text,
                                            gender: selectedGender,
                                            password: passwordController.text,
                                            passwordConfirmation:
                                                confirmPasswordController.text,
                                          );
                                    }
                                  },
                                ),
                          verticalSpace(24),
                          GestureDetector(
                            onTap: () => Navigator.of(context)
                                .pushReplacementNamed(Routes.loginScreen),
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyles.font13DarkBlueRegular,
                                  ),
                                  TextSpan(
                                    text: 'Sign In',
                                    style: TextStyles.font13BlueSemiBold,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _GenderSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;

  const _GenderSelector({required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _GenderOption(label: 'Male', value: 1, selected: selected, onTap: onChanged)),
        SizedBox(width: 12.w),
        Expanded(child: _GenderOption(label: 'Female', value: 2, selected: selected, onTap: onChanged)),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final int value;
  final int selected;
  final ValueChanged<int> onTap;

  const _GenderOption({
    required this.label,
    required this.value,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = value == selected;
    return GestureDetector(
      onTap: () => onTap(value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF247CFF)
                : const Color(0xFFEDEDED),
            width: 1.3,
          ),
          color: const Color(0xFFFDFDFF),
        ),
        alignment: Alignment.center,
        child: Text(label, style: TextStyles.font14DarkBlueMedium),
      ),
    );
  }
}
