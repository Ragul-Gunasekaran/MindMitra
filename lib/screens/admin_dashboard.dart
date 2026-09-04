import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/theme/app_theme.dart';
import '../constants/base_url.dart';
import '../services/auth_service.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  Map<String, dynamic>? _overview;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOverview();
  }

  Future<void> _fetchOverview() async {
    final token = AuthService().accessToken;
    try {
      final res = await http.get(Uri.parse('$API_BASE_URL/api/admin/overview'), headers: {'Authorization': 'Bearer $token'});
      if (res.statusCode == 200) {
        setState(() {
          _overview = jsonDecode(res.body);
          _isLoading = false;
        });
      }
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Portal")),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : _overview == null
          ? const Center(child: Text("Unable to load admin data."))
          : ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                const Text("Platform Overview", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                const SizedBox(height: 16),
                _buildStatCard("Total Elderly Users", _overview!['total_elderly'].toString()),
                _buildStatCard("Total Caregivers", _overview!['total_caregivers'].toString()),
                _buildStatCard("Active Connections", _overview!['active_connections'].toString()),
                _buildStatCard("Cognitive Activities", _overview!['cognitive_activities_completed'].toString()),
                const SizedBox(height: 32),
                ElevatedButton.icon(
                  icon: const Icon(Icons.people),
                  label: const Text("Manage Users"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("User Management opens here.")));
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.feedback),
                  label: const Text("View Feedback"),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Feedback Dashboard opens here.")));
                  },
                )
              ],
            ),
    );
  }

  Widget _buildStatCard(String title, String count) {
    return Card(
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: Text(count, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.primaryOrange)),
      ),
    );
  }
}
