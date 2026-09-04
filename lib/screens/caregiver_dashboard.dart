import 'package:flutter/material.dart';
import 'analytics_dashboard.dart';
import '../services/storage_service.dart';
import '../core/theme/app_theme.dart';

class CaregiverDashboard extends StatefulWidget {
  const CaregiverDashboard({Key? key}) : super(key: key);
  @override
  _CaregiverDashboardState createState() => _CaregiverDashboardState();
}

class _CaregiverDashboardState extends State<CaregiverDashboard> {
  final storage = StorageService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Caregiver Dashboard"),
        actions: [
          IconButton(icon: const Icon(Icons.people), onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Switching to Ravi Kumar (Age 74)")));
          })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Good Morning", style: TextStyle(fontSize: 18, color: AppTheme.textLight)),
            Row(
              children: [
                const Icon(Icons.person, size: 40, color: AppTheme.primaryOrange),
                const SizedBox(width: 12),
                Text(storage.currentUser.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const Spacer(),
                const Text("Age 68", style: TextStyle(fontSize: 18, color: AppTheme.textLight)),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Overall Today", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(),
            _buildStatusRow("Cognitive Activity", "Completed ?", AppTheme.successGreen),
            _buildStatusRow("Routine", "80%", AppTheme.primaryOrange),
            _buildStatusRow("Mood", "?? Good", Colors.blue),
            _buildStatusRow("Wellness", "Good", AppTheme.successGreen),
            _buildStatusRow("Safety", "?? Safe", AppTheme.successGreen),
            const SizedBox(height: 24),
            const Text("Needs Attention", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.alertRed)),
            const Divider(),
            Card(
              color: AppTheme.alertRed.withOpacity(0.1),
              child: const ListTile(
                leading: Icon(Icons.warning, color: AppTheme.alertRed),
                title: Text("Evening medicine pending", style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 24),
            const Text("Recent Achievements", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(),
            const ListTile(leading: Icon(Icons.check_circle, color: AppTheme.successGreen), title: Text("? 5-Day Activity Streak")),
            const ListTile(leading: Icon(Icons.check_circle, color: AppTheme.successGreen), title: Text("? Memory Explorer")),
            const SizedBox(height: 24),
            const Text("Recent Updates", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(),
            const ListTile(leading: Icon(Icons.psychology, color: Colors.blue), title: Text("Memory activity completed")),
            const ListTile(leading: Icon(Icons.mood, color: AppTheme.primaryOrange), title: Text("Mood check completed")),
            const ListTile(leading: Icon(Icons.photo, color: Colors.purple), title: Text("New memory added: Family Picnic")),
            const SizedBox(height: 24),
            const Text("Quick Actions", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _buildActionButton(Icons.bar_chart, "Progress"),
                _buildActionButton(Icons.calendar_month, "Routine"),
                _buildActionButton(Icons.favorite, "Memories"),
                _buildActionButton(Icons.notification_add, "Add Reminder"),
                _buildActionButton(Icons.chat, "Message"),
              ],
            ),
            const SizedBox(height: 24),
            const Text("Caregiver Notes", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const Divider(),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text("Private Note: Anita enjoyed today's memory activity. Call her before the evening routine.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatusRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18)),
          Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.primaryOrange,
        side: const BorderSide(color: AppTheme.primaryOrange),
      ),
      onPressed: () {
        
        if (label == "Progress") {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const AnalyticsDashboard()));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Opening $label...")));
        }

      },
    );
  }
}
