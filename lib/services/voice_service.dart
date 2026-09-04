import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter/material.dart';

class VoiceService {
  static final VoiceService _instance = VoiceService._internal();
  factory VoiceService() => _instance;

  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();

  bool _isTtsInitialized = false;
  bool _isSttInitialized = false;

  VoiceService._internal() {
    _initTts();
    _initStt();
  }

  Future<void> _initTts() async {
    try {
      await _flutterTts.setLanguage("en-US");
      await _flutterTts.setSpeechRate(0.5); // Slower for elderly
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isTtsInitialized = true;
    } catch (e) {
      debugPrint("TTS initialization failed: $e");
    }
  }

  Future<void> _initStt() async {
    try {
      _isSttInitialized = await _speech.initialize(
        onStatus: (status) => debugPrint('STT Status: $status'),
        onError: (errorNotification) => debugPrint('STT Error: $errorNotification'),
      );
    } catch (e) {
      debugPrint("STT initialization failed: $e");
    }
  }

  Future<void> speak(String text) async {
    if (!_isTtsInitialized) {
      debugPrint("TTS not available, skipping speech: $text");
      return;
    }
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      debugPrint("Speech failed: $e");
    }
  }

  Future<void> stopSpeaking() async {
    if (_isTtsInitialized) {
      await _flutterTts.stop();
    }
  }

  Future<bool> startListening(Function(String) onResult) async {
    if (!_isSttInitialized) {
      return false; // Not available
    }

    if (!_speech.isListening) {
      await _speech.listen(
        onResult: (result) {
          onResult(result.recognizedWords);
        },
      );
      return true;
    }
    return false;
  }

  Future<void> stopListening() async {
    if (_speech.isListening) {
      await _speech.stop();
    }
  }
}
