import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/authentication/change_password_screen.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import 'register_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                    'assets/yoga_vertical_bar.png',
                    height: 220,
                    fit: BoxFit.contain,
                  ),
                ),
                // Top Right Flower
                Positioned(
                  top: 10,
                  right: 0,
                  child: Image.asset(
                    'assets/top_right_flower.png',
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
                // Bottom Left Flower
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image.asset(
                    'assets/bottom_left_flower.png',
                    height: 80,
                    fit: BoxFit.contain,
                  ),
                ),
                // Main Content
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Form(
                      key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 20),
                            // Logo
                            Image.asset(
                              'assets/vedic_health_logo.png',
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
                              'Enter your Email and we\'ll send you a verification code to get back into your account.',
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
                              child: TextFormField(
                                validator: emailValidator,
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
                                      'assets/email_icon.png',
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
                                onPressed: () {
                                  _submitHandler();
                                },
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
                            /*const SizedBox(height: 24),
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
                                'assets/google_logo.png'),
                            const SizedBox(width: 24),
                            _buildSocialButton(
                                'assets/apple_logo.png'),
                            const SizedBox(width: 24),
                            _buildSocialButton(
                                'assets/facebook_logo.png'),
                          ],
                        ),*/
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
                        )
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    sendOTP();
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
  void verifyOtp() async {
    String otp = otpController.text.trim();

    if (otp.isEmpty) {
      Toast.show("Please enter OTP",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      return;
    }

    var data = {
      "email": _emailController.text,
      "otp": otpController.text
    };

    APIDialog.showAlertDialog(context, 'Verifying OTP...');
    Navigator.pop(context);
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('users/verifyOtp', requestModel, context);

    Navigator.pop(context); // close loading dialog

    var responseJSON = json.decode(response.toString());
    print(responseJSON);
    if (responseJSON['statusCode'] == 200 ||
        responseJSON['statusCode'] == 201) {
      Toast.show('OTP verified successfully. Please change your password.',
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChangePasswordScreen(_emailController.text)));
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  ChangePasswordScreen(_emailController.text)));
    }
  }
  sendOTP() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {
      "email": _emailController.text,

    };

    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/sendOtpForPassword', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(responseJSON['statusCode']);

    if (responseJSON['statusCode'] == 200 ||
        responseJSON['statusCode'] == 201) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      showOtpVerificationDialog();
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?\.)+[a-zA-Z0-9](?:[a-zA-Z0-9-]*[a-zA-Z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
  void showOtpVerificationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Verify OTP"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("Enter the OTP sent to your email or phone."),
              const SizedBox(height: 10),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "OTP",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: const Text("Verify"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.darkBrown,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                verifyOtp();
              },
            ),
          ],
        );
      },
    );
  }
}
