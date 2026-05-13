part of 'payment_methods_cubit.dart';

class PaymentMethodsState {
  final List<PaymentMethodModel> methods;
  final bool isLoading;
  final String? errorMessage;

  const PaymentMethodsState({
    required this.methods,
    required this.isLoading,
    this.errorMessage,
  });

  const PaymentMethodsState.initial()
      : this(methods: const [], isLoading: false);

  const PaymentMethodsState.loading()
      : this(methods: const [], isLoading: true);

  PaymentMethodsState.success(List<PaymentMethodModel> methods)
      : this(methods: methods, isLoading: false);

  PaymentMethodsState.error(String message)
      : this(methods: const [], isLoading: false, errorMessage: message);
}
