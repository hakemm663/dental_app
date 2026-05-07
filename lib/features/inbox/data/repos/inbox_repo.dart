import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';

class MockInboxRepo {
  static final List<DoctorModel> _doctors = [
    const DoctorModel(
      id: 101,
      name: 'Dr. Randy Wigham',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=11',
      address: 'RSUD Gatot Subroto',
    ),
    const DoctorModel(
      id: 102,
      name: 'Dr. Jack Sulivan',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=12',
      address: 'RSUD Gatot Subroto',
    ),
    const DoctorModel(
      id: 103,
      name: 'Drg. Hanna Stanton',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=5',
      address: 'RSUD Gatot Subroto',
    ),
    const DoctorModel(
      id: 104,
      name: 'Dr. Emery Lubin',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=8',
      address: 'RSUD Gatot Subroto',
    ),
    const DoctorModel(
      id: 105,
      name: 'Dr. Nolan Geidt',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=53',
      address: 'RSUD Gatot Subroto',
    ),
    const DoctorModel(
      id: 106,
      name: 'Dr. Gretchen Saris',
      specializationName: 'General Doctor',
      image: 'https://i.pravatar.cc/150?img=49',
      address: 'RSUD Gatot Subroto',
    ),
  ];

  final List<ConversationModel> _conversations = [
    ConversationModel(
      id: '1',
      doctor: _doctors[0],
      lastMessage:
          "Fine, I'll do a check. Does the patient have a history of certain diseases?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
    ),
    ConversationModel(
      id: '2',
      doctor: _doctors[1],
      lastMessage:
          "Fine, I'll do a check. Does the patient have a history of certain diseases?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
      unreadCount: 2,
    ),
    ConversationModel(
      id: '3',
      doctor: _doctors[2],
      lastMessage:
          "Fine, I'll do a check. Does the patient have a history of certain diseases?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ConversationModel(
      id: '4',
      doctor: _doctors[3],
      lastMessage:
          "Fine, I'll do a check. Does the patient have a history of certain diseases?",
      lastMessageTime: DateTime.now().subtract(const Duration(hours: 3)),
      unreadCount: 2,
    ),
  ];

  final Map<String, List<MessageModel>> _messages = {
    '1': [
      MessageModel(
        id: 1,
        conversationId: 1,
        text: 'Hi, Dr. Randy \u{1F64F}',
        senderId: 0,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isMe: true,
      ),
      MessageModel(
        id: 2,
        conversationId: 1,
        text: 'Good morning, how can I help you?',
        senderId: 101,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 50)),
        isMe: false,
      ),
      MessageModel(
        id: 3,
        conversationId: 1,
        text: 'Good morning doctor, I have a headache and body aches.',
        senderId: 0,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 40)),
        isMe: true,
      ),
      MessageModel(
        id: 4,
        conversationId: 1,
        text: 'Fine, how long has the complaint been?',
        senderId: 101,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 30)),
        isMe: false,
      ),
      MessageModel(
        id: 5,
        conversationId: 1,
        text: "It's been about the last 3 days.",
        senderId: 0,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 20)),
        isMe: true,
      ),
      MessageModel(
        id: 6,
        conversationId: 1,
        text:
            "Fine, I'll do a check. Does the patient have a history of certain diseases?",
        senderId: 101,
        timestamp: DateTime.now()
            .subtract(const Duration(hours: 2, minutes: 10)),
        isMe: false,
      ),
    ],
  };

  int _nextMessageId = 100;

  Future<List<ConversationModel>> getConversations() async =>
      List.unmodifiable(_conversations);

  Future<List<ConversationModel>> searchConversations(String query) async {
    final lower = query.toLowerCase();
    return _conversations
        .where((c) =>
            c.doctor.name.toLowerCase().contains(lower) ||
            c.lastMessage.toLowerCase().contains(lower))
        .toList();
  }

  Future<List<MessageModel>> getMessages(String conversationId) async =>
      List.unmodifiable(_messages[conversationId] ?? []);

  Future<MessageModel> sendMessage(String conversationId, String text) async {
    final message = MessageModel(
      id: _nextMessageId++,
      conversationId: int.tryParse(conversationId) ?? 0,
      text: text,
      senderId: 0,
      timestamp: DateTime.now(),
      isMe: true,
    );
    _messages.putIfAbsent(conversationId, () => []);
    _messages[conversationId]!.add(message);

    final idx = _conversations.indexWhere((c) => c.id == conversationId);
    if (idx != -1) {
      final old = _conversations[idx];
      _conversations[idx] = ConversationModel(
        id: old.id,
        doctor: old.doctor,
        lastMessage: text,
        lastMessageTime: message.timestamp,
        unreadCount: old.unreadCount,
      );
    }
    return message;
  }

  Future<List<DoctorModel>> getDoctorsForNewMessage() async =>
      List.unmodifiable(_doctors);
}
