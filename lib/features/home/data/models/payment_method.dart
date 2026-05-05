enum CardBrand {
  mastercard('Master Card', 'assets/icons/mastercard.png'),
  amex('American Express', 'assets/icons/Group 1000004778.png'),
  capitalOne('Capital One', 'assets/icons/Group 1000004780.png'),
  barclays('Barclays', 'assets/icons/Group 1000004781.png');

  final String label;
  final String assetPath;
  const CardBrand(this.label, this.assetPath);
}

sealed class PaymentMethod {
  const PaymentMethod();

  String get label => switch (this) {
        CreditCardPayment(:final brand) => brand.label,
        BankTransferPayment() => 'Bank Transfer',
        PayPalPayment() => 'Paypal',
      };
}

class CreditCardPayment extends PaymentMethod {
  final CardBrand brand;
  const CreditCardPayment(this.brand);
}

class BankTransferPayment extends PaymentMethod {
  const BankTransferPayment();
}

class PayPalPayment extends PaymentMethod {
  const PayPalPayment();
}
