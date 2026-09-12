import 'package:connectcall/models/user_model.dart';
import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/screen/presentation.dart';
import 'package:connectcall/service/call_log_service.dart';
import 'package:connectcall/utils/cache_avatar.dart';
import 'package:connectcall/utils/call_feedback.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

class ZegoCallManager {
  ZegoCallManager._();

  static final _callLogService = CallLogService(CallLogRepository());

  static Future<void> init(UserModel user) async {
    ZegoAvatarCache.set(user.uid, user.photoUrl);
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(dotenv.env['ZEGO_APP_ID']!),
      appSign: dotenv.env['ZEGO_APP_SIGN']!,
      userID: user.uid,
      userName: user.name,
      plugins: [ZegoUIKitSignalingPlugin()],

      requireConfig: ZegoCallUiConfig.buildCallConfig,
      uiConfig: ZegoCallUiConfig.invitationUiConfig,

      // ✅ events: top-level parameter (sibling of requireConfig), NOT config.events
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) async {
          await _callLogService.onCallEnd();
          defaultAction();
        },
        // ✅ onError: direct property, NOT nested inside room:
        onError: (error) {
          CallFeedback.show('Connection failed. Please try again.', isError: true);
        },
      ),

      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
        // ✅ signaling/invitation-level errors (e.g. user offline, network drop)
        onError: (error) {
          CallFeedback.show('Something went wrong. Please try again.', isError: true);
        },
        onIncomingCallReceived: (callID, caller, callType, callees, customData) {
          _callLogService.trackIncoming(
            caller.id,
            caller.name,
            callType == ZegoCallType.videoCall,
          );
        },
        onIncomingCallAcceptButtonPressed: () {
          _callLogService.markIncomingAccepted();
        },
        onIncomingCallDeclineButtonPressed: () {
          _callLogService.logMissedIncoming();
        },
        onIncomingCallCanceled: (callID, caller, customData) {
          _callLogService.logMissedIncoming();
          CallFeedback.show('${caller.name} cancelled the call');
        },
        onIncomingCallTimeout: (callID, caller) {
          _callLogService.logMissedIncoming();
          CallFeedback.show('Missed call from ${caller.name}');
        },
        onOutgoingCallAccepted: (callID, callee) {
          _callLogService.markOutgoingAccepted(callee.id, callee.name, false);
        },
        onOutgoingCallDeclined: (callID, callee, customData) {
          _callLogService.logMissedOutgoing(callee.id, callee.name);
          CallFeedback.show('${callee.name} declined the call');
        },
        onOutgoingCallRejectedCauseBusy: (callID, callee, customData) {
          _callLogService.logMissedOutgoing(callee.id, callee.name);
          CallFeedback.show('${callee.name} is busy on another call');
        },
        onOutgoingCallTimeout: (callID, callees, isVideoCall) {
          for (final callee in callees) {
            _callLogService.logMissedOutgoing(callee.id, callee.name, isVideoCall: isVideoCall);
          }
          CallFeedback.show('No answer');
        },
      ),
    );
  }

  static Future<void> deinit() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}