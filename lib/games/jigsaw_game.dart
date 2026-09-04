import 'package:flutter/material.dart';
import '../models/game_result.dart';
import '../services/score_service.dart';
import '../screens/result/game_result_screen.dart';

class JigsawGameScreen extends StatefulWidget {
  const JigsawGameScreen({Key? key}) : super(key: key);

  @override
  State<JigsawGameScreen> createState() => _JigsawGameScreenState();
}

class _JigsawGameScreenState extends State<JigsawGameScreen> {
  late DateTime _startTime;
  bool _finished = false;
  int _moves = 0;
  
  List<Color> _pieces = [Colors.green, Colors.red, Colors.yellow, Colors.blue];
  List<Color> _target = [Colors.red, Colors.blue, Colors.green, Colors.yellow];
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  void _onTap(int index) {
    if (_finished) return;
    
    setState(() {
      if (_selectedIndex == null) {
        _selectedIndex = index;
      } else {
        // Swap
        Color temp = _pieces[_selectedIndex!];
        _pieces[_selectedIndex!] = _pieces[index];
        _pieces[index] = temp;
        _selectedIndex = null;
        _moves++;
        _checkWin();
      }
    });
  }
  
  void _checkWin() {
    bool win = true;
    for(int i=0; i<4; i++) {
      if (_pieces[i] != _target[i]) win = false;
    }
    
    if (win) {
      _finished = true;
      double timeTaken = DateTime.now().difference(_startTime).inMilliseconds / 1000.0;
      
      GameResult result = GameResult(
        type: GameType.jigsaw,
        score: (100 - (timeTaken + _moves * 2)).toInt().clamp(10, 100),
        accuracy: 100.0,
        responseTime: timeTaken,
      );
      
      ScoreService().updateScore(result);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => GameResultScreen(result: result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Puzzle Game", style: TextStyle(color: Colors.white)), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Match the pattern by tapping two blocks to swap them.", textAlign: TextAlign.center, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _miniTarget(_target[0]), _miniTarget(_target[1]),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _miniTarget(_target[2]), _miniTarget(_target[3]),
              ]
            ),
            const SizedBox(height: 40),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
              itemCount: 4,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _onTap(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _pieces[index],
                      border: _selectedIndex == index ? Border.all(color: Colors.black, width: 4) : null,
                    ),
                  ),
                );
              }
            ),
            const SizedBox(height: 20),
            Text("Moves: $_moves", style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
  
  Widget _miniTarget(Color c) {
    return Container(width: 40, height: 40, color: c, margin: const EdgeInsets.all(2));
  }
}
