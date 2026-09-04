import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../services/recommendation_engine.dart';
import '../games/memory_game.dart';
import '../games/attention_game.dart';
import '../games/jigsaw_game.dart';
import '../games/reaction_game.dart';
import '../games/language_game.dart';
import '../games/math_game.dart';
import '../models/game_result.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({Key? key}) : super(key: key);

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final _storage = StorageService();
  final _recommender = RecommendationEngine();

  void _startGame(Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Good Morning, ${_storage.currentUser.name}",
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Ready for today's brain training?",
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const SizedBox(height: 24),
          _buildGoalCard(),
          const SizedBox(height: 16),
          _buildRecommendationCard(),
          const SizedBox(height: 16),
          _buildScoreCard(),
          const SizedBox(height: 24),
          const Text(
            "Quick Games",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildQuickGamesGrid(),
        ],
      ),
    );
  }

  Widget _buildGoalCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Today's Goal", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Complete 3 cognitive activities.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: 2 / 3, minHeight: 12, backgroundColor: Colors.grey[300]),
            const SizedBox(height: 8),
            const Text("Progress: 2 / 3 completed", style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationCard() {
    String recTitle = _recommender.getRecommendationTitle();
    GameType recType = _recommender.getRecommendedGame();
    return Card(
      color: Colors.blue[50],
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Recommended for You", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            const SizedBox(height: 8),
            Text(recTitle, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text("Based on your recent performance.", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                   Widget screen;
                   switch(recType) {
                     case GameType.memory: screen = const MemoryGameScreen(); break;
                     case GameType.attention: screen = const AttentionGameScreen(); break;
                     case GameType.jigsaw: screen = const JigsawGameScreen(); break;
                     case GameType.reaction: screen = const ReactionGameScreen(); break;
                     case GameType.language: screen = const LanguageGameScreen(); break;
                     case GameType.math: screen = const MathGameScreen(); break;
                     default: screen = const MemoryGameScreen(); break;
                   }
                   _startGame(screen);
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("START", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Cognitive Score", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text("${_storage.currentScore.overall}", style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            const Column(
              children: [
                Icon(Icons.arrow_upward, color: Colors.green, size: 30),
                Text("8% from", style: TextStyle(fontSize: 16)),
                Text("last week", style: TextStyle(fontSize: 16)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickGamesGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _gameCard("MEMORY", Icons.psychology, Colors.purple, const MemoryGameScreen()),
        _gameCard("ATTENTION", Icons.center_focus_strong, Colors.orange, const AttentionGameScreen()),
        _gameCard("PUZZLE", Icons.extension, Colors.blue, const JigsawGameScreen()),
        _gameCard("REACTION", Icons.bolt, Colors.red, const ReactionGameScreen()),
        _gameCard("LANGUAGE", Icons.sort_by_alpha, Colors.teal, const LanguageGameScreen()),
        _gameCard("MATH", Icons.calculate, Colors.indigo, const MathGameScreen()),
      ],
    );
  }

  Widget _gameCard(String title, IconData icon, Color color, Widget screen) {
    return InkWell(
      onTap: () => _startGame(screen),
      child: Card(
        color: color.withOpacity(0.1),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color.withOpacity(0.5), width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ),
    );
  }
}
