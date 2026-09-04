import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class MathGameScreen extends StatelessWidget {
  const MathGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Math Game"), backgroundColor: Colors.indigo),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GameResult result = GameResult(type: GameType.math, score: 90, accuracy: 100.0, responseTime: 1.5);
            ScoreService().updateScore(result);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
          },
          child: const Text("Simulate Win"),
        ),
      ),
    );
  }
}

