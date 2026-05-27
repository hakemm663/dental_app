import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage})
    : _storage = storage ?? FirebaseStorage.instance;

  Future<String> uploadChatImage(String filePath, String conversationId) async {
    final file = File(filePath);
    final fileName = path.basename(filePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath = 'chat_images/$conversationId/${timestamp}_$fileName';

    final ref = _storage.ref().child(storagePath);
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }

  Future<String> uploadChatAttachment(
    String filePath,
    String conversationId,
  ) async {
    final file = File(filePath);
    final fileName = path.basename(filePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final storagePath =
        'chat_attachments/$conversationId/${timestamp}_$fileName';

    final ref = _storage.ref().child(storagePath);
    final task = await ref.putFile(file);
    return await task.ref.getDownloadURL();
  }
}
