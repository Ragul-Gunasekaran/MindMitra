import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../core/config/localization.dart';

class SafetyDashboard extends StatelessWidget {
  const SafetyDashboard({Key? key}) : super(key: key);

  void _showSosConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Emergency SOS", style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to trigger an emergency alert to your caregivers?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancel", style: TextStyle(fontSize: 20)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Emergency Alert Sent!")));
            },
            child: const Text("YES, HELP ME"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.alertRed,
              padding: const EdgeInsets.all(32),
            ),
            icon: const Icon(Icons.warning_amber_rounded, size: 48, color: Colors.white),
            label: Text(AppLocalization().translate("sos_button"), style: const TextStyle(fontSize: 32, color: Colors.white)),
            onPressed: () => _showSosConfirmation(context),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.successGreen,
              padding: const EdgeInsets.all(24),
            ),
            icon: const Icon(Icons.check_circle, size: 36, color: Colors.white),
            label: const Text("I'm Safe (Check-in)", style: TextStyle(fontSize: 24, color: Colors.white)),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Caregiver notified that you are safe.")));
            },
          ),
          const SizedBox(height: 32),
          const Text("Emergency Contacts", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          _buildContactCard(context, "Priya (Daughter)", "+91 9876543210"),
          _buildContactCard(context, "Dr. Sharma", "+91 8765432109"),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String name, String phone) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.contact_phone, size: 36, color: AppTheme.primaryOrange),
        title: Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        subtitle: Text(phone, style: const TextStyle(fontSize: 18)),
        trailing: IconButton(
          icon: const Icon(Icons.call, size: 36, color: AppTheme.successGreen),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Calling $name...")));
          },
        ),
      ),
    );
  }
}
