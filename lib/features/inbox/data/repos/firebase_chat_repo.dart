import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:docdoc/features/home/data/models/doctor_model.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:docdoc/features/inbox/data/models/message_model.dart';
import 'package:uuid/uuid.dart';

class FirebaseChatRepo {
  final FirebaseFirestore _firestore;
  final String _patientId;
  static const _uuid = Uuid();

  FirebaseChatRepo({required String patientId, FirebaseFirestore? firestore})
      : _patientId = patientId,
        _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _firestore.collection('conversations');

  CollectionReference<Map<String, dynamic>> _messages(String conversationId) =>
      _conversations.doc(conversationId).collection('messages');

  Stream<List<ConversationModel>> getConversationsStream() {
    return _conversations
        .where('patientId', isEqualTo: _patientId)
        .orderBy('lastMessageTime', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => _conversationFromDoc(doc))
            .toList());
  }

  Future<List<ConversationModel>> searchConversations(String query) async {
    final snapshot = await _conversations
        .where('patientId', isEqualTo: _patientId)
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
      'senderId': _patientId,
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
      id: messageId,
      conversationId: conversationId,
      text: text,
      senderId: _patientId,
      timestamp: now.toDate(),
      isMe: true,
    );
  }

  Future<MessageModel> sendImageMessage(
      String conversationId, String imageUrl) async {
    final messageId = _uuid.v4();
    final now = Timestamp.now();

    final data = {
      'senderId': _patientId,
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
      id: messageId,
      conversationId: conversationId,
      text: '',
      senderId: _patientId,
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
      'senderId': _patientId,
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
      id: messageId,
      conversationId: conversationId,
      text: fileUrl,
      senderId: _patientId,
      timestamp: now.toDate(),
      isMe: true,
      type: MessageType.attachment,
      fileName: fileName,
      fileSize: fileSize,
    );
  }

  Future<ConversationModel> getOrCreateConversation(DoctorModel doctor) async {
    final existing = await _conversations
        .where('patientId', isEqualTo: _patientId)
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
      'patientId': _patientId,
      'lastMessage': '',
      'lastMessageTime': now,
      'unreadCount': 0,
      'participants': [doctor.id, _patientId],
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
        .where('patientId', isEqualTo: _patientId)
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
      id: doc.id,
      conversationId: doc.reference.parent.parent!.id,
      text: data['text'] as String? ?? '',
      senderId: '${data['senderId']}',
      timestamp: timestamp,
      isMe: data['isMe'] as bool? ?? false,
      type: type,
      imageUrl: data['imageUrl'] as String?,
      fileName: data['fileName'] as String?,
      fileSize: data['fileSize'] as int?,
    );
  }
}
