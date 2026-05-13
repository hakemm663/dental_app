import 'package:docdoc/core/helpers/constans.dart';
import 'package:docdoc/core/helpers/shared_pref_helper.dart';
import 'package:docdoc/features/home/data/models/payment_method_model.dart';

class PaymentMethodsRepo {
  Future<List<PaymentMethodModel>> getAll() async {
    final raw = await SharedPrefHelper.getStringList(SharedPrefKeys.paymentMethods);
    return raw.map(PaymentMethodModel.fromJsonString).toList();
  }

  Future<void> add(PaymentMethodModel method) async {
    final all = await getAll();
    final updated = [...all, method];
    await _save(updated);
  }

  Future<void> remove(String id) async {
    final all = await getAll();
    await _save(all.where((m) => m.id != id).toList());
  }

  Future<void> setDefault(String id) async {
    final all = await getAll();
    await _save(
      all.map((m) => m.copyWith(isDefault: m.id == id)).toList(),
    );
  }

  Future<void> _save(List<PaymentMethodModel> methods) =>
      SharedPrefHelper.setStringList(
        SharedPrefKeys.paymentMethods,
        methods.map((m) => m.toJsonString()).toList(),
      );
}
