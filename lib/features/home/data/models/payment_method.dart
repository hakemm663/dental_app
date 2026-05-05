enum CardBrand {
  mastercard('Master Card'),
  amex('American Express'),
  capitalOne('Capital One'),
  barclays('Barclays');

  final String label;
  const CardBrand(this.label);
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
