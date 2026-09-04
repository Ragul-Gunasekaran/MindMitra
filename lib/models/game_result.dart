enum GameType { memory, attention, jigsaw, reaction, language, math, recall, reasoning, spatial }

extension GameTypeExtension on GameType {
  String get domain {
    switch (this) {
      case GameType.memory:
      case GameType.recall:
        return "Memory";
      case GameType.attention:
        return "Attention";
      case GameType.jigsaw:
      case GameType.spatial:
        return "Visual/Spatial";
      case GameType.reaction:
        return "Reaction";
      case GameType.language:
        return "Language";
      case GameType.math:
        return "Mathematics";
      case GameType.reasoning:
        return "Reasoning";
      default:
        return "General";
    }
  }
}

class GameResult {
  final GameType type;
  final int score;
  final double accuracy; // percentage 0-100
  final double responseTime; // seconds
  final DateTime date;
  final String difficulty;

  GameResult({
    required this.type,
    required this.score,
    required this.accuracy,
    required this.responseTime,
    this.difficulty = "Medium",
    DateTime? date,
  }) : this.date = date ?? DateTime.now();
}
