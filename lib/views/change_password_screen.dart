import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../utils/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/appbar_widget.dart';

class ChangePasswordScreen extends StatefulWidget {
  AddressDetailsState createState() => AddressDetailsState();
}

class AddressDetailsState extends State<ChangePasswordScreen> {
  var currentPasswordController = TextEditingController();
  var newPasswordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isObscureCurrent = true;
  bool isObscureConfirm = true;
  bool isObscureNew = true;
  String? landingUI;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      body: Column(
        children: [
          SizedBox(height: 22),

          AppBarWidget("Password Change"),
          Expanded(
            child: Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                color: Colors.white,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    padding: EdgeInsets.zero,
                  //  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Current Password",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9D9CA0))),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: currentPasswordController,
                          validator: checkPasswordValidator,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: isObscureCurrent
                                  ? const Icon(
                                      Icons.visibility_off,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    ),
                              onPressed: () {
                                Future.delayed(Duration.zero, () async {
                                  setState(() {
                                    isObscureCurrent = !isObscureCurrent;
                                  });
                                });
                              },
                            ),
                            isDense: true,
                            // Added this
                            contentPadding: EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE4E8F1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE5DFDF),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                color: Color(0xFF606162),
                                fontSize: 14,
                                fontFamily: "Montserrat"),
                            hintText: "Enter Current Password",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text("New Password",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9D9CA0))),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: newPasswordController,
                          validator: checkPasswordValidator,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: isObscureNew
                                  ? const Icon(
                                      Icons.visibility_off,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    ),
                              onPressed: () {
                                Future.delayed(Duration.zero, () async {
                                  setState(() {
                                    isObscureNew = !isObscureNew;
                                  });
                                });
                              },
                            ),
                            isDense: true,
                            // Added this
                            contentPadding: EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE4E8F1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE5DFDF),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                color: Color(0xFF606162),
                                fontSize: 14,
                                fontFamily: "Montserrat"),
                            hintText: "Enter New Password",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text("Confirm New Password",
                            style: TextStyle(
                                fontSize: 15,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF9D9CA0))),
                      ),
                      const SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextFormField(
                          controller: confirmPasswordController,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: isObscureConfirm
                                  ? const Icon(
                                      Icons.visibility_off,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    )
                                  : const Icon(
                                      Icons.visibility,
                                      size: 20,
                                      color: Color(0xFFAEAEAE),
                                    ),
                              onPressed: () {
                                Future.delayed(Duration.zero, () async {
                                  setState(() {
                                    isObscureConfirm = !isObscureConfirm;
                                  });
                                });
                              },
                            ),
                            isDense: true,
                            // Added this
                            contentPadding: EdgeInsets.all(14),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE4E8F1),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: Color(0xFFE5DFDF),
                              ),
                            ),

                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4.0),
                              borderSide: BorderSide(
                                width: 1,
                                color: AppTheme.darkBrown,
                              ),
                            ),
                            filled: true,
                            hintStyle: TextStyle(
                                color: Color(0xFF606162),
                                fontSize: 14,
                                fontFamily: "Montserrat"),
                            hintText: "Confirm Password",
                            fillColor: Colors.white,
                          ),
                        ),
                      ),

                      const SizedBox(height: 35),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xFFE3E3E3)),
                                    child: Center(
                                      child: Text(
                                        "Back",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                                flex: 1),
                            SizedBox(width: 15),
                            Expanded(
                                child:


                                InkWell(
                                  onTap: () {
                                    _submitHandler(context);
                                  },
                                  child: Container(
                                    height: 58,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(10),
                                    color: AppTheme.darkBrown
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(
                                            fontSize: 17,
                                            fontFamily: "Montserrat",
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),



                                flex: 1),
                          ],
                        ),
                      ),
                      SizedBox(height: 22),


                      landingUI=="mittbunny"?

                      Container(
                          padding: EdgeInsets.only(top: 120),
                          child: Lottie.asset("assets/kid_playing.json")):Container()

                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }

  void _submitHandler(BuildContext context) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    //updatePasswordProfile();
  }

  String? checkPasswordValidator(String? value) {
    if (value!.length < 6) {
      return 'Password is required';
    }
    return null;
  }
  fetchUserUI()async{

    landingUI=await MyUtils.getSharedPreferences("landing_ui");
    setState(() {

    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserUI();
  }

 /* updatePasswordProfile() async {

    APIDialog.showAlertDialog(context, "Updating Password...");
    var data={
      "password":currentPasswordController.text,
      "newpassword":newPasswordController.text,
      "newpassword_confirmation":confirmPasswordController.text,
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPIWithHeader("change-password",data,context);
    var responseJSON = json.decode(response.body);
    print(responseJSON);


    Navigator.pop(context);


    if (responseJSON['success']) {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.greenAccent);



      Navigator.pop(context);

    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }


    setState(() {});
  }*/
}
