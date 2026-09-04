import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/base_url.dart';

class SyncOperation {
  final String id;
  final String entityType;
  final String operationType;
  final Map<String, dynamic> payload;
  final int createdAt;

  SyncOperation({
    required this.id,
    required this.entityType,
    required this.operationType,
    required this.payload,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'entityType': entityType,
    'operationType': operationType,
    'payload': payload,
    'createdAt': createdAt,
  };

  factory SyncOperation.fromJson(Map<String, dynamic> json) => SyncOperation(
    id: json['id'],
    entityType: json['entityType'],
    operationType: json['operationType'],
    payload: json['payload'],
    createdAt: json['createdAt'],
  );
}

class SyncManager {
  static final SyncManager _instance = SyncManager._internal();
  factory SyncManager() => _instance;
  SyncManager._internal();

  final _uuid = Uuid();
  List<SyncOperation> _queue = [];
  bool isOnline = true;
  bool isSyncing = false;
  DateTime? lastSyncedAt;

  final _syncStatusController = StreamController<String>.broadcast();
  Stream<String> get syncStatusStream => _syncStatusController.stream;

  Future<void> init() async {
    await _loadQueue();
    // Start background check loop safely
    _checkConnectivityLoop();
  }

  Future<void> _loadQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueStr = prefs.getString('sync_queue');
      if (queueStr != null) {
        final List<dynamic> decoded = jsonDecode(queueStr);
        _queue = decoded.map((e) => SyncOperation.fromJson(e)).toList();
      }
    } catch (_) {}
    _updateStatus();
  }

  Future<void> _saveQueue() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final queueStr = jsonEncode(_queue.map((e) => e.toJson()).toList());
      await prefs.setString('sync_queue', queueStr);
    } catch (_) {}
    _updateStatus();
  }

  void _updateStatus() {
    if (isSyncing) {
      _syncStatusController.add("? Syncing...");
    } else if (!isOnline) {
      _syncStatusController.add("? Offline — Your data is saved here");
    } else if (_queue.isNotEmpty) {
      _syncStatusController.add("? ${_queue.length} items waiting to sync");
    } else {
      _syncStatusController.add("? Everything is up to date");
    }
  }

  Future<void> queueOperation(String entityType, String operationType, Map<String, dynamic> payload) async {
    final op = SyncOperation(
      id: _uuid.v4(),
      entityType: entityType,
      operationType: operationType,
      payload: payload,
      createdAt: DateTime.now().millisecondsSinceEpoch,
    );
    _queue.add(op);
    await _saveQueue();
    syncNow(); // Try immediately
  }

  void _checkConnectivityLoop() {
    Timer.periodic(const Duration(seconds: 15), (_) async {
      await syncNow();
    });
  }

  Future<void> syncNow() async {
    if (isSyncing) return;
    isSyncing = true;
    _updateStatus();

    try {
      // 1. Simple heartbeat check
      final response = await http.get(Uri.parse('$API_BASE_URL/health')).timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        isOnline = true;
        
        // 2. Process Queue
        List<SyncOperation> toRemove = [];
        for (final op in _queue) {
          bool success = await _pushOperation(op);
          if (success) toRemove.add(op);
        }

        if (toRemove.isNotEmpty) {
          _queue.removeWhere((op) => toRemove.contains(op));
          await _saveQueue();
        }

        lastSyncedAt = DateTime.now();
        
        // 3. Inform listeners
        _updateStatus();
      } else {
        isOnline = false;
        _updateStatus();
      }
    } catch (_) {
      isOnline = false;
      _updateStatus();
    } finally {
      isSyncing = false;
    }
  }

  Future<bool> _pushOperation(SyncOperation op) async {
    try {
      if (op.entityType == 'GameResult') {
        final res = await http.post(
          Uri.parse('$API_BASE_URL/api/results'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(op.payload),
        ).timeout(const Duration(seconds: 5));
        return res.statusCode == 200 || res.statusCode == 201;
      }
      return true; // Ignore unknown ops to avoid infinite queue
    } catch (_) {
      return false;
    }
  }
}
