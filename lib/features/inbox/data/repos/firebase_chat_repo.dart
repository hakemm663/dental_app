import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseChatRepo {
  final FirebaseFirestore _firestore;
  static const _uuid = Uuid();
  static const int _currentPatientId = 0;

  FirebaseChatRepo({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _firestore.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messages(String conversationId) =>
      _conversations.doc(conversationId).collection('messages');

  Stream<List<ConversationModel>> getConversationsStream() {
    return _conversations
        .where('patientId', isEqualTo: _currentPatientId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _conversationFromDoc(doc))
            .toList());
  }

  Future<List<ConversationModel>> searchConversations(String query) async {
    final snapshot = await _conversations
        .where('patientId', isEqualTo: _currentPatientId)
        .orderBy('lastMessageTime', descending: true)
        .get();

    final lower = query.toLowerCase();
    return snapshot.docs
        .map(_conversationFromDoc)
        .where((c) =>
            c.doctor.name.toLowerCase().contains(lower) ||
            c.lastMessage.toLowerCase().contains(lower))
        .toList();
  }

  Stream<List<MessageModel>> getMessagesStream(String conversationId) {
    return _messages(conversationId)
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => _messageFromDoc(doc)).toList());
  }

  Future<MessageModel> sendMessage(
      String conversationId, String text) async {
    final messageId = _uuid.v4();
    final now = Timestamp.now();

    final data = {
      'senderId': _currentPatientId,
      'text': text,
      'type': 'text',
      'imageUrl': null,
      'fileName': null,
      'fileSize': null,
      'timestamp': now,
      'isMe': true,
    };

    await _messages(conversationId).doc(messageId).set(data);
    await _conversations.doc(conversationId).update({
      'lastMessage': text,
      'lastMessageTime': now,
    });

    return MessageModel(
      id: messageId.hashCode,
      conversationId: conversationId.hashCode,
      text: text,
      senderId: _currentPatientId,
      timestamp: now.toDate(),
      isMe: true,
    );
  }

  Future<MessageModel> sendImageMessage(
      String conversationId, String imageUrl) async {
    final messageId = _uuid.v4();
    final now = Timestamp.now();

    final data = {
      'senderId': _currentPatientId,
      'text': '',
      'type': 'image',
      'imageUrl': imageUrl,
      'fileName': null,
      'fileSize': null,
      'timestamp': now,
      'isMe': true,
    };

    await _messages(conversationId).doc(messageId).set(data);
    await _conversations.doc(conversationId).update({
      'lastMessage': '📷 Photo',
      'lastMessageTime': now,
    });

    return MessageModel(
      id: messageId.hashCode,
      conversationId: conversationId.hashCode,
      text: '',
      senderId: _currentPatientId,
      timestamp: now.toDate(),
      isMe: true,
      type: MessageType.image,
      imageUrl: imageUrl,
    );
  }

  Future<MessageModel> sendAttachmentMessage(
    String conversationId,
    String fileUrl,
    String fileName,
    int fileSize,
  ) async {
    final messageId = _uuid.v4();
    final now = Timestamp.now();

    final data = {
      'senderId': _currentPatientId,
      'text': fileUrl,
      'type': 'attachment',
      'imageUrl': null,
      'fileName': fileName,
      'fileSize': fileSize,
      'timestamp': now,
      'isMe': true,
    };

    await _messages(conversationId).doc(messageId).set(data);
    await _conversations.doc(conversationId).update({
      'lastMessage': '📎 $fileName',
      'lastMessageTime': now,
    });

    return MessageModel(
      id: messageId.hashCode,
      conversationId: conversationId.hashCode,
      text: fileUrl,
      senderId: _currentPatientId,
      timestamp: now.toDate(),
      isMe: true,
      type: MessageType.attachment,
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  Future<ConversationModel> getOrCreateConversation(DoctorModel doctor) async {
    final existing = await _conversations
        .where('patientId', isEqualTo: _currentPatientId)
        .where('doctorId', isEqualTo: doctor.id)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      return _conversationFromDoc(existing.docs.first);
    }

    final docRef = _conversations.doc();
    final now = Timestamp.now();

    final data = {
      'doctorId': doctor.id,
      'doctorName': doctor.name,
      'doctorImage': doctor.image,
      'doctorSpecialization': doctor.specializationName,
      'doctorAddress': doctor.address,
      'patientId': _currentPatientId,
      'lastMessage': '',
      'lastMessageTime': now,
      'unreadCount': 0,
      'participants': [doctor.id, _currentPatientId],
    };

    await docRef.set(data);

    return ConversationModel(
      id: docRef.id,
      doctor: doctor,
      lastMessage: '',
      lastMessageTime: now.toDate(),
    );
  }

  Future<List<DoctorModel>> getDoctorsForNewMessage() async {
    final snapshot = await _conversations
        .where('patientId', isEqualTo: _currentPatientId)
        .get();

    final seen = <int>{};
    final doctors = <DoctorModel>[];

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final doctorId = data['doctorId'] as int;
      if (seen.add(doctorId)) {
        doctors.add(DoctorModel(
          id: doctorId,
          name: data['doctorName'] as String,
          image: data['doctorImage'] as String?,
          specializationName: data['doctorSpecialization'] as String?,
          address: data['doctorAddress'] as String?,
        ));
      }
    }

    return doctors;
  }

  Future<void> seedInitialData() async {
    final existing = await _conversations
        .where('patientId', isEqualTo: _currentPatientId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) return;

    final doctors = [
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
    ];

    final batch = _firestore.batch();

    for (final doctor in doctors) {
      final convRef = _conversations.doc();
      final convTime = Timestamp.fromDate(
        DateTime.now().subtract(const Duration(hours: 2)),
      );

      batch.set(convRef, {
        'doctorId': doctor.id,
        'doctorName': doctor.name,
        'doctorImage': doctor.image,
        'doctorSpecialization': doctor.specializationName,
        'doctorAddress': doctor.address,
        'patientId': _currentPatientId,
        'lastMessage':
            "Fine, I'll do a check. Does the patient have a history of certain diseases?",
        'lastMessageTime': convTime,
        'unreadCount': doctor.id == 101 || doctor.id == 102 ? 2 : 0,
        'participants': [doctor.id, _currentPatientId],
      });

      if (doctor.id == 101) {
        final seedMessages = [
          ('Hi, Dr. Randy 🙏', 0, true, 3, 0),
          ('Good morning, how can I help you?', 101, false, 2, 50),
          (
            'Good morning doctor, I have a headache and body aches.',
            0,
            true,
            2,
            40
          ),
          ('Fine, how long has the complaint been?', 101, false, 2, 30),
          ("It's been about the last 3 days.", 0, true, 2, 20),
          (
            "Fine, I'll do a check. Does the patient have a history of certain diseases?",
            101,
            false,
            2,
            10
          ),
        ];

        for (final (text, senderId, isMe, hours, minutes) in seedMessages) {
          final msgRef = convRef.collection('messages').doc(_uuid.v4());
          batch.set(msgRef, {
            'senderId': senderId,
            'text': text,
            'type': 'text',
            'imageUrl': null,
            'fileName': null,
            'fileSize': null,
            'timestamp': Timestamp.fromDate(
              DateTime.now()
                  .subtract(Duration(hours: hours, minutes: minutes)),
            ),
            'isMe': isMe,
          });
        }
      }
    }

    await batch.commit();
  }

  ConversationModel _conversationFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final lastMessageTime =
        (data['lastMessageTime'] as Timestamp).toDate();

    final doctor = DoctorModel(
      id: data['doctorId'] as int,
      name: data['doctorName'] as String,
      image: data['doctorImage'] as String?,
      specializationName: data['doctorSpecialization'] as String?,
      address: data['doctorAddress'] as String?,
    );

    return ConversationModel(
      id: doc.id,
      doctor: doctor,
      lastMessage: data['lastMessage'] as String? ?? '',
      lastMessageTime: lastMessageTime,
      unreadCount: data['unreadCount'] as int? ?? 0,
    );
  }

  MessageModel _messageFromDoc(
      QueryDocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data();
    final timestamp = (data['timestamp'] as Timestamp).toDate();
    final typeStr = data['type'] as String? ?? 'text';
    final type = switch (typeStr) {
      'image' => MessageType.image,
      'attachment' => MessageType.attachment,
      _ => MessageType.text,
    };

    return MessageModel(
      id: doc.id.hashCode,
      conversationId: doc.reference.parent.parent!.id.hashCode,
      text: data['text'] as String? ?? '',
      senderId: data['senderId'] as int,
      timestamp: timestamp,
      isMe: data['isMe'] as bool? ?? false,
      type: type,
      imageUrl: data['imageUrl'] as String?,
      fileName: data['fileName'] as String?,
      fileSize: data['fileSize'] as int?,
    );
  }
}
