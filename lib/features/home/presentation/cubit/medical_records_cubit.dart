import 'package:docdoc/core/networking/api_result.dart';
import 'package:docdoc/features/home/data/models/medical_record_model.dart';
import 'package:docdoc/features/home/domain/use_cases/medical_records_use_cases.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'medical_records_state.dart';

class MedicalRecordsCubit extends Cubit<MedicalRecordsState> {
  final GetMedicalRecordsUseCase _getUseCase;

  MedicalRecordsCubit(this._getUseCase) : super(const MedicalRecordsState.initial());

  Future<void> getMedicalRecords() async {
    emit(const MedicalRecordsState.loading());
    final result = await _getUseCase();
    switch (result) {
      case Success(:final data):
        emit(MedicalRecordsState.success(data));
      case Failure(:final errMsg):
        emit(MedicalRecordsState.error(errMsg));
    }
  }
}
