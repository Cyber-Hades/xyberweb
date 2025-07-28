import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import '../../view_model/auth_view_model.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import 'vendor_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  String? emailError;
  String? passwordError;

  void _loginUser() async {
    setState(() {
      emailError = null;
      passwordError = null;

      if (_emailController.text.trim().isEmpty) {
        emailError = "Email is required";
      }
      if (_passwordController.text.isEmpty) {
        passwordError = "Password is required";
      }
    });

    if (emailError == null && passwordError == null) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);

      await authViewModel.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        context: context,
        onSuccess: (type) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
              type == 0 ? const StudentHomeScreen() : const VendorHomeScreen(),
            ),
          );
        },
        onError: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid email or password")),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
      horizontal: screenWidth * 0.06,
          vertical: screenHeight * 0.05,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Welcome Back!",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Please login to continue"),
            const SizedBox(height: 30),

            // Email
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                errorText: emailError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            // Password
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                ),
                errorText: passwordError,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            // Forgot Password
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
                  );

                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ),

            const SizedBox(height: 10),
            CustomButton(label: 'Login', onPressed: _loginUser),

            const SizedBox(height: 30),
            const Center(
              child: Text(
                "Or sign in with",
                style: TextStyle(color: Colors.grey),
              ),
            ),
            const SizedBox(height: 15),

            // Google Sign-In
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.g_mobiledata),
                  iconSize: screenWidth * 0.1,
                  onPressed: () {
                    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
                    authViewModel.signInWithGoogle(
                      context: context,
                      onSuccess: (type) {
                        // ScaffoldMessenger.of(context).showSnackBar(
                        //   const SnackBar(content: Text("Google sign-in successful")),
                        // );
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => type == 0
                                ? const StudentHomeScreen()
                                : const VendorHomeScreen(),
                          ),
                        );
                      },
                      onError: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Google sign-in failed")),
                        );
                      },
                    );
                  },
                ),
                const SizedBox(width: 20),
                IconButton(
                  icon: const Icon(Icons.apple),
                  iconSize: screenWidth * 0.1,
                  onPressed: () {
                    // TODO: Implement Apple sign-in
                  },
                ),
              ],
            ),
          ],
        ),
    );
  }
}
