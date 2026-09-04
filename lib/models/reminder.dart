class Reminder {
  final String id;
  final String title;
  final DateTime time;
  final String category;
  bool completed;

  Reminder({
    required this.id,
    required this.title,
    required this.time,
    required this.category,
    this.completed = false,
  });
}
