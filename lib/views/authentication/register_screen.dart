import 'package:flutter/material.dart';

import '../login_screen.dart';
import 'otp_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreeTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Top Left Yoga Gradient Bar
              Positioned(
                top: 0,
                left: 24,
                child: Image.asset(
                  'assets/auth_image/yoga_vertical_bar.png',
                  height: 220,
                  fit: BoxFit.contain,
                ),
              ),
              // Top Right Flower
              Positioned(
                top: 10,
                right: 0,
                child: Image.asset(
                  'assets/auth_image/top_right_flower.png',
                  height: 150,
                  fit: BoxFit.contain,
                ),
              ),
              // Bottom Left Flower
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'assets/auth_image/bottom_left_flower.png',
                  height: 80,
                  fit: BoxFit.contain,
                ),
              ),
              // Main Content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Logo
                      Image.asset(
                        'assets/auth_image/vedic_health_logo.png',
                        height: 35,
                      ),
                      const SizedBox(height: 230),
                      // Welcome Text
                      Row(
                        children: [
                          const Text(
                            'Create ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF662A09),
                            ),
                          ),
                          const Text(
                            'Account',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF38328),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      // Name Field
                      _buildInputContainer(
                        child: TextField(
                          controller: _nameController,
                          decoration: InputDecoration(
                            hintText: 'Name',
                            hintStyle: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/auth_image/leading_user.png',
                                width: 18,
                                height: 18,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Mobile Field
                      _buildInputContainer(
                        child: TextField(
                          controller: _mobileController,
                          keyboardType: TextInputType.phone,
                          decoration: InputDecoration(
                            hintText: 'Mobile no.',
                            hintStyle: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16,
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.only(right: 8),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const OTPVerificationScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  // backgroundColor: const Color(0xFFFF8C42),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                ),
                                child: const Text(
                                  'Verify',
                                  style: TextStyle(
                                    color: Color(0xFFF38328),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/auth_image/leading_lock.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Email Field
                      _buildInputContainer(
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/auth_image/email_icon.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Password Field
                      _buildInputContainer(
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/auth_image/leading_lock.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF707070),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Confirm Password Field
                      _buildInputContainer(
                        child: TextField(
                          controller: _confirmPasswordController,
                          obscureText: _obscureConfirmPassword,
                          decoration: InputDecoration(
                            hintText: 'Confirm password',
                            hintStyle: TextStyle(
                              color: const Color(0xFF707070),
                              fontSize: 16,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image.asset(
                                'assets/auth_image/leading_lock.png',
                                width: 24,
                                height: 24,
                              ),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureConfirmPassword
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: const Color(0xFF707070),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Terms & Conditions
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: Checkbox(
                                value: _agreeTerms,
                                onChanged: (v) {
                                  setState(() {
                                    _agreeTerms = v ?? false;
                                  });
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                activeColor: const Color(0xFF6B4423),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    const TextSpan(
                                      text: 'By clicking you agree to our ',
                                      style: TextStyle(
                                        color: Color(0xFF2D2D2D),
                                      ),
                                    ),
                                    TextSpan(
                                      text: 'Terms of Use',
                                      style: const TextStyle(
                                        color: Color(0xFF6B4423),
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    TextSpan(
                                      text: 'Privacy Policy',
                                      style: const TextStyle(
                                        color: Color(0xFF6B4423),
                                      ),
                                    ),
                                  ],
                                  style: TextStyle(
                                      fontSize: 13, color: Colors.grey[800]),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Register Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF6B4423),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Register',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Login Link
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Already have an account? ",
                              style: TextStyle(
                                color: Color(0xFF662A09),
                                fontSize: 14,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(0, 0),
                              ),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFFFF8C42),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
