import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'caregiver_dashboard.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = StorageService().currentUser;
    final score = StorageService().currentScore;
    
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text("Profile", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const CircleAvatar(radius: 40, backgroundColor: Colors.blue, child: Icon(Icons.person, size: 40, color: Colors.white)),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("Age: ${user.age}", style: const TextStyle(fontSize: 18)),
                    Text("Current Score: ${score.overall}", style: const TextStyle(fontSize: 18, color: Colors.green)),
                  ],
                )
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton.icon(
          icon: const Icon(Icons.admin_panel_settings),
          label: const Text("Caregiver Dashboard", style: TextStyle(fontSize: 18)),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.all(16),
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CaregiverDashboard()));
          },
        ),
        const SizedBox(height: 24),
        const Text("Settings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _settingTile(Icons.language, "Language", "English"),
        _settingTile(Icons.text_fields, "Text Size", "Large"),
        _settingTile(Icons.volume_up, "Sound", "On"),
        _settingTile(Icons.record_voice_over, "Voice Instructions", "On"),
        _settingTile(Icons.contrast, "High Contrast", "Off"),
      ],
    );
  }
  
  Widget _settingTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title, style: const TextStyle(fontSize: 18)),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
          const Icon(Icons.arrow_forward_ios, size: 16),
        ],
      ),
      onTap: () {},
    );
  }
}
