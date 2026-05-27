import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

/// Thin Supabase Storage wrapper. Buckets must be created in the Supabase
/// dashboard (or via SQL):
///   `avatars` — public read; per-user folder writes scoped by RLS
///   `medical-records` — owner-only read/write
class SupabaseStorageService {
  final SupabaseClient _client;
  const SupabaseStorageService(this._client);

  static const String avatarsBucket = 'avatars';
  static const String medicalRecordsBucket = 'medical-records';

  /// Uploads to `{bucket}/{userId}/{timestamp}.{ext}` and returns the public
  /// URL. Throws [StorageException] if the bucket is missing or RLS denies.
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    final ext = p.extension(filePath).replaceFirst('.', '').toLowerCase();
    final fileName =
        '${DateTime.now().millisecondsSinceEpoch}.${ext.isEmpty ? 'jpg' : ext}';
    final storagePath = '$userId/$fileName';
    await _client.storage
        .from(avatarsBucket)
        .upload(
          storagePath,
          File(filePath),
          fileOptions: const FileOptions(upsert: true),
        );
    return _client.storage.from(avatarsBucket).getPublicUrl(storagePath);
  }
}
