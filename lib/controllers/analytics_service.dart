import 'dart:convert';
import 'dart:developer';
import 'analytics_storage_service.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;

  AnalyticsService._internal();

  final Map<String, int> propertyViews = {};
  final Map<String, Duration> propertyTimeSpent = {};
  final Map<String, int> interactionCounts = {};

  void logView(String propertyId) {
    propertyViews[propertyId] = (propertyViews[propertyId] ?? 0) + 1;
    _save();
    log('[Analytics] Viewed Property: $propertyId (${propertyViews[propertyId]} times)');
  }

  void logTimeSpent(String propertyId, Duration duration) {
    final total = propertyTimeSpent[propertyId] ?? Duration.zero;
    propertyTimeSpent[propertyId] = total + duration;
    _save();
    log('[Analytics] Time on $propertyId: ${propertyTimeSpent[propertyId]}');
  }

  void logInteraction(String key) {
    interactionCounts[key] = (interactionCounts[key] ?? 0) + 1;
    _save();
    log('[Analytics] Interaction: $key (${interactionCounts[key]})');
  }

  Future<void> _save() async {
    // Build the exact payload you’ll persist
    final payload = {
      'views': propertyViews,
      'timeSpent': propertyTimeSpent.map((k, v) => MapEntry(k, v.inSeconds)),
      'interactions': interactionCounts,
    };
    print('Analytics payload → $payload');


    await AnalyticsStorageService.saveToFile(payload);
  }

  Future<void> printAnalytics() async {
    final saved = await AnalyticsStorageService.loadFromFile();
    log('--- Local Analytics Dump ---');
    log(jsonEncode(saved));
    log('-----------------------------');
  }
}
