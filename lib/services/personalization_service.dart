import 'dart:async';
import 'storage_service.dart';
import 'analytics_service.dart';

class UserContext {
  final int ageGroup;
  final String preferredLanguage;
  final Map<String, double> domainActivity;
  final double averageAccuracy;
  final int streak;
  final double routineCompletion;
  final String moodTrend;
  final bool hasSufficientData;

  UserContext({
    required this.ageGroup,
    required this.preferredLanguage,
    required this.domainActivity,
    required this.averageAccuracy,
    required this.streak,
    required this.routineCompletion,
    required this.moodTrend,
    required this.hasSufficientData,
  });
}

class RecommendedActivity {
  final String title;
  final String duration;
  final String reason;
  final String domain;

  RecommendedActivity(this.title, this.duration, this.reason, this.domain);
}

class PersonalizationService {
  static final PersonalizationService _instance = PersonalizationService._internal();
  factory PersonalizationService() => _instance;
  PersonalizationService._internal();

  final _analytics = AnalyticsService();
  final _storage = StorageService();

  Future<UserContext> buildContext() async {
    final summary = await _analytics.getAnalytics("7d");
    final hasData = summary.activityCount > 2;

    return UserContext(
      ageGroup: _storage.currentUser.age > 70 ? 70 : 60,
      preferredLanguage: "en",
      domainActivity: summary.domains,
      averageAccuracy: summary.averageAccuracy,
      streak: summary.activeDays,
      routineCompletion: summary.routineCompletion,
      moodTrend: summary.moodTrend,
      hasSufficientData: hasData,
    );
  }

  Future<List<RecommendedActivity>> getDailyRecommendations() async {
    final context = await buildContext();
    if (!context.hasSufficientData) {
      return [
        RecommendedActivity("Memory Match", "5 min", "I'm still learning your preferences. Try this to get started.", "Memory"),
        RecommendedActivity("Focus Tap", "3 min", "A great introductory activity.", "Attention"),
      ];
    }

    List<RecommendedActivity> recs = [];
    
    // Find lowest domain
    String lowestDomain = "Memory";
    double lowestScore = 100.0;
    context.domainActivity.forEach((key, value) {
      if (value < lowestScore && value > 0) {
        lowestScore = value;
        lowestDomain = key;
      }
    });

    if (lowestDomain == "Memory") {
      recs.add(RecommendedActivity("Memory Match", "5 min", "You haven't practiced Memory recently.", "Memory"));
    } else if (lowestDomain == "Attention") {
      recs.add(RecommendedActivity("Focus Tap", "3 min", "Your Attention score could use a gentle boost.", "Attention"));
    } else {
      recs.add(RecommendedActivity("Logic Puzzle", "5 min", "Let's practice $lowestDomain today.", lowestDomain));
    }

    recs.add(RecommendedActivity("Visual Puzzle", "5 min", "A short activity to vary today's session.", "Visual/Spatial"));
    
    return recs;
  }
}
