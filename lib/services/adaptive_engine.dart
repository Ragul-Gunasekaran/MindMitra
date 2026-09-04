import 'storage_service.dart';
import 'dart:math';

class AdaptiveEngine {
  final _storage = StorageService();

  String evaluatePerformance(double accuracy, double completionTimeSecs) {
    String feedback = "";
    if (accuracy >= 80) {
      if (_storage.currentDifficulty == "Easy") {
        _storage.currentDifficulty = "Medium";
        feedback = "Great job! We've increased the difficulty to Medium to keep your mind sharp.";
      } else if (_storage.currentDifficulty == "Medium") {
        _storage.currentDifficulty = "Hard";
        feedback = "Excellent! You're ready for Hard mode.";
      } else if (_storage.currentDifficulty == "Hard") {
        _storage.currentDifficulty = "Expert";
        feedback = "Outstanding! You've reached Expert level.";
      } else {
        feedback = "Perfect score! You are mastering Expert level.";
      }
    } else if (accuracy >= 50 && accuracy < 80) {
      feedback = "Good effort! Let's practice more at this level to build confidence.";
    } else {
      if (_storage.currentDifficulty == "Expert") {
        _storage.currentDifficulty = "Hard";
        feedback = "Let's step back to Hard mode for a bit of practice.";
      } else if (_storage.currentDifficulty == "Hard") {
        _storage.currentDifficulty = "Medium";
        feedback = "Let's step back to Medium mode to build your confidence.";
      } else if (_storage.currentDifficulty == "Medium") {
        _storage.currentDifficulty = "Easy";
        feedback = "We've adjusted to Easy mode so you can take your time.";
      } else {
        feedback = "Keep trying! Practice makes perfect.";
      }
    }
    return feedback;
  }
}
