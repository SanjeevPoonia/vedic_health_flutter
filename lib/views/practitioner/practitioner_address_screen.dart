import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_payment_page.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';
import '../../widgets/notification_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PractitionerAddressScreen extends StatefulWidget{
  _practitionerState createState()=>_practitionerState();
}
class _practitionerState extends State<PractitionerAddressScreen>{
  bool isLoading = false;
  String customerName="";
  String selectedCustomerId="";
  List<dynamic> searchedUserData=[];
  List<dynamic> searchedUserAddress=[];
  int selectedTab = 1;
  int selectedShippingIndex = 9999;
  double deliveryCharges=0.0;
  List<dynamic> ratesList = [];
  double subTotal=0.0;
  double discount=0.0;
  double grandTotal=0.0;
  int selectedRadioButton = 0;
  int selectedAddressIndex = 9999;
  String selectedAddressID = "";
  bool addressLoader = false;
  var couponController = TextEditingController();
  bool isCoupanApplied=false;
  String coupanCode="";
  String coupanId="";
  String coupanType="";
  String coupanValue="";
  String maxCoupanValue="";
  String coupanTitle="";
  int selectedPaymentTab = 1;

  List<membershipProducts> membershipProductDisList=[];
  bool isMembershipPurchased=false;
  String membershipId="";
  List<dynamic> cartList=[];
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  bool checkToggle = false;

  String employeeId="";
  List<dynamic> centerIdsList=[];
  String selectedShippingDrop = "Select Shipping method";

  bool isNewMembershipAdded=false;
  String newMembershipPrice="0";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          NotificationBarWidget(),
          Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15))),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft:
                  Radius.circular(20), // Adjust the radius as needed
                  bottomRight:
                  Radius.circular(20), // Adjust the radius as needed
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back_ios_new_sharp,
                          size: 24, color: Colors.black)),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text("Customer Details",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
          SizedBox(height: 16),
          Expanded(
              child: isLoading
                  ? Center(
                child: Loader(),
              )
                  : ListView(
                padding: EdgeInsets.symmetric(horizontal: 12),
                children: [
                  Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 8,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(1),
                                  color: AppTheme.lightGreen),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              height: 8,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(1),
                                  color: Color(0xFFC4C4C4)),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    // margin: EdgeInsets.only(right: 25),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00DB00),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 6,
                                          color: Color(0xFF00DB00)
                                              .withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1,
                          ),
                          Expanded(
                            child: SizedBox(
                              child: Row(
                                children: [
                                  Container(
                                    width: 18,
                                    height: 18,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF00DB00),
                                      border: Border.all(
                                          width: 1,
                                          color: Colors.white),
                                      boxShadow: [
                                        BoxShadow(
                                          offset: Offset(0, 1),
                                          blurRadius: 6,
                                          color: Color(0xFF00DB00)
                                              .withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            flex: 1,
                          )
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
                        child: Text("Customer Details",
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

                  Text("Select Your Customer",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                  SizedBox(height: 15),
                  InkWell(
                    onTap: (){
                      _searchCustomerDialog(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFAF2EA),
                        border: Border.all(
                          color: const Color(0xFFE2E2E2),
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Text(
                            customerName.isEmpty?"Choose Customer":customerName,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.keyboard_arrow_down,
                            color: Colors.black54,
                            size: 22,
                          ),
                        ],
                      ),
                    ),
                  ),

                  searchedUserData.isNotEmpty?
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                        if(selectedShippingIndex!=9999){
                                          deliveryCharges=double.tryParse(ratesList[selectedShippingIndex]["amount"])!;
                                          calculateThePaymentDetails();
                                        }else{
                                          deliveryCharges=0.0;
                                          calculateThePaymentDetails();
                                        }

                                      });
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 128,
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
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
                                        deliveryCharges=0.0;
                                        calculateThePaymentDetails();
                                      });
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 128,
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
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

                              ],
                            ),
                          ),
                          SizedBox(height: 25),
                          selectedTab == 2
                              ? Container(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          6),
                                      color: Color(0xFFF3FEF8),
                                      border: Border.all(
                                          color:
                                          Color(0xFFE2E2E2),
                                          width: 1)),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(top: 5),
                                        child: Image.asset(
                                            "assets/loc_ic.png",
                                            width: 24,
                                            height: 35.03),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                  searchedUserAddress[
                                                  selectedAddressIndex]
                                                  ["name"],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    color: Colors
                                                        .black,
                                                  )),
                                              SizedBox(height: 2),
                                              Text(
                                                  searchedUserAddress[
                                                  selectedAddressIndex]
                                                  [
                                                  "area"]
                                                      .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "city"]
                                                          .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "state"]
                                                          .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "country"]
                                                          .toString() +
                                                      "-" +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "pincode"]
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors
                                                        .black
                                                        .withOpacity(
                                                        0.92),
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  searchedUserAddress[selectedAddressIndex]
                                                  ["mobile"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    color: Colors
                                                        .black,
                                                  )),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                              : Container(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                                    Expanded(
                                        child: Container(
                                          height: 54,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  6),
                                              color:
                                              selectedRadioButton == 0
                                                  ? Color(0xFFFAF2EA)
                                                  : Colors.white,
                                              border: Border.all(
                                                  color:
                                                  Color(0xFFE2E2E2),
                                                  width: 1)),
                                          child: Row(
                                            children: [
                                              SizedBox(width: 13),
                                              Container(
                                                child: selectedRadioButton !=
                                                    0
                                                    ? GestureDetector(
                                                    onTap: () {
                                                      print("Clicked");
                                                      setState(() {
                                                        selectedRadioButton =
                                                        0;
                                                      });
                                                    },
                                                    child: Icon(
                                                        Icons
                                                            .radio_button_off,
                                                        color: Color(
                                                            0xFF9D9CA0)))
                                                    : Icon(
                                                    Icons
                                                        .radio_button_checked,
                                                    color: AppTheme
                                                        .darkBrown),
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                  searchedUserAddress.length == 0
                                                      ? "No address"
                                                      : searchedUserAddress[selectedAddressIndex]["name"],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        flex: 1),
                                    SizedBox(width: 12),
                                    searchedUserAddress.length == 0?
                                    Expanded(
                                        child: GestureDetector(
                                          onTap: () async {
                                            showAddAddressDialog(context);
                                          },
                                          child: Container(
                                            height: 54,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    4),
                                                color: Color(0xFFB65303)),
                                            child: Center(
                                              child: Text(
                                                  "Add Address",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                        ),
                                        flex: 1):
                                    Expanded(
                                        flex: 1,
                                        child: GestureDetector(
                                          onTap: () async {
                                            showAddressDialog(
                                              context,
                                                  () {
                                                    showAddAddressDialog(context);
                                                  },
                                                  (index) {
                                                    setState(() {
                                                      selectedAddressIndex = index;
                                                      print("Selected address index: $index");
                                                    });

                                              },
                                            );
                                          },
                                          child: Container(
                                            height: 54,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                BorderRadius.circular(
                                                    4),
                                                color: Color(0xFFB65303)),
                                            child: Center(
                                              child: Text(
                                                  "Select Address",
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight:
                                                    FontWeight.w500,
                                                    color: Colors.white,
                                                  )),
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                                SizedBox(height: 22),
                                searchedUserAddress.length != 0
                                    ? addressLoader
                                    ? Container(
                                  height: 100,
                                  child: Center(
                                    child: Loader(),
                                  ),
                                )
                                    : Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      borderRadius:
                                      BorderRadius.circular(
                                          6),
                                      color: Color(0xFFF3FEF8),
                                      border: Border.all(
                                          color:
                                          Color(0xFFE2E2E2),
                                          width: 1)),
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets
                                            .only(top: 5),
                                        child: Image.asset(
                                            "assets/loc_ic.png",
                                            width: 24,
                                            height: 35.03),
                                      ),
                                      SizedBox(width: 12),
                                      Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(height: 5),
                                              Text(
                                                  searchedUserAddress[
                                                  selectedAddressIndex]
                                                  ["name"],
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                    FontWeight
                                                        .w500,
                                                    color: Colors
                                                        .black,
                                                  )),
                                              SizedBox(height: 2),
                                              Text(
                                                  searchedUserAddress[
                                                  selectedAddressIndex]
                                                  [
                                                  "area"]
                                                      .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "city"]
                                                          .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "state"]
                                                          .toString() +
                                                      "," +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "country"]
                                                          .toString() +
                                                      "-" +
                                                      searchedUserAddress[selectedAddressIndex]
                                                      [
                                                      "pincode"]
                                                          .toString(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    color: Colors
                                                        .black
                                                        .withOpacity(
                                                        0.92),
                                                  )),
                                              SizedBox(height: 5),
                                              Text(
                                                  searchedUserAddress[selectedAddressIndex]
                                                  ["mobile"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 15,
                                                    fontWeight:
                                                    FontWeight
                                                        .w600,
                                                    color: Colors
                                                        .black,
                                                  )),
                                            ],
                                          ))
                                    ],
                                  ),
                                )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(height: 28),

                          SizedBox(height: 28),
                          selectedTab == 1
                              ? GestureDetector(
                            onTap: () {
                              calculateShippingCharges();
                            },
                            child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(4),
                                    color: Color(0xFFB65303)),
                                child: Center(
                                  child: Text("Calculate Shipping Cost",
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      )),
                                )),
                          )
                              : Container(),
                          selectedTab == 1 ? SizedBox(height: 22) : Container(),
                          selectedTab == 1 && ratesList.length != 0
                              ? Row(
                            children: [
                              Text("Select Shipping Method",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              Spacer(),
                              Image.asset("assets/logo_ship.png",
                                  height: 18, width: 110)
                            ],
                          )
                              : Container(),
                          selectedTab == 1 && ratesList.length != 0
                              ? SizedBox(height: 12)
                              : Container(),
                          selectedTab == 1 && ratesList.length != 0
                              ? GestureDetector(
                            onTap: () {
                              shippingOptionsBottomSheet(context);
                            },
                            child: Container(
                              height: 54,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xFFE2E2E2),
                                      width: 1)),
                              child: Row(
                                children: [
                                  SizedBox(width: 13),
                                  Expanded(child: Text(
                                    selectedShippingDrop ==
                                        "Select Shipping method"
                                        ? "Select Shipping method"
                                        : selectedShippingDrop
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: selectedShippingDrop ==
                                          "Select Shipping method"
                                          ? Color(0xFFA0A0A0)
                                          .withOpacity(0.92)
                                          : Colors.black
                                        ..withOpacity(0.92),
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),),

                                  Icon(Icons.keyboard_arrow_down_outlined,
                                      size: 23, color: Colors.black),
                                  SizedBox(width: 12),
                                ],
                              ),
                            ),
                          )
                              : Container(),
                          selectedTab == 1 && ratesList.length != 0
                              ? SizedBox(height: 15)
                              : Container(),

                          Text("Select Payment Type",
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
                                        selectedPaymentTab = 1;
                                      });
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 128,
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: selectedPaymentTab == 1
                                              ? Colors.white
                                              : Color(0xFFF2F5F9),
                                          borderRadius: selectedPaymentTab == 1
                                              ? BorderRadius.circular(70)
                                              : BorderRadius.circular(70)),
                                      child: Center(
                                        child: Text("Offline",
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                color: selectedPaymentTab == 1
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
                                        selectedPaymentTab = 2;
                                      });
                                    },
                                    child: Container(
                                      height: 48,
                                      width: 128,
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 5),
                                      decoration: BoxDecoration(
                                          color: selectedPaymentTab == 2
                                              ? Colors.white
                                              : Color(0xFFF2F5F9),
                                          borderRadius: selectedPaymentTab == 2
                                              ? BorderRadius.circular(70)
                                              : BorderRadius.circular(70)),
                                      child: Center(
                                        child: Text("Online",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat",
                                                color: selectedPaymentTab == 2
                                                    ? Colors.black
                                                    : Color(0XFF9D9CA0))),
                                      ),
                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          SizedBox(height: 28),
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
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xFFEBD8D8), width: 1),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: TextFormField(
                                      controller: couponController,
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        height: 1.6,
                                        color: Colors.black,
                                      ),
                                      decoration: const InputDecoration(
                                        hintText: 'Enter coupon code',
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 5),
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
                                onTap: () async {
                                  if(couponController.text=="")
                                  {
                                    Toast.show("Coupon name cannot be empty !",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.red);
                                  } else
                                  {
                                    var result= await checkCoupanCode(couponController.text.toString());
                                    isCoupanApplied=result['valid'];
                                    if(isCoupanApplied){
                                      coupanCode=result['promo_code'];
                                      coupanId=result['id'];
                                      coupanType=result['type'];
                                      coupanValue=result['value'];
                                      maxCoupanValue=result['max'];
                                      coupanTitle=result['title'];
                                      double maxAm=double.parse(maxCoupanValue);
                                      double percent=double.parse(coupanValue);
                                      double disAmount=0.0;
                                      if(coupanType=="percentage"){
                                        disAmount= subTotal * percent / 100;
                                      }else{
                                        disAmount=percent;
                                      }
                                      discount = (disAmount < maxAm ? disAmount : maxAm);
                                      discount = double.parse(discount.toStringAsFixed(2));

                                      setState(() {

                                      });
                                      calculateThePaymentDetails();
                                    }


                                  }
                                },
                                child: Container(
                                  height: 48,
                                  // margin: const EdgeInsets.only(right: 15),
                                  decoration: BoxDecoration(
                                      color: AppTheme.darkBrown,
                                      border: Border.all(
                                          color: AppTheme.darkBrown, width: 1),
                                      borderRadius: BorderRadius.only(
                                          bottomRight: Radius.circular(6),
                                          topRight: Radius.circular(6))),
                                  child: const Center(
                                    child: Padding(
                                      padding:
                                      EdgeInsets.symmetric(horizontal: 18),
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

                          Text("Cart Details",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          ListView.builder(
                              itemCount: cartList.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context,int pos)
                              {

                                String cartId=cartList[pos]['_id']?.toString()??"";
                                int maxOrderQuantity=cartList[pos]['productDetails']['maxOrderQuantity']??0;
                                int currentQuantity=cartList[pos]["quantity"]??0;
                                int stock=cartList[pos]['productDetails']['stock']??0;
                                double? itemPrice=double.tryParse({cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"]}.toString());
                                int itemPriceInt=itemPrice??cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];
                                String categoryId=cartList[pos]?['productDetails']?['category']?.toString()??"";
                                double discountedPrice=0.0;
                                if(membershipProductDisList.isNotEmpty){
                                  discountedPrice=calculateTheAmount(categoryId, itemPriceInt);
                                }

                                String dicountOffer=calculatePercentage(categoryId);





                                return Column(
                                  children: [

                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 11),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [

                                          BoxShadow(
                                            offset: Offset(0, 1),
                                            blurRadius: 6,
                                            color: Color(0xFFD6D6D6),
                                          ),
                                        ],

                                      ),

                                      child: Row(
                                        children: [

                                          Stack(
                                            children: [
                                              Container(
                                                width: 83,
                                                height: 76,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(10),
                                                    image: DecorationImage(
                                                        fit: BoxFit
                                                            .cover,
                                                        image: NetworkImage(
                                                          AppConstant.appBaseURL+cartList[pos]["productDetails"]["coverImage"],
                                                        ))

                                                ),
                                              ),
                                            ],
                                          ),

                                          SizedBox(width: 15),

                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [


                                                SizedBox(height: 15),


                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text(cartList[pos]["productDetails"]["productName"],
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.black,
                                                          )),
                                                    ),









                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                Text("Brand: "+cartList[pos]["productDetails"]["brand_name"],
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      color: Color(0xFFA3A3A3),
                                                    )),
                                                SizedBox(height: 6),
                                                Row(
                                                  children: [
                                                    /* Text("\$"+cartList[pos]["productDetails"]["price"].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),*/
                                                    Text("\$$itemPriceInt",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.black,
                                                        )),

                                                    SizedBox(width: 13),

                                                    Spacer(),

                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [

                                                        SizedBox(width: 5,),
                                                        Container(
                                                          //width: 68,
                                                          height: 26,
                                                          padding: EdgeInsets.symmetric(horizontal: 10),
                                                          decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.circular(30),
                                                              color: Color(0xFFF5F5F5)
                                                          ),
                                                          child: Center(child: Text(cartList[pos]["quantity"].toString(),
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight: FontWeight.w600,
                                                                color: Colors.black,
                                                              )),),

                                                        ),
                                                        SizedBox(width: 5,),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 6),
                                                discountedPrice!=0.0?
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Text("Member Price",
                                                          style: TextStyle(
                                                            fontSize: 15,
                                                            fontWeight: FontWeight.w600,
                                                            color: Colors.green,
                                                          )),
                                                    ),
                                                    SizedBox(width: 10,),
                                                    Text("\$${discountedPrice.toStringAsFixed(2)}",
                                                        style: TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.green,
                                                        )),
                                                    SizedBox(width: 5,),
                                                    Text(dicountOffer,
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.w500,
                                                          color: Colors.green,
                                                        )),
                                                  ],
                                                ):Container(),
                                                SizedBox(height: 15),

                                              ],
                                            ),
                                          )









                                        ],
                                      ),


                                    ),

                                    SizedBox(height: 15),
                                  ],
                                );
                              }



                          ),
                          SizedBox(height: 21),

                          Text("Payment Details",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Text("Sub Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              SizedBox(width: 5,),
                              Text("\$${subTotal.toStringAsFixed(2)}",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  ))

                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Text("Discount",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              SizedBox(width: 5,),
                              Text("\$$discount",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color:discount==0.0?Colors.black: Colors.green,
                                      fontWeight: FontWeight.w500
                                  ))

                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Text("Shipping Charges",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              SizedBox(width: 5,),
                              Text("\$$deliveryCharges",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  ))

                            ],
                          ),
                          isNewMembershipAdded?
                              SizedBox(height: 10,):Container(),
                          isNewMembershipAdded?
                          Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Text("Membership",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    )),
                              ),
                              SizedBox(width: 5,),
                              Text("\$$newMembershipPrice",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500
                                  ))

                            ],
                          ):Container(),

                          SizedBox(height: 10,),
                          Row(

                            children: [
                              Expanded(
                                flex:1,
                                child: Text("Grand Total",
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w800
                                    )),
                              ),
                              SizedBox(width: 5,),
                              Text("\$$grandTotal",
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w800
                                  ))

                            ],
                          ),
                          SizedBox(height: 20,),
                          Divider(color: Colors.grey,height: 1,),
                          SizedBox(height: 28),


                          Text("Billing Address",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                          SizedBox(height: 5),
                          selectedTab==1?Row(
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      checkToggle = !checkToggle;
                                    });

                                    if (checkToggle &&
                                        searchedUserAddress.length != 0) {
                                      addressLine1Controller.text =
                                          searchedUserAddress[selectedAddressIndex]
                                          ["area"]
                                              .toString() +
                                              "," +
                                              searchedUserAddress[selectedAddressIndex]
                                              ["city"]
                                                  .toString() +
                                              "," +
                                              searchedUserAddress[selectedAddressIndex]
                                              ["state"]
                                                  .toString() +
                                              "," +
                                              searchedUserAddress[selectedAddressIndex]
                                              ["country"]
                                                  .toString() +
                                              "-" +
                                              searchedUserAddress[selectedAddressIndex]
                                              ["pincode"]
                                                  .toString();
                                    } else {
                                      addressLine1Controller.text = "";
                                    }
                                  },
                                  child: checkToggle
                                      ? Icon(Icons.check_box,
                                      color: AppTheme.themeColor)
                                      : Icon(Icons
                                      .check_box_outline_blank_outlined)),
                              SizedBox(width: 8),
                              Text("Same as shipping address",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                  )),
                            ],
                          ):Container(),
                          SizedBox(height: 18),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xFFEBD8D8), width: 1),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: TextFormField(
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        height: 1.6,
                                        color: Colors.black,
                                      ),
                                      controller: addressLine1Controller,
                                      decoration: InputDecoration(
                                        hintText: 'Address Line 1',
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 5),
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFFA0A0A0)
                                              .withOpacity(0.92),
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
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Color(0xFFEBD8D8), width: 1),
                                      borderRadius: BorderRadius.circular(6)),
                                  child: TextFormField(
                                      style: const TextStyle(
                                        fontSize: 15.0,
                                        height: 1.6,
                                        color: Colors.black,
                                      ),
                                      controller: addressLine2Controller,
                                      decoration: InputDecoration(
                                        hintText: 'Address Line 2(Optional)',
                                        contentPadding: EdgeInsets.only(
                                            left: 10, bottom: 5),
                                        fillColor: Colors.white,
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                          fontSize: 13.0,
                                          color: Color(0xFFA0A0A0)
                                              .withOpacity(0.92),
                                        ),
                                      )),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 28),
                        ],
                      ):Container(),


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
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if(selectedCustomerId.isEmpty){
                          Toast.show(
                              "Please select an user to continue!",
                              duration: Toast.lengthLong,
                              gravity: Toast.bottom,
                              backgroundColor: Colors.red);
                        }else{
                          if (selectedTab == 1) {
                            if (searchedUserAddress.length == 0) {
                              Toast.show(
                                  "Please select an address to continue!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            } else if (selectedShippingIndex == 9999) {
                              Toast.show("Please select a shipping method!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }else if(addressLine1Controller.text.trim().toString().isEmpty){
                              Toast.show("Please Enter a Billing Address!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }else if(selectedPaymentTab==1){
                              //placeOrderForOfflinePayment();
                              _confirmOfflinePayment();
                            }else {
                              placeOrderForOnlinePayment();
                            }
                          }
                          else if (selectedTab == 2) {
                            if(addressLine1Controller.text.trim().toString().isEmpty){
                              Toast.show("Please Enter a Billing Address!",
                                  duration: Toast.lengthLong,
                                  gravity: Toast.bottom,
                                  backgroundColor: Colors.red);
                            }else if(selectedPaymentTab==1){
                              //placeOrderForOfflinePayment();
                              _confirmOfflinePayment();
                            } else {
                              placeOrderForOnlinePayment();
                            }
                          }
                        }

                      },
                      child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFFB65303)),
                          child: Center(
                            child: Text("Payment",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          )),
                    ),
                    flex: 1),
              ],
            ),
          )
        ],
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
                height: MediaQuery.of(context).size.height - 150,
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
                                child: Icon(
                                  Icons.clear,
                                  color: Color(0xFFAFAFAF),
                                )),
                            const SizedBox(width: 15)
                          ],
                        ),
                        SizedBox(height: 25),
                        Expanded(
                          child: Container(
                            // height: 150,
                            child: ListView.builder(
                                itemCount: ratesList.length,
                                itemBuilder: (BuildContext context, int pos) {
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedShippingIndex = pos;

                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 10, bottom: 10, left: 13, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          selectedShippingIndex == pos
                                              ? Icon(Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                              : Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                          SizedBox(width: 12),
                                          Expanded(
                                              child: RichText(
                                                text: TextSpan(
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    color:
                                                    Colors.black.withOpacity(0.6),
                                                  ),
                                                  children: <TextSpan>[
                                                    TextSpan(
                                                      text: ratesList[pos]
                                                      ["duration_terms"],
                                                    ),
                                                    TextSpan(
                                                      text: '\$' +
                                                          ratesList[pos]["amount"]
                                                              .toString(),
                                                      style: const TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xFFF38328),
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ))
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                        SizedBox(height: 15),
                        GestureDetector(
                          onTap: () {
                            if (selectedShippingIndex != 9999) {
                              deliveryCharges=double.tryParse(ratesList[selectedShippingIndex]["amount"])!;
                              selectedShippingDrop = ratesList[selectedShippingIndex]["duration_terms"].toString();
                              calculateThePaymentDetails();
                              setState(() {});
                              Navigator.pop(context);
                            }else{
                              deliveryCharges=0.0;
                              calculateThePaymentDetails();
                            }
                          },
                          child: Container(
                              height: 54,
                              margin: EdgeInsets.symmetric(horizontal: 15),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFB65303)),
                              child: Center(
                                child: Text("Submit",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),
                              )),
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
  var searchDialogState;
  void _searchCustomerDialog(BuildContext context) {
    final TextEditingController mobileNoController =
    TextEditingController();
    final TextEditingController emailController =
    TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(), // tap outside only
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {}, // 👈 prevents focus loss on TextField tap
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 25),

                          /// HEADER
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text(
                                "Search Customer",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Image.asset(
                                  'assets/close_icc.png',
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// BODY
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Enter Mobile Number",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                _inputBox(
                                  controller: mobileNoController,
                                  keyboardType: TextInputType.phone,
                                  hint: "Enter here",
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  "Enter Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                _inputBox(
                                  controller: emailController,
                                  keyboardType:
                                  TextInputType.emailAddress,
                                  hint: "Enter here",
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 35),

                          /// ACTIONS
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Navigator.of(ctx).pop(),
                                  child: _actionButton(
                                    title: "Cancel",
                                    bgColor:
                                    const Color(0xFFE3E3E3),
                                    textColor: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    String mobile =
                                    mobileNoController.text.trim();
                                    String email =
                                    emailController.text.trim();

                                    if (!isValidGlobalMobile(mobile)) {
                                      Toast.show(
                                        "Please enter a valid mobile number",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }

                                    if (!isValidEmail(email)) {
                                      Toast.show(
                                        "Please enter a valid email address",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }

                                    Navigator.of(ctx).pop();
                                    searchUser(email, mobile);
                                  },
                                  child: _actionButton(
                                    title: "Search",
                                    bgColor:
                                    AppTheme.darkBrown,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  calculateThePaymentDetails(){
    double memPrice=0.0;
    if (isNewMembershipAdded) {
      print("new membership price $newMembershipPrice");
      memPrice= double.tryParse(newMembershipPrice) ?? 0.0;
    }

    double tot=subTotal+deliveryCharges+memPrice;
    double tos=tot-discount;
    grandTotal = double.parse(tos.toStringAsFixed(2));
    setState(() {

    });

  }
  Widget _inputBox({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hint,
  }) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2EA),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          isDense: true,
        ),
      ),
    );
  }
  Widget _actionButton({
    required String title,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
  Widget _boxTextView({
    required String value,
  }) {
    return Container(

      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2EA),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
       value,
        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),
        ),

    );
  }
  bool isValidEmail(String value) {
    if (value.isEmpty) return false;
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(value.trim());
  }
  bool isValidGlobalMobile(String value) {
    if (value.isEmpty) return false;

    final RegExp globalPhoneRegex = RegExp(
      r'^\+?[1-9]\d{7,14}$',
    );

    return globalPhoneRegex.hasMatch(
      value.replaceAll(RegExp(r'\s|-|\(|\)'), ''),
    );
  }
  searchUser(String email,String mobile) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {
      "mobileNo":mobile,
      "email":email,
     };


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/searchUser', requestModel, context);

    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    List<dynamic>dataList=(responseJSON['data'] as List?)??[];
    if(dataList.isNotEmpty){
      String searchedUserId=dataList[0]?['_id']?.toString()??"";
      String searchedUserName=dataList[0]?['name']?.toString()??"";
      String searchedUserEmail=dataList[0]?['email']?.toString()??"";
      String searchedUsermobileNo=dataList[0]?['mobileNo']?.toString()??"";
      String searchedUserrole=dataList[0]?['role']?.toString()??"";
      String searchedUserstripeCustomerId=dataList[0]?['stripeCustomerId']?.toString()??"";
      List<dynamic> searchedUserAddressList=(dataList[0]?['address'] as List?)??[];
      List<dynamic> searchedUserMemberShip=(dataList[0]?['membership'] as List?)??[];
      List<dynamic> searchedUserMemberHistory=(dataList[0]?['membershipHistory'] as List?)??[];

      if(searchedUserMemberShip.isEmpty){
        _searchCustomerNoMembershipDialog(context, dataList);
      }else{
        _searchCustomerWithMembershipDialog(context, dataList);
      }

    }else{

      //Toast.show("User Not found with these details please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      _searchCustomerNotFoundDialog(context, email, mobile);
    }






  }
  void _searchCustomerWithMembershipDialog(BuildContext context,List<dynamic> dataList) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            String searchedUserId=dataList[0]?['_id']?.toString()??"";
            String searchedUserName=dataList[0]?['name']?.toString()??"";
            String searchedUserEmail=dataList[0]?['email']?.toString()??"";
            String searchedUsermobileNo=dataList[0]?['mobileNo']?.toString()??"";
            String searchedUserrole=dataList[0]?['role']?.toString()??"";
            String searchedUserstripeCustomerId=dataList[0]?['stripeCustomerId']?.toString()??"";
            List<dynamic> searchedUserAddressList=(dataList[0]?['address'] as List?)??[];
            List<dynamic> searchedUserMemberShip=(dataList[0]?['membership'] as List?)??[];
            List<dynamic> searchedUserMemberHistory=(dataList[0]?['membershipHistory'] as List?)??[];

            String membershipName="";
            if(searchedUserMemberShip.isNotEmpty){
              membershipName=searchedUserMemberShip[searchedUserMemberShip.length-1]?['plan_name']?.toString()??"";
            }

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250), // smooth animation
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 KEY
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),

                        /// ---- HEADER ----
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "Customer Details",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Image.asset(
                                'assets/close_icc.png',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ---- BODY ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUserName),
                              const SizedBox(height: 10),

                              const Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUserEmail),
                              const SizedBox(height: 10),

                              const Text(
                                "Mobile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUsermobileNo),
                              const SizedBox(height: 10),

                              const Text(
                                "Membership Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15,color: Colors.black),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  const Text(
                                    "Plan name: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black),
                                  ),
                                  SizedBox(width: 10,),
                                   Expanded(child: Text(
                                     membershipName,
                                     style: TextStyle(
                                         fontWeight: FontWeight.w700, fontSize: 14,color: Colors.green),
                                   ),flex: 1,),
                                ],
                              ),
                              SizedBox(height: 10,),




                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// ---- ACTION BUTTONS ----
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(ctx).pop();

                                } ,
                                child: _actionButton(
                                  title: "Back",
                                  bgColor: const Color(0xFFE3E3E3),
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  setState(() {
                                    isNewMembershipAdded=false;
                                    newMembershipPrice="0";
                                  });
                                  _selectSearchedUser(dataList);
                                },
                                child: _actionButton(
                                  title: "Continue",
                                  bgColor: AppTheme.darkBrown,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  void _searchCustomerNoMembershipDialog(BuildContext context,List<dynamic> dataList) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            String searchedUserId=dataList[0]?['_id']?.toString()??"";
            String searchedUserName=dataList[0]?['name']?.toString()??"";
            String searchedUserEmail=dataList[0]?['email']?.toString()??"";
            String searchedUsermobileNo=dataList[0]?['mobileNo']?.toString()??"";
            String searchedUserrole=dataList[0]?['role']?.toString()??"";
            String searchedUserstripeCustomerId=dataList[0]?['stripeCustomerId']?.toString()??"";
            List<dynamic> searchedUserAddressList=(dataList[0]?['address'] as List?)??[];
            List<dynamic> searchedUserMemberShip=(dataList[0]?['membership'] as List?)??[];
            List<dynamic> searchedUserMemberHistory=(dataList[0]?['membershipHistory'] as List?)??[];

            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250), // smooth animation
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 KEY
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),

                        /// ---- HEADER ----
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "Customer Details",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Image.asset(
                                'assets/close_icc.png',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ---- BODY ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUserName),
                              const SizedBox(height: 10),

                              const Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUserEmail),
                              const SizedBox(height: 10),

                              const Text(
                                "Mobile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: searchedUsermobileNo),
                              const SizedBox(height: 10),

                              const Text(
                                "Membership Details",
                                style: TextStyle(
                                    fontWeight: FontWeight.w700, fontSize: 15,color: Colors.black),
                              ),

                              Row(
                                children: [
                                  const Text(
                                    "Membership Status: ",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500, fontSize: 14,color: Colors.black),
                                  ),
                                  SizedBox(width: 10,),
                                  const Text(
                                    "No Active Plan",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700, fontSize: 14,color: Colors.red),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10,),
                              _boxTextView(value: "Ask the customer if they would like to add a membership to receive additional discounts on purchases.")



                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// ---- ACTION BUTTONS ----
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(ctx).pop();
                                  setState(() {
                                    isNewMembershipAdded=false;
                                    newMembershipPrice="0";
                                  });
                                _selectSearchedUser(dataList);
                                } ,
                                child: _actionButton(
                                  title: "Continue",
                                  bgColor: const Color(0xFFE3E3E3),
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  fetchMembershipList(dataList);
                                },
                                child: _actionButton(
                                  title: "Add Membership",
                                  bgColor: AppTheme.darkBrown,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  _selectSearchedUser(List<dynamic> dataList){
    searchedUserData.clear();
    searchedUserAddress.clear();
    customerName="";
    searchedUserData=dataList;
    customerName=dataList[0]?['name']?.toString()??"";
    selectedCustomerId=dataList[0]?['_id']?.toString()??"";
    searchedUserAddress=(dataList[0]?['address'] as List?)??[];
    List<dynamic> searchedUserMemberShip=(dataList[0]?['membership'] as List?)??[];

    if (searchedUserAddress.length != 0) {
      selectedAddressIndex = 0;
      selectedAddressID = searchedUserAddress[selectedAddressIndex]["_id"].toString();
    }
    setState(() {

    });

    if(searchedUserMemberShip.isNotEmpty){
      fetchMembershipCourses();
    }else{
      fetchCartItems(true);
    }

  }
  Future<Map<String, dynamic>> checkCoupanCode(String promoCode) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return {'valid':false,'message':"User id not found"};
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "couponCode": promoCode,
      "userId":selectedCustomerId, // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'coupon/applyCoupon', resModel, context);
    var responseJSON= json.decode(response.toString());
    Navigator.of(context).pop();
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201){
      var coupan=responseJSON['coupon'];
      String id=coupan['_id']?.toString()??"";
      String discountType=coupan['discountType']?.toString()??"";
      String discountValue=coupan['discountValue']?.toString()??"";
      String maxDiscount=coupan['maxDiscount']?.toString()??"";
      String title=coupan['title']?.toString()??"";
      return {'valid':true,'id':id,'type':discountType,'value':discountValue,'max':maxDiscount,'title':title,'promo_code':promoCode};

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return {'valid':false,'message':responseJSON['message']?.toString()??"Something went wrong! Please try again"};
    }

  }
  fetchCartItems(bool progressDialog) async {

    if(progressDialog)
    {
      APIDialog.showAlertDialog(context, "Please wait...");
    }
    else
    {
      setState(() {
        isLoading = true;
      });
    }



    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {"page":1,"user":userId.toString(),"pageSize":100};
    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/findUserCart', requestModel, context);
    if(progressDialog)
    {
      Navigator.pop(context);
    }
    else
    {
      setState(() {
        isLoading = false;
      });
    }





    var responseJSON = json.decode(response.toString());
    print(response.toString());
    subTotal=0;
    cartList.clear();
    cartList = responseJSON["data"];

    for(int i=0;i<cartList.length;i++)
    {
      int itemPriceInt=cartList[i]["quantity"] * cartList[i]["productDetails"]["price"];
      String categoryId=cartList[i]?['productDetails']?['category']?.toString()??"";

      double discountedPrice=0.0;
      if(membershipProductDisList.isNotEmpty){
        discountedPrice=calculateTheAmount(categoryId, itemPriceInt);
      }
      if(discountedPrice!=0.0){
        subTotal=subTotal+discountedPrice;
      }else{
        subTotal=subTotal+itemPriceInt;
      }




      //int totalAmount=cartList[i]["quantity"] * cartList[i]["productDetails"]["price"];
    }



    setState(() {});
    calculateThePaymentDetails();
  }
  fetchMembershipCourses() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": selectedCustomerId
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('course_management/getCourseAndMembership', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(Navigator.canPop(context)){
     Navigator.of(context).pop();
    }
    if(statusCode==200){
      membershipId=responseJSON['data']?['membership']?['membership_id']?.toString()??"";
      if(responseJSON['data']?['membership']==null){
        isMembershipPurchased=false;
      }else{
        isMembershipPurchased=true;
      }

    }else{
      isMembershipPurchased=false;
    }

    if(isMembershipPurchased){
      fetchMembershipDetails();
    }else{
      fetchCartItems(false);
    }



  }
  fetchMembershipDetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "id": membershipId,
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_management/view', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    if(statusCode==200){
      var result=responseJSON['result'];
      membershipProductDisList.clear();
      var data = result['product_categories'];
      List proList = (data is List) ? data : (data != null ? [data] : []);
      for(var proCat in proList){
        String categoryid=proCat['category_id']?.toString()??"";
        int dicount=proCat['discount']??0;
        String _id=proCat['_id']?.toString()??"";
        membershipProductDisList.add(membershipProducts(categoryid, dicount, _id));
      }

    }

    fetchCartItems(true);
  }
  double calculateTheAmount(String categoryId,int itemPrice){
    double totalPrice=0.0;
    int discount=0;
    for(var proCat in membershipProductDisList){
      String catId=proCat.categoryId;
      if(categoryId==catId){
        discount=proCat.discount;
        print("discount $discount");
        break;
      }
    }
    double discountAmount= itemPrice * discount / 100;
    totalPrice=itemPrice-discountAmount;
    return totalPrice;
  }
  String calculatePercentage(String categoryId){
    String percentageOff="";
    int discount=0;
    for(var proCat in membershipProductDisList){
      String catId=proCat.categoryId;
      if(categoryId==catId){
        discount=proCat.discount;
        print("discount $discount");
        break;
      }
    }
    percentageOff="($discount% off)";
    return percentageOff;
  }

  void _confirmOfflinePayment() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      // 🔒 Important flags
      isDismissible: false,
      enableDrag: false,

      builder: (ctx) => WillPopScope(
        onWillPop: () async => false, // back button disable
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  Lottie.asset('assets/yoga.json', height: 120, width: 120),

                  const SizedBox(height: 5),
                  const Text(
                    "Payment Alert",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                      color: Colors.red
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Are you sure you want to collect cash from the customer?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: (){
                            Navigator.of(ctx).pop();
                          } ,
                          child: _actionButton(
                            title: "No",
                            bgColor: const Color(0xFFE3E3E3),
                            textColor: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                            placeOrderForOfflinePayment();

                          },
                          child: _actionButton(
                            title: "Cash Collected",
                            bgColor: AppTheme.darkBrown,
                            textColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  placeOrderForOfflinePayment() async {
    APIDialog.showAlertDialog(context, "Placing order...");



    List<String> cartIDs=[];
    for(int i=0;i<cartList.length;i++)
    {
      cartIDs.add(cartList[i]["_id"].toString());
    }
    var data;
    if (selectedTab == 2) {
      data = {
        "cartIds": cartIDs,
        "userId": selectedCustomerId,
        "deliveryCharge": 0,
        "carrier": "",
        "coupanId": coupanCode,
        "pickupDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "addressId": searchedUserAddress.isNotEmpty?searchedUserAddress[selectedAddressIndex]["_id"].toString():"",
        "paymentMethod":"offline",
        "billingAddress1":addressLine1Controller.text.toString(),
        "billingAddress2":addressLine2Controller.text.toString(),
        if (isMembershipPurchased) "membershipId": membershipId,
        if(isNewMembershipAdded)"newMembershipId":membershipId,

      };
    }
    if (selectedTab == 1) {
      double? valueDelivery=double.tryParse(ratesList[selectedShippingIndex]["amount"]);

      data = {
        "cartIds": cartIDs,
        "userId": selectedCustomerId,
        "deliveryCharge": valueDelivery??int.tryParse(ratesList[selectedShippingIndex]["amount"]),
        "carrier": ratesList[selectedShippingIndex]["provider"],
        "coupanId": coupanCode,
        "shippingId": ratesList[selectedShippingIndex]["object_id"].toString(),
        "pickupDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "addressId": searchedUserAddress.isNotEmpty?searchedUserAddress[selectedAddressIndex]["_id"].toString():"",
        "paymentMethod":"offline",
        "billingAddress1":addressLine1Controller.text,
        "billingAddress2":addressLine2Controller.text,
        if (isMembershipPurchased) "membershipId": membershipId,
        if(isNewMembershipAdded)"newMembershipId":membershipId,

      };
    }

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'order-management/orderNowForPractitionerOffline', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['statusCode'] == 200) {
      Toast.show(responseJSON['message'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
      _modelOrderOfflineSuccessfull(context);

    } else {
      Toast.show(responseJSON['messages'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }
  placeOrderForOnlinePayment() async {
    APIDialog.showAlertDialog(context, "Placing order...");



    List<String> cartIDs=[];
    for(int i=0;i<cartList.length;i++)
    {
      cartIDs.add(cartList[i]["_id"].toString());
    }
    var data;
    if (selectedTab == 2) {
      data = {
        "cartIds": cartIDs,
        "userId": selectedCustomerId,
        "deliveryCharge": 0,
        "carrier": "",
        "coupanId": coupanCode,
        "pickupDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "addressId": searchedUserAddress.isNotEmpty?searchedUserAddress[selectedAddressIndex]["_id"].toString():"",
        "paymentMethod":"online",
        "billingAddress1":addressLine1Controller.text.toString(),
        "billingAddress2":addressLine2Controller.text.toString(),
        if (isMembershipPurchased) "membershipId": membershipId,
        if(isNewMembershipAdded)"newMembershipId":membershipId,

      };
    }
    if (selectedTab == 1) {
      double? valueDelivery=double.tryParse(ratesList[selectedShippingIndex]["amount"]);

      data = {
        "cartIds": cartIDs,
        "userId": selectedCustomerId,
        "deliveryCharge": valueDelivery??int.tryParse(ratesList[selectedShippingIndex]["amount"]),
        "carrier": ratesList[selectedShippingIndex]["provider"],
        "coupanId": coupanCode,
        "shippingId": ratesList[selectedShippingIndex]["object_id"].toString(),
        "pickupDate": DateFormat('yyyy-MM-dd').format(DateTime.now()),
        "addressId": searchedUserAddress.isNotEmpty?searchedUserAddress[selectedAddressIndex]["_id"].toString():"",
        "paymentMethod":"online",
        "billingAddress1":addressLine1Controller.text,
        "billingAddress2":addressLine2Controller.text,
        if (isMembershipPurchased) "membershipId": membershipId,
        if(isNewMembershipAdded)"newMembershipId":membershipId,

      };
    }

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'order-management/practitionerOrderByNow', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['statusCode'] == 200) {
      String paymentUrl=responseJSON['paymentUrl']?.toString()??"";
      String orderId= responseJSON["orderId"]?.toString()??"NA";
      if(paymentUrl.isNotEmpty){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PractitionerPaymentPage(paymentUrl, orderId)));

      }else{
        Toast.show("Error!! Issue with payment link. Please try again later",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    } else {
      Toast.show(responseJSON['messages'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  void _modelOrderOfflineSuccessfull(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,

      // 🔒 Important flags
      isDismissible: false,
      enableDrag: false,

      builder: (ctx) => WillPopScope(
        onWillPop: () async => false, // back button disable
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  Lottie.asset('assets/check_animation.json', height: 120, width: 120),

                  const SizedBox(height: 5),
                  const Text(
                    "Thank You for Ordering!",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Montserrat",
                    ),
                  ),

                  const SizedBox(height: 18),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      "Your Order placed successfully.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ),

                  const SizedBox(height: 35),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(ctx).pop();
                        _navigateToHomeScreen();
                      },
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppTheme.darkBrown,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "OK",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  _navigateToHomeScreen(){
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => PractitionerHomeScreen()),
    );
  }
  calculateShippingCharges() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    var data = {
      "from": centerIdsList.isNotEmpty?centerIdsList[0].toString():"",
      "to": searchedUserAddress[selectedAddressIndex]["_id"].toString()
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'order-management/getShippingCharge', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    ratesList = responseJSON["data"]["rates"];
    setState(() {});
  }
  Future<void> fetchEmpdetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId=await MyUtils.getSharedPreferences("user_id")??"";
    var data = {
      "userId":userId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('employee-management/findByUserId', requestModel, context);
    var responseJSON = json.decode(response.toString());
    employeeId=responseJSON['data']?['employee']?['_id']?.toString()??"0";
    centerIdsList=(responseJSON['data']?['employee']?['centerId']as List?)??[];

    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
  }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchEmpdetails();
    });

  }
  fetchMembershipList(List<dynamic> dataList) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "page": 1,
      "pageSize": 100,
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_management/getAll', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    if(statusCode==200){

      List<dynamic> membershipList=(responseJSON['result'] as List?)??[];
      if(membershipList.isEmpty){
        Toast.show("Membership Plans not found please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
        _searchCustomerNoMembershipDialog(context, dataList);
      }else{
        showMembershipDialog(context, dataList, membershipList);
      }

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong!!!",duration: Toast.lengthLong,backgroundColor: Colors.red);
      _searchCustomerNoMembershipDialog(context, dataList);
    }

  }
  void showMembershipDialog(
      BuildContext context, List<dynamic>dataList,List<dynamic> membershipList) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.75,
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: membershipList.length,
              itemBuilder: (context, index) {
                var plan = membershipList[index];
                return _membershipItem(plan, ctx,dataList);
              },
            ),
          ),
        );
      },
    );
  }


  Widget _membershipItem(var plan, BuildContext context,List<dynamic> dataList) {

    String memId=plan['_id']?.toString()??"";
    String memPlanName=plan['plan_name']?.toString()??"";
    int isBestValue=plan['is_bestvalue']??0;
    String memPlanDescription=plan['plan_description']?.toString()??"";
    String imageUrl=plan['image']?.toString()??"";
    String price=plan['price']?.toString()??"0";
    String expiring_in=plan['expiring_in']?.toString()??"";

    String planImage="";
    if(imageUrl.isNotEmpty){
      planImage=AppConstant.appBaseURL+imageUrl;
    }


    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// TOP MEMBERSHIP BADGE
            if (isBestValue==1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  "Best Value",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),

            const SizedBox(height: 8),

            /// IMAGE + TITLE
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: CachedNetworkImage(
                    imageUrl: planImage,
                    height: 70,
                    width: 70,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 70,
                      width: 70,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 70,
                      width: 70,
                      color: Colors.grey.shade300,
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        memPlanName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$$price / $expiring_in days",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            /// HTML DESCRIPTION
            Html(
              data: memPlanDescription,
              style: {
                "body": Style(
                  margin: Margins.zero,
                  padding: HtmlPaddings.zero,
                  fontSize: FontSize(14),
                ),
              },
            ),

            const SizedBox(height: 12),

            /// ENROLL BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.orangeColor,   // button background
                  foregroundColor: Colors.white,    // text & icon color
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() {
                    membershipId=memId;
                    isMembershipPurchased=true;
                    isNewMembershipAdded=true;
                    newMembershipPrice=price;
                  });
                  _selectSearchedUserWithMembership(dataList);

                },
                child: const Text("Enroll"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _selectSearchedUserWithMembership(List<dynamic> dataList){
    searchedUserData.clear();
    searchedUserAddress.clear();
    customerName="";
    searchedUserData=dataList;
    customerName=dataList[0]?['name']?.toString()??"";
    selectedCustomerId=dataList[0]?['_id']?.toString()??"";
    searchedUserAddress=(dataList[0]?['address'] as List?)??[];
    List<dynamic> searchedUserMemberShip=(dataList[0]?['membership'] as List?)??[];

    if (searchedUserAddress.length != 0) {
      selectedAddressIndex = 0;
      selectedAddressID = searchedUserAddress[selectedAddressIndex]["_id"].toString();
    }
    setState(() {

    });

    fetchMembershipDetails();

  }

  void _searchCustomerNotFoundDialog(BuildContext context,String Email,String Mobile) {

    TextEditingController nameController= TextEditingController();
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {



            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250), // smooth animation
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 KEY
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),

                        /// ---- HEADER ----
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "Customer Not Found",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Image.asset(
                                'assets/close_icc.png',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ---- BODY ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Email",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: Email),
                              const SizedBox(height: 10),

                              const Text(
                                "Mobile",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: Mobile),
                              const SizedBox(height: 10),
                              _boxTextView(value: "This mobile number and email not registered in our system click to verify with customer\'s email id.\nVerify customer\'s email id to proceed this order"),

                              const SizedBox(height: 20),
                              const Text(
                                "Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _inputBox(controller: nameController, keyboardType: TextInputType.text, hint: "Enter customer name")


                            ],


                          ),
                        ),

                        const SizedBox(height: 35),

                        /// ---- ACTION BUTTONS ----
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: (){
                                  Navigator.of(ctx).pop();
                                } ,
                                child: _actionButton(
                                  title: "Back",
                                  bgColor: const Color(0xFFE3E3E3),
                                  textColor: Colors.black,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  String name=nameController.text.toString();
                                  if(name.trim().isEmpty){
                                    Toast.show("Please enter customer name", duration: Toast.lengthLong,backgroundColor: Colors.red);
                                  }else{
                                    Navigator.of(ctx).pop();
                                    verifyNewUserEmail(Email, Mobile,name);
                                  }

                                },
                                child: _actionButton(
                                  title: "Verify Email",
                                  bgColor: AppTheme.darkBrown,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  verifyNewUserEmail(String email,String mobile,String name) async {
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "mobile_number":mobile,
      "mobileNumber": mobile,
      "email":email,
    };


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/sendOtp', requestModel, context);

    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    if(responseJSON['statusCode']==201){
      Toast.show(responseJSON['message']?.toString()??"OTP Sent to your email address",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _verifyOtpDialog(context, email, mobile,name);
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
      //_verifyOtpDialog(context, email, mobile);
    }
  }
  void _verifyOtpDialog(BuildContext context,String email,String mobile,String name) {
    final List<TextEditingController> _otpControllers = List.generate(5, (index) => TextEditingController());

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(), // tap outside only
                child: SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {}, // 👈 prevents focus loss on TextField tap
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 25),

                          /// HEADER
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text(
                                "Verify OTP",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Image.asset(
                                  'assets/close_icc.png',
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),

                          const SizedBox(height: 20),
                          const SizedBox(height: 20),

                          /// ---- BODY ----
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                const Text(
                                  "Name",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                _boxTextView(value: name),
                                SizedBox(height: 10,),
                                const Text(
                                  "Email",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                _boxTextView(value: email),
                                const SizedBox(height: 10),

                                const Text(
                                  "Mobile",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                _boxTextView(value: mobile),
                                SizedBox(height: 10,),
                                const Text(
                                  "Enter OTP sent on email address",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: List.generate(5, (index) {
                                    return Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF6F6F6),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: TextField(
                                        controller: _otpControllers[index],
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        maxLength: 1,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        decoration: InputDecoration(
                                          counterText: '',
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                            borderSide: BorderSide.none,
                                          ),
                                          filled: true,
                                          fillColor: const Color(0xFFF6F6F6),
                                        ),
                                        onChanged: (value) {
                                          if (value.isNotEmpty && index < 4) {
                                            FocusScope.of(context).nextFocus();
                                          }
                                        },
                                      ),
                                    );
                                  }),
                                ),

                              ],
                            ),
                          ),



                          const SizedBox(height: 35),

                          /// ACTIONS
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () =>
                                      Navigator.of(ctx).pop(),
                                  child: _actionButton(
                                    title: "Cancel",
                                    bgColor:
                                    const Color(0xFFE3E3E3),
                                    textColor: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    bool isOtpValid = _otpControllers.every((controller) => controller.text.isNotEmpty);

                                    if (!isOtpValid) {
                                      Toast.show(
                                        "Please enter complete OTP",
                                        duration: Toast.lengthLong,
                                        gravity: Toast.bottom,
                                        backgroundColor: Colors.red,
                                      );

                                    }else{
                                      String otp = _otpControllers.map((e) => e.text).join();

                                      verifyUserOtp(email, mobile,otp,name);
                                    }


                                  },
                                  child: _actionButton(
                                    title: "Verify",
                                    bgColor:
                                    AppTheme.darkBrown,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
 void verifyUserOtp(String email,String mobile,String otp,String name) async {
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "mobile_number":mobile,
      "email":email,
      "otp":otp,
    };


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/verifyOtp', requestModel, context);

    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    if(responseJSON['statusCode']==200){
      Toast.show(responseJSON['message']?.toString()??"OTp verified Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      if(Navigator.canPop(context)){
        Navigator.pop(context);
      }
      createUserFromPractitioner(email, mobile, name);
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }
  void createUserFromPractitioner(String email,String mobile,String name) async {
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "mobileNo":mobile,
      "email":email,
      "name":name,

    };


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/createUserByPractitionar', requestModel, context);

    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    if(responseJSON['statusCode']==201){
      Toast.show(responseJSON['message']?.toString()??"User Account created Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      searchUser(email, mobile);
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }


  // Add new Addrees Functions
  void showAddressDialog(
      BuildContext context,
      VoidCallback onAddAddress,
      Function(int index) onSelectAddress,
      ) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.75,
                child: Column(
                  children: [

                    /// ADDRESS LIST
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: searchedUserAddress.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAddressIndex = index;
                              });
                            },
                            child: _addressItem(
                              address: searchedUserAddress[index],
                              isSelected: selectedAddressIndex == index,
                              index: index,
                              onChanged: (val) {
                                setState(() {
                                  selectedAddressIndex = val!;
                                });
                              },
                            ),
                          );
                        },
                      ),
                    ),

                    /// BOTTOM ACTION BUTTONS
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Color(0xFFE2E2E2)),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onAddAddress();
                              },
                              child: const Text("Add Address"),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.orangeColor,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: selectedAddressIndex == 9999
                                  ? null
                                  : () {
                                Navigator.pop(context);
                                onSelectAddress(selectedAddressIndex);
                              },
                              child: const Text("Select"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _addressItem({
    required Map<String, dynamic> address,
    required bool isSelected,
    required int index,
    required ValueChanged<int?> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: const Color(0xFFF3FEF8),
        border: Border.all(
          color: isSelected ? AppTheme.orangeColor : const Color(0xFFE2E2E2),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Radio<int>(
            value: index,
            groupValue: isSelected ? index : null,
            onChanged: onChanged,
            activeColor: AppTheme.orangeColor,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Image.asset(
              "assets/loc_ic.png",
              width: 24,
              height: 35,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  address["name"] ?? "",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${address["area"]}, ${address["city"]}, ${address["state"]}, "
                      "${address["country"]} - ${address["pincode"]}",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.black.withOpacity(0.92),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  address["mobile"] ?? "",
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  fetchCountryID(String name,String mobile,String flatNo,String area,String state,String city,String country,String pincode) async {
    APIDialog.showAlertDialog(context, "Please wait...");

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.get(
        'https://maps.googleapis.com/maps/api/geocode/json?address=' +
            area +
            "," +
            city+
            "," +
            state +
            "," +
            country +
            "-" +
            pincode +
            "&key=AIzaSyA8l9u2VyQTXNDh-fjLXAxTOMNmUQAWCG0",
        context);

    var responseJSON = json.decode(response.body);

    print(responseJSON);
    print("****222");

    Navigator.pop(context);

    List<dynamic> addressList = responseJSON["results"];
    print("****");

    String stateID = "";
    String countryID = "";

    for (int i = 0; i < addressList[0]["address_components"].length; i++) {
      if (addressList[0]["address_components"][i]["types"]
          .toString()
          .contains("administrative_area_level_1")) {
        stateID =
            addressList[0]["address_components"][i]["short_name"].toString();
      }

      if (addressList[0]["address_components"][i]["types"]
          .toString()
          .contains("country")) {
        countryID =
            addressList[0]["address_components"][i]["short_name"].toString();
      }
    }

    print(stateID);
    print(countryID);

    addNewAddress(name, mobile, flatNo, area, state, city, country, pincode, stateID, countryID);

  }

  void addNewAddress(String name,String mobile,String flatNo,String area,String state,String city,String country,String pincode,String stateCode,String countryCode)async{
    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "name":name,
      "mobile":mobile,
      "flatNo":flatNo,
      "area":area,
      "state":state,
      "city":city,
      "country":country,
      "pincode":pincode,
      "stateCode":stateCode,
      "countryCode":countryCode,
      "user_id":selectedCustomerId,
    };
    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/add-address', requestModel, context);
    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    if(responseJSON['statusCode']==201){
      Toast.show(responseJSON['message']?.toString()??"Address Added Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      getUserAllAddress();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }

  }
  void getUserAllAddress()async{
    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "user":selectedCustomerId,
    };
    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/all-address', requestModel, context);
    var responseJSON = json.decode(response.toString());
    if(Navigator.canPop(context)){
      Navigator.pop(context);
    }

    if(responseJSON['statusCode']==201){
     searchedUserAddress.clear();
     searchedUserAddress=(responseJSON['data']?['data'] as List?)??[];
     if(searchedUserAddress.isNotEmpty){
       selectedAddressIndex=0;
     }

     setState(() {

     });

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }

  }

  void showAddAddressDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController mobileController = TextEditingController();
    final TextEditingController streetController = TextEditingController();
    final TextEditingController aptController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stateController = TextEditingController();
    final TextEditingController countryController = TextEditingController();
    final TextEditingController zipController = TextEditingController();

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AnimatedPadding(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => FocusScope.of(context).unfocus(),
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: GestureDetector(
                      onTap: () {},
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 25),

                          /// HEADER
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              const Text(
                                "Add Address",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => Navigator.of(ctx).pop(),
                                child: Image.asset(
                                  'assets/close_icc.png',
                                  width: 14,
                                  height: 14,
                                ),
                              ),
                              const SizedBox(width: 20),
                            ],
                          ),

                          const SizedBox(height: 20),

                          /// BODY
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _label("Name"),
                                _inputBoxAddress(controller: nameController),

                                _label("Mobile"),
                                _inputBoxAddress(
                                  controller: mobileController,
                                  keyboardType: TextInputType.phone,
                                ),

                                _label("Street Address"),
                                _inputBoxAddress(controller: streetController),

                                _label("Apt / Suite"),
                                _inputBoxAddress(controller: aptController),

                                _label("City"),
                                _inputBoxAddress(controller: cityController),

                                _label("State"),
                                _inputBoxAddress(controller: stateController),

                                _label("Country"),
                                _inputBoxAddress(controller: countryController),

                                _label("Zip Code"),
                                _inputBoxAddress(
                                  controller: zipController,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 30),

                          /// ACTION BUTTONS
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => Navigator.of(ctx).pop(),
                                  child: _actionButton(
                                    title: "Cancel",
                                    bgColor: const Color(0xFFE3E3E3),
                                    textColor: Colors.black,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    String name=nameController.text.toString();
                                    String mobile=mobileController.text.toString();
                                    String streetAddress=streetController.text.toString();
                                    String flatNo=aptController.text.toString();
                                    String city=cityController.text.toString();
                                    String state=stateController.text.toString();
                                    String county=countryController.text.toString();
                                    String zip=zipController.text.toString();
                                    if(name.trim().isEmpty){
                                      Toast.show(
                                        "Please fill name",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(mobile.trim().isEmpty || !isValidGlobalMobile(mobile)){
                                      Toast.show(
                                        "Please fill valid Mobile number",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(streetAddress.trim().isEmpty){
                                      Toast.show(
                                        "Please fill Street Address",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(flatNo.trim().isEmpty){
                                      Toast.show(
                                        "Please fill Apt/Suite",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(city.trim().isEmpty){
                                      Toast.show(
                                        "Please fill city",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(state.trim().isEmpty){
                                      Toast.show(
                                        "Please fill State",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(county.trim().isEmpty){
                                      Toast.show(
                                        "Please fill Country",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else if(zip.trim().isEmpty){
                                      Toast.show(
                                        "Please fill Country",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red,
                                      );
                                      return;
                                    }else{
                                      Navigator.of(ctx).pop();
                                      fetchCountryID(name, mobile, flatNo, streetAddress, state, city, county, zip);
                                    }






                                  },
                                  child: _actionButton(
                                    title: "Save",
                                    bgColor: AppTheme.orangeColor,
                                    textColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _inputBoxAddress({
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String hint = "Enter here",
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFE2E2E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: BorderSide(color: AppTheme.orangeColor),
        ),
      ),
    );
  }

}
class membershipProducts{
  String categoryId;
  int discount;
  String id;

  membershipProducts(this.categoryId, this.discount, this.id);
}