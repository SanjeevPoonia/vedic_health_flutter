




import 'dart:convert';
import 'dart:ui';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import 'package:vedic_health/views/select_delivery_address_screen.dart';
import 'package:vedic_health/views/webview_page.dart';
import 'package:vedic_health/views/word_webview_screen.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class AddressScreen extends StatefulWidget {
  final List<String> cartIDs;
  AddressScreen(this.cartIDs);
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddressScreen> {
  int selectedIndex = 0;
  List<dynamic> ratesList=[];
  int selectedSortIndex = 0;
  String selectedShippingDrop="Select Shipping method";
  int selectedShippingIndex = 9999;
  var selectDOB = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  bool addressLoader=false;
  String selectedAddressID="";
  final List<String> tabs = ["Category", "Brand"];

  List<bool> categoryCheckList=[false,false,false,false];
  List<bool> brandCheckList=[false,false,false,false];
  int selectedAddressIndex=9999;

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

  var couponController=TextEditingController();







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
                          child: Text("Address Details",
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


            Expanded(child:
            isLoading?

                Center(
                  child: Loader(),
                ):



            ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [


                Stack(
                  children: [

                    Row(
                      children: [
                        Expanded(
                          flex:1,
                          child: Container(
                            height: 8,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: AppTheme.lightGreen
                            ),
                          ),
                        ),


                        Expanded(
                          flex:1,
                          child: Container(
                            height: 8,
                            margin: EdgeInsets.only(top: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(1),
                                color: Color(0xFFC4C4C4)
                            ),
                          ),
                        ),
                      ],
                    ),


                    Row(
                      children: [

                        Expanded(child: SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,
                                // margin: EdgeInsets.only(right: 25),

                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00DB00),
                                  border: Border.all(width: 1,color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 6,
                                      color: Color(0xFF00DB00).withOpacity(0.5),
                                    ),
                                  ],

                                ),
                              ),
                            ],
                          ),
                        ),flex: 1,),

                        Expanded(child: SizedBox(
                          child: Row(
                            children: [
                              Container(
                                width: 18,
                                height: 18,


                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xFF00DB00),
                                  border: Border.all(width: 1,color: Colors.white),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: Offset(0, 1),
                                      blurRadius: 6,
                                      color: Color(0xFF00DB00).withOpacity(0.5),
                                    ),
                                  ],

                                ),
                              ),
                            ],
                          ),
                        ),flex: 1,)

                      ],
                    )



                  ],
                ),


                SizedBox(height: 10),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Text("Bag",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),


                    Container(
                      margin: EdgeInsets.only(left: 40),
                      child: Text("Address",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF00DB00),
                          )),
                    ),


                    Text("Payment",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                  ],
                ),

                SizedBox(height: 25),





                Text("Shipping Information",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
                SizedBox(height: 15),

                Container(
                  height: 59,
                  width: double.infinity,
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color(0xFFF2F5F9),
                      borderRadius: BorderRadius.circular(70)),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 1;
                            });
                          },
                          child: Container(
                            height: 48,
                            width: 128,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: selectedTab == 1
                                    ? Colors.white
                                    : Color(0xFFF2F5F9),
                                borderRadius: selectedTab == 1
                                    ? BorderRadius.circular(70)
                                    : BorderRadius.circular(70)),
                            child: Center(
                              child: Text("Ship to Address",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: selectedTab == 1
                                          ? Colors.black
                                          : Color(0XFF9D9CA0))),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 2;
                            });
                          },
                          child: Container(
                            height: 48,
                            width: 128,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: selectedTab == 2
                                    ? Colors.white
                                    : Color(0xFFF2F5F9),
                                borderRadius: selectedTab == 2
                                    ? BorderRadius.circular(70)
                                    : BorderRadius.circular(70)),
                            child: Center(
                              child: Text("In - Store Pickup",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: selectedTab == 2
                                          ? Colors.black
                                          : Color(0XFF9D9CA0))),
                            ),
                          ),
                        ),
                      ),
                      /*Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedTab = 3;
                            });
                          },
                          child: Container(
                            height: 48,
                            width: 128,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                color: selectedTab == 3
                                    ? Colors.white
                                    : Color(0xFFEEEDF2),
                                borderRadius: selectedTab == 3
                                    ? BorderRadius.circular(70)
                                    : BorderRadius.circular(0)),
                            child: Center(
                              child: Text("Documents",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      color: selectedTab == 3
                                          ? Colors.black
                                          : Color(0XFF9D9CA0))),
                            ),
                          ),
                        ),
                      ),*/
                    ],
                  ),
                ),


                SizedBox(height: 25),


                selectedTab==2?

                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Pick Up Your Order At:",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),



                      SizedBox(height: 17),



                      centersList.length==0?Text("No centers found!"):

                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xFFF3FEF8),
                            border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                        ),


                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset("assets/loc_ic.png",width: 24,height: 35.03),
                            ),

                            SizedBox(width: 12),

                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),







                                Text(centersList[0]["address"].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.92),
                                    )),



                              ],
                            ))







                          ],
                        ),



                      ),

                      SizedBox(height: 17),
                      DateFieldWidget3(
                        "Date To Pickup",
                        "Select",
                        controller: selectDOB,
                        rightIcon: Icon(Icons.calendar_month_outlined,
                            color: Colors.black),
                        isDatePicker: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2100));

                          if (pickedDate != null) {
                            String formattedDate =
                            DateFormat('yyyy-MM-dd').format(pickedDate);
                            selectDOB.text = formattedDate.toString();
                            setState(() {});
                          }
                          print('Dropdown tapped');
                        },
                      ),



                    ],
                  ),
                ):






                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text("Select Shipping Address",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),

                      SizedBox(height: 17),


                      Row(
                        children: [


                          Expanded(child: Container(

                            height: 54,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color:selectedRadioButton==0? Color(0xFFFAF2EA):Colors.white,
                                border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                            ),


                            child: Row(
                              children: [

                                SizedBox(width: 13),


                                Container(
                                  child:   selectedRadioButton!=0?GestureDetector(
                                      onTap:(){

                                        print("Clicked");



                                        setState(() {
                                          selectedRadioButton=0;
                                        });



                                      },

                                      child: Icon(Icons.radio_button_off,color: Color(0xFF9D9CA0))):

                                  Icon(Icons.radio_button_checked,color: AppTheme.darkBrown),
                                ),

                                SizedBox(width:10),

                                Text(


                                    addressList.length==0?"No address":addressList[selectedAddressIndex]["name"],
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),









                              ],
                            ),


                          ),flex: 1),

                          SizedBox(width: 12),
                          Expanded(child: GestureDetector(
                            onTap: () async{
                              final data= await Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectDeliveryAddressScreen(selectedAddressID)));

                              if(data!=null)
                              {
                                selectedAddressID=data.toString();
                                fetchAddress(false);
                              }

                            },
                            child:
                            Container(
                              height: 54,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  color: Color(0xFFB65303)
                              ),
                              child: Center(
                                child: Text("Select Address",
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),flex: 1),

                        ],
                      ),


                      SizedBox(height: 22),

                      addressList.length!=0?


                          addressLoader?

                              Container(
                                height: 100,
                                child: Center(
                                  child: Loader(),
                                ),
                              ):




                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xFFF3FEF8),
                            border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                        ),


                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Image.asset("assets/loc_ic.png",width: 24,height: 35.03),
                            ),

                            SizedBox(width: 12),

                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Text(addressList[selectedAddressIndex]["name"],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    )),

                                SizedBox(height: 2),



                                Text(addressList[selectedAddressIndex]["area"].toString()+","+addressList[selectedAddressIndex]["city"].toString()+","+addressList[selectedAddressIndex]["state"].toString()+","+addressList[selectedAddressIndex]["country"].toString()+"-"+addressList[selectedAddressIndex]["pincode"].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.92),
                                    )),


                                SizedBox(height: 5),

                                Text(addressList[selectedAddressIndex]["mobile"].toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),


                              ],
                            ))







                          ],
                        ),



                      ):Container(),

                    ],
                  ),
                ),




                SizedBox(height: 28),


                selectedTab==1?
                GestureDetector(
                  onTap: (){

                    calculateShippingCharges();
                  },
                  child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Color(0xFFB65303)
                      ),
                      child: Center(
                        child:
                        Text("Calculate Shipping Cost",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            )),
                      )
                  ),
                ):Container(),


                selectedTab==1?

                SizedBox(height: 22):Container(),




                selectedTab==1 && ratesList.length!=0?
                Row(
                  children: [
                    Text("Select Shipping Method",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    
                    Spacer(),
                    
                    Image.asset("assets/logo_ship.png",height: 18,width: 110)
                    
                    
                  ],
                ):Container(),



                selectedTab==1 && ratesList.length!=0?
                SizedBox(height: 12):Container(),




                selectedTab==1 && ratesList.length!=0?
                GestureDetector(
                  onTap: (){
                    shippingOptionsBottomSheet(context);
                  },
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color:Colors.white,
                        border: Border.all(color: Color(0xFFE2E2E2),width: 1)
                    ),


                    child: Row(
                      children: [

                        SizedBox(width: 13),


                        Text(
                          selectedShippingDrop=="Select Shipping method"?
                            "Select Shipping method":selectedShippingDrop.toString(),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: selectedShippingDrop=="Select Shipping method"? Color(0xFFA0A0A0).withOpacity(0.92):Colors.black..withOpacity(0.92),
                            )),


                        Spacer(),

                        Icon(Icons.keyboard_arrow_down_outlined,size: 23,color: Colors.black),

                        SizedBox(width: 12),








                      ],
                    ),


                  ),
                ):Container(),



                selectedTab==1 && ratesList.length!=0?
                SizedBox(height: 15):Container(),

                Text("Promo Code",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),

                SizedBox(height: 17),


              Row(
                children: [

                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                          color:  Colors.white,
                          border: Border.all(color: Color(0xFFEBD8D8),width: 1),
                          borderRadius:
                          BorderRadius.circular(6)),
                      child: TextFormField(
                        controller: couponController,
                          style: const TextStyle(
                            fontSize: 15.0,
                            height: 1.6,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'Enter coupon code',
                            contentPadding:
                            EdgeInsets.only(left: 10,bottom: 5),
                            fillColor: Colors.white,
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                              fontSize: 13.0,
                              color: Colors.grey,
                            ),
                          )),
                    ),
                  ),

                  SizedBox(height: 15),


                  GestureDetector(
                    onTap: () {
                   /*   if(couponController.text=="")
                      {
                        Toast.show("Coupon name cannot be empty !",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.red);
                      }
                      else
                      {
                        //applyCoupon();
                      }
*/




                    },
                    child: Container(
                      height: 48,
                     // margin: const EdgeInsets.only(right: 15),
                      decoration: BoxDecoration(
                          color: AppTheme.darkBrown,
                          border: Border.all(color: AppTheme.darkBrown,width: 1),
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(6),
                              topRight: Radius.circular(6))),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 18),
                          child: Text('Apply',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    ),
                  ),

                ],
              ),


                SizedBox(height: 21),

/*
                Text("Gift Card",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),

                SizedBox(height: 14),


                Row(
                  children: [

                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color:  Colors.white,
                            border: Border.all(color: Color(0xFFEBD8D8),width: 1),
                            borderRadius:
                            BorderRadius.circular(6)),
                        child: TextFormField(
                            style: const TextStyle(
                              fontSize: 15.0,
                              height: 1.6,
                              color: Colors.black,
                            ),
                            decoration: const InputDecoration(
                              hintText: '',
                              contentPadding:
                              EdgeInsets.only(left: 10,bottom: 5),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey,
                              ),
                            )),
                      ),
                    ),


                  ],
                ),


                SizedBox(height: 21),*/


                Text("Billing Address",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),

                SizedBox(height: 18),


                Row(
                  children: [

                    GestureDetector(
                        onTap: (){
                          setState(() {
                            checkToggle=!checkToggle;
                          });

                          if(checkToggle && addressList.length!=0)
                            {
                              addressLine1Controller.text=addressList[selectedAddressIndex]["area"].toString()+","+addressList[selectedAddressIndex]["city"].toString()+","+addressList[selectedAddressIndex]["state"].toString()+","+addressList[selectedAddressIndex]["country"].toString()+"-"+addressList[selectedAddressIndex]["pincode"].toString();
                            }
                          else
                            {
                              addressLine1Controller.text="";
                            }
                        },

                        child:checkToggle? Icon(Icons.check_box,color: AppTheme.themeColor):Icon(Icons.check_box_outline_blank_outlined)),

                    SizedBox(width:8),
                    Text("Same as shipping address",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),





                  ],
                ),


                SizedBox(height: 18),

                Row(
                  children: [

                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color:  Colors.white,
                            border: Border.all(color: Color(0xFFEBD8D8),width: 1),
                            borderRadius:
                            BorderRadius.circular(6)),
                        child: TextFormField(
                            style: const TextStyle(
                              fontSize: 15.0,
                              height: 1.6,
                              color: Colors.black,
                            ),
                            controller: addressLine1Controller,
                            decoration:  InputDecoration(
                              hintText: 'Address Line 1',
                              contentPadding:
                              EdgeInsets.only(left: 10,bottom: 5),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFFA0A0A0).withOpacity(0.92),
                              ),
                            )),
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 15),


                Row(
                  children: [

                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                            color:  Colors.white,
                            border: Border.all(color: Color(0xFFEBD8D8),width: 1),
                            borderRadius:
                            BorderRadius.circular(6)),
                        child: TextFormField(
                            style: const TextStyle(
                              fontSize: 15.0,
                              height: 1.6,
                              color: Colors.black,
                            ),
                            controller: addressLine2Controller,
                            decoration:  InputDecoration(
                              hintText: 'Address Line 2(Optional)',
                              contentPadding:
                              EdgeInsets.only(left: 10,bottom: 5),
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                fontSize: 13.0,
                                color: Color(0xFFA0A0A0).withOpacity(0.92),
                              ),
                            )),
                      ),
                    ),


                  ],
                ),
                SizedBox(height: 28),


              ],
            )),



            Container(
              height: 88,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 6,
                    color: Color(0xFFD6D6D6),
                  ),
                ],

              ),

              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Row(
                children: [





                  Expanded(child: GestureDetector(
                    onTap: (){

                      if(selectedTab==1)
                        {

                          if(addressList.length==0)
                            {
                              Toast.show("Please select an address to continue!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          else if(selectedShippingIndex==9999)
                            {
                              Toast.show("Please select a shipping method!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          else
                            {
                              placeOrder();
                            }


                        }
                      else if(selectedTab==2)
                        {
                          if(selectDOB.text=="")
                            {
                              Toast.show("Please select a Pickup Date!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }
                          else
                            {
                              placeOrder();
                            }
                        }






                    },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Color(0xFFB65303)
                      ),
                      child: Center(
                        child:
                        Text("Payment",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      )
                    ),
                  ),flex: 1),











                ],
              ),


            )











          ],
        ),
      ),
    );
  }

  void shippingOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
     // isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height-150,
                child: Stack(
                  children: [





                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text('Select Shipping Method',
                                  style: TextStyle(
                                      fontSize: 19,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                            ),
                            const Spacer(),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(Icons.clear,color: Color(0xFFAFAFAF),)),
                            const SizedBox(width: 15)
                          ],
                        ),
                        SizedBox(height: 25),

                        Expanded(
                          child: Container(
                           // height: 150,
                            child: ListView.builder(
                                itemCount: ratesList.length,
                                itemBuilder: (BuildContext context,int pos)

                            {

                              return GestureDetector(
                                onTap: (){



                                  setModalState(() {
                                    selectedShippingIndex=pos;
                                  });
                                  

                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 10,bottom: 10,left: 13,right: 10),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      
                                      selectedShippingIndex==pos?
                                      Icon(Icons.radio_button_checked,color: AppTheme.darkBrown):Icon(Icons.radio_button_off,color: Color(0xFF707070)),

                                      SizedBox(width: 12),

                                      Expanded(child: RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:Colors.black.withOpacity(0.6),
                                          ),
                                          children: <TextSpan>[
                                             TextSpan(
                                              text: ratesList[pos]["duration_terms"] ,
                                            ),


                                             TextSpan(
                                              text: '\$'+ratesList[pos]["amount"].toString(),
                                              style: const TextStyle(fontSize: 16, color: Color(0xFFF38328),fontWeight: FontWeight.bold),
                                            ),

                                          ],
                                        ),
                                      ))



                                    ],
                                  ),
                                ),
                              );


                            }

                            ),
                          ),
                        ),


                        SizedBox(height: 15),



                        GestureDetector(
                          onTap: (){


                            if(selectedShippingIndex!=9999)
                              {
                                selectedShippingDrop=ratesList[selectedShippingIndex]["duration_terms"].toString();
                                setState(() {

                                });
                                Navigator.pop(context);
                              }

                          },
                          child: Container(
                              height: 54,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFB65303)
                              ),
                              child: Center(
                                child:
                                Text("Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                              )
                          ),
                        ),





                        SizedBox(height: 20),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress(true);
    fetchCenterManagement();
  }
  // Successurl
  //http://vedic.qdegrees.com:3008/order-management/paymentSuccess/682dff96a56e642c84ea1a4f
  fetchAddress(bool firstLoad) async {


    if(firstLoad)
      {

        setState(() {
          isLoading = true;
        });

      }
    else
      {

        setState(() {
          addressLoader = true;
        });

      }





    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {"user":userId.toString()};


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/all-address', requestModel, context);



    if(firstLoad)
    {

      setState(() {
        isLoading = false;
      });

    }
    else
    {

      setState(() {
        addressLoader = false;
      });

    }

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    addressList = responseJSON["data"]["data"];

    if(firstLoad)
      {
        if(addressList.length!=0)
        {
          selectedAddressIndex=0;
          selectedAddressID=addressList[selectedAddressIndex]["_id"].toString();
        }
      }

    else
      {

        for(int i=0;i<addressList.length;i++)
          {
            if(selectedAddressID==addressList[i]["_id"].toString())
              {
                selectedAddressIndex=i;
              }
          }



      }














    setState(() {});
  }

  fetchCenterManagement() async {

    setState(() {
      isLoading = true;
    });



    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {};


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('center_management/allCenterManagement', requestModel, context);



    setState(() {
      isLoading = false;
    });





    var responseJSON = json.decode(response.toString());
    print(response.toString());

    centersList = responseJSON["centers"];












    setState(() {});
  }
  placeOrder() async {

    APIDialog.showAlertDialog(context, "Placing order...");

    String? userId=await MyUtils.getSharedPreferences("user_id");


    var data;
    if(selectedTab==2)
      {
        data ={"cartIds":widget.cartIDs,"userId":userId.toString(),"deliveryCharge":0,"carrier":"","coupanId":"","pickupDate":selectDOB.text.toString(),"addressId":addressList[selectedAddressIndex]["_id"].toString()};

      }
    if(selectedTab==1)
      {
         data ={"cartIds":widget.cartIDs,"userId":userId.toString(),"deliveryCharge":ratesList[selectedShippingIndex]["amount"],"carrier":ratesList[selectedShippingIndex]["provider"],"coupanId":"","shippingId":ratesList[selectedShippingIndex]["object_id"].toString(),"addressId":addressList[selectedAddressIndex]["_id"].toString()};
      }



    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('order-management/OrderByNow', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());



    if (responseJSON['message'] == "Order placed") {

         Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

         String paymentUrl=responseJSON["paymentUrl"].toString();

         // Navigate to payment gateway
      Navigator.push(context, MaterialPageRoute(builder: (context)=>WebViewWordDoc(paymentUrl,"")));





    }
    else
    {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }






    setState(() {});
  }


  calculateShippingCharges() async {

    APIDialog.showAlertDialog(context, "Please wait...");

    String? userId=await MyUtils.getSharedPreferences("user_id");


    var data ={"from":centersList[0]["_id"].toString(),"to":addressList[selectedAddressIndex]["_id"].toString()};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('order-management/getShippingCharge', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());

    ratesList=responseJSON["data"]["rates"];






/*
    if (responseJSON['message'] == "Order placed") {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    }
    else
    {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }*/






    setState(() {});
  }

  fetchOrderHistory(String url) async {

    APIDialog.showAlertDialog(context, "Please wait...");

    String? userId=await MyUtils.getSharedPreferences("user_id");


    var data ={"from":centersList[0]["_id"].toString(),"to":addressList[selectedAddressIndex]["_id"].toString()};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('order-management/getShippingCharge', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());


/*
    if (responseJSON['message'] == "Order placed") {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    }
    else
    {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }*/






    setState(() {});
  }


}

class DateFieldWidget3 extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Icon? rightIcon;
  final bool isDatePicker; // New parameter for date picker
  final Function? onTap; // Optional callback for custom input types

  DateFieldWidget3(
      this.title,
      this.hintText, {
        this.validator,
        this.controller,
        this.rightIcon,
        this.isDatePicker = false, // Default to false
        this.onTap,
      });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )
          ),
        ),
        const SizedBox(height: 7),
        Container(
          //    height: 55,
          margin: EdgeInsets.symmetric(horizontal: 0),
          child: TextFormField(
            validator: validator != null ? validator : null,
            controller: controller,
            readOnly: isDatePicker, // Make read-only if it's a date picker
            keyboardType:
            isDatePicker ? TextInputType.none : TextInputType.text, // Disable keyboard for date picker
            onTap: isDatePicker
                ? () async {
              if (onTap != null) {
                onTap!(); // Execute custom logic
              } else {
                // Default date picker logic
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (pickedDate != null && controller != null) {
                  controller!.text = "${pickedDate.toLocal()}".split(' ')[0];
                }
              }
            }
                : null, // Only handle tap if it's a date picker
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFE4E4E4),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Color(0xFFE4E4E4),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4.0),
                borderSide: BorderSide(
                  width: 1,
                  color: Colors.blue, // Replace with your theme color
                ),
              ),
              filled: true,
              hintStyle: TextStyle(color: Color(0xFF606162), fontSize: 16,fontFamily: "Montserrat"),
              hintText: hintText,
              fillColor: Colors.white,
              suffixIcon: rightIcon,
            ),
          ),
        ),
      ],
    );
  }






}