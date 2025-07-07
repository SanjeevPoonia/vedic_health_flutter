




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

                itemBuilder: (

                BuildContext context,int pos)
            {

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
                            child:




                            selectedAddressIndex==pos?




                            Icon(Icons.radio_button_checked,color: AppTheme.darkBrown):
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




                                Image.asset("assets/edit_ic2.png",width: 17.59,height: 17.59),

                                SizedBox(width: 10),

                                Image.asset("assets/delete_ic2.png",width: 17.59,height: 17.59),

                                SizedBox(width: 5),

                              ],
                            ),

                            SizedBox(height: 2),



                            /*    Text(addressList[0]["area"].toString()+","+addressList[0]["city"].toString()+","+addressList[0]["state"].toString()+","+addressList[0]["country"].toString()+"-"+addressList[0]["pincode"].toString(),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.black.withOpacity(0.92),
                          )),*/


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

                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddAddressScreen()));

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
            Center(
              child: Text("Back to cart",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF865940),
                  )),
            ),

            SizedBox(height: 31),

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
    fetchAddress();


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
    for(int i=0;i<addressList.length;i++)
    {
      if(widget.selectedAddressID==addressList[i]["_id"].toString())
      {
        selectedAddressIndex=i;
      }
    }
    setState(() {});
  }




}
