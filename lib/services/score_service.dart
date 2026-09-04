import 'storage_service.dart';
import '../models/game_result.dart';

class ScoreService {
  final _storage = StorageService();

  void updateScore(GameResult result) {
    _storage.saveGameResult(result);
    
    int change = result.accuracy >= 80 ? 2 : (result.accuracy < 50 ? -2 : 0);
    
    switch (result.type) {
      case GameType.memory:
        _storage.currentScore.memory += change;
        break;
      case GameType.attention:
        _storage.currentScore.attention += change;
        break;
      case GameType.jigsaw:
        _storage.currentScore.problemSolving += change;
        break;
      case GameType.reaction:
        _storage.currentScore.reaction += change;
        break;
      case GameType.language:
        _storage.currentScore.language += change;
        break;
      case GameType.math:
        _storage.currentScore.math += change;
        break;
      case GameType.recall:
        _storage.currentScore.memory += change;
        break;
    }
  }
}
