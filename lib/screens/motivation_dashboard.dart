import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/motivation_service.dart';

class MotivationDashboard extends StatefulWidget {
  const MotivationDashboard({Key? key}) : super(key: key);
  @override
  _MotivationDashboardState createState() => _MotivationDashboardState();
}

class _MotivationDashboardState extends State<MotivationDashboard> {
  final _service = MotivationService();
  late Future<List<Achievement>> _achievementsFuture;
  late Future<Map<String, int>> _streaksFuture;

  @override
  void initState() {
    super.initState();
    _achievementsFuture = _service.getAchievements();
    _streaksFuture = _service.getStreaks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Motivation & Achievements")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Your Streaks", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            FutureBuilder<Map<String, int>>(
              future: _streaksFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStreakCard("??", "Cognitive", snapshot.data!['Cognitive']!),
                      _buildStreakCard("??", "Routine", snapshot.data!['Routine']!),
                      _buildStreakCard("??", "Wellness", snapshot.data!['Wellness']!),
                    ],
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
            const SizedBox(height: 12),
            const Center(child: Text("Every new day is a fresh start.", style: TextStyle(fontStyle: FontStyle.italic, color: AppTheme.textLight))),
            const SizedBox(height: 32),
            const Text("Personal Records", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.emoji_events, color: AppTheme.primaryOrange, size: 36),
                title: const Text("Longest Cognitive Streak", style: TextStyle(fontSize: 18)),
                trailing: FutureBuilder<Map<String, int>>(
                  future: _streaksFuture,
                  builder: (context, snapshot) => Text("${snapshot.data?['Best'] ?? 0} days", style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text("Achievements", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 16),
            FutureBuilder<List<Achievement>>(
              future: _achievementsFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.map((ach) => _buildAchievementCard(ach)).toList(),
                  );
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStreakCard(String emoji, String label, int days) {
    return Card(
      elevation: 2,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: 100,
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 32)),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text("$days days", style: const TextStyle(fontSize: 14, color: AppTheme.primaryOrange, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementCard(Achievement ach) {
    return Card(
      color: ach.isUnlocked ? Colors.white : Colors.grey.shade100,
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Text(ach.isUnlocked ? ach.iconEmoji : "??", style: const TextStyle(fontSize: 36)),
        title: Text(ach.title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: ach.isUnlocked ? AppTheme.textDark : Colors.grey)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ach.description, style: TextStyle(fontSize: 16, color: ach.isUnlocked ? AppTheme.textLight : Colors.grey)),
            if (!ach.isUnlocked) ...[
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: ach.progress / ach.total,
                backgroundColor: Colors.grey.shade300,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
              const SizedBox(height: 4),
              Text("Progress: ${ach.progress} / ${ach.total}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ]
          ],
        ),
        trailing: ach.isUnlocked ? const Icon(Icons.check_circle, color: AppTheme.successGreen, size: 32) : null,
      ),
    );
  }
}
