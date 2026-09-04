import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../services/auth_service.dart';
import '../../main.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  void _login() async {
    setState(() => _isLoading = true);
    final success = await _authService.login(_emailCtrl.text, _passCtrl.text);
    setState(() => _isLoading = false);
    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyHomePage(title: "MindMitra")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("We couldn't sign you in. Please check your email and password.")));
    }
  }

  void _demoMode() async {
    setState(() => _isLoading = true);
    await _authService.loginDemo();
    setState(() => _isLoading = false);
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MyHomePage(title: "MindMitra")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Welcome to MindMitra")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.favorite, size: 80, color: AppTheme.primaryOrange),
                const SizedBox(height: 32),
                TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder())),
                const SizedBox(height: 16),
                TextField(controller: _passCtrl, obscureText: true, decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder())),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text("Sign In"),
                ),
                const SizedBox(height: 16),
                TextButton(onPressed: () {}, child: const Text("Create an account", style: TextStyle(fontSize: 18))),
                const Divider(height: 48),
                ElevatedButton.icon(
                  icon: const Icon(Icons.explore),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey.shade200, foregroundColor: Colors.black),
                  onPressed: _isLoading ? null : _demoMode,
                  label: const Text("Continue in Demo Mode"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
