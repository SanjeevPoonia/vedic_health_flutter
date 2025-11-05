import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/api_helper.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class ChangePasswordScreen extends StatefulWidget {
  var email;
  ChangePasswordScreen(this.email, {super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
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
                          // Welcome Text
                          Row(
                            children: [
                              const Text(
                                'Change ',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF662A09),
                                ),
                              ),
                              const Text(
                                'Password',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFF38328),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 32),
                          // Password Field
                          _buildInputContainer(
                            child: TextFormField(
                              validator: checkPasswordValidator,
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
                                    'assets/leading_lock.png',
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
                            child: TextFormField(
                              validator: checkConfirmPassword,
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
                                    'assets/leading_lock.png',
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
                          const SizedBox(height: 20),
                          // Submit Button
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
                                'Submit',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          /* // Or sign in with
                      Row(
                        children: [
                          Expanded(child: Divider(color: Colors.grey[300])),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
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
                      ),
                      const SizedBox(height: 32),*/
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
      ),
    );
  }
  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    changepassword();
  }
  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password required (min. 6 characters)';
    }
    return null;
  }
  String? checkConfirmPassword(String? value) {
    String password=_passwordController.text.toString();
    if (value!.length < 6) {
      return 'Confirm Password required (min. 6 characters)';
    }else if(password!=value){
      return 'Password and Confirm Password must be same';
    }
    return null;
  }
  changepassword() async {
    var signupData = {
      "email": widget.email,
      "password": _passwordController.text,
      "confirmPassword": _confirmPasswordController.text,
    };

    var requestModel = {
      'data': base64.encode(utf8.encode(json.encode(signupData)))
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var signUPResponse =
    await helper.postAPI('users/changePassword', requestModel, context);

    var responseJSONs = json.decode(signUPResponse.toString());
    print(responseJSONs);
    print("klklkl");
    if (responseJSONs['statusCode'] == 200 ||
        responseJSONs['statusCode'] == 201) {
      Toast.show("Your password has been updated successfully. Kindly log in to proceed.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VedicHealthLoginScreen()));
    } else {
      Toast.show(responseJSONs['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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
