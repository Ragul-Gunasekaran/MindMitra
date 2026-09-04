import 'package:flutter/material.dart';

class AppNotification {
  final String title;
  final String message;
  final DateTime time;
  bool isRead;

  AppNotification({required this.title, required this.message, required this.time, this.isRead = false});
}

class NotificationManager extends ChangeNotifier {
  static final NotificationManager _instance = NotificationManager._internal();
  factory NotificationManager() => _instance;
  NotificationManager._internal();

  List<AppNotification> notifications = [
    AppNotification(title: "Medicine Reminder", message: "Time to take your morning medicine.", time: DateTime.now().subtract(const Duration(minutes: 5))),
    AppNotification(title: "New Goal", message: "Complete a memory game today to keep your streak!", time: DateTime.now().subtract(const Duration(hours: 2))),
  ];

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  void addNotification(String title, String message) {
    notifications.insert(0, AppNotification(title: title, message: message, time: DateTime.now()));
    notifyListeners();
  }

  void markAllRead() {
    for (var n in notifications) {
      n.isRead = true;
    }
    notifyListeners();
  }
}
