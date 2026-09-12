import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserPresenceHandler extends StatefulWidget {
  final Widget child;
  const UserPresenceHandler({super.key, required this.child});

  @override
  State<UserPresenceHandler> createState() => _UserPresenceHandlerState();
}

class _UserPresenceHandlerState extends State<UserPresenceHandler> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    PresenceService.setOnline(true);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      PresenceService.setOnline(true);
    } else {
      PresenceService.setOnline(false);
    }
  }

  @override
  void dispose() {
    PresenceService.setOnline(false);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}



class PresenceService {
  PresenceService._();

  static Future<void> setOnline(bool isOnline) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'isOnline': isOnline,
    });
  }
}