import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class WellnessDashboard extends StatelessWidget {
  const WellnessDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Today's Wellness", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 24),
          _buildWellnessCard(Icons.water_drop, "Water", "5 / 8 glasses", 5/8, Colors.blue),
          _buildWellnessCard(Icons.directions_walk, "Walking", "3,200 steps", 3200/5000, AppTheme.successGreen),
          _buildWellnessCard(Icons.bedtime, "Sleep", "7h 20m", 7.3/8, Colors.indigo),
          _buildWellnessCard(Icons.restaurant, "Meals", "2 / 3 meals", 2/3, AppTheme.primaryOrange),
          const SizedBox(height: 32),
          const Text("Mood History", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMoodTrend("Mon", "??"),
                  _buildMoodTrend("Tue", "??"),
                  _buildMoodTrend("Wed", "??"),
                  _buildMoodTrend("Thu", "??"),
                  _buildMoodTrend("Today", "??"),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildWellnessCard(IconData icon, String title, String value, double progress, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, size: 36, color: color),
                const SizedBox(width: 16),
                Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const Spacer(),
                Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: progress,
              minHeight: 12,
              backgroundColor: color.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodTrend(String day, String emoji) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(day, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
      ],
    );
  }
}
