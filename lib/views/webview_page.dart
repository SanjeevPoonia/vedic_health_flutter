import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import 'package:toast/toast.dart';
import 'package:vedic_health/views/payment_success_screen.dart';

import '../utils/app_theme.dart';

class WebviewPage extends StatefulWidget {
  final String url,orderId;
  WebviewPage(this.url,this.orderId);

  @override
  _WebviewPageState createState() => _WebviewPageState();
}

class _WebviewPageState extends State<WebviewPage> {
  bool loading = true;
  late InAppWebViewController _webViewController;

  @override
  void initState() {
    super.initState();

    // _loadHTML();
  }

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            //title: new Text('Are you sure?'),
            content: new Text('Do you want to cancel this transaction ?'),
            actions: <Widget>[
               ElevatedButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
               ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }



   backIOS() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        //title: new Text('Are you sure?'),
        content:  Text('Do you want to cancel this transaction ?'),
        actions: <Widget>[
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    ));
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppTheme.themeColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_sharp,
                color: Colors.black),
            onPressed: () => backIOS(),
          ),
          title: RichText(
            text: TextSpan(
              style: TextStyle(
                fontSize: 13,
                color: Color(0xFF1A1A1A),
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: 'Payment',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),

              ],
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: InAppWebView(
                  initialOptions: InAppWebViewGroupOptions(
                      crossPlatform: InAppWebViewOptions(
                        useShouldOverrideUrlLoading: true,
                        mediaPlaybackRequiresUserGesture: false,
                        javaScriptEnabled: true,
                        javaScriptCanOpenWindowsAutomatically: true,
                      ),
                      android: AndroidInAppWebViewOptions(
                        useWideViewPort: false,
                        useHybridComposition: true,
                        loadWithOverviewMode: true,
                        domStorageEnabled: true,
                      ),
                      ios: IOSInAppWebViewOptions(
                          allowsInlineMediaPlayback: true,
                          enableViewportScale: true,
                          ignoresViewportScaleLimits: true)),
                  initialData: InAppWebViewInitialData(
                    data: _loadHTML()),
                  onWebViewCreated: (InAppWebViewController controller) {
                    _webViewController = controller;
                  },
                  onLoadError: (controller, url, code, message) {
                    print(message);
                  },
                  onLoadStop:
                      (InAppWebViewController controller, Uri? pageUri) async {
                    setState(() {
                      loading = false;
                    });
                    print(pageUri.toString());
                    final page = pageUri.toString();

                    if(page=="http://vedic.qdegrees.com:3008/order-management/paymentSuccess/"+widget.orderId.toString())
                      {

                        Toast.show('Payment Successful',
                            duration: Toast.lengthShort,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.green);
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentSuccessScreen(widget.orderId)),
                                (Route<dynamic> route) => false);
                      }
                  /*  else if(
                    page==UrlList.cancelUrl
                    )
                      {
                        Toast.show('Payment Failed',
                            duration: Toast.lengthShort,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);
                      }*/





       /*             if (page == widget.data?.cancelUrl ||
                        page == widget.data?.redirectUrl) {
                      var html = await controller.evaluateJavascript(
                          source:
                              "window.document.getElementsByTagName('html')[0].outerHTML;");

                      String html1 = html.toString();
                      print(html1);
                      if (html1.contains('<body>')) {
                        html1 = html1.split('<body>')[1].split('</body>')[0];

                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) =>
                                    PaymentSuccessScreen(widget.orderId)),
                                (Route<dynamic> route) => false);
                      }
                    }*/
                  },
                ),
              ),
              (loading)
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Center(),
            ],
          ),
        ),
      ),
    );
  }

  String _loadHTML() {
    final url = widget.url;
 /*   final command = "initiateTransaction";
    final encRequest = widget.encValue;
    final accessCode = widget.accesCode;*/

    String html =
        "<html> <head><meta name='viewport' content='width=device-width, initial-scale=1.0'></head> <body onload='document.f.submit();'> <form id='f' name='f' method='post' action='$url'>";
          /*  "<input type='hidden' name='command' value='$command'/>" +
            "<input type='hidden' name='encRequest' value='$encRequest' />" +
            "<input  type='hidden' name='access_code' value='$accessCode' />";*/
    print(html);
    return html + "</form> </body> </html>";
  }
}
