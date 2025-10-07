import 'package:flutter/material.dart';

import 'register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
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
                          height: 38,
                        ),
                        const SizedBox(height: 230),
                        // Title
                        Row(
                          children: [
                            const Text(
                              'Password ',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2D2D2D),
                              ),
                            ),
                            const Text(
                              'Recovery',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF38328),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Subtitle
                        const Text(
                          'Enter your Email / Mobile Number and we\'ll send you a verification code to get back into your account.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF666666),
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 32),
                        // Email/Mobile Field
                        Container(
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
                          child: TextField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                color: Colors.grey[400],
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
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Get Code Button
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
                              'Get Code',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        // Or sign in with
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey[300])),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'Or sign in with',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey[300])),
                          ],
                        ),
                        const SizedBox(height: 24),
                        // Social Login Buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildSocialButton(
                                'assets/auth_image/google_logo.png'),
                            const SizedBox(width: 24),
                            _buildSocialButton(
                                'assets/auth_image/apple_logo.png'),
                            const SizedBox(width: 24),
                            _buildSocialButton(
                                'assets/auth_image/facebook_logo.png'),
                          ],
                        ),
                        const SizedBox(height: 32),
                        // Register Link
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                  color: Color(0xFF2D2D2D),
                                  fontSize: 14,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                ),
                                child: const Text(
                                  'Register',
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
        ));
  }

  Widget _buildSocialButton(String imagePath) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 1,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            width: 48,
            height: 48,
          ),
        ),
      ),
    );
  }
}
