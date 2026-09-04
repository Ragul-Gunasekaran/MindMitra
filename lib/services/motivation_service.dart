import 'dart:async';
import 'storage_service.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final String category;
  final bool isUnlocked;
  final int progress;
  final int total;
  final String iconEmoji;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.isUnlocked,
    required this.progress,
    required this.total,
    required this.iconEmoji,
  });
}

class MotivationService {
  static final MotivationService _instance = MotivationService._internal();
  factory MotivationService() => _instance;
  MotivationService._internal();

  final _storage = StorageService();

  Future<List<Achievement>> getAchievements() async {
    // Simulate derived state from storage/analytics
    await Future.delayed(const Duration(milliseconds: 200));
    
    return [
      Achievement(id: "1", title: "First Step", description: "Complete your first cognitive activity.", category: "Cognitive", isUnlocked: true, progress: 1, total: 1, iconEmoji: "??"),
      Achievement(id: "2", title: "Memory Keeper", description: "Add 5 personal memories.", category: "Memory", isUnlocked: false, progress: 2, total: 5, iconEmoji: "??"),
      Achievement(id: "3", title: "Consistent Week", description: "Be active on 5 days in one week.", category: "Consistency", isUnlocked: true, progress: 5, total: 5, iconEmoji: "??"),
      Achievement(id: "4", title: "Curious Mind", description: "Practice 5 different cognitive domains.", category: "Exploration", isUnlocked: false, progress: 4, total: 5, iconEmoji: "??"),
    ];
  }

  Future<Map<String, int>> getStreaks() async {
    // Derived from historical activity
    await Future.delayed(const Duration(milliseconds: 100));
    return {
      "Cognitive": 5,
      "Routine": 4,
      "Wellness": 3,
      "Best": 7, // Personal Record
    };
  }

  String getDailyEncouragement(int currentStreak) {
    if (currentStreak >= 7) {
      return "You've stayed active for $currentStreak days. Wonderful consistency!";
    } else if (currentStreak > 1) {
      return "You're building a strong routine today. Every small step counts.";
    } else {
      return "Whenever you're ready, a short activity is waiting for you.";
    }
  }

  String getVoiceResponse(String query) {
    query = query.toLowerCase();
    if (query.contains("how am i doing") || query.contains("progress")) {
      return "You've been active for five days this week and completed twelve cognitive activities. You are doing wonderfully.";
    } else if (query.contains("mission") || query.contains("today")) {
      return "Today, try two cognitive activities and complete your evening routine.";
    }
    return "I am here to support you. Let me know if you want to play a game or check your routine.";
  }
}
