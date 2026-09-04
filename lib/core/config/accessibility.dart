import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

class AccessibilityConfig extends ChangeNotifier {
  static final AccessibilityConfig _instance = AccessibilityConfig._internal();
  factory AccessibilityConfig() => _instance;
  AccessibilityConfig._internal();

  final _storage = StorageService();

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

  void updateTextScale(double scale) {
    _textScaleFactor = scale;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }
  
  void toggleReducedMotion(bool value) {
    _reducedMotion = value;
    notifyListeners();
  }

  void toggleVoiceGuidance(bool value) {
    _voiceGuidance = value;
    notifyListeners();
  }
  
  void toggleSpokenReminders(bool value) {
    _spokenReminders = value;
    notifyListeners();
  }

  void toggleSimpleMode(bool value) {
    _simpleMode = value;
    notifyListeners();
  }
}
