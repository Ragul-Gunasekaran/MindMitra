import 'storage_service.dart';

class AdaptiveEngine {
  final _storage = StorageService();

  String evaluatePerformance(double accuracy) {
    if (accuracy >= 80) {
      if (_storage.currentDifficulty == "Easy") {
        _storage.currentDifficulty = "Medium";
        return "Difficulty increased to Medium based on your excellent performance.";
      } else if (_storage.currentDifficulty == "Medium") {
        _storage.currentDifficulty = "Hard";
        return "Difficulty increased to Hard based on your excellent performance.";
      }
    } else if (accuracy < 50) {
      if (_storage.currentDifficulty == "Hard") {
        _storage.currentDifficulty = "Medium";
        return "Difficulty adjusted to Medium for better practice.";
      } else if (_storage.currentDifficulty == "Medium") {
        _storage.currentDifficulty = "Easy";
        return "Difficulty adjusted to Easy for better practice.";
      }
    }
    return "Difficulty maintained based on your performance.";
  }
}
