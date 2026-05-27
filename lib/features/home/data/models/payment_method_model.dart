import 'dart:convert';

class PaymentMethodModel {
  final String id;
  final String label;
  final String brand;
  final String last4;
  final bool isDefault;

  const PaymentMethodModel({
    required this.id,
    required this.label,
    required this.brand,
    required this.last4,
    this.isDefault = false,
  });

  PaymentMethodModel copyWith({bool? isDefault}) {
    return PaymentMethodModel(
      id: id,
      label: label,
      brand: brand,
      last4: last4,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'label': label,
    'brand': brand,
    'last4': last4,
    'isDefault': isDefault,
  };

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
      id: json['id'] as String,
      label: json['label'] as String,
      brand: json['brand'] as String,
      last4: json['last4'] as String,
      isDefault: json['isDefault'] as bool? ?? false,
    );
  }

  String toJsonString() => jsonEncode(toJson());

  factory PaymentMethodModel.fromJsonString(String s) =>
      PaymentMethodModel.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
