import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/analytics_service.dart';
import 'reports_dashboard.dart';

class AnalyticsDashboard extends StatefulWidget {
  const AnalyticsDashboard({Key? key}) : super(key: key);
  @override
  _AnalyticsDashboardState createState() => _AnalyticsDashboardState();
}

class _AnalyticsDashboardState extends State<AnalyticsDashboard> {
  String _selectedPeriod = "7d";
  late Future<AnalyticsSummary> _analyticsFuture;
  final _service = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  void _loadAnalytics() {
    setState(() {
      _analyticsFuture = _service.getAnalytics(_selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Progress"),
        actions: [
          IconButton(icon: const Icon(Icons.description), onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ReportsDashboard()));
          })
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPeriodChip("7 Days", "7d"),
                _buildPeriodChip("30 Days", "30d"),
                _buildPeriodChip("90 Days", "90d"),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder<AnalyticsSummary>(
              future: _analyticsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Padding(padding: EdgeInsets.all(16.0), child: Text("We couldn''t connect right now. Your saved information is still available.", style: TextStyle(fontSize: 18), textAlign: TextAlign.center)));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Overall Cognitive Activity", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildStatCard(Icons.psychology, "${data.activityCount}", "Activities"),
                          _buildStatCard(Icons.percent, "${data.averageAccuracy.toStringAsFixed(0)}%", "Accuracy"),
                          _buildStatCard(Icons.calendar_today, "${data.activeDays}", "Active Days"),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text("Domain Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      const SizedBox(height: 16),
                      ...data.domains.entries.map((e) => _buildDomainRow(e.key, e.value)).toList(),
                      const SizedBox(height: 32),
                      const Text("Routine & Wellness", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      const SizedBox(height: 16),
                      _buildStatCardHorizontal(Icons.check_circle, "Routine Completion", "${data.routineCompletion.toStringAsFixed(0)}%"),
                      const SizedBox(height: 8),
                      _buildStatCardHorizontal(Icons.mood, "Mood Trend", data.moodTrend),
                      const SizedBox(height: 32),
                      const Center(child: Text("Showing last synchronized data.", style: TextStyle(fontStyle: FontStyle.italic, color: AppTheme.textLight))),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodChip(String label, String value) {
    final isSelected = _selectedPeriod == value;
    return ChoiceChip(
      label: Text(label, style: TextStyle(fontSize: 18, color: isSelected ? Colors.white : AppTheme.textDark)),
      selected: isSelected,
      selectedColor: AppTheme.primaryOrange,
      onSelected: (selected) {
        if (selected) {
          _selectedPeriod = value;
          _loadAnalytics();
        }
      },
    );
  }

  Widget _buildStatCard(IconData icon, String value, String label) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 36, color: AppTheme.primaryOrange),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            Text(label, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _buildDomainRow(String domain, double score) {
    String trend = score >= 80 ? "?" : (score >= 70 ? "?" : "?");
    Color trendColor = score >= 80 ? AppTheme.successGreen : (score >= 70 ? Colors.blue : AppTheme.primaryOrange);
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(domain, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          Text("${score.toStringAsFixed(0)}%", style: const TextStyle(fontSize: 18)),
          const Spacer(),
          Text(trend, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: trendColor)),
          const SizedBox(width: 16),
          Expanded(child: Text(textStatus, style: TextStyle(fontSize: 18, color: trendColor))),
        ],
      ),
    );
  }

  Widget _buildStatCardHorizontal(IconData icon, String label, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 36, color: Colors.blue),
        title: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
      ),
    );
  }
}
