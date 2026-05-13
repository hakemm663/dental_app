part of 'medical_records_cubit.dart';

class MedicalRecordsState {
  final List<MedicalRecordModel> records;
  final bool isLoading;
  final String? errorMessage;

  const MedicalRecordsState({
    required this.records,
    required this.isLoading,
    this.errorMessage,
  });

  const MedicalRecordsState.initial()
      : this(records: const [], isLoading: false);

  const MedicalRecordsState.loading()
      : this(records: const [], isLoading: true);

  MedicalRecordsState.success(List<MedicalRecordModel> records)
      : this(records: records, isLoading: false);

  MedicalRecordsState.error(String message)
      : this(records: const [], isLoading: false, errorMessage: message);
}
