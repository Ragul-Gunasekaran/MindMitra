import '../models/user.dart';
import '../models/cognitive_score.dart';
import '../models/game_result.dart';
import '../models/reminder.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  User currentUser = User(id: "1", name: "Anita Devi", age: 68);
  
  CognitiveScore currentScore = CognitiveScore(
    memory: 55,
    attention: 82,
    language: 70,
    math: 65,
    reaction: 76,
    problemSolving: 74,
  );

  List<GameResult> gameResults = [];
  
  List<Reminder> reminders = [
    Reminder(id: "1", title: "Take morning medicine", time: DateTime.now().subtract(const Duration(hours: 1)), category: "Health", completed: true),
    Reminder(id: "2", title: "Call daughter", time: DateTime.now().add(const Duration(minutes: 30)), category: "Family", completed: false),
    Reminder(id: "3", title: "Doctor appointment", time: DateTime.now().add(const Duration(hours: 3)), category: "Medical", completed: false),
    Reminder(id: "4", title: "Evening Walk", time: DateTime.now().add(const Duration(hours: 6)), category: "Activity", completed: false),
  ];

  String currentDifficulty = "Medium";

  void saveGameResult(GameResult result) {
    gameResults.insert(0, result);
  }
}
