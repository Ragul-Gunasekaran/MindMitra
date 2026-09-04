import 'package:flutter/material.dart';

class AppLocalization extends ChangeNotifier {
  static final AppLocalization _instance = AppLocalization._internal();
  factory AppLocalization() => _instance;
  AppLocalization._internal();

  String _currentLanguageCode = 'en';
  String get currentLanguageCode => _currentLanguageCode;

  final Map<String, String> languageNames = {
    'en': 'English',
    'hi': 'Hindi',
    'ta': 'Tamil',
    'as': 'Assamese',
    'bn': 'Bengali',
  };

  void setLanguage(String code) {
    if (languageNames.containsKey(code)) {
      _currentLanguageCode = code;
      notifyListeners();
    }
  }

  // Simplified Translation Engine
  final Map<String, Map<String, String>> _translations = {
    'en': {
      'good_morning': 'Good Morning',
      'todays_plan': 'Today''s Plan',
      'how_are_you_feeling': 'How are you feeling?',
      'ask_mindmitra': 'Ask MindMitra',
      'sos_button': 'SOS / EMERGENCY',
    },
    'hi': {
      'good_morning': '????????',
      'todays_plan': '?? ?? ?????',
      'how_are_you_feeling': '?? ???? ????? ?? ??? ????',
      'ask_mindmitra': '??????????? ?? ?????',
      'sos_button': '??????? (SOS)',
    },
    'ta': {
      'good_morning': '???? ???????',
      'todays_plan': '?????? ???????',
      'how_are_you_feeling': '??????? ?????? ??????????????',
      'ask_mindmitra': '?????????????? ?????????',
      'sos_button': '?????? (SOS)',
    },
    // Adding fallbacks for Assamese and Bengali to avoid large file size in MVP
  };

  String translate(String key) {
    if (_translations.containsKey(_currentLanguageCode)) {
      if (_translations[_currentLanguageCode]!.containsKey(key)) {
        return _translations[_currentLanguageCode]![key]!;
      }
    }
    // Fallback to English
    return _translations['en']![key] ?? key;
  }
}
