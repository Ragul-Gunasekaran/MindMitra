import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class AttentionGameScreen extends StatefulWidget {
  const AttentionGameScreen({Key? key}) : super(key: key);

  @override
  State<AttentionGameScreen> createState() => _AttentionGameScreenState();
}

class _AttentionGameScreenState extends State<AttentionGameScreen> {
  late DateTime _startTime;
  bool _finished = false;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _onShapeSelected(bool isTarget) {
    if (_finished) return;
    _finished = true;

    double timeTaken = DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
    
    GameResult result = GameResult(
      type: GameType.attention,
      score: isTarget ? (100 - timeTaken.toInt()).clamp(10, 100) : 0,
      accuracy: isTarget ? 100.0 : 0.0,
      responseTime: timeTaken,
    );
    
    ScoreService().updateScore(result);
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attention Game", style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Tap the RED circle", textAlign: TextAlign.center, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 60),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShape(Colors.blue, BoxShape.circle, false),
                _buildShape(Colors.red, BoxShape.circle, true),
              ],
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShape(Colors.red, BoxShape.rectangle, false),
                _buildShape(Colors.yellow, BoxShape.rectangle, false, isTriangle: true),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShape(Color color, BoxShape shape, bool isTarget, {bool isTriangle = false}) {
    return GestureDetector(
      onTap: () => _onShapeSelected(isTarget),
      child: Container(
        width: 120,
        height: 120,
        decoration: isTriangle ? null : BoxDecoration(color: color, shape: shape),
        child: isTriangle 
          ? Icon(Icons.change_history, size: 120, color: color) 
          : null,
      ),
    );
  }
}
