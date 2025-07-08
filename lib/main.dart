
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';

import 'core/utils/theme_controller.dart';
import 'helpers/notification_helper.dart' as web_notify;
import 'controllers/analytics_service.dart';
import 'controllers/filter_controller.dart';
import 'controllers/property_controller.dart';
import 'core/network/api_service.dart';
import 'views/home_screen.dart';
import 'views/property_detail_screen_route.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// ── Firebase init ──
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
      apiKey: "AIzaSyDiABBzdjKTiRPBVlFnF5nPSUNUF8h4qW4",
      authDomain: "interviewtask-6d696.firebaseapp.com",
      projectId: "interviewtask-6d696",
      storageBucket: "interviewtask-6d696.appspot.com",
      messagingSenderId: "724001120064",
      appId: "1:724001120064:web:57dfe30840b8dffdac24a5",
      measurementId: "G-RSVK7305HM",
    )
        : null,
  );

  await _setupNotificationHandlers(); // works for both web & mobile

  runApp(const PropertyApp());
}

Future<void> _setupNotificationHandlers() async {
  final messaging = FirebaseMessaging.instance;

  final settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );
  debugPrint('🔔 Permission status: ${settings.authorizationStatus}');

  final token = await messaging.getToken(
    vapidKey: kIsWeb
        ? 'BMr7GZHhGbcre4buBHcD5I7sQWL-5GGwjneW_cfZZLNZUXdeReg2Urp1QF9RDfpIQsLiHZOTfSLiLYltsk7WIzY'
        : null,
  );
  debugPrint('📲 FCM Token: $token');

  if (kIsWeb && settings.authorizationStatus == AuthorizationStatus.authorized) {
    await web_notify.requestWebNotificationPermission();
  }

  await _handleInitialNotification();
  _setupForegroundNotificationHandler();
  _setupBackgroundNotificationHandler();
}

Future<void> _handleInitialNotification() async {
  if (kIsWeb) return; // Web has no "getInitialMessage"
  final message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) _processNotification(message);
}

void _setupForegroundNotificationHandler() {
  if (kIsWeb) return;
  FirebaseMessaging.onMessage.listen((message) {
    debugPrint('📬 Foreground notification received');
    _showNotificationSnackbar(message);
  });
}

void _setupBackgroundNotificationHandler() {
  if (kIsWeb) return;
  FirebaseMessaging.onMessageOpenedApp.listen(_processNotification);
}

enum TransitionType { slide, fade, scale }

void _processNotification(RemoteMessage message) {
  final propertyId = message.data['propertyId'];
  if (propertyId == null || propertyId.isEmpty) return;

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _navigateToPropertyDetail(
      propertyId: propertyId,
      transitionType: TransitionType.slide,
    );
  });
}

void _showNotificationSnackbar(RemoteMessage message) {
  final context = navigatorKey.currentContext;
  if (context == null) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message.notification?.title ?? 'New property update'),
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'View',
        onPressed: () => _processNotification(message),
      ),
    ),
  );
}

void _navigateToPropertyDetail({
  required String propertyId,
  TransitionType transitionType = TransitionType.slide,
}) {
  final route = _createPropertyDetailRoute(propertyId, transitionType);
  navigatorKey.currentState?.push(route);
}

PageRouteBuilder _createPropertyDetailRoute(
    String propertyId,
    TransitionType transitionType,
    ) {
  return PageRouteBuilder(
    pageBuilder: (_, __, ___) => PropertyDetailScreenRoute(id: propertyId),
    transitionsBuilder: (_, animation, __, child) {
      switch (transitionType) {
        case TransitionType.fade:
          return FadeTransition(opacity: animation, child: child);
        case TransitionType.scale:
          return ScaleTransition(scale: animation, child: child);
        case TransitionType.slide:
        default:
          return SlideTransition(
            position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                .animate(CurvedAnimation(parent: animation, curve: Curves.easeInOut)),
            child: child,
          );
      }
    },
    transitionDuration: const Duration(milliseconds: 400),
  );
}
class PropertyApp extends StatelessWidget {
  const PropertyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ApiService()),
        Provider(create: (_) => AnalyticsService()),
        ChangeNotifierProvider(create: (_) => ThemeController()),   // ← already here
        ChangeNotifierProvider(create: (_) => FilterController()),
        ChangeNotifierProxyProvider<FilterController, PropertyController>(
          create: (context) => PropertyController(
            filterController: context.read<FilterController>(),
            apiService: context.read<ApiService>(),
            analyticsService: context.read<AnalyticsService>(),
          )..fetchProperties(),
          update: (context, filter, previous) =>
          (previous ??
              PropertyController(
                filterController: filter,
                apiService: context.read<ApiService>(),
                analyticsService: context.read<AnalyticsService>(),
              ))
            ..updateFilterController(filter),
        ),
      ],


      child: Consumer<ThemeController>(
        builder: (context, themeCtl, _) {

          final lightScheme = ColorScheme.fromSeed(seedColor: Colors.teal);
          final darkScheme  = ColorScheme.fromSeed(
            seedColor: Colors.teal,
            brightness: Brightness.dark,
          );

          return MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            title: 'Property Listing App',

            theme: ThemeData(
              useMaterial3: true,
              colorScheme: lightScheme,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: darkScheme,
            ),
            themeMode: themeCtl.mode,

            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
