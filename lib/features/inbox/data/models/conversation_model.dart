import 'package:docdoc/features/home/data/models/doctor_model.dart';

class ConversationModel {
  final int id;
  final DoctorModel doctor;
  final String lastMessage;
  final DateTime lastMessageTime;
  final int unreadCount;

  const ConversationModel({
    required this.id,
    required this.doctor,
    required this.lastMessage,
    required this.lastMessageTime,
    this.unreadCount = 0,
  });
}
