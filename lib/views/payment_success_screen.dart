import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/order_model.dart';
import 'package:vedic_health/views/home_screen.dart';

import '../network/api_helper.dart';
import '../utils/app_theme.dart';



class PaymentSuccessScreen extends StatefulWidget {
  final String orderId;
  final int paymentType;
  const PaymentSuccessScreen(this.orderId,this.paymentType, {super.key});
  _paymentSuccessState createState()=> _paymentSuccessState();
}
class _paymentSuccessState extends State<PaymentSuccessScreen>{
  bool isLoading=false;

  String OrderStatus="Payment Successful.";
  bool isSuccess=true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading?Center(child: Loader(),):Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
              height: 200,
              child: OverflowBox(
                minHeight: 320,
                maxHeight: 320,
                child: Lottie.asset('assets/check_animation.json'),
              )),
          Text(widget.paymentType==1?"Thank You for registering":widget.paymentType==2?"Thank You for booking Appointment":OrderStatus,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text(widget.paymentType==1?"You registered successfully":widget.paymentType==2?"Your appointment booked successfully":'Order ID # ${widget.orderId}',
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

  @override
  void initState() {
    super.initState();
    print("***************Enter on thank you page*************");
    if(widget.paymentType!=1){
      orderSuccess();
    }

  }
  orderSuccess() async {

    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPIForNormalResponse(
        'order-management/paymentSuccess/${widget.orderId}', context);

    var responseJSON = json.decode(response.body);

    print(response.body.toString());
    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
    }
    setState(() {});
  }

  bookEventTicket() async {

    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPIForNormalResponse(
        'Events/Thankyou/${widget.orderId}', context);

    var responseJSON = json.decode(response.body);

    print(response.body.toString());
    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
    }
    setState(() {});
  }
}
