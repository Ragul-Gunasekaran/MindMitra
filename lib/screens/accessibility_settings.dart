import 'package:flutter/material.dart';
import '../core/config/accessibility.dart';
import '../core/theme/app_theme.dart';

class AccessibilitySettings extends StatefulWidget {
  const AccessibilitySettings({Key? key}) : super(key: key);
  @override
  _AccessibilitySettingsState createState() => _AccessibilitySettingsState();
}

class _AccessibilitySettingsState extends State<AccessibilitySettings> {
  final _config = AccessibilityConfig();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Accessibility")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Text Size", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
            const SizedBox(height: 8),
            ListTile(
              title: const Text("Small"),
              leading: Radio<double>(value: 0.9, groupValue: _config.textScaleFactor, onChanged: (v) => _config.updateTextScale(v!)),
            ),
            ListTile(
              title: const Text("Normal"),
              leading: Radio<double>(value: 1.2, groupValue: _config.textScaleFactor, onChanged: (v) => _config.updateTextScale(v!)),
            ),
            ListTile(
              title: const Text("Large"),
              leading: Radio<double>(value: 1.5, groupValue: _config.textScaleFactor, onChanged: (v) => _config.updateTextScale(v!)),
            ),
            ListTile(
              title: const Text("Extra Large"),
              leading: Radio<double>(value: 1.8, groupValue: _config.textScaleFactor, onChanged: (v) => _config.updateTextScale(v!)),
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("High Contrast Mode", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Increase visibility of text and buttons"),
              value: _config.highContrast,
              onChanged: _config.toggleHighContrast,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Reduced Motion", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Minimize animations and transitions"),
              value: _config.reducedMotion,
              onChanged: _config.toggleReducedMotion,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Voice Guidance", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Speak important actions and feedback"),
              value: _config.voiceGuidance,
              onChanged: _config.toggleVoiceGuidance,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Spoken Reminders", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Read reminders out loud"),
              value: _config.spokenReminders,
              onChanged: _config.toggleSpokenReminders,
            ),
            const Divider(),
            SwitchListTile(
              title: const Text("Simple Elderly Mode", style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text("Show only the most important features on Home"),
              value: _config.simpleMode,
              onChanged: _config.toggleSimpleMode,
            ),
          ],
        ),
      ),
    );
  }
}
