import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class CaregiverDashboard extends StatelessWidget {
  const CaregiverDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final user = storage.currentUser;
    final score = storage.currentScore;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Caregiver Dashboard"), backgroundColor: Colors.indigo, foregroundColor: Colors.white),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            Text("Age: ${user.age}", style: const TextStyle(fontSize: 18, color: Colors.grey)),
            const SizedBox(height: 24),
            const Text("Today's Activity", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Games completed:", style: TextStyle(fontSize: 16)), Text("3", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                    Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Average score:", style: TextStyle(fontSize: 16)), Text("76", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                    Divider(),
                    Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text("Training time:", style: TextStyle(fontSize: 16)), Text("18 min", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Performance Insight", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              color: Colors.blue[50],
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.blue.withOpacity(0.5))),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.insights, color: Colors.blue, size: 32),
                    SizedBox(width: 16),
                    Expanded(child: Text("Memory performance has improved by 8% compared with the previous week.", style: TextStyle(fontSize: 16))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Recent Sessions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...storage.gameResults.take(3).map((result) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(result.type.toString().split('.').last.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text("Score: ${result.score} • Accuracy: ${result.accuracy.toStringAsFixed(0)}%"),
                trailing: const Text("Today", style: TextStyle(color: Colors.grey)),
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}
