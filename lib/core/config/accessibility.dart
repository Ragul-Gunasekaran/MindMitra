import 'package:flutter/material.dart';

class AccessibilityConfig extends ChangeNotifier {
  static final AccessibilityConfig _instance = AccessibilityConfig._internal();
  factory AccessibilityConfig() => _instance;
  AccessibilityConfig._internal();

  double _textScaleFactor = 1.2;
  bool _highContrast = false;

  double get textScaleFactor => _textScaleFactor;
  bool get highContrast => _highContrast;

  void updateTextScale(double scale) {
    _textScaleFactor = scale;
    notifyListeners();
  }

  void toggleHighContrast(bool value) {
    _highContrast = value;
    notifyListeners();
  }
}
