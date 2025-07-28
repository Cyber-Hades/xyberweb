import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_button.dart';
import '../../view_model/auth_view_model.dart';
import 'home_screen.dart';
import 'vendor_home_screen.dart';
import 'verify_email_screen.dart'; // Make sure this path is correct

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String _userType = 'education';
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  String? fullNameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;

  bool isValidEmail(String email) {
    final regex = RegExp(r"^[\w\.-]+@[\w\.-]+\.\w{2,}$");
    return regex.hasMatch(email) && !email.contains("s@g.com");
  }

  void _registerUser() async {
    setState(() {
      fullNameError = null;
      emailError = null;
      passwordError = null;
      confirmPasswordError = null;

      if (_fullNameController.text.trim().isEmpty) {
        fullNameError = "Full name is required";
      }

      final email = _emailController.text.trim();
      if (email.isEmpty) {
        emailError = "Email is required";
      } else if (!isValidEmail(email)) {
        emailError = "Enter a valid email address";
      }

      if (_passwordController.text.isEmpty) {
        passwordError = "Password is required";
      }

      if (_confirmPasswordController.text.isEmpty) {
        confirmPasswordError = "Please confirm your password";
      } else if (_confirmPasswordController.text != _passwordController.text) {
        confirmPasswordError = "Passwords do not match";
      }
    });

    if (fullNameError == null &&
        emailError == null &&
        passwordError == null &&
        confirmPasswordError == null) {
      final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
      final int type = _userType == 'education' ? 0 : 1;

      final error = await authViewModel.register(
        name: _fullNameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        type: type,
        context: context,
        onSuccess: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const VerifyEmailScreen()),
          );
        },
      );

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.06),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _fullNameController,
            decoration: InputDecoration(
              hintText: 'Full Name',
              prefixIcon: const Icon(Icons.person),
              errorText: fullNameError,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              hintText: 'Email',
              prefixIcon: const Icon(Icons.email),
              errorText: emailError,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          TextField(
            controller: _passwordController,
            obscureText: _obscurePassword,
            decoration: InputDecoration(
              hintText: 'Password',
              prefixIcon: const Icon(Icons.lock),
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
          const SizedBox(height: 16),

          TextField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirmPassword,
            decoration: InputDecoration(
              hintText: 'Confirm Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                onPressed: () =>
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              ),
              errorText: confirmPasswordError,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          DropdownButtonFormField<String>(
            value: _userType,
            decoration: InputDecoration(
              labelText: 'Select User Type',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
            ),
            items: const [
              DropdownMenuItem(value: 'education', child: Text('Education')),
              DropdownMenuItem(value: 'business', child: Text('Business')),
            ],
            onChanged: (value) => setState(() => _userType = value!),
          ),
          const SizedBox(height: 30),

          CustomButton(label: 'Register', onPressed: _registerUser),
          const SizedBox(height: 30),

          const Center(child: Text("Or continue with")),
          const SizedBox(height: 15),

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
                onPressed: () {}, // Optional: Add Apple auth if needed
              ),
            ],
          ),
          const SizedBox(height: 30),

          const Text.rich(
            TextSpan(
              text: 'By registering, you agree to our ',
              style: TextStyle(fontSize: 12),
              children: [
                TextSpan(
                  text: 'Terms of Service',
                  style: TextStyle(color: Colors.blue),
                ),
                TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(color: Colors.blue),
                ),
                TextSpan(text: '.'),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
