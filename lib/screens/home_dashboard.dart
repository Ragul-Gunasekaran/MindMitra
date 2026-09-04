import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/config/localization.dart';
import '../services/storage_service.dart';
import '../services/personalization_service.dart';
import '../services/ai_companion_service.dart';
import '../services/voice_service.dart';
import 'analytics_dashboard.dart';
import 'memory_dashboard.dart';
import 'safety_dashboard.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);
  @override
  _HomeDashboardState createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _storage = StorageService();
  final _personalization = PersonalizationService();
  final _ai = AICompanionService();
  final _voice = VoiceService();
  bool _isListening = false;
  late Future<List<RecommendedActivity>> _recsFuture;

  @override
  void initState() {
    super.initState();
    _recsFuture = _personalization.getDailyRecommendations();
  }

  void _handleAskMindMitra() {
    if (_isListening) {
      _voice.stopListening();
      setState(() => _isListening = false);
    } else {
      _voice.speak("I am listening. How can I help?");
      setState(() => _isListening = true);
      _voice.startListening((text) async {
        if (text.isNotEmpty) {
           final response = await _ai.processIntent(text);
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Heard: $text\nMindMitra: $response"), duration: const Duration(seconds: 4)));
           _voice.speak(response);
           setState(() => _isListening = false);
        }
      }).then((available) {
        if (!available) {
          setState(() => _isListening = false);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voice isn't available on this device. You can type your question instead.")));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Good Morning, ${_storage.currentUser.name.split(' ').first} ??", style: AppTheme.lightTheme.textTheme.displayMedium),
          const SizedBox(height: 16),
          Card(
            color: Colors.blue.withOpacity(0.1),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today's Companion", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  SizedBox(height: 8),
                  Text("Let's take one small step today.", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Today's Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildPlanItem(Icons.psychology, "Memory Match", "5 min", Colors.blue),
                  _buildPlanItem(Icons.ads_click, "Focus Tap", "3 min", AppTheme.primaryOrange),
                  _buildPlanItem(Icons.directions_walk, "Wellness", "10 min", AppTheme.successGreen),
                  _buildPlanItem(Icons.calendar_month, "Evening Routine", "7:00 PM", Colors.purple),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Recommended For You", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          FutureBuilder<List<RecommendedActivity>>(
            future: _recsFuture,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Column(
                  children: snapshot.data!.map((rec) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.star, color: AppTheme.primaryOrange),
                      title: Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("Why this? ${rec.reason}"),
                      trailing: ElevatedButton(onPressed: (){}, child: const Text("Start")),
                    ),
                  )).toList(),
                );
              }
              return const CircularProgressIndicator();
            },
          ),
          const SizedBox(height: 24),
          const Text("Your Progress", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildProgressStat("??", "5 Day", "Streak"),
                  _buildProgressStat("?", "82%", "Routine"),
                  _buildProgressStat("??", "6", "Active Days"),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Quick Access", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildQuickActionButton(Icons.mic, "Ask MindMitra", _handleAskMindMitra),
              _buildQuickActionButton(Icons.bar_chart, "My Progress", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsDashboard()))),
              _buildQuickActionButton(Icons.favorite, "My Memories", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryDashboard()))),
              _buildQuickActionButton(Icons.security, "Safety", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyDashboard()))),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildPlanItem(IconData icon, String title, String subtitle, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Text(subtitle, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String emoji, String value, String label) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange)),
        Text(label, style: const TextStyle(fontSize: 14, color: AppTheme.textLight)),
      ],
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap) {
    return ElevatedButton.icon(
      icon: Icon(icon),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textDark,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      onPressed: onTap,
    );
  }
}
