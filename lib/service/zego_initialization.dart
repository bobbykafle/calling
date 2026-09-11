import 'package:connectcall/models/user_model.dart';
import 'package:connectcall/repo/call_repo.dart';
import 'package:connectcall/screen/presentation.dart';
import 'package:connectcall/service/call_log_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

/// Handles starting/stopping the Zego call-invitation service,
/// and wires call-log tracking events. No UI code lives here.
class ZegoCallManager {
  ZegoCallManager._();

  static final _callLogService = CallLogService(CallLogRepository());

  static Future<void> init(UserModel user) async {
    await ZegoUIKitPrebuiltCallInvitationService().init(
      appID: int.parse(dotenv.env['ZEGO_APP_ID']!),
      appSign: dotenv.env['ZEGO_APP_SIGN']!,
      userID: user.uid,
      userName: user.name,
      plugins: [ZegoUIKitSignalingPlugin()],

      // UI (colors/layout) — yo purai alag file bata aaउँछ
      requireConfig: ZegoCallUiConfig.buildCallConfig,
      uiConfig: ZegoCallUiConfig.invitationUiConfig,

      // Call-log tracking — yo chai "logic" ho, UI hoina
      events: ZegoUIKitPrebuiltCallEvents(
        onCallEnd: (event, defaultAction) async {
          await _callLogService.onCallEnd();
          defaultAction();
        },
      ),
      invitationEvents: ZegoUIKitPrebuiltCallInvitationEvents(
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
        },
        onIncomingCallTimeout: (callID, caller) {
          _callLogService.logMissedIncoming();
        },
        onOutgoingCallAccepted: (callID, callee) {
          _callLogService.markOutgoingAccepted(callee.id, callee.name, false);
        },
        onOutgoingCallDeclined: (callID, callee, customData) {
          _callLogService.logMissedOutgoing(callee.id, callee.name);
        },
        onOutgoingCallRejectedCauseBusy: (callID, callee, customData) {
          _callLogService.logMissedOutgoing(callee.id, callee.name);
        },
        onOutgoingCallTimeout: (callID, callees, isVideoCall) {
          for (final callee in callees) {
            _callLogService.logMissedOutgoing(callee.id, callee.name, isVideoCall: isVideoCall);
          }
        },
      ),
    );
  }

  static Future<void> deinit() async {
    await ZegoUIKitPrebuiltCallInvitationService().uninit();
  }
}