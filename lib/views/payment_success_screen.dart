import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/views/home_screen.dart';

import '../utils/app_theme.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final String orderId;
  PaymentSuccessScreen(this.orderId);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200,
              child: OverflowBox(
                minHeight: 320,
                maxHeight: 320,
                child: Lottie.asset('assets/check_animation.json'),
              )),
          Text('Payment Successful',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text('Order ID # '+orderId,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black,
              )),
          SizedBox(height: 35),
          Container(
            width: double.infinity,
            height: 50,
            margin: EdgeInsets.symmetric(horizontal: 90),
            child: ElevatedButton(
                child: Text('Back to Home',
                    style: TextStyle(color: Colors.white, fontSize: 14)),
                style: ButtonStyle(
                    foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white),
                    backgroundColor:
                    MaterialStateProperty.all<Color>(AppTheme.darkBrown),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ))),
                onPressed: () {



                   Route route = MaterialPageRoute(builder: (context) => HomeScreen());
      Navigator.pushAndRemoveUntil(
          context, route, (Route<dynamic> route) => false);
                }),
          ),
        ],
      ),
    );
  }




}
