import 'storage_service.dart';

class AICompanionService {
  static final AICompanionService _instance = AICompanionService._internal();
  factory AICompanionService() => _instance;
  AICompanionService._internal();

  final _storage = StorageService();

  String generateDailyInsight() {
    final score = _storage.currentScore;
    
    String insight = "You completed most of your morning routine. Great job! ";
    
    if (score.attention > 80) {
      insight += "You performed very well in attention tasks today. ";
    } else {
      insight += "Memory activities may be useful for today's session. ";
    }

    insight += "\n\nNote: MindMitra provides wellness recommendations, not medical diagnoses. Please consult a doctor for medical advice.";
    
    return insight;
  }
}
