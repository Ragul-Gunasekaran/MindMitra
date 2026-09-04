import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../models/cognitive_score.dart';
import '../models/game_result.dart';
import '../models/reminder.dart';
import '../constants/base_url.dart';

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

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('$API_BASE_URL/api/users/${currentUser.id}')).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentUser = User(id: data['id'], name: data['name'], age: data['age']);
      }
      
      final scoreResponse = await http.get(Uri.parse('$API_BASE_URL/api/users/${currentUser.id}/cognitive-score')).timeout(const Duration(seconds: 3));
      if (scoreResponse.statusCode == 200) {
        final scoreData = jsonDecode(scoreResponse.body);
        currentScore = CognitiveScore(
          memory: scoreData['memory'],
          attention: scoreData['attention'],
          language: scoreData['language'],
          math: scoreData['math'],
          reaction: scoreData['reaction'],
          problemSolving: scoreData['problem_solving'],
        );
      }
    } catch (e) {
      print("Unable to connect to server. Showing demo data.");
    }
  }

  Future<void> saveGameResult(GameResult result) async {
    gameResults.insert(0, result);
    try {
      await http.post(
        Uri.parse('$API_BASE_URL/api/results'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'user_id': currentUser.id,
          'game_type': result.type.toString(),
          'score': result.score,
          'accuracy': result.accuracy,
          'response_time': result.responseTime,
          'difficulty': currentDifficulty,
        }),
      ).timeout(const Duration(seconds: 3));
    } catch (e) {
      print("Unable to connect to server. Saved locally.");
    }
  }
}
