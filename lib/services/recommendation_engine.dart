import 'storage_service.dart';
import 'dart:math';

class RecommendationEngine {
  final _storage = StorageService();

  String getDailyMission() {
    final scores = {
      "Memory": _storage.currentScore.memory,
      "Attention": _storage.currentScore.attention,
      "Language": _storage.currentScore.language,
      "Math": _storage.currentScore.math,
      "Reaction": _storage.currentScore.reaction,
      "Reasoning": _storage.currentScore.problemSolving,
    };

    String weakestArea = "Memory";
    int lowestScore = 100;
    scores.forEach((key, value) {
      if (value < lowestScore) {
        lowestScore = value;
        weakestArea = key;
      }
    });

    return "Your $weakestArea score ($lowestScore) could use a boost! MindMitra recommends playing a $weakestArea activity today.";
  }
}
