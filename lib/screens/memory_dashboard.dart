import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class MemoryDashboard extends StatelessWidget {
  const MemoryDashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("My Memories", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 24),
          _buildMemoryCard(
            context,
            "Family Picnic 1998",
            "A beautiful day out with the kids at the national park.",
            Icons.photo_album,
          ),
          _buildMemoryCard(
            context,
            "Rohan's Graduation",
            "My grandson graduating from college in 2024. So proud!",
            Icons.school,
          ),
          _buildMemoryCard(
            context,
            "Our Old House",
            "The house where we lived for 30 years and raised our family.",
            Icons.house,
          ),
          const SizedBox(height: 32),
          const Text("Family Members", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildFamilyMember("Rohan", "Grandson", Icons.person),
              _buildFamilyMember("Priya", "Daughter", Icons.person_3),
              _buildFamilyMember("Amit", "Son", Icons.person_4),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_a_photo, size: 32),
              label: const Text("Add New Memory"),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add Memory feature coming soon.")));
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMemoryCard(BuildContext context, String title, String description, IconData icon) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(color: AppTheme.primaryOrange.withOpacity(0.2), shape: BoxShape.circle),
          child: Icon(icon, size: 40, color: AppTheme.primaryOrange),
        ),
        title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        subtitle: Text(description, style: const TextStyle(fontSize: 18, color: AppTheme.textLight)),
        trailing: const Icon(Icons.play_circle_fill, size: 48, color: AppTheme.primaryOrange),
        onTap: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Playing audio note for: $title")));
        },
      ),
    );
  }

  Widget _buildFamilyMember(String name, String relation, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.primaryOrange.withOpacity(0.2),
          child: Icon(icon, size: 48, color: AppTheme.primaryOrange),
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textDark)),
        Text(relation, style: const TextStyle(fontSize: 16, color: AppTheme.textLight)),
      ],
    );
  }
}
