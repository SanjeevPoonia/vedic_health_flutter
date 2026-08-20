import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/add_address_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../widgets/notification_bar_widget.dart';

class SelectDeliveryAddressScreen extends StatefulWidget {
  final String selectedAddressID;
  SelectDeliveryAddressScreen(this.selectedAddressID);
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<SelectDeliveryAddressScreen> {
  int selectedIndex = 0;
  int selectedSortIndex = 0;
  int selectedAddressIndex=9999;
  var selectDOB = TextEditingController();
  var addressLine1Controller = TextEditingController();
  var addressLine2Controller = TextEditingController();
  String? profileImage = "";



  final List<String> tabs = ["Category", "Brand"];

  List<bool> categoryCheckList=[false,false,false,false];
  List<bool> brandCheckList=[false,false,false,false];

  bool isLoading=false;
  List<dynamic> addressList=[];
  int selectedTab = 1;
  double shippingCost=0;
  int selectedRadioButton=0;
  bool checkToggle=false;






  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            NotificationBarWidget(),
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
                        child:Icon(Icons.arrow_back_ios_new_sharp,size: 24,color: Colors.black)),




                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("Select Delivery Address",
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



        Expanded(child:

        isLoading?

            Center(
              child: Loader(),
            ):

        ListView(
          padding: EdgeInsets.symmetric(horizontal: 11),

          children: [
            Text("All Addresses("+addressList.length.toString()+")",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),
            SizedBox(height: 12),
            ListView.builder(
                itemCount: addressList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context,int pos)
                {

                  String addressId=addressList[pos]['_id']?.toString()??"";

                  return Column(
                    children: [

                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFF3FEF8),
                            border: Border.all(color: Color(0xFFDBDBDB),width: 1)
                        ),


                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [


                            Padding(
                                padding: const EdgeInsets.only(top: 5),
                                child: selectedAddressIndex==pos? Icon(Icons.radio_button_checked,color: AppTheme.darkBrown):
                               GestureDetector(
                                   onTap:(){
                                     setState(() {
                                       selectedAddressIndex=pos;
                                     });
                                     Navigator.pop(context,addressList[pos]["_id"].toString());
                                     },

                                    child: Icon(Icons.radio_button_off,color: Color(0xFF707070)))
                            ),

                            SizedBox(width: 12),

                            Expanded(child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(addressList[pos]["name"],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          )),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressScreen(true,addressList[pos])));
                                      },
                                      child:Image.asset("assets/edit_ic2.png",width: 17.59,height: 17.59) ,
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: (){
                                        _deleteAddressBottomDialog(context, addressId);
                                      },
                                      child: Image.asset("assets/delete_ic2.png",width: 17.59,height: 17.59),
                                    ),
                                    SizedBox(width: 5),

                                  ],
                                ),

                                SizedBox(height: 2),
                                Text(addressList[pos]["area"].toString()+","+addressList[pos]["city"].toString()+","+addressList[pos]["state"].toString()+","+addressList[pos]["country"].toString()+"-"+addressList[pos]["pincode"].toString(),
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.black.withOpacity(0.92),
                                    )),


                                SizedBox(height: 5),

                                Text(addressList[pos]["mobile"].toString(),
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black,
                                    )),


                              ],
                            ))







                          ],
                        ),



                      ),

                      SizedBox(height: 13)

                    ],
                  );
                }
            ),


            SizedBox(height: 8),

            Text("Add Delivery Address",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),

            SizedBox(height: 20),

            GestureDetector(
              onTap: (){

                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressScreen(false,null)));

               // calculateShippingCharges();
              },
              child: Container(
                  height: 51,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: AppTheme.themeColor
                  ),
                  child: Center(
                    child:
                    Text("Add a new delivery address",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        )),
                  )
              ),
            ),


            SizedBox(height: 30),

            Padding(padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [

                Expanded(child: Container(
                  height:1,
                  color: Colors.grey.withOpacity(0.5),
                )),


                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text("OR",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      )),
                ),
                Expanded(child: Container(
                  height:1,
                  color: Colors.grey.withOpacity(0.5),
                )),

              ],
            ),


            ),


            SizedBox(height: 20),
            InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child:Center(
                child: Text("Back to cart",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF865940),
                    )),
              ) ,
            ),

            SizedBox(height: 31),

          ],
        ))
            
          ],
        ),
      );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAddress();
  }
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
    addressList.clear();
    addressList = responseJSON["data"]["data"];
    for(int i=0;i<addressList.length;i++)
    {
      if(widget.selectedAddressID==addressList[i]["_id"].toString())
      {
        selectedAddressIndex=i;
      }
    }
    setState(() {});
  }
  void _deleteAddressBottomDialog(BuildContext context,String addressId) {
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
                        "Are you sure?",
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
                          "Do you really want to delete this Address.",
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
                          onTap: () async {
                            Navigator.of(ctx).pop();
                            deleteAddress(addressId);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.darkBrown),
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
  deleteAddress(String addressId) async {

    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {
      "user":userId.toString(),
      "addressId":addressId
    };


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('users/delete-address', requestModel, context);
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    var responseJSON = json.decode(response.toString());
    print(response.toString());
    int status=responseJSON['statusCode']??0;
    String message=responseJSON['message']?.toString()??"";
    if(status==200){
      Toast.show(message.isNotEmpty?message:"Address deleted Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      setState(() {});
      fetchAddress();
    }else{
      Toast.show(message.isNotEmpty?message:"Something went wrong. Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }




}
