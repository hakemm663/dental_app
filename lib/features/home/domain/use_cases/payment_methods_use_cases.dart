import 'package:docdoc/features/home/data/models/payment_method_model.dart';
import 'package:docdoc/features/home/data/repos/payment_methods_repo.dart';

class GetPaymentMethodsUseCase {
  final PaymentMethodsRepo _repo;

  const GetPaymentMethodsUseCase(this._repo);

  Future<List<PaymentMethodModel>> call() => _repo.getAll();
}

class AddPaymentMethodUseCase {
  final PaymentMethodsRepo _repo;

  const AddPaymentMethodUseCase(this._repo);

  Future<void> call(PaymentMethodModel method) => _repo.add(method);
}

class RemovePaymentMethodUseCase {
  final PaymentMethodsRepo _repo;

  const RemovePaymentMethodUseCase(this._repo);

  Future<void> call(String id) => _repo.remove(id);
}

class SetDefaultPaymentMethodUseCase {
  final PaymentMethodsRepo _repo;

  const SetDefaultPaymentMethodUseCase(this._repo);

  Future<void> call(String id) => _repo.setDefault(id);
}
