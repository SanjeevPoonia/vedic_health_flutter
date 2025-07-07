import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:vedic_health/views/sign_up_screen.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';
import '../widgets/textfield_widget.dart';
import 'home_screen.dart';
import 'dart:convert' show utf8, base64;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  bool isObscure = true;
  bool termsChecked = false;
  bool checkToggle=false;
  final _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var passwordController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Container(
      color: AppTheme.darkBrown,
      child: SafeArea(
          child: GestureDetector(
            onTap: (){
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              resizeToAvoidBottomInset: false,
        body:  Form(
            key: _formKey,
            child:  Column(
              children: [
                const SizedBox(height: 45),
                Center(
                  child: Image.asset(
                    'assets/vedic_health.png',
                    width: 100,
                    height: 100,
                  ),
                ),
                const SizedBox(height: 18),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(horizontal: 12),
                    child: SizedBox(
                      height: 50,
                      child: Column(
                        children: [
                          const SizedBox(height: 25),
                          const Center(
                            child: Text('Hello',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBrown,
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text('Login to your account.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                )),
                          ),
                          const SizedBox(height: 25),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: TextFieldShow(
                              validator: emailValidator,
                              controller: emailController,
                              labeltext: 'Email',
                              fieldIC: const Icon(Icons.mail,
                                  size: 20,
                                  color: AppTheme.darkBrown),
                              suffixIc: const Icon(
                                Icons.abc,
                                size: 0,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [


                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        checkToggle=!checkToggle;
                                      });
                                    },

                                    child:checkToggle? Icon(Icons.check_box,color: AppTheme.darkBrown):Icon(Icons.check_box_outline_blank_outlined)),

                                SizedBox(width:8),
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
                     /*     const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 35,
                                  height: 35,
                                  child: Checkbox(
                                    activeColor: AppTheme.darkBrown,
                                    value: termsChecked,
                                    onChanged: (newValue) => setState(
                                            () => termsChecked = newValue!),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 5),
                                    child: RichText(
                                      text: TextSpan(
                                        style: const TextStyle(
                                          fontSize: 12.5,

                                          color: Colors.black87,
                                        ),
                                        children: <TextSpan>[
                                          const TextSpan(
                                              text:
                                              'By continuing, you agree that you have read and accept our '),
                                          TextSpan(
                                            text: 'T&Cs',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.darkBrown),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                //Navigator.push(context, MaterialPageRoute(builder: (context)=>CMSScreen("terms-conditions", "Terms & Conditions")));
                                              },
                                          ),
                                          const TextSpan(text: ' and '),
                                          TextSpan(
                                            text: 'Privacy Policy',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.darkBrown),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                // Navigator.push(context, MaterialPageRoute(builder: (context)=>CMSScreen("privacy-policy", "Privacy Policy")));
                                              },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/
                          const SizedBox(height: 45),
                          InkWell(
                            onTap: () {

                              _submitHandler();

                            },
                            child: Container(
                                margin:
                                const EdgeInsets.symmetric(horizontal: 17),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppTheme.darkBrown,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 50,
                                child: const Center(
                                  child: Text('Login',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                )),
                          ),


                          Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('New User? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1A1A1A),
                                  )),
                              GestureDetector(
                                onTap: () {
                                     Navigator.push(
                                       context,
                                       MaterialPageRoute(
                                           builder: (context) =>
                                               SignUpScreen()));
                                },
                                child: const Text('Sign up',
                                    style: TextStyle(
                                      fontSize: 15,
                                      decoration: TextDecoration.underline,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.darkBrown,
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
              ],
            ))
      ),
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

    loginUser();
    //
  }

  validateTerms(){
    if(!termsChecked)
      {
        Toast.show("Please accept the T&Cs and Privacy Policy",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }
    else
      {

      }
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




    if (responseJSON['message'] == "User successfully sign in") {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      MyUtils.saveSharedPreferences(
          'access_token', responseJSON['data']['password'].toString());

      MyUtils.saveSharedPreferences(
          'name', responseJSON['data']['name'].toString());
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
