import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../constants/base_url.dart';
import '../services/auth_service.dart';
import 'auth/login_screen.dart';

class PrivacyCenter extends StatelessWidget {
  const PrivacyCenter({Key? key}) : super(key: key);

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Account", style: TextStyle(color: AppTheme.alertRed, fontWeight: FontWeight.bold)),
        content: const Text("Are you sure you want to permanently delete your MindMitra account? This action cannot be undone and will erase all cognitive history and memories.", style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed),
            onPressed: () async {
              try {
                if (!AuthService().isDemo) {
                  final token = AuthService().accessToken;
                  final user = AuthService().currentUser;
                  await http.delete(Uri.parse('$API_BASE_URL/api/users/${user!.id}'), headers: {'Authorization': 'Bearer $token'});
                }
                await AuthService().logout();
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
              } catch (_) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Cannot delete account while offline.")));
              }
            }, 
            child: const Text("Yes, Delete My Account")
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy & Data")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("MindMitra protects your privacy.", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                "MindMitra provides wellness and cognitive assistance. It does not diagnose medical conditions.\n\n"
                "Your cognitive results, memories, and routines are stored securely to provide personalized AI recommendations. "
                "Only you and your explicitly authorized caregivers can view this information.",
                style: TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.delete_forever),
            label: const Text("Delete My Account"),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppTheme.alertRed, side: const BorderSide(color: AppTheme.alertRed)),
            onPressed: () => _showDeleteConfirmation(context),
          )
        ],
      ),
    );
  }
}
