import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class LanguageGameScreen extends StatelessWidget {
  const LanguageGameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Language Game"), backgroundColor: Colors.teal),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GameResult result = GameResult(type: GameType.language, score: 85, accuracy: 100.0, responseTime: 2.5);
            ScoreService().updateScore(result);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
          },
          child: const Text("Simulate Win"),
        ),
      ),
    );
  }
}

