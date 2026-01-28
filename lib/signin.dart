import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool _obscurePass = true;
  bool _loading = false;

  // ================= LOGIN USING SHARED PREFERENCES =================
  Future<void> loginUser() async {
    setState(() => _loading = true);

    final prefs = await SharedPreferences.getInstance();

    final savedEmail = prefs.getString("email");
    final savedPassword = prefs.getString("password");

    if (email.text.trim() == savedEmail &&
        password.text.trim() == savedPassword) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Login Successful")));

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnlineScholarRequest()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid Email or Password"),
          backgroundColor: Colors.red,
        ),
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

              // Logo
              Image.asset("assets/images/logo.png", height: 90),
              const SizedBox(height: 20),

              const Text(
                "Sign In",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0a1a3d),
                ),
              ),
              const SizedBox(height: 30),

              // EMAIL FIELD
              buildField(
                controller: email,
                label: "Email",
                icon: Icons.email,
                validator: (v) => v!.contains("@") ? null : "Enter valid email",
              ),
              const SizedBox(height: 15),

              // PASSWORD FIELD
              buildPasswordField(
                controller: password,
                label: "Password",
                obscure: _obscurePass,
                toggle: () => setState(() => _obscurePass = !_obscurePass),
              ),
              const SizedBox(height: 30),

              // LOGIN BUTTON
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
                            loginUser();
                          }
                        },
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Sign In"),
                ),
              ),
              const SizedBox(height: 20),

              // SIGNUP LINK
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SignUp()),
                      );
                    },
                    child: const Text(
                      "Sign Up",
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

  // ---------- TEXT FIELD ----------
  Widget buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  // ---------- PASSWORD FIELD ----------
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
