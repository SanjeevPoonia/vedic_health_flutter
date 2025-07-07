




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import 'change_password_screen.dart';
import 'login_screen.dart';
import 'my_reviews_screen.dart';

class ProfileScreen extends StatefulWidget {

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<ProfileScreen> {
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
                          child: Text("My Account",
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

            SizedBox(height: 16),



        Expanded(child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 12),
          children: [

         Row(
           children: [

             Stack(
               children: [
                 Container(
                   width: 88,
                   height: 88,
                   decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       border: Border.all(
                           width: 2, color: Colors.white)),
                   child: Container(
                     width: 88,
                     height: 88,
                     decoration: BoxDecoration(
                       shape: BoxShape.circle,
                       image:

                       profileImage==""?

                       DecorationImage(
                           fit: BoxFit.cover,
                           image:AssetImage(
                               "assets/user_d2.png")):

                       DecorationImage(
                           fit: BoxFit.cover,
                           image:NetworkImage(
                               profileImage.toString())),
                     ),
                   ),
                 ),
                 Positioned(
                     top: 55,
                     left: 55,
                     child: GestureDetector(
                       onTap: (){
                         // _showPictureDialog();
                         //_fetchImage(context);
                       },
                       child: Container(
                         width: 30,
                         height: 30,
                         padding: EdgeInsets.all(7),
                         decoration: BoxDecoration(
                             shape: BoxShape.circle,
                             border: Border.all(
                                 color: Colors.white, width: 1),
                             color: Color(0xFFF38328)),
                         child: Image.asset("assets/edit_img.png",
                             color: Colors.white),
                       ),
                     ))
               ],
             ),

             SizedBox(width: 12),

             Expanded(child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text("John Smith",
                     style: TextStyle(
                       fontSize: 17,
                       fontWeight: FontWeight.w600,
                       color: Colors.black,
                     )),

                 SizedBox(height: 5),

                 Text("johnsmith@gmail.com",
                     style: TextStyle(
                       fontSize: 12,
                       color: Color(0xFF9D9CA0),
                     )),


               ],
             ))
           ],
         ),

            SizedBox(height: 30),

            GestureDetector(
              onTap: () async {
              /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 7,top: 7),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/profile_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("My Profile",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/doc_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Documents",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/appoint_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Appointments",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),


            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/member_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Membership",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),


            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/product_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Products",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),


            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/courses_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Courses",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),


            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/member_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Events",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),



            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/invoices_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Invoices",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/
                Navigator.push(context, MaterialPageRoute(builder: (context)=>MyReviewScreen()));

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/reviews_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("My Reviews",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/


                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordScreen()));


              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/pass_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Password Change",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Colors.black))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),

            Divider(color: Colors.grey.withOpacity(0.2)),
            GestureDetector(
              onTap: () async {

                _modalBottomLogout();
                /*  final data = await Navigator.push(context, MaterialPageRoute(builder: (context)=>SchoolDetailsScreen(profileData["school"][0],profileData["additional_data"][0],profileData["user"][0])));

                if(data!=null)
                {
                  fetchSchoolProfile();
                }*/

              },
              child: Container(
                padding: EdgeInsets.only(bottom: 5,top: 5),

                child: Row(
                  children: [
                    SizedBox(width: 5),
                    Image.asset("assets/log_tb.png",width: 40,height: 40),
                    SizedBox(width: 17),
                    Expanded(
                        child: Text("Logout",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Montserrat",
                                color: Color(0xFFBA363B)))),
                    SizedBox(width: 5),
                    Icon(Icons.arrow_forward_ios_rounded,
                        color: Colors.black, size: 16),
                    SizedBox(width: 5),
                  ],
                ),
              ),
            ),


            SizedBox(height: 20)
          ],
        ))












          ],
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


  void _modalBottomLogout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Image.asset(
                            'assets/close_icc.png',
                            width: 14,
                            height: 14,
                          )),
                      const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Lottie.asset('assets/yoga.json', height: 120, width: 120),

                      const SizedBox(height: 5),
                      Text(
                        "Logout Account !",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Are you sure you want to logout? Once you logout you need to login again.",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFE3E3E3)),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            ToastContext().init(context);
                            Navigator.of(ctx).pop();
                            Route route = MaterialPageRoute(builder: (context) => LoginScreen());
                            Navigator.pushAndRemoveUntil(
                                context, route, (Route<dynamic> route) => false);
                            Toast.show("Logged out successfully!",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.greenAccent);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.darkBrown

                            ),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }

}
