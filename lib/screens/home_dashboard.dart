import 'package:flutter/material.dart';
import 'motivation_dashboard.dart';
import 'analytics_dashboard.dart';
import 'reports_dashboard.dart';
import '../services/storage_service.dart';
import '../services/voice_service.dart';
import '../services/recommendation_engine.dart';
import '../services/ai_companion_service.dart';
import '../core/theme/app_theme.dart';
import '../core/config/localization.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _storage = StorageService();
  final _recommendation = RecommendationEngine();
  final _ai = AICompanionService();
  final _voice = VoiceService();
  bool _isListening = false;
  String _selectedMood = "";

  void _recordMood(String mood) {
    setState(() {
      _selectedMood = mood;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Mood recorded: $mood", style: const TextStyle(fontSize: 20))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(AppLocalization().translate("good_morning") + "," ${_storage.currentUser.name.split(' ').first} ??", style: AppTheme.lightTheme.textTheme.displayMedium),
              IconButton(
                icon: const Icon(Icons.sos, color: AppTheme.alertRed, size: 48),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency SOS Activated! Notifying family...")));
                },
              )
            ],
          ),
          const SizedBox(height: 24),
          Card(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(AppLocalization().translate("todays_plan"), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  const SizedBox(height: 12),
                  _buildRoutineItem(Icons.check_circle, "Morning Medicine", "Completed at 8:00 AM", AppTheme.successGreen),
                  _buildRoutineItem(Icons.check_circle, "Breakfast", "Completed at 8:30 AM", AppTheme.successGreen),
                  _buildRoutineItem(Icons.psychology, "Brain Activity", _recommendation.getDailyMission(), AppTheme.primaryOrange, action: "START"),
                  _buildRoutineItem(Icons.directions_walk, "Walking Goal", "30 minutes today", Colors.blue, action: "START"),
                  _buildRoutineItem(Icons.phone, "Family Call", "Daughter - 5:00 PM", Colors.purple),
                  _buildRoutineItem(Icons.medication, "Evening Medicine", "7:00 PM", AppTheme.alertRed),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(AppLocalization().translate("how_are_you_feeling"), style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildMoodEmoji("??", "Very Good"),
              _buildMoodEmoji("??", "Good"),
              _buildMoodEmoji("??", "Okay"),
              _buildMoodEmoji("??", "Low"),
              _buildMoodEmoji("??", "Very Low"),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.mic, size: 32),
              label: const Text(AppLocalization().translate("ask_mindmitra")),
              onPressed: () {
                
                if (_isListening) {
                  _voice.stopListening();
                  setState(() => _isListening = false);
                } else {
                  _voice.speak("I am listening. How can I help?");
                  setState(() => _isListening = true);
                  _voice.startListening((text) {
                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Heard: $text")));
                  }).then((available) {
                     if (!available) {
                       setState(() => _isListening = false);
                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Microphone not available on this device.")));
                     }
                  });
                }

              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: AppTheme.textDark)),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }

  Widget _buildRoutineItem(IconData icon, String title, String subtitle, Color color, {String? action}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 36),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                Text(subtitle, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
              ],
            ),
          ),
          if (action != null)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              onPressed: () {},
              child: Text(action, style: const TextStyle(fontSize: 16)),
            ),
        ],
      ),
    );
  }

  Widget _buildMoodEmoji(String emoji, String label) {
    final isSelected = _selectedMood == label;
    return GestureDetector(
      onTap: () => _recordMood(label),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 48, color: isSelected ? Colors.black : Colors.grey)),
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
