class MedicalRecordModel {
  final int id;
  final String name;
  final String? type;
  final String? date;
  final String? fileUrl;

  const MedicalRecordModel({
    required this.id,
    required this.name,
    this.type,
    this.date,
    this.fileUrl,
  });

  factory MedicalRecordModel.fromJson(Map<String, dynamic> json) {
    return MedicalRecordModel(
      id: json['id'] as int,
      name: (json['name'] ?? json['title'] ?? '') as String,
      type: json['type'] as String?,
      date: (json['record_date'] ?? json['date'] ?? json['created_at'])
          as String?,
      fileUrl: (json['file_url'] ?? json['file']) as String?,
    );
  }
}
