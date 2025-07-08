// lib/core/services/analytics_storage_service.dart

import 'dart:convert';
import 'dart:io' as io show File;
import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsStorageService {
  static const _fileName = 'analytics-log.json';
  static const _webKey = 'analytics_json_web';

  static Future<void> saveToFile(Map<String, dynamic> analytics) async {
    final jsonStr = jsonEncode(analytics);

    if (kIsWeb) {
      // 🌐 Web: save to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_webKey, jsonStr);
    } else {
      // 📱 Mobile/Desktop: save to local file
      final dir = await getApplicationDocumentsDirectory();
      final file = io.File('${dir.path}/$_fileName');
      await file.writeAsString(jsonStr);
    }
  }
  static Future<void> debugPrintStoredData() async {
    try {
      final data = await loadFromFile();
      print('📊 Stored Analytics Data:');
      print('-----------------------');
      print(jsonEncode(data)); // Pretty-print JSON
      print('-----------------------');

      // For non-Web, also print the file path
      if (!kIsWeb) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath = '${dir.path}/$_fileName';
        print('📂 File location: $filePath');
      } else {
        print('🌐 Web storage (SharedPreferences key: $_webKey)');
      }
    } catch (e) {
      print('❌ Failed to print analytics data: $e');
    }
  }
  static Future<Map<String, dynamic>> loadFromFile() async {
    try {
      if (kIsWeb) {
        final prefs = await SharedPreferences.getInstance();
        final jsonStr = prefs.getString(_webKey);
        if (jsonStr == null) return {};
        return jsonDecode(jsonStr);
      } else {
        final dir = await getApplicationDocumentsDirectory();
        final file = io.File('${dir.path}/$_fileName');
        if (!file.existsSync()) return {};
        final content = await file.readAsString();
        return jsonDecode(content);
      }
    } catch (e) {
      return {};
    }
  }
}
