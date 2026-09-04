import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';
import 'dart:async';
import 'dart:math';

class ReactionGameScreen extends StatefulWidget {
  const ReactionGameScreen({Key? key}) : super(key: key);

  @override
  State<ReactionGameScreen> createState() => _ReactionGameScreenState();
}

class _ReactionGameScreenState extends State<ReactionGameScreen> {
  DateTime? _showTime;
  bool _targetVisible = false;
  bool _finished = false;
  bool _tooEarly = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }
  
  void _startTimer() {
    int delay = Random().nextInt(3000) + 1500; // 1.5s to 4.5s
    _timer = Timer(Duration(milliseconds: delay), () {
      if (mounted) {
        setState(() {
          _targetVisible = true;
          _showTime = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _onTap() {
    if (_finished) return;
    
    if (!_targetVisible) {
      setState(() {
        _tooEarly = true;
      });
      _timer?.cancel();
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() {
            _tooEarly = false;
          });
          _startTimer();
        }
      });
      return;
    }
    
    _finished = true;
    double timeTaken = DateTime.now().difference(_showTime!).inMilliseconds / 1000.0;
    
    GameResult result = GameResult(
      type: GameType.reaction,
      score: (100 - (timeTaken * 50)).toInt().clamp(10, 100),
      accuracy: 100.0,
      responseTime: timeTaken,
    );
    
    ScoreService().updateScore(result);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reaction Game", style: TextStyle(color: Colors.white)), backgroundColor: Colors.red),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: _onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: _tooEarly ? Colors.red[100] : (_targetVisible ? Colors.green[100] : Colors.white),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_tooEarly) 
                const Text("Too early! Wait for the target.", style: TextStyle(fontSize: 28, color: Colors.red, fontWeight: FontWeight.bold))
              else if (!_targetVisible)
                const Text("Wait for the lightning bolt...", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))
              else
                Column(
                  children: [
                    const Text("TAP NOW!", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.green)),
                    const SizedBox(height: 40),
                    Icon(Icons.bolt, size: 200, color: Colors.yellow[700]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
