import 'package:docdoc/core/widgets/bottom_action_bar.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/core/widgets/app_text_button.dart';
import 'package:docdoc/core/widgets/docdoc_app_bar.dart';
import 'package:docdoc/core/widgets/empty_state_view.dart';
import 'package:docdoc/features/home/data/models/payment_method_model.dart';
import 'package:docdoc/features/home/presentation/cubit/payment_methods_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PaymentMethodsCubit>().load();
  }

  void _showAddDialog() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      builder: (ctx) => BlocProvider.value(
        value: context.read<PaymentMethodsCubit>(),
        child: _AddCardSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const DocDocAppBar(title: 'Payment Methods'),
            Expanded(
              child: BlocBuilder<PaymentMethodsCubit, PaymentMethodsState>(
                buildWhen: (p, c) =>
                    p.isLoading != c.isLoading ||
                    p.errorMessage != c.errorMessage ||
                    p.methods != c.methods,
                builder: (_, state) {
                  if (state.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state.methods.isEmpty) {
                    return const EmptyStateView(
                      icon: Icons.credit_card_outlined,
                      message: 'No payment methods saved',
                    );
                  }
                  return ListView.separated(
                    padding: EdgeInsets.fromLTRB(24.w, 16.h, 24.w, 100.h),
                    itemCount: state.methods.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (_, i) => _CardTile(
                      method: state.methods[i],
                      onSetDefault: () => context
                          .read<PaymentMethodsCubit>()
                          .setDefault(state.methods[i].id),
                      onRemove: () => context
                          .read<PaymentMethodsCubit>()
                          .remove(state.methods[i].id),
                    ),
                  );
                },
              ),
            ),
            BottomActionBar(
              child: AppTextButton(
                buttonText: 'Add Payment Method',
                textStyle: TextStyles.font16WhiteSemiBold,
                borderRadius: 16,
                onPressed: _showAddDialog,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final PaymentMethodModel method;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  const _CardTile({
    required this.method,
    required this.onSetDefault,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: method.isDefault
            ? ColorsManager.lightBlue
            : ColorsManager.moreLighterGray,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: method.isDefault
              ? ColorsManager.mainBlue
              : ColorsManager.lighterGray,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.credit_card_rounded,
            size: 32.r,
            color: method.isDefault
                ? ColorsManager.mainBlue
                : ColorsManager.gray,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(method.label, style: TextStyles.font14DarkBlueMedium),
                SizedBox(height: 2.h),
                Text(
                  '${method.brand} •••• ${method.last4}',
                  style: TextStyles.font12GrayRegular,
                ),
              ],
            ),
          ),
          if (method.isDefault)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Default',
                style: TextStyles.font12BlueRegular.copyWith(
                  color: Colors.white,
                ),
              ),
            )
          else
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'default') onSetDefault();
                if (v == 'remove') onRemove();
              },
              itemBuilder: (_) => [
                const PopupMenuItem(
                  value: 'default',
                  child: Text('Set as default'),
                ),
                const PopupMenuItem(value: 'remove', child: Text('Remove')),
              ],
              icon: Icon(
                Icons.more_vert,
                size: 20.r,
                color: ColorsManager.gray,
              ),
            ),
        ],
      ),
    );
  }
}

class _AddCardSheet extends StatefulWidget {
  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _labelController = TextEditingController();
  final _brandController = TextEditingController();
  final _last4Controller = TextEditingController();

  @override
  void dispose() {
    _labelController.dispose();
    _brandController.dispose();
    _last4Controller.dispose();
    super.dispose();
  }

  void _onAdd() {
    if (!_formKey.currentState!.validate()) return;
    context.read<PaymentMethodsCubit>().add(
      label: _labelController.text.trim(),
      brand: _brandController.text.trim(),
      last4: _last4Controller.text.trim(),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24.w,
        24.h,
        24.w,
        MediaQuery.of(context).viewInsets.bottom + 32.h,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add Payment Method', style: TextStyles.font18DarkBlueBold),
            SizedBox(height: 20.h),
            _SheetField(
              controller: _labelController,
              hint: 'Card label (e.g. My Visa)',
            ),
            SizedBox(height: 12.h),
            _SheetField(
              controller: _brandController,
              hint: 'Brand (e.g. Visa, Mastercard)',
            ),
            SizedBox(height: 12.h),
            _SheetField(
              controller: _last4Controller,
              hint: 'Last 4 digits',
              maxLength: 4,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20.h),
            AppTextButton(
              buttonText: 'Add Card',
              textStyle: TextStyles.font16WhiteSemiBold,
              borderRadius: 16,
              onPressed: _onAdd,
            ),
          ],
        ),
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final int? maxLength;
  final TextInputType? keyboardType;

  const _SheetField({
    required this.controller,
    required this.hint,
    this.maxLength,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLength: maxLength,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyles.font14LightGrayRegular,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        filled: true,
        fillColor: ColorsManager.moreLighterGray,
        counterText: '',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
      style: TextStyles.font14DarkBlueMedium,
      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
    );
  }
}
