import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'signin.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String name = "";
  String email = "";
  String phone = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString("name") ?? "";
      email = prefs.getString("email") ?? "";
      phone = prefs.getString("phone") ?? "";
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf7f8),

      // AppBar with Logout icon
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: false,
        title: const Text(
          "Dashboard",
          style: TextStyle(
            color: Color(0xff0a1a3d),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout, color: Color(0xff0a1a3d)),
            tooltip: 'Logout',
          ),
        ],
      ),

      // Body with simple centered data
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xff0a1a3d),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email,
              style: const TextStyle(fontSize: 18, color: Color(0xff0a1a3d)),
            ),
            const SizedBox(height: 10),
            Text(
              phone,
              style: const TextStyle(fontSize: 18, color: Color(0xff0a1a3d)),
            ),
          ],
        ),
      ),
    );
  }
}
