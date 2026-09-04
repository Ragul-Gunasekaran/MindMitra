import 'dart:async';
import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({Key? key}) : super(key: key);

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  bool _showingImage = true;
  bool _finished = false;
  late DateTime _startTime;
  
  final List<String> _options = ["Book", "Apple", "Clock", "Chair"];
  final String _correctAnswer = "Book";
  
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showingImage = false;
          _startTime = DateTime.now();
        });
      }
    });
  }

  void _onOptionSelected(String option) {
    if (_finished) return;
    _finished = true;
    
    bool correct = option == _correctAnswer;
    double timeTaken = DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
    
    GameResult result = GameResult(
      type: GameType.memory,
      score: correct ? (100 - timeTaken.toInt()).clamp(10, 100) : 0,
      accuracy: correct ? 100.0 : 0.0,
      responseTime: timeTaken,
    );
    
    ScoreService().updateScore(result);
    
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Memory Game", style: TextStyle(color: Colors.white)), backgroundColor: Colors.purple),
      body: Center(
        child: _showingImage ? _buildMemorizePhase() : _buildQuestionPhase(),
      ),
    );
  }

  Widget _buildMemorizePhase() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Remember this picture", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 40),
        Icon(Icons.menu_book, size: 150, color: Colors.purple),
      ],
    );
  }

  Widget _buildQuestionPhase() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text("What object was in the picture?", textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 40),
          ..._options.map((opt) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onPressed: () => _onOptionSelected(opt),
              child: Text(opt, style: const TextStyle(fontSize: 24)),
            ),
          )).toList(),
        ],
      ),
    );
  }
}
