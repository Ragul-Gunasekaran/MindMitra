import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import '../core/theme/app_theme.dart';

class SafetyDashboard extends StatelessWidget {
  const SafetyDashboard({Key? key}) : super(key: key);

  void _triggerSOS(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: AppTheme.alertRed, size: 40),
            SizedBox(width: 16),
            Text("Emergency SOS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28)),
          ],
        ),
        content: const Text("Do you want to notify your family and caregivers that you need help?", style: TextStyle(fontSize: 22)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(fontSize: 22, color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.alertRed, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Emergency contacts notified successfully.", style: TextStyle(fontSize: 20)),
                backgroundColor: AppTheme.alertRed,
                duration: Duration(seconds: 5),
              ));
            },
            child: const Text("Yes, Send Help", style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Safety & SOS"), backgroundColor: AppTheme.alertRed),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 32),
            Semantics(
              button: true,
              label: "Emergency SOS Button. Tap to call for help.",
              child: InkWell(
                onTap: () => _triggerSOS(context),
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 250,
                  height: 250,
                  decoration: BoxDecoration(
                    color: AppTheme.alertRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: AppTheme.alertRed.withOpacity(0.5), blurRadius: 20, spreadRadius: 10),
                    ],
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sos, size: 80, color: Colors.white),
                      SizedBox(height: 8),
                      Text("SOS", style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 48),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text("Emergency Contacts", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            ),
            const SizedBox(height: 16),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, size: 40, color: Colors.blue),
                title: const Text("Priya (Daughter)", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                subtitle: const Text("Primary Contact", style: TextStyle(fontSize: 18)),
                trailing: IconButton(
                  icon: const Icon(Icons.phone, size: 36, color: AppTheme.successGreen),
                  onPressed: () {},
                  tooltip: "Call Priya",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
