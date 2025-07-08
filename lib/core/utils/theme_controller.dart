
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const _prefKey = 'theme_mode';

  ThemeMode _mode = ThemeMode.system;
  ThemeMode get mode => _mode;

  ThemeController() {
    _loadSavedMode();
  }


  void toggle() {
    _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    _saveMode();
    notifyListeners();
  }


  void setMode(ThemeMode mode) {
    _mode = mode;
    _saveMode();
    notifyListeners();
  }


  Future<void> _loadSavedMode() async {
    final prefs = await SharedPreferences.getInstance();
    final idx   = prefs.getInt(_prefKey);
    if (idx != null && idx >= 0 && idx < ThemeMode.values.length) {
      _mode = ThemeMode.values[idx];
      notifyListeners();                     // rebuild MaterialApp
    }
  }

  Future<void> _saveMode() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_prefKey, _mode.index);
  }
}
