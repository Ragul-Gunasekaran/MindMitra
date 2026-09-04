import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class RecallGameScreen extends StatelessWidget {
  const RecallGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memory Recall"), backgroundColor: Colors.purple[300]),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GameResult result = GameResult(type: GameType.recall, score: 75, accuracy: 80.0, responseTime: 5.0);
            ScoreService().updateScore(result);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
          },
          child: const Text("Simulate Win"),
        ),
      ),
    );
  }
}

