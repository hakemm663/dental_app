import 'package:cloud_functions/cloud_functions.dart';

class AgoraTokenService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;

  Future<String> generateToken({
    required String channelName,
    int uid = 0,
    String role = 'publisher',
  }) async {
    final result = await _functions.httpsCallable('generateToken').call({
      'channelName': channelName,
      'uid': uid,
      'role': role,
    });
    return result.data['token'] as String;
  }

  Future<String> acquireRecording({
    required String channelName,
    required int uid,
  }) async {
    final result = await _functions.httpsCallable('acquireRecording').call({
      'channelName': channelName,
      'uid': uid,
    });
    return result.data['resourceId'] as String;
  }

  Future<Map<String, dynamic>> startRecording({
    required String channelName,
    required int uid,
    required String resourceId,
    required Map<String, dynamic> storageConfig,
  }) async {
    final result = await _functions.httpsCallable('startRecording').call({
      'channelName': channelName,
      'uid': uid,
      'resourceId': resourceId,
      'storageConfig': storageConfig,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> stopRecording({
    required String channelName,
    required int uid,
    required String resourceId,
    required String sid,
  }) async {
    final result = await _functions.httpsCallable('stopRecording').call({
      'channelName': channelName,
      'uid': uid,
      'resourceId': resourceId,
      'sid': sid,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }

  Future<Map<String, dynamic>> queryRecording({
    required String resourceId,
    required String sid,
  }) async {
    final result = await _functions.httpsCallable('queryRecording').call({
      'resourceId': resourceId,
      'sid': sid,
    });
    return Map<String, dynamic>.from(result.data as Map);
  }
}
