import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/storage_service.dart';
import '../models/reminder.dart';

class RoutineDashboard extends StatefulWidget {
  const RoutineDashboard({Key? key}) : super(key: key);
  @override
  _RoutineDashboardState createState() => _RoutineDashboardState();
}

class _RoutineDashboardState extends State<RoutineDashboard> {
  final _storage = StorageService();

  void _toggleReminder(Reminder rem) {
    setState(() {
      rem.completed = !rem.completed;
    });
    _storage.saveReminder(rem);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.alarm_off, size: 64, color: AppTheme.textLight),
            const SizedBox(height: 16),
            const Text("You don't have any reminders yet.", style: TextStyle(fontSize: 22, color: AppTheme.textDark), textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.add),
              label: const Text("Add Reminder"),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final reminders = _storage.reminders;
    if (reminders.isEmpty) return _buildEmptyState();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daily Routine", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 24),
          ...reminders.map((rem) => _buildRoutineTimeline(rem)).toList(),
        ],
      ),
    );
  }

  Widget _buildRoutineTimeline(Reminder rem) {
    final isCompleted = rem.completed;
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text("${rem.time.hour.toString().padLeft(2, '0')}:${rem.time.minute.toString().padLeft(2, '0')}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
          ),
          Column(
            children: [
              InkWell(
                onTap: () => _toggleReminder(rem),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted ? AppTheme.successGreen : Colors.grey.shade300,
                  ),
                  child: isCompleted ? const Icon(Icons.check, size: 24, color: Colors.white) : null,
                ),
              ),
              Container(width: 2, height: 40, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(rem.title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isCompleted ? AppTheme.textLight : AppTheme.textDark, decoration: isCompleted ? TextDecoration.lineThrough : null)),
          ),
        ],
      ),
    );
  }
}
