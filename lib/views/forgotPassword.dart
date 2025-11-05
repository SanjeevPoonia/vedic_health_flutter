import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:vedic_health/utils/validators.dart';
import 'package:vedic_health/views/authentication/login_screen.dart';
import 'package:vedic_health/views/login_screen.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';
import '../widgets/textfield_widget.dart';
import 'home_screen.dart';
import 'dart:convert' show utf8, base64;

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  ForgotPasswordState createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
  bool isObscure = true;
  final otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: AppTheme.darkBrown,
      child: SafeArea(
          child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    Center(
                      child: Image.asset(
                        'assets/vedic_health.png',
                        width: 100,
                        height: 100,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          children: [
                            const SizedBox(height: 12),
                            const Center(
                              child: Text('Forgot your Password? ',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.darkBrown,
                                  )),
                            ),
                            const SizedBox(height: 10),
                            const Center(
                              child: Text("Don't Worry !! You can Reset It" ,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  )),
                            ),
                            const SizedBox(height: 25),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: TextFieldShow(
                                validator: emailValidator,
                                controller: emailController,
                                labeltext: 'Email',
                                fieldIC: const Icon(Icons.mail,
                                    size: 20, color: AppTheme.darkBrown),
                                suffixIc: const Icon(
                                  Icons.abc,
                                  size: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                  validator: checkPasswordValidator,
                                  controller: passwordController,
                                  obscureText: isObscure,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    suffixIcon: IconButton(
                                      icon: isObscure
                                          ? const Icon(
                                              Icons.visibility_off,
                                              size: 20,
                                              color: AppTheme.darkBrown,
                                            )
                                          : const Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color: AppTheme.darkBrown,
                                            ),
                                      onPressed: () {
                                        Future.delayed(Duration.zero, () async {
                                          if (isObscure) {
                                            isObscure = false;
                                          } else {
                                            isObscure = true;
                                          }

                                          setState(() {});
                                        });
                                      },
                                    ),
                                    labelText: 'Password*',
                                    labelStyle: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 15),
                              child: TextFormField(
                                  validator: checkPasswordValidator,
                                  controller: confirmPasswordController,
                                  obscureText: isObscure,
                                  style: const TextStyle(
                                    fontSize: 15.0,
                                    height: 1.6,
                                    color: Colors.black,
                                  ),
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.zero,
                                    /*    contentPadding:
                                      const EdgeInsets.fromLTRB(
                                          0.0, 20.0, 0.0, 10.0),*/
                                    suffixIcon: IconButton(
                                      icon: isObscure
                                          ? const Icon(
                                              Icons.visibility_off,
                                              size: 20,
                                              color: AppTheme.darkBrown,
                                            )
                                          : const Icon(
                                              Icons.visibility,
                                              size: 20,
                                              color: AppTheme.darkBrown,
                                            ),
                                      onPressed: () {
                                        Future.delayed(Duration.zero, () async {
                                          if (isObscure) {
                                            isObscure = false;
                                          } else {
                                            isObscure = true;
                                          }

                                          setState(() {});
                                        });
                                      },
                                    ),
                                    labelText: 'Confirm Password*',
                                    labelStyle: const TextStyle(
                                      fontSize: 15.0,
                                      color: Colors.grey,
                                    ),
                                  )),
                            ),
                            const SizedBox(height: 35),
                            const SizedBox(height: 22),
                            InkWell(
                              onTap: () {
                                _submitHandler();
                              },
                              child: Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 17),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      color: AppTheme.darkBrown,
                                      borderRadius: BorderRadius.circular(5)),
                                  height: 50,
                                  child: const Center(
                                    child: Text('Verify Mail',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white)),
                                  )),
                            ),
                            const SizedBox(height: 18),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ))),
      )),
    );
  }

  String? emailValidator(String? value) {
    if (value!.isEmpty ||
        !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
            .hasMatch(value)) {
      return 'Email should be valid Email address.';
    }
    return null;
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password is required';
    }
    return null;
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    sendOTP();
  }

  changepassword() async {
    var signupData = {
      "email": emailController.text,
      "password": passwordController.text,
      "confirmPassword": passwordController.text,
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
      //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const VedicHealthLoginScreen()));
    } else {
      Toast.show(responseJSONs['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
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
      "email": emailController.text,
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
      changepassword();
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }
  }

  sendOTP() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {
      "email": emailController.text,
      
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

  String? emailOrPhoneValidator(String? value) {
    if (value!.isEmpty) {
      return "Email or Mobile no. cannot be empty";
    } else if (!isNumeric(value)) {
      if (!RegExp(
              r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
          .hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    } else {
      if (!RegExp(r'(^(\+91[\-\s]?)?[0]?(91)?[6789]\d{9}$)').hasMatch(value)) {
        return 'Enter a valid Email or Mobile no.';
      }
    }

    return null;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
