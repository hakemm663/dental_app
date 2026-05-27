import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class _Country {
  final String name;
  final String code; // ISO 3166-1 alpha-2
  final String dialCode; // +20
  final String flag; // emoji
  final bool enabled;
  const _Country(
    this.name,
    this.code,
    this.dialCode,
    this.flag, {
    this.enabled = false,
  });
}

// Egypt-first. Other countries are intentionally selection-only so we can
// surface the "region not yet enabled" copy without implementing SMS for them.
const List<_Country> _kCountries = [
  _Country('Egypt', 'EG', '+20', '🇪🇬', enabled: true),
  _Country('Saudi Arabia', 'SA', '+966', '🇸🇦'),
  _Country('United Arab Emirates', 'AE', '+971', '🇦🇪'),
  _Country('Qatar', 'QA', '+974', '🇶🇦'),
  _Country('Kuwait', 'KW', '+965', '🇰🇼'),
  _Country('Bahrain', 'BH', '+973', '🇧🇭'),
  _Country('Oman', 'OM', '+968', '🇴🇲'),
  _Country('Jordan', 'JO', '+962', '🇯🇴'),
  _Country('United States', 'US', '+1', '🇺🇸'),
  _Country('United Kingdom', 'GB', '+44', '🇬🇧'),
];

/// Phone field with an inline country selector. Defaults to Egypt (+20).
/// Selecting a non-enabled country shows an adaptive "SMS unable to be sent
/// until this region enabled by the app developer" dialog and reverts to Egypt.
class PhoneCountryField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String? Function(String?)? validator;
  final void Function(String dialCode)? onDialCodeChanged;

  const PhoneCountryField({
    super.key,
    required this.controller,
    this.hintText = 'Your number',
    this.validator,
    this.onDialCodeChanged,
  });

  @override
  State<PhoneCountryField> createState() => PhoneCountryFieldState();
}

class PhoneCountryFieldState extends State<PhoneCountryField> {
  _Country _selected = _kCountries.first;

  String get dialCode => _selected.dialCode;

  /// E.164-normalised number, e.g. "+201024353182". Strips a leading 0 from
  /// the local part so users can paste "010…" naturally.
  String get normalisedNumber {
    var local = widget.controller.text.trim().replaceAll(RegExp(r'\s+'), '');
    if (local.startsWith('0')) local = local.substring(1);
    if (local.isEmpty) return '';
    return '${_selected.dialCode}$local';
  }

  Future<void> _openPicker() async {
    final picked = await showDocDocAdaptiveActionSheet<_Country>(
      context: context,
      title: 'Select country',
      actions: [
        for (final c in _kCountries)
          AdaptiveAction(
            label: '${c.flag}  ${c.name}  ${c.dialCode}',
            value: c,
          ),
      ],
    );
    if (picked == null || !mounted) return;
    if (!picked.enabled) {
      await showDocDocAdaptiveDialog(
        context: context,
        title: 'Region not supported',
        message:
            'SMS unable to be sent until this region enabled by the app developer.',
        confirmText: 'OK',
      );
      return;
    }
    setState(() => _selected = picked);
    widget.onDialCodeChanged?.call(picked.dialCode);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: ColorsManager.lighterGray),
      ),
      child: Row(
        children: [
          InkWell(
            onTap: _openPicker,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(_selected.flag, style: TextStyle(fontSize: 20.sp)),
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18.r,
                    color: ColorsManager.darkBlue,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(width: 1, height: 22.h, color: ColorsManager.lighterGray),
          SizedBox(width: 12.w),
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                border: InputBorder.none,
                isCollapsed: true,
                contentPadding: EdgeInsets.symmetric(vertical: 16.h),
                hintText: widget.hintText,
                hintStyle: TextStyles.font14GrayRegular,
              ),
              validator: widget.validator,
            ),
          ),
        ],
      ),
    );
  }
}
