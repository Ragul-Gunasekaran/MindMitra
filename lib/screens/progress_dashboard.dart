import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class ProgressDashboard extends StatelessWidget {
  const ProgressDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final score = storage.currentScore;
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Progress", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            color: Colors.green[50],
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.trending_up, color: Colors.green, size: 40),
                  SizedBox(width: 16),
                  Text("You are improving!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.green)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildScoreBar("Memory", score.memory, Colors.purple),
          _buildScoreBar("Attention", score.attention, Colors.orange),
          _buildScoreBar("Language", score.language, Colors.teal),
          _buildScoreBar("Mathematics", score.math, Colors.indigo),
          _buildScoreBar("Reaction", score.reaction, Colors.red),
          _buildScoreBar("Problem Solving", score.problemSolving, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildScoreBar(String label, int value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("$value", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / 100,
            minHeight: 12,
            backgroundColor: Colors.grey[300],
            color: color,
          ),
        ],
      ),
    );
  }
}
