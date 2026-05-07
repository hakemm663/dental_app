import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const String appId = 'YOUR_AGORA_APP_ID';

  RtcEngine? _engine;

  RtcEngine get engine {
    assert(_engine != null, 'AgoraService.initialize() must be called first');
    return _engine!;
  }

  bool get isInitialized => _engine != null;

  Future<void> initialize() async {
    if (_engine != null) return;

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(appId: appId));
    await _engine!.enableVideo();
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
  }

  Future<void> joinChannel({
    required String channelName,
    required int uid,
  }) async {
    assert(_engine != null, 'AgoraService.initialize() must be called first');
    await _engine!.joinChannel(
      token: '',
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(
        channelProfile: ChannelProfileType.channelProfileCommunication,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        publishCameraTrack: true,
        publishMicrophoneTrack: true,
        autoSubscribeAudio: true,
        autoSubscribeVideo: true,
      ),
    );
  }

  Future<void> leaveChannel() async {
    if (_engine == null) return;
    await _engine!.leaveChannel();
  }

  Future<void> toggleMicrophone(bool muted) async {
    if (_engine == null) return;
    await _engine!.muteLocalAudioStream(muted);
  }

  Future<void> toggleCamera(bool disabled) async {
    if (_engine == null) return;
    await _engine!.muteLocalVideoStream(disabled);
  }

  Future<void> switchCamera() async {
    if (_engine == null) return;
    await _engine!.switchCamera();
  }

  Future<void> toggleSpeaker(bool enabled) async {
    if (_engine == null) return;
    await _engine!.setEnableSpeakerphone(enabled);
  }

  void registerEventHandler(RtcEngineEventHandler handler) {
    _engine?.registerEventHandler(handler);
  }

  void unregisterEventHandler(RtcEngineEventHandler handler) {
    _engine?.unregisterEventHandler(handler);
  }

  Future<void> dispose() async {
    if (_engine == null) return;
    await _engine!.release();
    _engine = null;
  }
}

Future<bool> requestCallPermissions() async {
  final statuses = await [Permission.camera, Permission.microphone].request();
  return statuses[Permission.camera]!.isGranted &&
      statuses[Permission.microphone]!.isGranted;
}
