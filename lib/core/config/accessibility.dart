import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityConfig extends ChangeNotifier {
  static final AccessibilityConfig _instance = AccessibilityConfig._internal();
  factory AccessibilityConfig() => _instance;
  AccessibilityConfig._internal();

  double _textScaleFactor = 1.2;
  bool _highContrast = false;
  bool _reducedMotion = false;
  bool _voiceGuidance = true;
  bool _spokenReminders = true;
  bool _largeTouchTargets = true;
  bool _simpleMode = false;

  double get textScaleFactor => _textScaleFactor;
  bool get highContrast => _highContrast;
  bool get reducedMotion => _reducedMotion;
  bool get voiceGuidance => _voiceGuidance;
  bool get spokenReminders => _spokenReminders;
  bool get largeTouchTargets => _largeTouchTargets;
  bool get simpleMode => _simpleMode;

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _textScaleFactor = prefs.getDouble('textScaleFactor') ?? 1.2;
      _highContrast = prefs.getBool('highContrast') ?? false;
      _reducedMotion = prefs.getBool('reducedMotion') ?? false;
      _voiceGuidance = prefs.getBool('voiceGuidance') ?? true;
      _spokenReminders = prefs.getBool('spokenReminders') ?? true;
      _largeTouchTargets = prefs.getBool('largeTouchTargets') ?? true;
      _simpleMode = prefs.getBool('simpleMode') ?? false;
      notifyListeners();
    } catch (_) {}
  }

  void _save(String key, dynamic value) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (value is bool) prefs.setBool(key, value);
      if (value is double) prefs.setDouble(key, value);
    } catch (_) {}
  }

  void updateTextScale(double scale) {
    _textScaleFactor = scale;
    _save('textScaleFactor', scale);
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    _highContrast = value;
    _save('highContrast', value);
    notifyListeners();
  }
  
  void toggleReducedMotion(bool value) {
    _reducedMotion = value;
    _save('reducedMotion', value);
    notifyListeners();
  }

  void toggleVoiceGuidance(bool value) {
    _voiceGuidance = value;
    _save('voiceGuidance', value);
    notifyListeners();
  }
  
  void toggleSpokenReminders(bool value) {
    _spokenReminders = value;
    _save('spokenReminders', value);
    notifyListeners();
  }

  void toggleSimpleMode(bool value) {
    _simpleMode = value;
    _save('simpleMode', value);
    notifyListeners();
  }
}
