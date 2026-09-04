import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_service.dart' as import_auth;
import '../models/user.dart';
import '../models/cognitive_score.dart';
import '../models/game_result.dart';
import '../models/reminder.dart';
import '../constants/base_url.dart';
import 'sync_manager.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  User currentUser = User(id: "1", name: "Anita Devi", age: 68, role: "ELDERLY");
  void setCurrentUser(User user) {
    currentUser = user;
    init(); // reload data for this user
  }

  Future<void> clearUserData() async {
    gameResults.clear();
    reminders.clear();
    // In a real app, clear shared_preferences for this user too
  }
  
  CognitiveScore currentScore = CognitiveScore(
    memory: 55,
    attention: 82,
    language: 70,
    math: 65,
    reaction: 76,
    problemSolving: 74,
  );

  List<GameResult> gameResults = [];
  List<Reminder> reminders = [];
  String currentDifficulty = "Medium";

  final _syncManager = SyncManager();

  Future<void> init() async {
    await _loadLocalDefaults();
    await fetchUserData(); // Async background fetch
  }

  Future<void> _loadLocalDefaults() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Load Reminders
      final rStr = prefs.getString('local_reminders');
      if (rStr != null) {
        // Simple decode for demo structure
      } else {
        reminders = [
          Reminder(id: "1", title: "Take morning medicine", time: DateTime.now().subtract(const Duration(hours: 1)), category: "Health", completed: true),
          Reminder(id: "2", title: "Call daughter", time: DateTime.now().add(const Duration(minutes: 30)), category: "Family", completed: false),
        ];
      }
    } catch (_) {}
  }

  Future<void> fetchUserData() async {
    try {
      final response = await http.get(Uri.parse('$API_BASE_URL/api/users/${currentUser.id}'), headers: {'Authorization': 'Bearer ${import_auth.AuthService().accessToken}'}).timeout(const Duration(seconds: 3));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        currentUser = User.fromJson(data);
      }
      
      final scoreResponse = await http.get(Uri.parse('$API_BASE_URL/api/users/${currentUser.id}/cognitive-score'), headers: {'Authorization': 'Bearer ${import_auth.AuthService().accessToken}'}).timeout(const Duration(seconds: 3));
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
      print("Offline: Falling back to local cache.");
    }
  }

  Future<void> saveGameResult(GameResult result) async {
    gameResults.insert(0, result); // Local write immediately
    
    // Add to pending sync queue
    await _syncManager.queueOperation('GameResult', 'CREATE', {
      'user_id': currentUser.id,
      'game_type': result.type.toString(),
      'score': result.score,
      'accuracy': result.accuracy,
      'response_time': result.responseTime,
      'difficulty': currentDifficulty,
    });
  }

  Future<void> saveMemory(String title, String description) async {
    // Add memory to local state
    // Sync later
    await _syncManager.queueOperation('Memory', 'CREATE', {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'description': description,
    });
  }

  Future<void> saveReminder(Reminder rem) async {
    reminders.add(rem);
    await _syncManager.queueOperation('Reminder', 'CREATE', {
      'id': rem.id,
      'title': rem.title,
      'completed': rem.completed,
    });
  }
}
