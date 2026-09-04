import 'package:flutter/material.dart';
import '../games/memory_game.dart';
import '../games/attention_game.dart';
import '../games/jigsaw_game.dart';
import '../games/reaction_game.dart';
import '../games/language_game.dart';
import '../games/math_game.dart';
import '../games/recall_game.dart';

class GamesDashboard extends StatelessWidget {
  const GamesDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text("All Games", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildGameTile(context, "Memory Challenge", "Train your short-term memory", Icons.psychology, Colors.purple, const MemoryGameScreen()),
        _buildGameTile(context, "Attention Test", "Improve your focus", Icons.center_focus_strong, Colors.orange, const AttentionGameScreen()),
        _buildGameTile(context, "Jigsaw Puzzle", "Problem solving skills", Icons.extension, Colors.blue, const JigsawGameScreen()),
        _buildGameTile(context, "Reaction Speed", "Test your reflexes", Icons.bolt, Colors.red, const ReactionGameScreen()),
        _buildGameTile(context, "Memory Recall", "Remember details", Icons.history, Colors.purple[300]!, const RecallGameScreen()),
        _buildGameTile(context, "Language Skills", "Word matching", Icons.sort_by_alpha, Colors.teal, const LanguageGameScreen()),
        _buildGameTile(context, "Mathematics", "Simple arithmetic", Icons.calculate, Colors.indigo, const MathGameScreen()),
      ],
    );
  }

  Widget _buildGameTile(BuildContext context, String title, String subtitle, IconData icon, Color color, Widget screen) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(backgroundColor: color.withOpacity(0.2), child: Icon(icon, color: color)),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
        },
      ),
    );
  }
}
