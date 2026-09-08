import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

void initializeZegoService(String userId, String userName) {
  final appIdString = dotenv.env['ZEGO_APP_ID'] ?? '0';
  final int appId = int.tryParse(appIdString) ?? 0;
  final String appSign = dotenv.env['ZEGO_APP_SIGN'] ?? '';

  ZegoUIKitPrebuiltCallInvitationService().init(
    appID: appId,
    appSign: appSign,
    userID: userId,
    userName: userName,
    plugins: [ZegoUIKitSignalingPlugin()],
  );
}