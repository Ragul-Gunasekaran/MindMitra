import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';
import '../services/analytics_service.dart';

class ReportsDashboard extends StatefulWidget {
  const ReportsDashboard({Key? key}) : super(key: key);
  @override
  _ReportsDashboardState createState() => _ReportsDashboardState();
}

class _ReportsDashboardState extends State<ReportsDashboard> {
  String _selectedPeriod = "Weekly";
  late Future<ReportSummary> _reportFuture;
  final _service = AnalyticsService();

  @override
  void initState() {
    super.initState();
    _loadReport();
  }

  void _loadReport() {
    setState(() {
      _reportFuture = _service.getReport(_selectedPeriod);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildPeriodChip("Daily"),
                _buildPeriodChip("Weekly"),
                _buildPeriodChip("Monthly"),
              ],
            ),
            const SizedBox(height: 24),
            FutureBuilder<ReportSummary>(
              future: _reportFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("${data.period} Summary", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      const SizedBox(height: 16),
                      Card(
                        color: Colors.blue.withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.auto_awesome, color: Colors.blue, size: 28),
                                  SizedBox(width: 8),
                                  Text("AI Companion Summary", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text("You completed ${data.cognitiveActivities} cognitive sessions this ${data.period.toLowerCase()} and maintained an ${data.routineCompletion.toStringAsFixed(0)}% routine completion rate. Great consistency!", style: const TextStyle(fontSize: 18)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildReportRow(Icons.psychology, "Cognitive Activities", "${data.cognitiveActivities} completed"),
                      const Divider(),
                      _buildReportRow(Icons.percent, "Average Accuracy", "${data.averageAccuracy.toStringAsFixed(0)}%"),
                      const Divider(),
                      _buildReportRow(Icons.event_available, "Routine Completion", "${data.routineCompletion.toStringAsFixed(0)}%"),
                      const Divider(),
                      _buildReportRow(Icons.favorite, "Wellness Activity", "${data.wellnessActivity} days"),
                      const Divider(),
                      _buildReportRow(Icons.mood, "Mood", data.mood),
                      const SizedBox(height: 32),
                      const Text("Highlights & Insights", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
                      const SizedBox(height: 16),
                      ...data.insights.map((insight) => Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.check_circle, color: AppTheme.successGreen),
                            const SizedBox(width: 12),
                            Expanded(child: Text(insight, style: const TextStyle(fontSize: 18))),
                          ],
                        ),
                      )).toList(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.share, size: 28),
                          label: const Text("Share Report"),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Preparing report to share...")));
                          },
                        ),
                      ),
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

  Widget _buildPeriodChip(String value) {
    final isSelected = _selectedPeriod == value;
    return ChoiceChip(
      label: Text(value, style: TextStyle(fontSize: 18, color: isSelected ? Colors.white : AppTheme.textDark)),
      selected: isSelected,
      selectedColor: AppTheme.primaryOrange,
      onSelected: (selected) {
        if (selected) {
          _selectedPeriod = value;
          _loadReport();
        }
      },
    );
  }

  Widget _buildReportRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: AppTheme.primaryOrange, size: 28),
              const SizedBox(width: 16),
              Text(label, style: const TextStyle(fontSize: 18)),
            ],
          ),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
