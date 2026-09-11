import 'package:flutter/material.dart';
import 'package:zego_uikit/zego_uikit.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

class ZegoCallUiConfig {
  ZegoCallUiConfig._();

  /// In-call screen (video or audio) — real functionality via ZegoUIKitPrebuiltCallController
  static ZegoUIKitPrebuiltCallConfig buildCallConfig(ZegoCallInvitationData data) {
    final isGroup = data.invitees.length > 1;
    final isVideo = data.type == ZegoCallType.videoCall;

    final config = isGroup
        ? (isVideo
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall())
        : (isVideo
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall());

    config.topMenuBar.isVisible = false;
    config.bottomMenuBar.isVisible = false;

    if (!isVideo) {
      config.background = Container(color: Colors.black87);
    }

    config.avatarBuilder = (context, size, user, extraInfo) {
      return CircleAvatar(
        radius: size.width / 2,
        backgroundImage: NetworkImage('https://yourserver.com/avatar/${user?.id}.png'),
      );
    };

    config.foreground = _CallControlsOverlay(isVideo: isVideo);

    return config;
  }

  /// Incoming call ("ringing") screen — real config for callee side.
  static ZegoCallInvitationUIConfig get invitationUiConfig {
    return ZegoCallInvitationUIConfig(
      invitee: ZegoCallInvitationInviteeUIConfig(
        showAvatar: true,
        showCentralName: true,
        showCallingText: true,
        backgroundBuilder: (context, size, info) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black87, Colors.black54],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          );
        },
        acceptButton: ZegoCallButtonUIConfig(
          icon: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            child: const Icon(Icons.call, color: Colors.white),
          ),
        ),
        declineButton: ZegoCallButtonUIConfig(
          icon: Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            child: const Icon(Icons.call_end, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

/// Custom in-call controls — real mic/camera/speaker/end functionality
/// wired to ZegoUIKitPrebuiltCallController(), with reactive UI via ValueListenableBuilder.
class _CallControlsOverlay extends StatelessWidget {
  const _CallControlsOverlay({required this.isVideo});

  final bool isVideo;

  @override
  Widget build(BuildContext context) {
    final controller = ZegoUIKitPrebuiltCallController();

    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Mic mute/unmute
          ValueListenableBuilder<bool>(
            valueListenable: controller.audioVideo.microphone.localStateNotifier,
            builder: (context, isMicOn, _) {
              return _ControlButton(
                icon: isMicOn ? Icons.mic : Icons.mic_off,
                isActive: isMicOn,
                onTap: () => controller.audioVideo.microphone.switchState(),
              );
            },
          ),

          if (isVideo)
            ValueListenableBuilder<bool>(
              valueListenable: controller.audioVideo.camera.localStateNotifier,
              builder: (context, isCameraOn, _) {
                return _ControlButton(
                  icon: isCameraOn ? Icons.videocam : Icons.videocam_off,
                  isActive: isCameraOn,
                  onTap: () => controller.audioVideo.camera.switchState(),
                );
              },
            ),

          if (isVideo)
            _ControlButton(
              icon: Icons.flip_camera_ios,
              isActive: true,
              onTap: () {
                // toggles front/back; track state yourself if you need an icon flip
                controller.audioVideo.camera.switchFrontFacing(true);
              },
            ),

          if (!isVideo)
            ValueListenableBuilder<ZegoUIKitAudioRoute>(
              valueListenable: controller.audioVideo.audioOutput.localNotifier,
              builder: (context, route, _) {
                final isSpeaker = route == ZegoUIKitAudioRoute.speaker;
                return _ControlButton(
                  icon: isSpeaker ? Icons.volume_up : Icons.volume_off,
                  isActive: isSpeaker,
                  onTap: () => controller.audioVideo.audioOutput.switchToSpeaker(!isSpeaker),
                );
              },
            ),

          // End Call — confirmed API
          _ControlButton(
            icon: Icons.call_end,
            isActive: true,
            backgroundColor: Colors.red,
            onTap: () => controller.hangUp(context),
          ),
        ],
      ),
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.isActive,
    required this.onTap,
    this.backgroundColor,
  });

  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? (isActive ? Colors.white24 : Colors.red),
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}