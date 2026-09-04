import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/reminder.dart';

class MemoryDashboard extends StatefulWidget {
  const MemoryDashboard({Key? key}) : super(key: key);

  @override
  State<MemoryDashboard> createState() => _MemoryDashboardState();
}

class _MemoryDashboardState extends State<MemoryDashboard> {
  final _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Today's Reminders", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ..._storage.reminders.map((r) => _buildReminderCard(r)).toList(),
        ],
      ),
    );
  }

  Widget _buildReminderCard(Reminder reminder) {
    String timeStr = "${reminder.time.hour.toString().padLeft(2, '0')}:${reminder.time.minute.toString().padLeft(2, '0')}";
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(
          reminder.completed ? Icons.check_circle : Icons.schedule,
          color: reminder.completed ? Colors.green : Colors.orange,
          size: 32,
        ),
        title: Text(timeStr, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        subtitle: Text(reminder.title, style: const TextStyle(fontSize: 18)),
        trailing: reminder.completed ? null : OutlinedButton(
          onPressed: () {
            setState(() {
              reminder.completed = true;
            });
          },
          child: const Text("Done"),
        ),
      ),
    );
  }
}
