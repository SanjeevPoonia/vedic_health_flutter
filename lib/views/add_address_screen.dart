import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocode/geocode.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/utils/validators.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class AddAddressScreen extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<AddAddressScreen> {
  int selectedIndex = 0;
  int selectedSortIndex = 0;
  var selectDOB = TextEditingController();
  var nameController = TextEditingController();
  var streetAddressController = TextEditingController();
  var flatController = TextEditingController();
  var cityController = TextEditingController();
  var stateController = TextEditingController();
  var zipcodeController = TextEditingController();
  var countryController = TextEditingController();
  var mobileController = TextEditingController();
  String? profileImage = "";

  String selectedAddressID = "";
  final List<String> tabs = ["Category", "Brand"];

  List<bool> categoryCheckList = [false, false, false, false];
  List<bool> brandCheckList = [false, false, false, false];

  List<String> categoryList = [
    "All Categories (390)",
    "Health & Beauty (195)",
    "Health Care (195)",
    "Personal Care (0)"
  ];
  int selectedTab = 1;

  List<String> brandList = [
    "Auromere",
    "Thorne",
    "J. Crow's",
    "Kerala Ayurveda"
  ];
  List<String> sortList = [
    "Most Popular",
    "High to Low",
    "Low to High",
    "Highly Rated"
  ];
  double shippingCost = 0;

  int selectedRadioButton = 0;

  bool checkToggle = false;

  bool isLoading = false;
  List<dynamic> addressList = [];
  List<dynamic> centersList = [];

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF7F9FB),
        //backgroundColor: Colors.red,
        body: Column(
          children: [
            Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 10),
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
                    bottomLeft: Radius.circular(20),
                    // Adjust the radius as needed
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
                            size: 17, color: Colors.black)),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("Add new address",
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
            Expanded(
                child: Container(
              color: Colors.white,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 9),
                  children: [
                    SizedBox(height: 15),
                    Row(
                      children: [
                        Icon(Icons.my_location_sharp,
                            color: AppTheme.darkBrown),
                        SizedBox(width: 10),
                        Text("Use my current location",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.darkBrown,
                            )),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text("Name",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: nameController,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              validator: Validators.checkName,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("Street Address",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: streetAddressController,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              validator: Validators.checkEmptyString,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("Flat, House no., Building",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: flatController,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              validator: Validators.checkEmptyString,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                hintText: '',
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("City",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: cityController,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              validator: Validators.checkEmptyString,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("State",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              controller: stateController,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              validator: Validators.checkEmptyString,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("Zip Code",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              controller: zipcodeController,
                              validator: Validators.checkEmptyString,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("Country",
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
                                color: Colors.white,
                                border: Border.all(
                                    color: Color(0xFFEBD8D8), width: 1),
                                borderRadius: BorderRadius.circular(6)),
                            child: TextFormField(
                                controller: countryController,
                                onTapOutside: ((event) {
                                  FocusManager.instance.primaryFocus?.unfocus();
                                }),
                                validator: Validators.checkEmptyString,
                                style: const TextStyle(
                                  fontSize: 15.0,
                                  height: 1.6,
                                  color: Colors.black,
                                ),
                                decoration: InputDecoration(
                                  hintText: '',
                                  contentPadding:
                                      EdgeInsets.only(left: 10, bottom: 5),
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(6.0),
                                    borderSide: BorderSide(
                                        color: Color(0xFFEBD8D8), width: 1),
                                  ),
                                  hintStyle: TextStyle(
                                    fontSize: 13.0,
                                    color: Colors.grey,
                                  ),
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    Text("Mobile Phone",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        )),
                    SizedBox(height: 14),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                              keyboardType: TextInputType.number,
                              onTapOutside: ((event) {
                                FocusManager.instance.primaryFocus?.unfocus();
                              }),
                              controller: mobileController,
                              validator: Validators.checkEmptyString,
                              maxLength: 12,
                              style: const TextStyle(
                                fontSize: 15.0,
                                height: 1.6,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                hintText: '',
                                contentPadding:
                                    EdgeInsets.only(left: 10, bottom: 5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0),
                                  borderSide: BorderSide(
                                      color: Color(0xFFEBD8D8), width: 1),
                                ),
                                hintStyle: TextStyle(
                                  fontSize: 13.0,
                                  color: Colors.grey,
                                ),
                              )),
                        ),
                      ],
                    ),
                    SizedBox(height: 17),
                    SizedBox(height: 31),
                  ],
                ),
              ),
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
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 54,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFE3E3E3)),
                            child: Center(
                              child: Text("Back",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black,
                                  )),
                            )),
                      ),
                      flex: 1),
                  SizedBox(width: 15),
                  Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _submitHandler();
                        },
                        child: Container(
                          height: 54,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: AppTheme.darkBrown),
                          child: Center(
                            child: Text("Submit",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                )),
                          ),
                        ),
                      ),
                      flex: 1),
                ],
              ),
            )
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




  fetchCountryID() async {


    APIDialog.showAlertDialog(context, "Please wait...");



    ApiBaseHelper helper = ApiBaseHelper();
    var  response =
    await helper.get('https://maps.googleapis.com/maps/api/geocode/json?address='+streetAddressController.text.toString()+","+cityController.text.toString()+","+stateController.text.toString()+","+countryController.text.toString()+"-"+zipcodeController.text.toString()+"&key=AIzaSyDg2z9b58is8H3h_SNNpQTzMMl7Ma18Zac", context);

    var responseJSON = json.decode(response.body);


    print(responseJSON);
    print("****222");

    Navigator.pop(context);

    List<dynamic> addressList=responseJSON["results"];
    print("****");


    String stateID="";
    String countryID="";


    for(int i=0;i<addressList[0]["address_components"].length;i++)
      {

        if(addressList[0]["address_components"][i]["types"].toString().contains("administrative_area_level_1"))
          {
            stateID=addressList[0]["address_components"][i]["short_name"].toString();
          }


        if(addressList[0]["address_components"][i]["types"].toString().contains("country"))
        {
          countryID=addressList[0]["address_components"][i]["short_name"].toString();
        }




      }


    print(stateID);
    print(countryID);



    addAddress(stateID, countryID);








  }


  addAddress(String stateCode,String countryCode) async {




    APIDialog.showAlertDialog(context, "Please wait...");


    String? userId = await MyUtils.getSharedPreferences("user_id");
    var data = {
      "name": nameController.text.toString(),
      "mobile": mobileController.text.toString(),
      "flatNo": flatController.text.toString(),
      "area": streetAddressController.text.toString(),
      "state": stateController.text.toString(),
      "city": cityController.text.toString(),
      "country": countryController.text.toString(),
      "pincode": zipcodeController.text.toString(),
      "user_id": userId,
      "stateCode": stateCode,
      "countryCode": countryCode
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('users/add-address', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());


    if (responseJSON['message'] == "Address added successfully!") {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      String addressID="";
      addressID=responseJSON["data"]["_id"].toString();
      Navigator.pop(context);
      Navigator.pop(context,addressID);


    }
    else
    {
      Toast.show(responseJSON['error'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }




    setState(() {});
  }

  void _submitHandler() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    fetchCountryID();

    //
  }
}
