import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';

class PractitionerPaymentSuccessScreen extends StatefulWidget{
  final String orderId;
  final int paymentType;
  const PractitionerPaymentSuccessScreen(this.orderId,this.paymentType, {super.key});
  _practPaymentSuccess createState()=>_practPaymentSuccess();
}
class _practPaymentSuccess extends State<PractitionerPaymentSuccessScreen>{
  bool isLoading=false;

  String OrderStatus="Payment Successful.";
  bool isSuccess=true;
  String paymentTitle="";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isLoading?SizedBox(
              height: 200,
              child: OverflowBox(
                minHeight: 320,
                maxHeight: 320,
                child: Lottie.asset('assets/waiting_payment.json'),
              )):
          SizedBox(
              height: 200,
              child: OverflowBox(
                minHeight: 320,
                maxHeight: 320,
                child: isSuccess?Lottie.asset('assets/check_animation.json'):Lottie.asset('assets/failed_order.json'),
              )),
          Text(isLoading?"Please Wait...":paymentTitle,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF345D7C),
              ),
              textAlign: TextAlign.center),
          SizedBox(height: 10),
          Text(widget.paymentType==1?
          "You registered successfully":
          widget.paymentType==2?
          "Your appointment booked successfully":
          'Order ID # ${widget.orderId}',
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
                  Route route = MaterialPageRoute(builder: (context) => PractitionerHomeScreen());
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

    if(widget.paymentType==1){
      paymentTitle="Thank You for registering";
    }else if(widget.paymentType==2){
      paymentTitle="Thank You for booking Appointment";
    }else if(widget.paymentType==3){
      paymentTitle="Thank you for purchasing the course! We’re excited to have you with us.";
    }else if(widget.paymentType==4){
      paymentTitle="Thank you for purchasing the Membership! We’re excited to have you with us.";
    }else{
      paymentTitle=OrderStatus;
    }
    setState(() {});
    if(widget.paymentType==3){
      CourseSuccess();
    }else if(widget.paymentType==4){
      MembershipSuccess();
    }else if(widget.paymentType!=1){
      orderSuccess();
    }

  }




  orderSuccess() async {

    setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();

    try{
      var response = await helper.getAPIForNormalResponse(
          'order-management/paymentSuccess/${widget.orderId}', context);
      print("RAW RESPONSE:");
      print(response.body);

      if (response.body.trim().startsWith('<')) {
        isSuccess = true;
        OrderStatus = "Order placed successfully";
        paymentTitle = OrderStatus;
      } else {
        final responseJSON = jsonDecode(response.body);
        if (responseJSON['statusCode'] != null && responseJSON['statusCode'] == 400) {
          isSuccess = false;
          OrderStatus = responseJSON['message'].toString();
          paymentTitle = OrderStatus;
        } else {
          isSuccess = true;
          OrderStatus = responseJSON['message'] ?? "Order placed successfully";
          paymentTitle = OrderStatus;
        }
      }


    }catch(e){
      print('ERROR: $e');
      isSuccess=false;
      OrderStatus="Something went wrong";
      paymentTitle=OrderStatus;
    }

    /* var responseJSON = json.decode(response.body);
    print(response.body.toString());
    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
      paymentTitle=OrderStatus;
    }*/
    setState(() {
      isLoading=false;
    });


  }
  CourseSuccess() async {

    setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();


    try{
      var response = await helper.getAPIForNormalResponse(
          'course_management/paymentSuccess/${widget.orderId}', context);
      print("RAW RESPONSE:");
      print(response.body);

      if (response.body.trim().startsWith('<')) {
        isSuccess = true;
        OrderStatus = "Thank you for purchasing the course! We’re excited to have you with us.";
        paymentTitle = OrderStatus;
      } else {
        final responseJSON = jsonDecode(response.body);
        if (responseJSON['statusCode'] != null && responseJSON['statusCode'] == 400) {
          isSuccess = false;
          OrderStatus = responseJSON['message'].toString();
          paymentTitle = OrderStatus;
        } else {
          isSuccess = true;
          OrderStatus = responseJSON['message'] ?? "Thank you for purchasing the course! We’re excited to have you with us.";
          paymentTitle = OrderStatus;
        }
      }


    }catch(e){
      print('ERROR: $e');
      isSuccess=false;
      OrderStatus="Something went wrong";
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });
    /* var responseJSON = json.decode(response.body);

    print(response.body.toString());



    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });*/
  }
  MembershipSuccess() async {

    setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();


    try{
      var response = await helper.getAPIForNormalResponse(
          'membership_buy_management/paymentSuccess/${widget.orderId}', context);
      print("RAW RESPONSE:");
      print(response.body);

      if (response.body.trim().startsWith('<')) {
        isSuccess = true;
        OrderStatus = "Thank you for purchasing the Membership! We’re excited to have you with us.";
        paymentTitle = OrderStatus;
      } else {
        final responseJSON = jsonDecode(response.body);
        if (responseJSON['statusCode'] != null && responseJSON['statusCode'] == 400) {
          isSuccess = false;
          OrderStatus = responseJSON['message'].toString();
          paymentTitle = OrderStatus;
        } else {
          isSuccess = true;
          OrderStatus = responseJSON['message'] ?? "Thank you for purchasing the Membership! We’re excited to have you with us.";
          paymentTitle = OrderStatus;
        }
      }


    }catch(e){
      print('ERROR: $e');
      isSuccess=false;
      OrderStatus="Something went wrong";
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });


    /*setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPIForNormalResponse(
        'membership_buy_management/paymentSuccess/${widget.orderId}', context);

    var responseJSON = json.decode(response.body);

    print(response.body.toString());
    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });*/
  }
  bookEventTicket() async {
    setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();


    try{
      var response = await helper.getAPIForNormalResponse(
          'Events/Thankyou/${widget.orderId}', context);
      print("RAW RESPONSE:");
      print(response.body);

      if (response.body.trim().startsWith('<')) {
        isSuccess = true;
        OrderStatus = "Thank you for purchasing the Membership! We’re excited to have you with us.";
        paymentTitle = OrderStatus;
      } else {
        final responseJSON = jsonDecode(response.body);
        if (responseJSON['statusCode'] != null && responseJSON['statusCode'] == 400) {
          isSuccess = false;
          OrderStatus = responseJSON['message'].toString();
          paymentTitle = OrderStatus;
        } else {
          isSuccess = true;
          OrderStatus = responseJSON['message'] ?? "Thank you for purchasing the Membership! We’re excited to have you with us.";
          paymentTitle = OrderStatus;
        }
      }


    }catch(e){
      print('ERROR: $e');
      isSuccess=false;
      OrderStatus="Something went wrong";
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });

    /*setState(() {
      isLoading=true;
    });
    print("***************API function*************");
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPIForNormalResponse(
        'Events/Thankyou/${widget.orderId}', context);

    var responseJSON = json.decode(response.body);

    print(response.body.toString());
    if(responseJSON['statusCode']!=null && responseJSON['statusCode']==400){
      isSuccess=false;
      OrderStatus=responseJSON['message'].toString();
      paymentTitle=OrderStatus;
    }
    setState(() {
      isLoading=false;
    });*/
  }
}
