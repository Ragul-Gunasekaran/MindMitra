import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';
import 'accessibility_settings.dart';
import '../core/theme/app_theme.dart';
import '../services/storage_service.dart';
import 'safety_dashboard.dart';
import 'caregiver_dashboard.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = StorageService().currentUser;
    return SingleChildScrollView(
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
                    Text("Age: ${user.age}", style: const TextStyle(fontSize: 18, color: AppTheme.textLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          _buildMenuButton(context, "Safety & Emergency", Icons.security, () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => Scaffold(appBar: AppBar(title: const Text("Safety")), body: const SafetyDashboard())));
          }),
          _buildMenuButton(context, "Language Settings", Icons.language, () {
             ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Language menu coming soon.")));
          }),
          _buildMenuButton(context, "Caregiver Portal", Icons.family_restroom, () { Navigator.push(context, MaterialPageRoute(builder: (context) => const CaregiverDashboard())); }),
          _buildMenuButton(context, "Help & Support", Icons.help, () {}),
        ],
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, size: 36, color: AppTheme.primaryOrange),
        title: Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
