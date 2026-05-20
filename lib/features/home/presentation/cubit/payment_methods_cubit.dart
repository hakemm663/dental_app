import 'package:docdoc/features/home/data/models/payment_method_model.dart';
import 'package:docdoc/features/home/domain/use_cases/payment_methods_use_cases.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

part 'payment_methods_state.dart';

class PaymentMethodsCubit extends Cubit<PaymentMethodsState> {
  final GetPaymentMethodsUseCase _getUseCase;
  final AddPaymentMethodUseCase _addUseCase;
  final RemovePaymentMethodUseCase _removeUseCase;
  final SetDefaultPaymentMethodUseCase _setDefaultUseCase;

  PaymentMethodsCubit(
    this._getUseCase,
    this._addUseCase,
    this._removeUseCase,
    this._setDefaultUseCase,
  ) : super(const PaymentMethodsState.initial());

  Future<void> load() async {
    emit(const PaymentMethodsState.loading());
    try {
      final methods = await _getUseCase();
      emit(PaymentMethodsState.success(methods));
    } catch (e, st) {
      FirebaseCrashlytics.instance
          .recordError(e, st, reason: 'PaymentMethodsCubit.load failed');
      emit(PaymentMethodsState.error('Failed to load payment methods'));
    }
  }

  Future<void> add({
    required String label,
    required String brand,
    required String last4,
  }) async {
    final method = PaymentMethodModel(
      id: const Uuid().v4(),
      label: label,
      brand: brand,
      last4: last4,
      isDefault: state.methods.isEmpty,
    );
    await _addUseCase(method);
    await load();
  }

  Future<void> remove(String id) async {
    await _removeUseCase(id);
    await load();
  }

  Future<void> setDefault(String id) async {
    await _setDefaultUseCase(id);
    await load();
  }
}
