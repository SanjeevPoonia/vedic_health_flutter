

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/network/Utils.dart';
import 'package:vedic_health/views/authentication/login_screen.dart';
import 'package:vedic_health/views/login_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget
{
  final String token;
  SplashScreen(this.token);
  SplashState createState()=>SplashState();
}
class SplashState extends State<SplashScreen>
{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 140,
          height: 140,
          child: Image.asset("assets/vedic_health.png"),
        )
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _navigateUser();

  }

  _navigateUser() async {
    if(widget.token!='')
    {

      String role= await MyUtils.getSharedPreferences("role")??"";
      print("role**********$role");
      if(role=="practitioner"){
        Timer(
          Duration(seconds: 2),
              () => Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => PractitionerHomeScreen())));
      }else{
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => HomeScreen())));
      }
      //change



    }
    else
      {
        Timer(
            Duration(seconds: 2),
                () => Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (BuildContext context) => VedicHealthLoginScreen()
                )));
      }

  }
}
