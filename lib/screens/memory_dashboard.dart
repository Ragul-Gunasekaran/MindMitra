import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/voice_service.dart';

class MemoryDashboard extends StatefulWidget {
  const MemoryDashboard({Key? key}) : super(key: key);
  @override
  _MemoryDashboardState createState() => _MemoryDashboardState();
}

class _MemoryDashboardState extends State<MemoryDashboard> {
  final _voice = VoiceService();
  bool _isListening = false;

  void _showAddMemoryDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Add Memory", style: TextStyle(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const TextField(decoration: InputDecoration(labelText: "Memory Title", border: OutlineInputBorder())),
              const SizedBox(height: 16),
              const TextField(decoration: InputDecoration(labelText: "What happened?", border: OutlineInputBorder()), maxLines: 3),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(icon: const Icon(Icons.add_a_photo, size: 36, color: AppTheme.primaryOrange), onPressed: () {}),
                  IconButton(
                    icon: Icon(_isListening ? Icons.mic_off : Icons.mic, size: 36, color: Colors.blue), 
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Voice note recorded.")));
                    },
                  ),
                ],
              )
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            Navigator.pop(ctx);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Memory saved successfully!")));
          }, child: const Text("Save")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("My Memories", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              IconButton(icon: const Icon(Icons.search, size: 36), onPressed: () {}),
            ],
          ),
          const SizedBox(height: 24),
          Card(
            color: Colors.blue.withOpacity(0.1),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.history_edu, color: Colors.blue, size: 32),
                      SizedBox(width: 8),
                      Text("Memory of the Day", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text("Family Picnic — 1998", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Would you like to remember this moment?", style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 12),
                  ElevatedButton(onPressed: () {}, child: const Text("View Memory")),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text("Memory Prompt", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 12),
          const Text("What was your favorite family celebration?", style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.mic),
            label: const Text("Answer with Voice"),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Listening to your memory...")));
            },
          ),
          const SizedBox(height: 32),
          const Text("Timeline", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          _buildMemoryCard(context, "1998", "Family Picnic", "A beautiful day out with the kids at the national park.", Icons.photo_album, "Family"),
          _buildMemoryCard(context, "2010", "First Job", "Started working at the new office.", Icons.work, "Career"),
          _buildMemoryCard(context, "2024", "Rohan's Graduation", "My grandson graduating from college.", Icons.school, "Family"),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 32),
              label: const Text("Add New Memory"),
              style: ElevatedButton.styleFrom(backgroundColor: AppTheme.successGreen),
              onPressed: _showAddMemoryDialog,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, String year, String title, String description, IconData icon, String category) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(year, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
        title: Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
            const SizedBox(height: 8),
            Chip(label: Text(category, style: const TextStyle(fontSize: 12)), backgroundColor: AppTheme.primaryOrange.withOpacity(0.2)),
          ],
        ),
        trailing: const Icon(Icons.play_circle_fill, size: 40, color: AppTheme.primaryOrange),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Viewing $title")));
        },
      ),
    );
  }
}
