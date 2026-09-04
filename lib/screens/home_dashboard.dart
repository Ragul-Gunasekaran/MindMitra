import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../core/theme/app_theme.dart';
import '../core/config/accessibility.dart';
import '../services/storage_service.dart';
import '../services/personalization_service.dart';
import '../services/ai_companion_service.dart';
import '../services/voice_service.dart';
import 'analytics_dashboard.dart';
import 'memory_dashboard.dart';
import 'safety_dashboard.dart';
import 'motivation_dashboard.dart';
import 'routine_dashboard.dart';

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
  final _config = AccessibilityConfig();
  bool _isListening = false;
  late Future<List<RecommendedActivity>> _recsFuture;

  @override
  void initState() {
    super.initState();
    _recsFuture = _personalization.getDailyRecommendations();
    _config.addListener(_onAccessibilityChanged);
  }

  @override
  void dispose() {
    _config.removeListener(_onAccessibilityChanged);
    super.dispose();
  }

  void _onAccessibilityChanged() {
    setState(() {});
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
           if (_config.voiceGuidance) _voice.speak(response);
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
          Semantics(
            header: true,
            child: Text("Good Morning, ${_storage.currentUser.name.split(' ').first} ??", style: AppTheme.lightTheme.textTheme.displayMedium),
          ),
          const SizedBox(height: 16),
          _buildCompanionCard(),
          const SizedBox(height: 24),
          Semantics(header: true, child: const Text("Today's Plan", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark))),
          const SizedBox(height: 16),
          _buildPlanCard(),
          const SizedBox(height: 24),
          if (!_config.simpleMode) ...[
            Semantics(header: true, child: const Text("Recommended For You", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark))),
            const SizedBox(height: 16),
            _buildRecommendations(),
            const SizedBox(height: 24),
            Semantics(header: true, child: const Text("Your Progress", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark))),
            const SizedBox(height: 16),
            _buildProgressCard(),
            const SizedBox(height: 24),
          ],
          Semantics(header: true, child: const Text("Quick Access", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark))),
          const SizedBox(height: 16),
          _buildQuickAccessGrid(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildCompanionCard() {
    return Card(
      color: _config.highContrast ? Colors.white : Colors.blue.withOpacity(0.1),
      child: Semantics(
        label: "Today's Companion: Let's take one small step today.",
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Today's Companion", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
                  if (_config.voiceGuidance)
                    IconButton(
                      icon: const Icon(Icons.volume_up, color: Colors.blue),
                      tooltip: "Read Aloud",
                      onPressed: () => _voice.speak("Good Morning, ${_storage.currentUser.name.split(' ').first}. Let's take one small step today."),
                    )
                ],
              ),
              const SizedBox(height: 8),
              const Text("Let's take one small step today.", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPlanItem(Icons.psychology, "Memory Match", "5 min", Colors.blue, "Memory activity"),
            _buildPlanItem(Icons.ads_click, "Focus Tap", "3 min", AppTheme.primaryOrange, "Attention activity"),
            _buildPlanItem(Icons.directions_walk, "Wellness", "10 min", AppTheme.successGreen, "Wellness activity"),
            _buildPlanItem(Icons.calendar_month, "Evening Routine", "7:00 PM", Colors.purple, "Routine reminder"),
          ],
        ),
      ),
    );
  }

  Widget _buildPlanItem(IconData icon, String title, String subtitle, Color color, String semanticLabel) {
    return Semantics(
      label: "$semanticLabel: $title for $subtitle",
      button: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Wrap(
          children: [
            Icon(icon, color: _config.highContrast ? Colors.black : color, size: 36),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
            Text(subtitle, style: const TextStyle(fontSize: 18, color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return FutureBuilder<List<RecommendedActivity>>(
      future: _recsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(
            children: snapshot.data!.map((rec) => Semantics(
              label: "Recommended Activity: ${rec.title}. Reason: ${rec.reason}",
              button: true,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: Icon(Icons.star, color: _config.highContrast ? Colors.black : AppTheme.primaryOrange, size: 36),
                    title: Text(rec.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text("Why this? ${rec.reason}", style: const TextStyle(fontSize: 16)),
                    trailing: ElevatedButton(
                      onPressed: (){}, 
                      style: ElevatedButton.styleFrom(minimumSize: const Size(80, 48)),
                      child: const Text("Start")
                    ),
                  ),
                ),
              ),
            )).toList(),
          );
        }
        return const Center(child: Text("Loading your plan...", style: TextStyle(fontSize: 18)));
      },
    );
  }

  Widget _buildProgressCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          alignment: WrapAlignment.spaceAround, runSpacing: 16, spacing: 16,
          children: [
            _buildProgressStat("??", "5 Day", "Streak"),
            _buildProgressStat("?", "82%", "Routine"),
            _buildProgressStat("??", "6", "Active Days"),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressStat(String emoji, String value, String label) {
    return Semantics(
      label: "$label: $value",
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _config.highContrast ? Colors.black : AppTheme.primaryOrange)),
          Text(label, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
        ],
      ),
    );
  }

  Widget _buildQuickAccessGrid() {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        if (_config.simpleMode) ...[
          _buildQuickActionButton(Icons.play_circle, "Play Activity", () {}),
          _buildQuickActionButton(Icons.alarm, "My Reminders", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoutineDashboard()))),
          _buildQuickActionButton(Icons.mic, "Ask MindMitra", _handleAskMindMitra),
          _buildQuickActionButton(Icons.family_restroom, "Call Family", () {}),
          _buildQuickActionButton(Icons.security, "Emergency / SOS", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyDashboard())), color: AppTheme.alertRed),
        ] else ...[
          _buildQuickActionButton(Icons.mic, "Ask MindMitra", _handleAskMindMitra),
          _buildQuickActionButton(Icons.bar_chart, "My Progress", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AnalyticsDashboard()))),
          _buildQuickActionButton(Icons.favorite, "My Memories", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MemoryDashboard()))),
          _buildQuickActionButton(Icons.security, "Safety / SOS", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SafetyDashboard())), color: AppTheme.alertRed),
        ]
      ],
    );
  }

  Widget _buildQuickActionButton(IconData icon, String label, VoidCallback onTap, {Color? color}) {
    return Semantics(
      button: true,
      label: label,
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 28),
        label: Text(label, style: const TextStyle(fontSize: 18)),
        style: ElevatedButton.styleFrom(
          backgroundColor: _config.highContrast ? Colors.black : Colors.white,
          foregroundColor: _config.highContrast ? Colors.white : (color ?? AppTheme.textDark),
          minimumSize: const Size(160, 60), // Large Touch Target
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          side: BorderSide(color: color ?? Colors.grey.shade400, width: 2),
        ),
        onPressed: onTap,
      ),
    );
  }
}
