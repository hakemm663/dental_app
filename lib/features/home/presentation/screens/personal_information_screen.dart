import 'package:docdoc/core/widgets/bottom_action_bar.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/features/home/data/models/user_model.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/core/widgets/app_text_form_field.dart';
import 'package:docdoc/core/widgets/phone_country_field.dart';
import 'package:docdoc/features/home/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() =>
      _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneFieldKey = GlobalKey<PhoneCountryFieldState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  String? _selectedGender;
  bool _populated = false;
  bool _wasUpdating = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    final user = context.read<ProfileCubit>().state.user;
    if (user != null) {
      _populate(user);
    } else {
      context.read<ProfileCubit>().getUserProfile();
    }
  }

  void _populate(UserModel user) {
    _nameController.text = user.name;
    _emailController.text = user.email;
    _phoneController.text = user.phone;
    _selectedGender = user.gender;
    _populated = true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSave() {
    if (!_formKey.currentState!.validate()) return;
    final genderValue = _selectedGender == '1' || _selectedGender == 'male'
        ? 1
        : _selectedGender == '0' || _selectedGender == 'female'
        ? 0
        : null;
    final phone =
        _phoneFieldKey.currentState?.normalisedNumber ??
        _phoneController.text.trim();
    context.read<ProfileCubit>().updateProfile(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: phone,
      gender: genderValue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (p, c) => p.isUpdating != c.isUpdating || p.user != c.user,
      listener: (context, state) {
        if (!_populated && state.user != null) {
          setState(() => _populate(state.user!));
        }
        if (state.isUpdating) {
          _wasUpdating = true;
        } else if (_wasUpdating) {
          _wasUpdating = false;
          if (state.errorMessage == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated'),
                backgroundColor: ColorsManager.successGreen,
              ),
            );
          }
        }
        if (state.errorMessage != null) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              const DocDocAppBar(title: 'Personal Information'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(24.w, 8.h, 24.w, 24.h),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        _Label('Full Name'),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _nameController,
                          hintText: 'Enter your name',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        _Label('Email Address'),
                        SizedBox(height: 8.h),
                        AppTextFormField(
                          controller: _emailController,
                          hintText: 'Enter your email',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        _Label('Phone Number'),
                        SizedBox(height: 8.h),
                        PhoneCountryField(
                          key: _phoneFieldKey,
                          controller: _phoneController,
                          hintText: 'Your number',
                          validator: (v) =>
                              v == null || v.trim().isEmpty ? 'Required' : null,
                        ),
                        SizedBox(height: 16.h),
                        _Label('Gender'),
                        SizedBox(height: 8.h),
                        _GenderSelector(
                          value: _selectedGender,
                          onChanged: (v) => setState(() => _selectedGender = v),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              BlocBuilder<ProfileCubit, ProfileState>(
                buildWhen: (p, c) => p.isUpdating != c.isUpdating,
                builder: (_, state) => BottomActionBar(
                  child: state.isUpdating
                      ? const Center(child: CircularProgressIndicator())
                      : AppTextButton(
                          buttonText: 'Save Changes',
                          textStyle: TextStyles.font16WhiteSemiBold,
                          borderRadius: 16,
                          onPressed: _onSave,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;

  const _Label(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.font14DarkBlueMedium);
  }
}

class _GenderSelector extends StatelessWidget {
  final String? value;
  final ValueChanged<String?> onChanged;

  const _GenderSelector({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GenderOption(
            label: 'Male',
            genderKey: '1',
            selected: value == '1' || value == 'male',
            onTap: () => onChanged('1'),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _GenderOption(
            label: 'Female',
            genderKey: '0',
            selected: value == '0' || value == 'female',
            onTap: () => onChanged('0'),
          ),
        ),
      ],
    );
  }
}

class _GenderOption extends StatelessWidget {
  final String label;
  final String genderKey;
  final bool selected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.genderKey,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          color: selected
              ? ColorsManager.mainBlue
              : ColorsManager.moreLightGray,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: selected
                ? ColorsManager.mainBlue
                : ColorsManager.lighterGray,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyles.font14DarkBlueMedium.copyWith(
            color: selected ? Colors.white : ColorsManager.darkBlue,
          ),
        ),
      ),
    );
  }
}
