import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../core/theme/app_theme.dart';

class CaregiverDashboard extends StatelessWidget {
  const CaregiverDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();
    final user = storage.currentUser;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Caregiver Dashboard")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppTheme.primaryOrange.withOpacity(0.2),
                  child: const Icon(Icons.person, size: 48, color: AppTheme.primaryOrange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      Text("Age: ${user.age}  •  Status: Active", style: const TextStyle(fontSize: 18, color: AppTheme.textLight)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildAlertCard(context),
            const SizedBox(height: 24),
            const Text("Daily Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildStatRow("Routine Completion", "86%", AppTheme.successGreen),
                    const Divider(),
                    _buildStatRow("Reminder Adherence", "92%", AppTheme.successGreen),
                    const Divider(),
                    _buildStatRow("Activities Completed", "4/5", AppTheme.primaryOrange),
                    const Divider(),
                    _buildStatRow("Current Mood", "Good ??", Colors.blue),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Cognitive Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            Card(
              color: AppTheme.primaryOrange.withOpacity(0.1),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, color: AppTheme.primaryOrange, size: 32),
                    SizedBox(width: 16),
                    Expanded(child: Text("Memory performance has improved by 8% compared with the previous week.", style: TextStyle(fontSize: 18, color: AppTheme.textDark))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.description, size: 32),
                label: const Text("Generate Weekly Report"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Downloading report...")));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(BuildContext context) {
    return Card(
      color: AppTheme.alertRed.withOpacity(0.1),
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AppTheme.alertRed, size: 32),
            SizedBox(width: 16),
            Expanded(child: Text("Missed Evening Medicine yesterday. Please check in.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.alertRed))),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 18, color: AppTheme.textDark)),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: valueColor)),
      ],
    );
  }
}
