import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class RoutineDashboard extends StatelessWidget {
  const RoutineDashboard({Key? key}) : super(key: key);

  @override
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.alarm_off, size: 64, color: AppTheme.textLight),
            const SizedBox(height: 16),
            const Text("You don''t have any reminders yet.", style: TextStyle(fontSize: 22, color: AppTheme.textDark), textAlign: TextAlign.center),
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Daily Routine", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 24),
          _buildRoutineTimeline("07:30 AM", "Wake Up", true),
          _buildRoutineTimeline("08:00 AM", "Morning Medicine", true, isImportant: true),
          _buildRoutineTimeline("08:30 AM", "Breakfast", true),
          _buildRoutineTimeline("10:00 AM", "Cognitive Activity", false),
          _buildRoutineTimeline("12:30 PM", "Lunch", false),
          _buildRoutineTimeline("03:00 PM", "Walking", false),
          _buildRoutineTimeline("05:00 PM", "Family Call", false),
          _buildRoutineTimeline("07:00 PM", "Evening Medicine", false, isImportant: true),
        ],
      ),
    );
  }

  Widget _buildRoutineTimeline(String time, String title, bool isCompleted, {bool isImportant = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(time, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppTheme.textLight)),
          ),
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCompleted ? AppTheme.successGreen : Colors.grey.shade300,
                  border: Border.all(color: isImportant ? AppTheme.alertRed : Colors.transparent, width: 2),
                ),
                child: isCompleted ? const Icon(Icons.check, size: 16, color: Colors.white) : null,
              ),
              Container(width: 2, height: 40, color: Colors.grey.shade300),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: isCompleted ? AppTheme.textLight : AppTheme.textDark, decoration: isCompleted ? TextDecoration.lineThrough : null)),
          ),
        ],
      ),
    );
  }
}
