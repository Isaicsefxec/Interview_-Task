// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;                    // <-- web‑only library
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> requestWebNotificationPermission() async {
  final permission = await html.Notification.requestPermission();
  print('🔔 Permission: $permission');

  if (permission != 'granted') return;

  // Register Firebase Messaging service‑worker so PWA push works
  try {
    final reg = await html.window.navigator.serviceWorker
        ?.register('firebase-messaging-sw.js');
    print('✅ Service Worker scope: ${reg?.scope}');
  } catch (e) {
    print('❌ Service Worker error: $e');
  }

  final token = await FirebaseMessaging.instance.getToken();
  print('✅ Web FCM token: $token');
}
