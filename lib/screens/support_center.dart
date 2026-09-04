import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../constants/base_url.dart';
import '../services/auth_service.dart';

class SupportCenter extends StatelessWidget {
  const SupportCenter({Key? key}) : super(key: key);

  void _showFeedbackDialog(BuildContext context) {
    final typeCtrl = TextEditingController(text: "GENERAL");
    final msgCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Send Feedback"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: typeCtrl.text,
              items: const [
                DropdownMenuItem(value: "GENERAL", child: Text("General Feedback")),
                DropdownMenuItem(value: "BUG", child: Text("Report a Problem")),
                DropdownMenuItem(value: "FEATURE", child: Text("Feature Request")),
              ],
              onChanged: (val) => typeCtrl.text = val!,
            ),
            const SizedBox(height: 16),
            TextField(controller: msgCtrl, maxLines: 4, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: "What's on your mind?")),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Cancel")),
          ElevatedButton(onPressed: () async {
            if (msgCtrl.text.isEmpty) return;
            try {
              if (AuthService().isDemo) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback saved offline in Demo Mode.")));
              } else {
                await http.post(
                  Uri.parse('$API_BASE_URL/api/feedback'),
                  headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${AuthService().accessToken}'},
                  body: jsonEncode({'type': typeCtrl.text, 'message': msgCtrl.text})
                );
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Thank you for your feedback!")));
              }
            } catch (_) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Saved offline. Will send when connected.")));
            }
            Navigator.pop(ctx);
          }, child: const Text("Send")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Help & Support")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text("Getting Started", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          _buildHelpItem(Icons.psychology, "How to play games", "Tap 'Play Activity' on the Home screen to start a cognitive game. Follow the spoken or written instructions."),
          _buildHelpItem(Icons.mic, "Using Voice", "Tap the 'Ask MindMitra' microphone button and speak clearly. You can ask for your progress or daily plan."),
          _buildHelpItem(Icons.security, "Emergency SOS", "Tap the red SOS button on the Home screen. A dialog will confirm before sending alerts to your connected family."),
          const Divider(height: 48),
          const Text("Frequently Asked Questions", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          const ExpansionTile(
            title: Text("How do I change text size?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text("Go to Profile > Accessibility & Settings and select Extra Large.", style: TextStyle(fontSize: 16)))],
          ),
          const ExpansionTile(
            title: Text("What happens when I am offline?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            children: [Padding(padding: EdgeInsets.all(16.0), child: Text("MindMitra saves your games and reminders safely on this device. It will synchronize automatically when the internet returns.", style: TextStyle(fontSize: 16)))],
          ),
          const Divider(height: 48),
          ElevatedButton.icon(
            icon: const Icon(Icons.feedback),
            label: const Text("Send Feedback"),
            onPressed: () => _showFeedbackDialog(context),
          )
        ],
      ),
    );
  }

  Widget _buildHelpItem(IconData icon, String title, String desc) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 40, color: AppTheme.primaryOrange),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(desc, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
