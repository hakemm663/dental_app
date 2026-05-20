import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:docdoc/core/services/agora_service.dart';
import 'package:docdoc/core/services/agora_token_service.dart';
import 'package:docdoc/core/theming/colors.dart';
import 'package:docdoc/features/inbox/data/models/conversation_model.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

enum _ConnectionState { connecting, connected, reconnecting, ended }

class VideoCallScreen extends StatefulWidget {
  final ConversationModel conversation;

  const VideoCallScreen({super.key, required this.conversation});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraService _agoraService = GetIt.instance<AgoraService>();
  final AgoraTokenService _tokenService = GetIt.instance<AgoraTokenService>();

  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isSpeakerOn = true;
  bool _callEnded = false; // guards against double-leave when _endCall() precedes dispose()
  int? _remoteUid;
  _ConnectionState _connectionState = _ConnectionState.connecting;

  late final RtcEngineEventHandler _eventHandler;

  String get _channelName => widget.conversation.id.toString();

  @override
  void initState() {
    super.initState();
    _eventHandler = RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        if (mounted) {
          setState(() => _connectionState = _ConnectionState.connected);
          _agoraService.toggleSpeaker(true);
        }
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        if (mounted) {
          setState(() {
            _remoteUid = remoteUid;
            _connectionState = _ConnectionState.connected;
          });
        }
      },
      onUserOffline: (connection, remoteUid, reason) {
        if (mounted) {
          setState(() {
            _remoteUid = null;
            _connectionState = _ConnectionState.connecting;
          });
        }
      },
      onConnectionStateChanged: (connection, state, reason) {
        if (!mounted) return;
        if (state == ConnectionStateType.connectionStateReconnecting) {
          setState(() => _connectionState = _ConnectionState.reconnecting);
        } else if (state == ConnectionStateType.connectionStateConnected) {
          setState(() => _connectionState = _ConnectionState.connected);
        }
      },
      onTokenPrivilegeWillExpire: (connection, token) async {
        final newToken = await _tokenService.generateToken(
          channelName: _channelName,
        );
        _agoraService.renewToken(newToken);
      },
      onError: (err, msg) {
        if (mounted) {
          setState(() => _connectionState = _ConnectionState.connecting);
        }
      },
    );
    _initCall();
  }

  Future<void> _initCall() async {
    final granted = await requestCallPermissions();
    if (!granted) {
      if (mounted) Navigator.of(context).pop();
      return;
    }

    try {
      final token = await _tokenService.generateToken(
        channelName: _channelName,
      );
      await _agoraService.initialize();
      _agoraService.registerEventHandler(_eventHandler);
      await _agoraService.joinChannel(
        channelName: _channelName,
        uid: 0,
        token: token,
      );
    } catch (e, st) {
      FirebaseCrashlytics.instance
          .recordError(e, st, reason: 'Agora init failed');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to start call: $e'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  Future<void> _endCall() async {
    if (_callEnded) return;
    _callEnded = true;
    _agoraService.unregisterEventHandler(_eventHandler);
    await _agoraService.leaveChannel();
    if (mounted) Navigator.of(context).pop();
  }

  @override
  void dispose() {
    if (!_callEnded) {
      _agoraService.unregisterEventHandler(_eventHandler);
      _agoraService.leaveChannel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      body: Stack(
        children: [
          _RemoteView(
            agoraService: _agoraService,
            remoteUid: _remoteUid,
            channelName: _channelName,
            conversation: widget.conversation,
            connectionState: _connectionState,
          ),
          _BackButton(onTap: _endCall),
          _LocalPip(
            agoraService: _agoraService,
            isCameraOff: _isCameraOff,
          ),
          _ConnectionLabel(state: _connectionState),
          _BottomControls(
            isMicMuted: _isMicMuted,
            isCameraOff: _isCameraOff,
            isSpeakerOn: _isSpeakerOn,
            onMicToggle: () {
              final next = !_isMicMuted;
              setState(() => _isMicMuted = next);
              _agoraService.toggleMicrophone(next);
            },
            onCameraToggle: () {
              final next = !_isCameraOff;
              setState(() => _isCameraOff = next);
              _agoraService.toggleCamera(next);
            },
            onSpeakerToggle: () {
              final next = !_isSpeakerOn;
              setState(() => _isSpeakerOn = next);
              _agoraService.toggleSpeaker(next);
            },
            onSwitchCamera: () => _agoraService.switchCamera(),
            onEndCall: _endCall,
          ),
        ],
      ),
    );
  }
}

class _RemoteView extends StatelessWidget {
  final AgoraService agoraService;
  final int? remoteUid;
  final String channelName;
  final ConversationModel conversation;
  final _ConnectionState connectionState;

  const _RemoteView({
    required this.agoraService,
    required this.remoteUid,
    required this.channelName,
    required this.conversation,
    required this.connectionState,
  });

  @override
  Widget build(BuildContext context) {
    if (remoteUid != null && agoraService.isInitialized) {
      return Positioned.fill(
        child: AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: agoraService.engine,
            canvas: VideoCanvas(uid: remoteUid!),
            connection: RtcConnection(channelId: channelName),
          ),
        ),
      );
    }

    final doctor = conversation.doctor;
    return Positioned.fill(
      child: Container(
        color: const Color(0xFF1A1A2E),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 60.r,
                backgroundColor: ColorsManager.moreLighterGray,
                backgroundImage: doctor.image != null
                    ? NetworkImage(doctor.image!)
                    : null,
                child: doctor.image == null
                    ? Icon(Icons.person, size: 60.r, color: ColorsManager.gray)
                    : null,
              ),
              SizedBox(height: 16.h),
              Text(
                doctor.name,
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                connectionState == _ConnectionState.reconnecting
                    ? 'Reconnecting...'
                    : 'Calling...',
                style: TextStyle(fontSize: 14.sp, color: Colors.white70),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.h,
      left: 16.w,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40.r,
          height: 40.r,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18.r,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _LocalPip extends StatelessWidget {
  final AgoraService agoraService;
  final bool isCameraOff;

  const _LocalPip({required this.agoraService, required this.isCameraOff});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12.h,
      right: 16.w,
      child: Container(
        width: 100.w,
        height: 130.h,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2A3E),
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: isCameraOff || !agoraService.isInitialized
              ? Center(
                  child: Icon(Icons.videocam_off_rounded,
                      size: 32.r, color: Colors.white54),
                )
              : AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: agoraService.engine,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
        ),
      ),
    );
  }
}

class _ConnectionLabel extends StatelessWidget {
  final _ConnectionState state;

  const _ConnectionLabel({required this.state});

  String get _label {
    return switch (state) {
      _ConnectionState.connecting => 'Connecting...',
      _ConnectionState.connected => 'Connected',
      _ConnectionState.reconnecting => 'Reconnecting...',
      _ConnectionState.ended => '',
    };
  }

  @override
  Widget build(BuildContext context) {
    if (state == _ConnectionState.ended) return const SizedBox.shrink();
    return Positioned(
      top: MediaQuery.of(context).padding.top + 70.h,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Text(
            _label,
            style: TextStyle(color: Colors.white, fontSize: 12.sp),
          ),
        ),
      ),
    );
  }
}

class _BottomControls extends StatelessWidget {
  final bool isMicMuted;
  final bool isCameraOff;
  final bool isSpeakerOn;
  final VoidCallback onMicToggle;
  final VoidCallback onCameraToggle;
  final VoidCallback onSpeakerToggle;
  final VoidCallback onSwitchCamera;
  final VoidCallback onEndCall;

  const _BottomControls({
    required this.isMicMuted,
    required this.isCameraOff,
    required this.isSpeakerOn,
    required this.onMicToggle,
    required this.onCameraToggle,
    required this.onSpeakerToggle,
    required this.onSwitchCamera,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 40.h,
      left: 0,
      right: 0,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _CallControl(
              icon: isSpeakerOn ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              bgColor: isSpeakerOn
                  ? Colors.white.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.1),
              iconColor: Colors.white,
              onTap: onSpeakerToggle,
            ),
            _CallControl(
              icon: isCameraOff ? Icons.videocam_off_rounded : Icons.videocam_rounded,
              bgColor: isCameraOff
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              iconColor: Colors.white,
              onTap: onCameraToggle,
            ),
            _CallControl(
              icon: isMicMuted ? Icons.mic_off_rounded : Icons.mic_rounded,
              bgColor: isMicMuted
                  ? Colors.white.withValues(alpha: 0.1)
                  : Colors.white.withValues(alpha: 0.2),
              iconColor: Colors.white,
              onTap: onMicToggle,
            ),
            _CallControl(
              icon: Icons.flip_camera_ios_rounded,
              bgColor: Colors.white.withValues(alpha: 0.2),
              iconColor: Colors.white,
              onTap: onSwitchCamera,
            ),
            _CallControl(
              icon: Icons.call_end_rounded,
              bgColor: const Color(0xFFFF4D6D),
              iconColor: Colors.white,
              onTap: onEndCall,
            ),
          ],
        ),
      ),
    );
  }
}

class _CallControl extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _CallControl({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 52.r,
        height: 52.r,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 24.r),
      ),
    );
  }
}
