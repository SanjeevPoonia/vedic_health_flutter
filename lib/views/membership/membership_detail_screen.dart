import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:html/parser.dart' show parse;
import 'package:vedic_health/widgets/notification_bar_widget.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../word_webview_screen.dart';

class MembershipDetailScreen extends StatefulWidget {
  var plan;

  MembershipDetailScreen(this.plan, {super.key});

  @override
  State<MembershipDetailScreen> createState() => _MembershipDetailScreenState();
}

class _MembershipDetailScreenState extends State<MembershipDetailScreen> {
  int quantity = 1;

  List<dynamic> details = [];

  String planId="";
  String title="";
  String price="0";
  int expiresIn=0;
  String userId="";
  bool isLoading=false;
  String planDescription="";
  String planImage="";



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading?Center(child: Loader(),):
            Column(
              children: [
                NotificationBarWidget(),
                Expanded(child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      /// Top Image
                      SizedBox(
                        height: 250,
                        width: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: planImage,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                          const Icon(Icons.error, color: Colors.red),
                        ),
                      ),

                      /// Back + Share Buttons
                      Positioned(
                        top: 12,
                        left: 12,
                        child: _circleIconButton(
                          icon: Icons.arrow_back_ios_new,
                          onTap: () => Navigator.pop(context),
                        ),
                      ),
                      /*Positioned(
                top: 12,
                right: 12,
                child: _circleIconButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                ),
              ),*/

                      /// Scrollable Rounded White Container
                      Container(
                        margin: const EdgeInsets.only(top: 220),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        ),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// Title
                              Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 16),

                              /* /// Quantity Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Quantity",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Row(
                              children: [
                                _qtyButton(Icons.remove, () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
                                    });
                                  }
                                }),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0),
                                  child: Text(
                                    "$quantity",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                _qtyButton(Icons.add, () {
                                  setState(() {
                                    quantity++;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),*/

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Plan For",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Spacer(),
                                  Text(
                                    "$expiresIn days",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black
                                    ),
                                  ),


                                ],
                              ),

                              const SizedBox(height: 12),

                              /// Price Row
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children:  [
                                  const Text(
                                    "Price",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "\$ $price",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00BE55),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              Divider(),
                              const SizedBox(height: 10),
                              /// Details Header
                              const Text(
                                "Description",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                planDescription.isNotEmpty?parseHtmlString(planDescription):"Description not available",
                                style:  TextStyle(
                                  fontSize: 14,
                                  color: planDescription.isNotEmpty?Colors.black:Colors.grey,

                                ),
                              ),

                              const SizedBox(height: 10),
                              Divider(),
                              const SizedBox(height: 10),

                              /// Details Header
                              const Text(
                                "Details",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),

                              const SizedBox(height: 12),

                              /// Details List
                              details.isNotEmpty? ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: details.length,
                                itemBuilder: (context, index) {
                                  String pId=details[index]['_id']?.toString()??"";
                                  String pTitle=details[index]['title']?.toString()??"";
                                  String pDescripton=details[index]['description']?.toString()??"";
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Icon(Icons.check,
                                            color: Colors.green, size: 20),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            pTitle,
                                            style: const TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ):
                              const Text(
                                "Details not available",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
              ],
            ),

        /// Sticky Bottom Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {
              placeOrder();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
  }
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
      ),
    );
  }
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void>_loadUserData()async{
    setState(() {
      isLoading=true;
    });
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    var plan = widget.plan;
    planId=plan['_id']?.toString()??"";
    title=plan['plan_name']?.toString()??"";
    price=plan['price']?.toString()??"0";
    expiresIn=plan['expiring_in']??0;
    planDescription=plan['plan_description']?.toString()??"";
    String img=plan['image']?.toString()??"";
    if(img.isNotEmpty){
      planImage=AppConstant.appBaseURL+img;
    }
    details=(plan['plan_details'] as List?)??[];
    setState(() {
      isLoading=false;
    });
  }
  placeOrder() async {
    APIDialog.showAlertDialog(context, "Please wait...");

    var data= {
      "_id": planId,
      "user_id": userId,
    };
    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'membership_buy_management/paymentLink', requestModel, context);
    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    if (responseJSON['statusCode'] == 201) {
      Toast.show(responseJSON['data']?['message']?.toString()??"Course Placed",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      String paymentUrl = responseJSON['data']?["paymentUrl"]?.toString()??"";
      String orderId= responseJSON['data']?["orderId"]?.toString()??"NA";
      if(paymentUrl.isNotEmpty && orderId !="NA"){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewWordDoc(paymentUrl, orderId)));
      }


    } else {
      Toast.show(responseJSON['messages'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }
}
