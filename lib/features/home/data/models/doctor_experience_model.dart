class DoctorExperienceModel {
  final String place;
  final String fromYear;
  final String? toYear;
  final bool isCurrent;

  const DoctorExperienceModel({
    required this.place,
    required this.fromYear,
    this.toYear,
    this.isCurrent = false,
  });

  factory DoctorExperienceModel.fromJson(Map<String, dynamic> json) =>
      DoctorExperienceModel(
        place: json['place'] as String? ?? '',
        fromYear: json['from_year'] as String? ?? '',
        toYear: json['to_year'] as String?,
        isCurrent: json['is_current'] as bool? ?? false,
      );
}
