import 'dart:async';
import 'storage_service.dart';

class AnalyticsSummary {
  final String period;
  final int activityCount;
  final double averageAccuracy;
  final double routineCompletion;
  final int activeDays;
  final Map<String, double> domains;
  final String moodTrend;

  AnalyticsSummary({
    required this.period,
    required this.activityCount,
    required this.averageAccuracy,
    required this.routineCompletion,
    required this.activeDays,
    required this.domains,
    required this.moodTrend,
  });
}

class ReportSummary {
  final String period;
  final int cognitiveActivities;
  final double averageAccuracy;
  final double routineCompletion;
  final int wellnessActivity;
  final String mood;
  final List<String> insights;

  ReportSummary({
    required this.period,
    required this.cognitiveActivities,
    required this.averageAccuracy,
    required this.routineCompletion,
    required this.wellnessActivity,
    required this.mood,
    required this.insights,
  });
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final _storage = StorageService();

  Future<AnalyticsSummary> getAnalytics(String period) async {
    // Simulate API delay and offline fallback gracefully
    await Future.delayed(const Duration(milliseconds: 300));
    
    return AnalyticsSummary(
      period: period,
      activityCount: period == "7d" ? 18 : 3,
      averageAccuracy: 78.5,
      routineCompletion: 82.0,
      activeDays: period == "7d" ? 6 : 1,
      domains: {
        "Memory": 82.0,
        "Attention": 74.0,
        "Reasoning": 68.0,
        "Language": 79.0,
        "Mathematics": 71.0,
        "Visual/Spatial": 84.0,
        "Reaction": 76.0,
      },
      moodTrend: "Good",
    );
  }

  Future<ReportSummary> getReport(String period) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return ReportSummary(
      period: period,
      cognitiveActivities: period == "Weekly" ? 18 : 3,
      averageAccuracy: 78.0,
      routineCompletion: 82.0,
      wellnessActivity: period == "Weekly" ? 5 : 1,
      mood: "Mostly Good",
      insights: [
        "Activity has increased compared with last week.",
        "Routine consistency is strong this week.",
        "Memory practice is improving."
      ],
    );
  }
}
