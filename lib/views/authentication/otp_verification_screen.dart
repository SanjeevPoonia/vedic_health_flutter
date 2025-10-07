import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  const OTPVerificationScreen({super.key});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(5, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
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
                      // Title
                      Row(
                        children: [
                          const Text(
                            'OTP ',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF662A09),
                            ),
                          ),
                          const Text(
                            'Verification',
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
                        'OTP send to your given email ID',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF666666),
                        ),
                      ),
                      const SizedBox(height: 40),
                      // OTP Input Fields
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F6F6),
                              borderRadius: BorderRadius.circular(5),
                              // boxShadow: [
                              // BoxShadow(
                              //   color: Colors.grey.withOpacity(0.1),
                              //   spreadRadius: 1,
                              //   blurRadius: 10,
                              //   offset: const Offset(0, 2),
                              // ),
                              // ],
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: const Color(0xFFF6F6F6),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 4) {
                                  FocusScope.of(context).nextFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 40),
                      // Resend OTP Text
                      Center(
                        child: Column(
                          children: [
                            TweenAnimationBuilder<Duration>(
                              duration: const Duration(seconds: 30),
                              tween: Tween(
                                  begin: const Duration(seconds: 30),
                                  end: Duration.zero),
                              onEnd: () {},
                              builder: (BuildContext context, Duration value,
                                  Widget? child) {
                                final seconds = value.inSeconds % 60;
                                return Text(
                                  'Resend OTP In 00:${seconds.toString().padLeft(2, '0')} Seconds',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn't receive the OTP ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {},
                                  child: const Text(
                                    "Resend",
                                    style: TextStyle(
                                      color: Color(0xFF01345B),
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Submit Button
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
                            'Submit',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
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
}
