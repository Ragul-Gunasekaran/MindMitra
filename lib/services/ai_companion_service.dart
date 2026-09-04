import 'dart:async';
import 'personalization_service.dart';

class AICompanionService {
  static final AICompanionService _instance = AICompanionService._internal();
  factory AICompanionService() => _instance;
  AICompanionService._internal();

  final _personalization = PersonalizationService();

  Future<String> processIntent(String input) async {
    final query = input.toLowerCase();
    
    // Safety & Medical Intents
    if (query.contains("dementia") || query.contains("disease") || query.contains("alzheimer") || query.contains("diagnosis") || query.contains("doctor")) {
      return "I can't diagnose medical conditions. MindMitra can help you track your activities and personal trends. If you're concerned about your health, consider speaking with a qualified healthcare professional.";
    }
    if (query.contains("emergency") || query.contains("help") || query.contains("fall") || query.contains("fell")) {
      return "If you're in immediate danger, please use the Emergency/SOS button on the Safety Dashboard or contact your emergency contact immediately.";
    }

    // Natural Language Queries
    if (query.contains("how am i doing") || query.contains("progress")) {
      final context = await _personalization.buildContext();
      if (!context.hasSufficientData) return "I don't have enough recent activity data to summarize your progress yet. Keep playing!";
      return "You've been active for ${context.streak} days this week with ${context.routineCompletion.toStringAsFixed(0)}% routine completion. Great consistency!";
    }
    
    if (query.contains("what should i do") || query.contains("recommend") || query.contains("activity")) {
      final recs = await _personalization.getDailyRecommendations();
      return "Let''s try ${recs.first.title} today. ${recs.first.reason}";
    }

    if (query.contains("routine") || query.contains("reminders")) {
      return "You have an evening routine coming up later today. Would you like to review it?";
    }

    if (query.contains("memory") || query.contains("saved")) {
      return "You saved a memory about your family picnic. Would you like to revisit it or add another detail?";
    }

    return "I am your MindMitra companion. I can suggest activities, check your routine, or review your progress. What would you like to do?";
  }

  Future<String> generateDailyInsight() async {
    final context = await _personalization.buildContext();
    if (!context.hasSufficientData) {
      return "I'm still learning your preferences. Try a few activities so I can make better suggestions.\n\nNote: MindMitra provides wellness recommendations, not medical diagnoses.";
    }
    
    String insight = "You completed most of your morning routine. ";
    if (context.moodTrend == "Good") {
      insight += "You've logged mostly positive moods this week. ";
    }
    
    insight += "\n\nNote: MindMitra provides wellness recommendations, not medical diagnoses.";
    return insight;
  }
}
