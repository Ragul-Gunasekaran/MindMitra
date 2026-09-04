import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/storage_service.dart';
import '../services/recommendation_engine.dart';

class GamesDashboard extends StatelessWidget {
  const GamesDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final recommendation = RecommendationEngine();
    final score = StorageService().currentScore;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Cognitive Training", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 24),
          Card(
            color: Colors.white,
            side: const BorderSide(color: AppTheme.primaryOrange),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      Text("?? 5 Day Streak", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange)),
                      Text("Current Streak", style: TextStyle(fontSize: 14, color: AppTheme.textLight)),
                    ],
                  ),
                  Column(
                    children: [
                      Text("4 / 5 days", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      Text("Weekly Goal", style: TextStyle(fontSize: 14, color: AppTheme.textLight)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Card(
            color: AppTheme.primaryOrange.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Today's Mission", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                  const SizedBox(height: 12),
                  Text(recommendation.getDailyMission(), style: const TextStyle(fontSize: 18, color: AppTheme.textDark)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Starting today's cognitive mission...")));
                    },
                    child: const Text("START MISSION"),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text("Your Cognitive Skills", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          _buildSkillBar("Memory", score.memory),
          _buildSkillBar("Attention", score.attention),
          _buildSkillBar("Reasoning", score.problemSolving),
          _buildSkillBar("Language", score.language),
          _buildSkillBar("Mathematics", score.math),
          _buildSkillBar("Visual/Spatial", score.problemSolving),
          _buildSkillBar("Reaction", score.reaction),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.assessment, size: 32),
              label: const Text("Take Baseline Assessment"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Starting baseline assessment...")));
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillBar(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Expanded(
            child: LinearProgressIndicator(
              value: value / 100,
              minHeight: 12,
              backgroundColor: Colors.grey.shade300,
              valueColor: const AlwaysStoppedAnimation<Color>(AppTheme.primaryOrange),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(width: 16),
          Text("$value%", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
