
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/payment_success_screen.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../network/loader.dart';
import '../widgets/appbar_widget.dart';


class WebViewWordDoc extends StatefulWidget
{
  final String url;
  final String orderID;
  WebViewWordDoc(this.url,this.orderID);
  PrivacyPolicyState createState()=>PrivacyPolicyState();
}
class PrivacyPolicyState extends State<WebViewWordDoc> {
  bool isLoading=true;
  late final WebViewController _controller;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {

          Navigator.pop(context);


          return Future.value(false);
        },
        child: Scaffold(
         // backgroundColor: Colors.transparent,
          body:

          Column(
            children: [


              AppBarWidget("Payment"),



              Expanded(
                child:
                isLoading?
                Center(
                  child: Loader(),
                ):


                WebViewWidget(
                  controller: _controller,
                ),
              ),
            ],
          ),



        ),
      ),
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.url);
    _controller = WebViewController()
    ..enableZoom(true)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading=true;
            });
          },
          onPageFinished: (String url) {

            setState(() {
              isLoading=false;
            });


          },

          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {

            print("***&&&");
            print(request.url.toString());


            if (request.url.toString().startsWith("http://vedic.qdegrees.com:3008/order-management/paymentSuccess")) {

              ToastContext().init(context);

              Toast.show('Payment Successful',
                  duration: Toast.lengthShort,
                  gravity: Toast.bottom,
                  backgroundColor: Colors.green);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                      builder: (context) =>
                          PaymentSuccessScreen(widget.orderID)),
                      (Route<dynamic> route) => false);



              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }
// /initialUrl: 'https://aha-me.com/aha/terms_and_conditions',

/*JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    return JavascriptChannel(
        name: 'Toaster',
        onMessageReceived: (JavascriptMessage message) {
          // ignore: deprecated_member_use
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        });
  }*/
}