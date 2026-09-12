import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Background/Terminated message received: ${message.messageId}");
  
  if (message.data['type'] == 'call') {
    print("Incoming call from: ${message.data['callerName']}");
  }
}

class NotificationService {
  static Future<void> initialize() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // १. FCM Permission माग्ने
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');
    }

    // २. Foreground Presentation Options (एप खुलेको बेला ब्यानर देखाउन)
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // ३. Background Handler रजिस्टर गर्ने
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // ४. Foreground Message Listener (एप खुला भएको बेला कल वा म्यासेज आएमा)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.data}');
      
      if (message.data['type'] == 'call') {
        String callerName = message.data['callerName'] ?? 'Someone';
        String callId = message.data['callId'] ?? '';
        print("Incoming call in Foreground from $callerName (Call ID: $callId)");
        // TODO: यहाँ एपभित्र कल आउने UI देखाउने
      }
    });

    // ५. नटिफिकेसन क्लिक गरेर एप खोल्दा
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification clicked: ${message.data}');
      if (message.data['type'] == 'call') {
        // TODO: कल स्क्रिनमा रिडाइरेक्ट गर्ने
      }
    });

    // ६. Firestore मा FCM Token सिङ्क गर्ने
    await syncFCMToken();

    // ७. टोकन परिवर्तन हुँदा अपडेट गर्ने
    messaging.onTokenRefresh.listen((newToken) {
      _updateTokenInFirestore(newToken);
    });
  }

  // Firebase Firestore को 'users' कलेक्सनमा FCM Token सेभ गर्ने
  static Future<void> syncFCMToken() async {
    try {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        await _updateTokenInFirestore(fcmToken);
      }
    } catch (e) {
      (" FCM Token Sync Error: $e");
    }
  }

  static Future<void> _updateTokenInFirestore(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'fcmToken': token});
      ("Linked FCM Token to Firestore User: $userId");
    }
  }

  
}