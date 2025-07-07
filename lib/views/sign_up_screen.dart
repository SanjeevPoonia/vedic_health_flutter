import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:toast/toast.dart';
import 'package:vedic_health/utils/validators.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_modal.dart';
import '../utils/app_theme.dart';
import '../widgets/textfield_widget.dart';
import 'home_screen.dart';
import 'dart:convert' show utf8, base64;

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<SignUpScreen> {
  bool isObscure = true;
  bool termsChecked = false;
  bool checkToggle=false;
  final _formKey = GlobalKey<FormState>();
  var emailController=TextEditingController();
  var nameController=TextEditingController();
  var mobileController=TextEditingController();
  var passwordController=TextEditingController();
  var confirmPasswordController=TextEditingController();

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
                            child: Text('Hello',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.darkBrown,
                                )),
                          ),
                          const SizedBox(height: 10),
                          const Center(
                            child: Text('Register a new account',
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
                            child: TextFieldRegister(
                              validator: Validators.checkEmptyString,
                              controller: nameController,
                              labeltext: 'Name*',
                            ),
                          ),
                          const SizedBox(height: 10),




                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: TextFieldPhone(
                              validator: Validators.checkEmptyString,
                              controller: mobileController,
                              labeltext: 'Mobile Number*',
                            ),
                          ),
                          const SizedBox(height: 10),




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


                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              children: [


                                GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        termsChecked=!termsChecked;
                                      });
                                    },

                                    child:termsChecked? Icon(Icons.check_box,color: AppTheme.darkBrown):Icon(Icons.check_box_outline_blank_outlined)),

                                SizedBox(width:8),
                                Expanded(
                                  child: Text("By clicking you agree to our Terms of Use and Privacy Policy",
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),
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
                          const SizedBox(height: 22),
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
                                  child: Text('Register',
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
    validateTerms();

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
        sendOTP();
      }
  }



  sendOTP() async {
    FocusScope.of(context).unfocus();
    APIDialog.showAlertDialog(context, 'Sending OTP...');
    var data = {"email":emailController.text,"mobileNumber":mobileController.text.toString(),"requestFor":""};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/sendOtp', requestModel, context);
    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());




    if (responseJSON['message'] == "User successfully sign in") {

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
