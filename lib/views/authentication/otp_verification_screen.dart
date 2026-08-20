import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import 'login_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  String email;
  String mobileNo;
  String name;
  String lastName;
  String password;

  OTPVerificationScreen(this.email, this.mobileNo, this.name,this.lastName, this.password, {super.key});



  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(5, (index) => TextEditingController());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      // Logo
                      Image.asset(
                        'assets/vedic_health_logo.png',
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
                        'OTP Sent to your email or mobile no',
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
                                const Text(
                                  "Didn't receive the OTP ",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    sendOTP();
                                  },
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
                          onPressed: () {
                            verifyOtp();
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
  sendOTP() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {
      "email": widget.email,
      "mobileNumber": widget.mobileNo,
      "mobile_number": widget.mobileNo,
      "requestFor": ""
    };

    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/sendOtp', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.toString());
    print(responseJSON['statusCode']);

    if (responseJSON['statusCode'] == 200 ||
        responseJSON['statusCode'] == 201) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      for(int i=0;i<5;i++){
        _otpControllers[i].text="";
      }
      setState(() {

      });
      //Navigator.push(context, MaterialPageRoute(builder: (context) =>  OTPVerificationScreen(_emailController.text.toString(), _mobileController.text.toString(), _nameController.text.toString(), _passwordController.text.toString()),),);
      // showOtpVerificationDialog();
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }
  signupUser()async{
    var signupData = {
      "email": widget.email,
      "mobileNo": widget.mobileNo,
      "password": widget.password,
      "name":widget.name,
      "lastName":widget.lastName,
    };

    var requestModel = {
      'data': base64.encode(utf8.encode(json.encode(signupData)))
    };
    APIDialog.showAlertDialog(context, 'Please wait...');
    ApiBaseHelper helper = ApiBaseHelper();
    var signUPResponse =
    await helper.postAPI('users/create', requestModel, context);
    var responseJSONs = json.decode(signUPResponse.toString());
    Navigator.pop(context);
    print(responseJSONs);
    print("klklkl");
    if (responseJSONs['statusCode'] == 200 ||
        responseJSONs['statusCode'] == 201) {
      Toast.show("Your account has been created successfully.",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VedicHealthLoginScreen()));
    }else{
      Toast.show(responseJSONs['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  void verifyOtp() async {
    bool isOtpValid = _otpControllers.every((controller) => controller.text.isNotEmpty);

    if (!isOtpValid) {
      Toast.show(
        "Please enter complete OTP",
        duration: Toast.lengthLong,
        gravity: Toast.bottom,
        backgroundColor: Colors.red,
      );
      return;
    }

    String otp = _otpControllers.map((e) => e.text).join();
    var data = {
      "email": widget.email,
      "mobileNumber": widget.mobileNo,
      "otp": otp
    };

    APIDialog.showAlertDialog(context, 'Verifying OTP...');
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('users/verifyOtp', requestModel, context);
    Navigator.pop(context); // close loading dialog
    var responseJSON = json.decode(response.toString());
    print(responseJSON);
    if (responseJSON['statusCode'] == 200 || responseJSON['statusCode'] == 201) {
      signupUser();
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
      for(int i=0;i<5;i++){
        _otpControllers[i].text="";
      }
    }
  }
}
