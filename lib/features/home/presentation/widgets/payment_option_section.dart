import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/core/theming/styles.dart';
import 'package:docdoc/features/home/data/models/payment_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PaymentOptionSection extends StatelessWidget {
  final PaymentMethod? selected;
  final CardBrand defaultCreditBrand;
  final ValueChanged<PaymentMethod> onChanged;

  const PaymentOptionSection({
    super.key,
    required this.selected,
    required this.onChanged,
    this.defaultCreditBrand = CardBrand.mastercard,
  });

  bool get _creditExpanded => selected is CreditCardPayment;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Option', style: TextStyles.font18DarkBlueBold),
        SizedBox(height: 16.h),
        _CreditCardGroup(
          selected: selected,
          expanded: _creditExpanded,
          onTopTap: () => onChanged(CreditCardPayment(defaultCreditBrand)),
          onBrandTap: (brand) => onChanged(CreditCardPayment(brand)),
        ),
        SizedBox(height: 12.h),
        _SimpleOptionTile(
          label: 'Bank Transfer',
          isSelected: selected is BankTransferPayment,
          onTap: () => onChanged(const BankTransferPayment()),
        ),
        SizedBox(height: 12.h),
        _SimpleOptionTile(
          label: 'Paypal',
          isSelected: selected is PayPalPayment,
          onTap: () => onChanged(const PayPalPayment()),
        ),
      ],
    );
  }
}

class _CreditCardGroup extends StatelessWidget {
  final PaymentMethod? selected;
  final bool expanded;
  final VoidCallback onTopTap;
  final ValueChanged<CardBrand> onBrandTap;

  const _CreditCardGroup({
    required this.selected,
    required this.expanded,
    required this.onTopTap,
    required this.onBrandTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _RadioRow(label: 'Credit Card', isSelected: expanded, onTap: onTopTap),
        if (expanded) ...[
          SizedBox(height: 12.h),
          ...CardBrand.values.map(
            (brand) => _BrandRow(
              brand: brand,
              isSelected:
                  selected is CreditCardPayment &&
                  (selected as CreditCardPayment).brand == brand,
              showDivider: brand != CardBrand.values.last,
              onTap: () => onBrandTap(brand),
            ),
          ),
        ],
      ],
    );
  }
}

class _RadioRow extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _RadioRow({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Row(
        children: [
          _Radio(isSelected: isSelected),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyles.font14DarkBlueMedium,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _SimpleOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SimpleOptionTile({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _RadioRow(label: label, isSelected: isSelected, onTap: onTap);
  }
}

class _Radio extends StatelessWidget {
  final bool isSelected;

  const _Radio({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22.r,
      height: 22.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? ColorsManager.mainBlue : ColorsManager.lightGray,
          width: 2,
        ),
      ),
      alignment: Alignment.center,
      child: isSelected
          ? Container(
              width: 12.r,
              height: 12.r,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: ColorsManager.mainBlue,
              ),
            )
          : null,
    );
  }
}

class _BrandRow extends StatelessWidget {
  final CardBrand brand;
  final bool isSelected;
  final bool showDivider;
  final VoidCallback onTap;

  const _BrandRow({
    required this.brand,
    required this.isSelected,
    required this.showDivider,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(left: 32.w),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Row(
                children: [
                  _BrandIcon(brand: brand),
                  SizedBox(width: 14.w),
                  Expanded(
                    child: Text(
                      brand.label,
                      style: isSelected
                          ? TextStyles.font14DarkBlueMedium.copyWith(
                              color: ColorsManager.mainBlue,
                            )
                          : TextStyles.font14DarkBlueMedium,
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_rounded,
                      color: ColorsManager.mainBlue,
                      size: 20.r,
                    ),
                ],
              ),
            ),
            if (showDivider)
              Divider(height: 1, color: ColorsManager.lighterGray),
          ],
        ),
      ),
    );
  }
}

class _BrandIcon extends StatelessWidget {
  final CardBrand brand;

  const _BrandIcon({required this.brand});

  String get _svgAsset => switch (brand) {
    CardBrand.mastercard => 'assets/svgs/mastercard.svg',
    CardBrand.amex => 'assets/svgs/american_express.svg',
    CardBrand.capitalOne => 'assets/svgs/capital_one.svg',
    CardBrand.barclays => 'assets/svgs/barclays.svg',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 45.r,
      height: 45.r,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.white),
      ),
      alignment: Alignment.center,
      child: SvgPicture.asset(
        _svgAsset,
        width: 30.r,
        height: 30.r,
        fit: BoxFit.contain,
      ),
    );
  }
}
