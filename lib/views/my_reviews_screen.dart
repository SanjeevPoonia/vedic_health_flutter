




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class MyReviewScreen extends StatefulWidget {

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyReviewScreen> {
  int selectedIndex = 0;
  int selectedSortIndex = 0;
  var selectDOB = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  String? profileImage = "";

  String selectedAddressID="";
  final List<String> tabs = ["Category", "Brand"];

  List<bool> categoryCheckList=[false,false,false,false];
  List<bool> brandCheckList=[false,false,false,false];

  List<String> categoryList=[
    "All Categories (390)",
    "Health & Beauty (195)",
    "Health Care (195)",
    "Personal Care (0)"
  ];
  int selectedTab = 1;

  List<String> brandList=[
    "Auromere",
    "Thorne",
    "J. Crow's",
    "Kerala Ayurveda"
  ];
  List<String> sortList=[
    "Most Popular",
    "High to Low",
    "Low to High",
    "Highly Rated"
  ];
  double shippingCost=0;

  int selectedRadioButton=0;

  bool checkToggle=false;

  bool isLoading=false;
  List<dynamic> addressList=[];
  List<dynamic> centersList=[];





  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: Colors.red,
        body: Column(
          children: [
            Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
              ),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20), // Adjust the radius as needed
                    bottomRight: Radius.circular(20), // Adjust the radius as needed
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [



                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                        },
                        child:Icon(Icons.arrow_back_ios_new_sharp,size: 17,color: Colors.black)),




                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("My Reviews",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),







/*

                    GestureDetector(
                      onTap: (){


                      },
                      child: Image.asset("assets/cart_bag.png",width: 39,height: 39)
                    )
*/




                  ],
                ),
              ),
            ),

            SizedBox(height: 12),

            Expanded(child:   ListView.builder(
                itemCount: 4,
                padding: EdgeInsets.symmetric(horizontal: 10),
                itemBuilder: (BuildContext context, int pos) {
                  return Column(
                    children: [
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundImage: AssetImage(
                                    "assets/user_d2.png"),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text("Smith Jhons",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight:
                                            FontWeight.w600,
                                            color: Colors.black
                                                .withOpacity(0.92),
                                          )),
                                      SizedBox(height: 3),
                                      Text("Reviewed on Reviewed on 18 July 2022",
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Color(0xFF898989)
                                                .withOpacity(0.92),
                                          )),
                                    ],
                                  )),
                              SizedBox(width: 5),


                        ],
                                      ),

                          SizedBox(height: 12),

                          Row(
                            children: [
                              StarRating(
                                rating: 4.5,
                                allowHalfRating: true,
                                color: Color(0xFFF4AB3E),
                                borderColor: Color(0xFFF4AB3E),
                                onRatingChanged: (rating) =>
                                    null,
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 5),
                            child: Text(
                                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.black
                                      .withOpacity(0.92),
                                )),
                          ),


                          SizedBox(height: 22),
                          Row(
                            children: [
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(3),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          "assets/banner2.png",
                                        ))),
                              ),
                              SizedBox(width: 12),
                              Container(
                                width: 68,
                                height: 68,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(3),
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                          "assets/banner2.png",
                                        ))),
                              ),
                            ],
                          ),
                          SizedBox(height: 22)


                        ]),

                      SizedBox(height: 12)
                    ],
                  );
















          }))],
        ),
      ),
    );
  }



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  // Successurl
  //http://vedic.qdegrees.com:3008/order-management/paymentSuccess/682dff96a56e642c84ea1a4f
  fetchAddress() async {

    setState(() {
      isLoading = true;
    });



    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {"user":userId.toString()};


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/all-address', requestModel, context);



    setState(() {
      isLoading = false;
    });


    var responseJSON = json.decode(response.toString());
    print(response.toString());

    addressList = responseJSON["data"]["data"];

    if(addressList.length!=0)
      {
        selectedAddressID=addressList[0]["_id"].toString();
      }












    setState(() {});
  }




}
