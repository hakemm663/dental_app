enum CardBrand {
  mastercard('Master Card', 'mastercard'),
  amex('American Express', 'amex'),
  capitalOne('Capital One', 'capital_one'),
  barclays('Barclays', 'barclays');

  final String label;
  final String wireKey;
  const CardBrand(this.label, this.wireKey);
}

sealed class PaymentMethod {
  const PaymentMethod();

  String get label => switch (this) {
    CreditCardPayment(:final brand) => brand.label,
    BankTransferPayment() => 'Bank Transfer',
    PayPalPayment() => 'Paypal',
  };

  String get wireKey => switch (this) {
    CreditCardPayment() => 'credit_card',
    BankTransferPayment() => 'bank_transfer',
    PayPalPayment() => 'paypal',
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
