import 'package:connectcall/main.dart';
import 'package:connectcall/utils/build_context.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';


class CallFeedback {
  CallFeedback._();

  static void show(String message, {bool isError = false}) {
    final context = navigatorKey.currentContext;
    if (context == null) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: isError ? context.error: context.black,
          duration: const Duration(seconds: 3),
        ),
      );
  }
}


class NetworkCheck {
  NetworkCheck._();

  static Future<bool> isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  static Future<bool> checkBeforeCall() async {
    if (!await isOnline()) {
      CallFeedback.show('No internet connection', isError: true);
      return false;
    }
    return true;
  }
}