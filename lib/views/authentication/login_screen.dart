import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/authentication/register_screen.dart';
import 'package:vedic_health/views/authentication/forgot_password_screen.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_modal.dart';
import '../../utils/app_theme.dart';
import '../../widgets/textfield_widget.dart';
import '../forgotPassword.dart';
import '../home_screen.dart';

class VedicHealthLoginScreen extends StatefulWidget {
  const VedicHealthLoginScreen({super.key});

  @override
  State<VedicHealthLoginScreen> createState() => _VedicHealthLoginScreenState();
}

class _VedicHealthLoginScreenState extends State<VedicHealthLoginScreen> {
  bool isObscure = true;
  bool termsChecked = false;
  bool checkToggle = false;
  final _formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getRemeberedPassword();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(child: GestureDetector(
      onTap: (){
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
            key: _formKey,
            child: SafeArea(
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
                          height: 38,
                        ),
                        const SizedBox(height: 180),
                        // Welcome Text
                        const Text(
                          'Welcome back!',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D2D2D),
                          ),
                        ),
                        const SizedBox(height: 32),
                        /* // Username/Email Field
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
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'Username/email',
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
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Password Field
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
                            controller: passwordController,
                            obscureText: true,
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
                        const SizedBox(height: 12),*/
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
                                    Future.delayed(Duration.zero,
                                            () async {
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
                        const SizedBox(height: 20),
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 15),
                          child: Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkToggle = !checkToggle;
                                    });
                                  },
                                  child: checkToggle
                                      ? Icon(Icons.check_box,
                                      color: AppTheme.darkBrown)
                                      : Icon(Icons
                                      .check_box_outline_blank_outlined)),
                              SizedBox(width: 8),
                              Text("Remember",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                 /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ForgotPassword()));*/
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const ForgotPasswordScreen()));
                                },
                                child: const Text('Forgot Password?',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkBrown,
                                        decoration:
                                        TextDecoration.underline)),
                              ),
                            ],
                          ),
                        ),


                        /*// Forget Password
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  const ForgotPasswordScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              'Forget Password?',
                              style: TextStyle(
                                color: Color(0xFF6B4423),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),*/
                        const SizedBox(height: 20),
                        // Login Button
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
                              'Login',
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
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
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
  getRemeberedPassword()async{
    print("fetching retrive");
    final email=await MyUtils.getSharedPreferences(
        'loginEmail');
    print(email);
    final pass=await MyUtils.getSharedPreferences(
        'loginPassword');

    if(email!=null &&pass!=null){
      setState(() {
        emailController.text=email;
        passwordController.text=pass;
        checkToggle=true;
      });
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

    loginUser();
    //
  }

  validateTerms() {
    if (!termsChecked) {
      Toast.show("Please accept the T&Cs and Privacy Policy",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    } else {}
  }

  loginUser() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Logging in...');
    var data = {
      "email": emailController.text,
      "password": passwordController.text,
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/login', requestModel, context);
    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    if (responseJSON['statusCode'] == 200||responseJSON['statusCode'] == 201) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      print(emailController.text);
      print("savedEmail");
      MyUtils.saveSharedPreferences(
          'access_token', responseJSON['data']['password'].toString());
      if(checkToggle){
        print("data saved in orefs");
        MyUtils.saveSharedPreferences(
            'loginEmail', emailController.text);
        MyUtils.saveSharedPreferences(
            'loginPassword', passwordController.text);

      }
      MyUtils.saveSharedPreferences(
          'name', responseJSON['data']['name'].toString());
      MyUtils.saveSharedPreferences(
          'email', responseJSON['data']['email'].toString());
      MyUtils.saveSharedPreferences(
          'user_id', responseJSON['data']['_id'].toString());

      AppModel.setTokenValue(responseJSON['data']['password'].toString());
      AppModel.setLoginToken(true);

      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomeScreen()),
              (Route<dynamic> route) => false);
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
