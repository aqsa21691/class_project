import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'signin.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController name = TextEditingController();
  final TextEditingController phone = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _loading = false;

  // ================= REGISTER USER =================
  Future<void> registerUser() async {
    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse("https://bgnu.space/api/submit_registration"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "full_name": name.text.trim(),
          "cellno": phone.text.trim(),
          "email": email.text.trim(),
          "password": password.text.trim(),
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // SAVE DATA LOCALLY
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("name", name.text.trim());
        await prefs.setString("email", email.text.trim());
        await prefs.setString("phone", phone.text.trim());
        await prefs.setString("password", password.text.trim());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Registration Successful"),
            backgroundColor: Colors.green,
          ),
        );

        // Go to Sign In
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignIn()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? "Registration Failed"),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e"), backgroundColor: Colors.red),
      );
    }

    setState(() => _loading = false);
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffaf7f8),
      appBar: AppBar(
        title: const Text("E10_BGNU"),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xff0a1a3d),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              Image.asset("assets/images/logo.png", height: 90),
              const SizedBox(height: 20),

              const Text(
                "Sign Up",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0a1a3d),
                ),
              ),

              const SizedBox(height: 30),

              buildField(
                controller: name,
                label: "Full Name",
                icon: Icons.person,
                validator: (v) => v!.isEmpty ? "Enter full name" : null,
              ),

              const SizedBox(height: 15),

              buildField(
                controller: phone,
                label: "Phone Number",
                icon: Icons.phone,
                keyboard: TextInputType.phone,
                validator: (v) {
                  if (v!.isEmpty) return "Enter phone number";
                  if (!v.startsWith("92") || v.length != 12) {
                    return "Phone must start with 92 and be 12 digits";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              buildField(
                controller: email,
                label: "Email",
                icon: Icons.email,
                keyboard: TextInputType.emailAddress,
                validator: (v) => v!.contains("@") ? null : "Enter valid email",
              ),

              const SizedBox(height: 15),

              buildPasswordField(
                controller: password,
                label: "Password",
                obscure: _obscurePass,
                toggle: () => setState(() => _obscurePass = !_obscurePass),
              ),

              const SizedBox(height: 15),

              buildPasswordField(
                controller: confirmPassword,
                label: "Confirm Password",
                obscure: _obscureConfirm,
                toggle: () =>
                    setState(() => _obscureConfirm = !_obscureConfirm),
                validator: (v) =>
                    v != password.text ? "Passwords do not match" : null,
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0a1a3d),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _loading
                      ? null
                      : () {
                          if (_formKey.currentState!.validate()) {
                            registerUser();
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign Up"),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignIn()),
                      );
                    },
                    child: const Text(
                      "Sign In",
                      style: TextStyle(
                        color: Color(0xff0a1a3d),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscure,
    required VoidCallback toggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        labelText: label,
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
          onPressed: toggle,
        ),
      ),
    );
  }
}
