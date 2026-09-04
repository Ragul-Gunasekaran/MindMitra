import 'package:flutter/material.dart';
import '../../models/game_result.dart';
import '../../services/adaptive_engine.dart';
import '../../services/storage_service.dart';

class GameResultScreen extends StatelessWidget {
  final GameResult result;
  
  const GameResultScreen({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final engine = AdaptiveEngine();
    final storage = StorageService();
    String aiMessage = engine.evaluatePerformance(result.accuracy);
    
    return Scaffold(
      appBar: AppBar(title: const Text("Your Result", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text("Great job!", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 24),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    _resultRow("Score", "${result.score}"),
                    const Divider(),
                    _resultRow("Accuracy", "${result.accuracy.toStringAsFixed(0)}%"),
                    const Divider(),
                    _resultRow("Response Time", "${result.responseTime.toStringAsFixed(1)} sec"),
                    const Divider(),
                    _resultRow("Difficulty", storage.currentDifficulty),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.blue[50],
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: const BorderSide(color: Colors.blue, width: 2)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.auto_awesome, color: Colors.blue),
                        SizedBox(width: 8),
                        Text("AI Adaptive Cognitive Engine", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(aiMessage, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), backgroundColor: Colors.orange, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.of(context).pop();
                // We should ideally pop back to Home or Game, but pop is simplest for MVP
              },
              child: const Text("Next Game", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text("Home", style: TextStyle(fontSize: 20)),
            )
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 20)),
          Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
