import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/base_url.dart';
import '../models/user.dart';
import 'storage_service.dart';
import 'sync_manager.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  String? _accessToken;
  User? _currentUser;
  bool _isDemo = false;

  String? get accessToken => _accessToken;
  User? get currentUser => _currentUser;
  bool get isDemo => _isDemo;

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$API_BASE_URL/api/auth/login'),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'username': email, 'password': password},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _accessToken = data['access_token'];
        _isDemo = false;
        
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', _accessToken!);
        await _fetchMe();
        return true;
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  Future<void> loginDemo() async {
    _isDemo = true;
    _accessToken = "demo_token";
    _currentUser = User(id: "demo_1", name: "Demo User", age: 65, role: "ELDERLY");
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', _accessToken!);
    StorageService().setCurrentUser(_currentUser!);
  }

  Future<void> _fetchMe() async {
    if (_accessToken == null) return;
    try {
      final response = await http.get(
        Uri.parse('$API_BASE_URL/api/auth/me'),
        headers: {'Authorization': 'Bearer $_accessToken'},
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _currentUser = User.fromJson(data);
        StorageService().setCurrentUser(_currentUser!);
      }
    } catch (_) {}
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    _accessToken = prefs.getString('access_token');
    if (_accessToken != null) {
      if (_accessToken == "demo_token") {
        await loginDemo();
        return true;
      }
      await _fetchMe();
      return _currentUser != null;
    }
    return false;
  }

  Future<void> logout() async {
    _accessToken = null;
    _currentUser = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    
    // Clear user-specific data from SyncManager and Storage
    await SyncManager().clearQueue();
    await StorageService().clearUserData();
  }
}
