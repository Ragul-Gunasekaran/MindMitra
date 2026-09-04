enum GameType { memory, attention, jigsaw, reaction, language, math, recall }

class GameResult {
  final GameType type;
  final int score;
  final double accuracy; // percentage 0-100
  final double responseTime; // seconds
  final DateTime date;

  GameResult({
    required this.type,
    required this.score,
    required this.accuracy,
    required this.responseTime,
    DateTime? date,
  }) : this.date = date ?? DateTime.now();
}
