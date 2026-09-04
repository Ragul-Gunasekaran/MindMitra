import 'storage_service.dart';
import '../models/game_result.dart';

class RecommendationEngine {
  final _storage = StorageService();

  GameType getRecommendedGame() {
    var score = _storage.currentScore;
    Map<GameType, int> scores = {
      GameType.memory: score.memory,
      GameType.attention: score.attention,
      GameType.language: score.language,
      GameType.math: score.math,
      GameType.reaction: score.reaction,
      GameType.jigsaw: score.problemSolving,
    };
    
    var lowest = scores.entries.reduce((a, b) => a.value < b.value ? a : b);
    return lowest.key;
  }
  
  String getRecommendationTitle() {
    GameType type = getRecommendedGame();
    switch (type) {
      case GameType.memory: return "Memory Game";
      case GameType.attention: return "Attention Game";
      case GameType.language: return "Language Game";
      case GameType.math: return "Math Game";
      case GameType.reaction: return "Reaction Game";
      case GameType.jigsaw: return "Jigsaw Puzzle";
      case GameType.recall: return "Memory Recall";
    }
  }
}
