import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as stripe;
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/selectotherperson_screen.dart';
import '../../network/Utils.dart';
import '../../utils/app_theme.dart';
import '../../utils/name_avatar.dart';
import '../payment_success_screen.dart';
import '../word_webview_screen.dart';
import 'add_family&friends_screen.dart';
import 'package:flutter/services.dart';

class BookPaymentScreen extends StatefulWidget {
  final DateTime date;
  final String userId;
  final String name;
  final double price;
  final List<Map<String, dynamic>> allServicesData;
  final List<Map<String,dynamic>> empData;
  final List<String> appointIds;

   const BookPaymentScreen({
    super.key,
    required this.date,
    required this.userId,
    required this.name,
    required this.price,
     required this.allServicesData,
     required this.empData,
     required this.appointIds

  });
  @override
  State<BookPaymentScreen> createState() => _BookPaymentScreenState();
}

class _BookPaymentScreenState extends State<BookPaymentScreen> {
  bool _sameAsShipping = true;
  bool _agreeToPolicy = false;
  String _bookingFor = 'me'; // 'me' or 'other'
  final TextEditingController _specialRequestController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController monthYearController = TextEditingController();
  final TextEditingController cvcController = TextEditingController();

  List<Map<String, dynamic>> userAddresses = [];
  bool isLoading = false;
  Map<String, dynamic>? selectedAddress;

  String selfUserId="";
  String bookingForUserId="";
  List<Map<String,dynamic>> selectedEmpList=[];
  List<String> bookForList=["User (ME)","Other Person"];
  String selectedBookForName="User (ME)";
  String selectedOtherPersonId="";
  List<dynamic> otherPersonsList=[];

  bool isCardExpired=false;
  String StripeSecrateKey="";


  bool needCardDetails=false;
  //stripe.CardFieldInputDetails? cardDetails;
  bool isPaymentInitialize=false;
  stripe.CardFormEditController cardController=stripe.CardFormEditController();

  @override
  void initState() {
    super.initState();
    monthYearController.addListener(_validateExpiry);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUserDetails();
    });

  }
  void _validateExpiry() {
    final text = monthYearController.text;
    if (text.length == 5 && text.contains('/')) {
      final parts = text.split('/');
      final month = int.tryParse(parts[0]) ?? 0;
      final year = int.tryParse(parts[1]) ?? 0;

      if (month > 0 && month <= 12) {
        final now = DateTime.now();
        final currentYear = int.parse(now.year.toString().substring(2));
        final currentMonth = now.month;

        // check expired
        if (year < currentYear ||
            (year == currentYear && month < currentMonth)) {
          setState(() => isCardExpired = true);
        } else {
          setState(() => isCardExpired = false);
        }
      } else {
        setState(() => isCardExpired = true);
      }
    } else {
      setState(() => isCardExpired = false);
    }
  }

  _fetchUserDetails()async{
    selfUserId= await MyUtils.getSharedPreferences("user_id")??"";
    selectedEmpList.addAll(widget.empData);
    bookingForUserId=selfUserId;
    fetchUserAddresses();
    // call this API if need card details


    String apId=widget.appointIds[0];

    fetchAppointmentDetail(apId);


  }

  Future<void> fetchUserAddresses() async {
    setState(() {
      isLoading = true;
      userAddresses = [];
    });

    try {

      // Prepare payload
      var requestPayload = {
        "user": selfUserId,
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'users/all-address',
        requestModel,
        context,
      );

      var responseJSON = json.decode(response.toString());

      if (responseJSON["data"] != null &&
          responseJSON["data"]["data"] != null &&
          responseJSON["data"]["data"].isNotEmpty) {
        setState(() {
          userAddresses = List<Map<String, dynamic>>.from(
            responseJSON["data"]["data"],
          );
        });
      } else {
        setState(() {
          userAddresses = [];
        });
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    }

    setState(() {
      isLoading = false;
    });
  }
  Future<void> fetchOtherPersons() async {

    APIDialog.showAlertDialog(context, "Please Wait...");
    try {
      // Prepare payload
      var requestPayload = {
        "userId": selfUserId,
      };
      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'user-family/find',
        requestModel,
        context,
      );
      var responseJSON = json.decode(response.toString());
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      if(responseJSON['statusCode']==201){
        otherPersonsList.clear();
        if(responseJSON["data"] != null && responseJSON["data"]["userFamilyData"] != null){
          otherPersonsList=responseJSON["data"]["userFamilyData"];
        }
      }

      if(otherPersonsList.isEmpty){
        Toast.show("Please Add family or Friend",duration: Toast.lengthLong,backgroundColor: Colors.red);
        selectedBookForName="User (ME)";
        bookingForUserId=selfUserId;
        setState(() {

        });
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AddFamilyFriendScreen()),
        );
      }else{
        setState(() {

        });
        selectOtherPerson(context);
      }




    } catch (e) {
      print("Error fetching addresses: $e");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    }


  }
  void selectOtherPerson(BuildContext context) {
    String tempSelectedId=selectedOtherPersonId;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Select Other Person',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedOtherPersonId="";
                                bookingForUserId=selfUserId;
                                selectedBookForName='User (ME)';
                              });
                              Navigator.pop(context);
                            },
                            child:
                            const Icon(Icons.clear, color: Color(0xFFAFAFAF))),
                        const SizedBox(width: 15)
                      ],
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: ListView(
                        children: [

                          ...otherPersonsList
                              .map((emp) => GestureDetector(
                            onTap: () {
                              setModalState(() {
                                tempSelectedId = emp["_id"];
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 13, right: 10),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  tempSelectedId == emp["_id"]
                                      ? const Icon(
                                      Icons.radio_button_checked,
                                      color: AppTheme.darkBrown)
                                      : const Icon(Icons.radio_button_off,
                                      color: Color(0xFF707070)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      "${emp["firstName"] ?? "Unknown"} ${emp["lastName"] ?? ""} (${emp["relation"] ?? ""}) "
                                      ,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black54),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ))
                              .toList(),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                              selectedOtherPersonId="";
                              bookingForUserId=selfUserId;
                              selectedBookForName='User (ME)';
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 54,
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFFE3E3E3)),
                                child: const Center(
                                  child: Text("Back",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              setState(() {
                               selectedOtherPersonId=tempSelectedId;
                               bookingForUserId=selectedOtherPersonId;
                               selectedBookForName='Other Person';
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 54,
                                margin: const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("Submit",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future<void> setUpPayment() async{

    String nameOnCard= cardNameController.text.toString();
    if(nameOnCard.isEmpty){
      Toast.show("Please Enter name written on your card",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }
    if(needCardDetails && (!cardController.details.complete)){
      Toast.show("Please Enter Complete and valid card details",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }
    String billingAddressLine1=addressLine1Controller.text.toString();
    if(billingAddressLine1.isEmpty){
      Toast.show("Please Enter billing address line 1",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(!_agreeToPolicy){
      Toast.show("Please Agree to Cancellation Policy",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }
    APIDialog.showAlertDialog(context, "Please Wait...");
    try{
      final paymentMethod=await stripe.Stripe.instance.createPaymentMethod(params: const stripe.PaymentMethodParams.card(paymentMethodData: stripe.PaymentMethodData()));
      final paymentMethodId=paymentMethod.id;
      final setupIntent=await stripe.Stripe.instance.confirmSetupIntent(paymentIntentClientSecret: StripeSecrateKey,
          params: const stripe.PaymentMethodParams.card(paymentMethodData: stripe.PaymentMethodData()));
      final setupIntentKey=setupIntent.id;
      final paymentMethodKey=setupIntent.paymentMethodId;

      print("payment Method id $paymentMethodId");
      print("setup Intent id $setupIntentKey");
      print("PaymentMethodJey $paymentMethodKey");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
      addPayment(paymentMethodKey);
    }catch(e){
      print("Error Create Payment Methods : $e");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
      Toast.show("Something went wrong. Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }


  }
  /*Future<void> confirmSetupIntent(String setupIntentId, String paymentMethodId) async {
    APIDialog.showAlertDialog(context, "Please wait...");


    final url = Uri.parse('https://api.stripe.com/v1/setup_intents/$setupIntentId/confirm');

    print(url);

    final response = await http.post(
      url,
      headers: {
        *//*'Authorization': 'Bearer $StripeSecrateKey',*//*
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'payment_method': paymentMethodId,
        'payment_method_data[type]':'card',
        'payment_method_data[billing_details][name]':cardNameController.text.toString(),
        'payment_method_data[billing_details][address][line1]':addressLine1Controller.text.toString(),
        'payment_method_data[billing_details][address][line2]':addressLine2Controller.text.toString(),
        'payment_method_data[referrer]':AppConstant.StripeReffereUrl,
        'key':AppConstant.StripePublicKey,
        'client_secret':StripeSecrateKey,
      },
    );

    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Setup Intent Confirmed Successfully!");
      print(data);
      String paymentIntent="";
      if(paymentIntent.isEmpty){
        addPayment(paymentIntent);
      }

    } else {
      print("Failed: ${response.body}");
      Toast.show("Error!! While Saving your details. Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }*/
  Future<void> addPayment(String paymentIntent) async {





    APIDialog.showAlertDialog(context, "Please Wait...");

    try {





      // Prepare payload
      var requestPayload = {
        "name":"",
        "mobile":"",
        "flatNo":"",
        "area":"",
        "state":"",
        "city":"",
        "country":"",
        "pincode":"",
        "id":widget.appointIds[0],
        "price":widget.price,
        "aboutAppoiment":_specialRequestController.text,
        "paymentIntent":paymentIntent
      };

      if(selectedBookForName=="Other Person"){
        requestPayload['familyMemberId']=bookingForUserId;
      }else{
        requestPayload['userId']=bookingForUserId;
      }
      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/appointmentPayment',
        requestModel,
        context,
      );
      var responseJSON = json.decode(response.toString());
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      if(responseJSON['statusCode']==200){
       String paymentUrl=responseJSON['paymentUrl']?.toString()??"";

       if(paymentUrl.isNotEmpty){
         if(paymentUrl.contains("Shop/thankYou")){
           Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(
                   builder: (context) =>
                       PaymentSuccessScreen(widget.appointIds[0],2)),
                   (Route<dynamic> route) => false);
         }else{
           Navigator.push(
               context,
               MaterialPageRoute(
                   builder: (context) => WebViewWordDoc(paymentUrl, widget.appointIds[0])));
         }

       }
      }

    } catch (e) {
      print("Error Create Payment Methods : $e");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
      Toast.show("Something went wrong. Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }


  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top App Bar
              Card(
                elevation: 1,
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.white,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                  ),
                ),
                child: Container(
                  height: 65,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_sharp,
                            size: 17, color: Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Payment",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              ListView.builder(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: selectedEmpList.length,
                  itemBuilder: (context,index){
                    String empName=selectedEmpList[index]['emp_name']?.toString()??"N/A";
                    String empId=selectedEmpList[index]['empId']?.toString()??"N/A";
                    double dou=selectedEmpList[index]['price']??0.0;
                    return Container(

                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      margin: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              NameAvatar(fullName:  empName,size: 70,),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    empName,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  const Row(
                                      children: [
                                        Icon(Icons.star, color: Colors.grey, size: 18),
                                        Icon(Icons.star, color: Colors.grey, size: 18),
                                        Icon(Icons.star, color: Colors.grey, size: 18),
                                        Icon(Icons.star, color: Colors.grey, size: 18),
                                        Icon(Icons.star, color: Colors.grey, size: 18),
                                        SizedBox(width: 5),
                                        Text("(0)"),
                                      ],),
                                  const SizedBox(height: 5),
                                  Text(
                                    "\$$dou", // This price is static, you could also pass this as a parameter
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    );
                  }),



              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Who Are You Booking For?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: bookForList.length,
                        itemBuilder: (BuildContext context, int pos) {
                          String name=bookForList[pos];


                          bool isSelected=false;
                          if(selectedBookForName==name){
                            isSelected=true;
                          }
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedBookForName=name;
                                bookingForUserId=selfUserId;
                              });

                              if(selectedBookForName=='Other Person'){
                                fetchOtherPersons();
                              }



                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 10, bottom: 10, left: 13, right: 10),
                              child: Row(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                 isSelected
                                      ? const Icon(
                                      Icons.radio_button_checked,
                                      color: AppTheme.darkBrown)
                                      : const Icon(Icons.radio_button_off,
                                      color: Color(0xFF707070)),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                     name,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color:
                                        // ignore: deprecated_member_use
                                        Colors.black.withOpacity(0.6),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),

              const SizedBox(height: 20),
/* if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (userAddresses.isEmpty)
                      const Text("No saved addresses found.")
                    else
                      Column(
                        children: userAddresses.map((address) {
                          final fullName = address["name"] ?? "Unknown";
                          final uniqueId = address["_id"];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1, color: const Color(0xFFDBDBDB)),
                              color: selectedAddress != null &&
                                      selectedAddress!["_id"] == uniqueId
                                  ? const Color.fromARGB(70, 243, 131, 40)
                                  : Colors.white,
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: const Color(0xFF865940),
                                  value: uniqueId,

                                  // ignore: deprecated_member_use
                                  groupValue: selectedAddress?["_id"],
                                  // ignore: deprecated_member_use
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAddress = address;
                                    });

                                    // If "Other" type, push SelectOtherPersonScreen
                                    if (address["name"] == "Other Person") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectOtherPersonScreen(
                                            address:
                                                address, // ✅ Pass selected address
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      "$fullName - ${address["city"]}, ${address["country"]}",
                                      style: TextStyle(
                                        fontWeight: selectedAddress != null &&
                                                selectedAddress!["_id"] ==
                                                    uniqueId
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),*/

              // About Your Appointment Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About Your Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: TextField(
                        controller: _specialRequestController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 116, 115, 115)),
                          hintText:
                              "Do you have any special request or ideas to share with service provider? (Optional)",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              isPaymentInitialize?
              needCardDetails?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Payment Information",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5,),
                    const Text(
                      "A card is required to hold your appointment slot, You will not be charged",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.deepOrange
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Enter your name as it\'s written on your card.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.black
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFDBDBDB),
                              ),
                            ),
                            child: TextField(
                              controller: cardNameController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115)),
                                hintText:
                                "Name on card",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 10),

                          stripe.CardFormField(
                            controller: cardController,
                            style:  stripe.CardFormStyle(
                              borderColor: Colors.transparent,
                              textColor: Colors.black,
                              fontSize: 16,
                              placeholderColor: Colors.grey,
                              backgroundColor: Colors.white,
                            ),
                            autofocus: false,
                            onCardChanged: (card) {
                              debugPrint('Card changed: $card');
                            },
                          )

                        ],
                      ),
                    ),


                    /*stripe.CardField(
                      onCardChanged: (card){
                        setState(() {
                          cardDetails=card;
                        });
                      },
                    ),*/
                    /*Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),

                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Credit Card",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10,),
                          const Text(
                            "Enter your name as it\'s written on your card.",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFDBDBDB),
                              ),
                            ),
                            child: TextField(
                              controller: cardNameController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 116, 115, 115)),
                                hintText:
                                "Name on card",
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 12),
                              ),
                              maxLines: 1,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                width: 1,
                                color: const Color(0xFFDBDBDB),
                              ),
                            ),
                            child: TextField(
                              controller: cardNumberController,
                              decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Color.fromARGB(255, 116, 115, 115)),
                                hintText: "1234 1234 1234 1234",
                                border: InputBorder.none,
                                counterText: "", // hide character counter
                                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                              ),
                              maxLength: 19, // 16 digits + 3 spaces
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(16),
                                CardNumberInputFormatter(),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              // Expiry Date (MM/YY)
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        width: 1,
                                        color: isCardExpired ? Colors.red : const Color(0xFFDBDBDB)
                                    ),
                                  ),
                                  child: TextField(
                                    controller: monthYearController,
                                    decoration: const InputDecoration(
                                      hintText: "MM/YY",
                                      border: InputBorder.none,
                                      counterText: "",
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    ),
                                    style: TextStyle(
                                      color: isCardExpired ? Colors.red : Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    keyboardType: TextInputType.number,
                                    maxLength: 5,
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,
                                      LengthLimitingTextInputFormatter(4),
                                      ExpiryDateInputFormatter(),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // CVC
                              Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: 1, color: const Color(0xFFDBDBDB)),
                                  ),
                                  child: TextField(
                                    controller: cvcController,
                                    decoration: const InputDecoration(
                                      hintText: "CVC",
                                      border: InputBorder.none,
                                      counterText: "",
                                      contentPadding:
                                      EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                    ),
                                    maxLength: 3,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                  ),
                                ),
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),*/
                  ],
                ),
              ):Container():Container(),

              const SizedBox(height: 20),

              // Billing Address Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Billing Address",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: TextField(
                        controller: addressLine1Controller,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 116, 115, 115)),
                          hintText:
                          "Address Line 1",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: TextField(
                        controller: addressLine2Controller,
                        decoration: const InputDecoration(
                          hintStyle: TextStyle(
                              color: Color.fromARGB(255, 116, 115, 115)),
                          hintText:
                          "Address Line 2 (Optional)",
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        maxLines: 2,
                      ),
                    ),

                  ],
                ),
              ),

              const SizedBox(height: 20),
              // Price Detail Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price Detail",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("\$${widget.price}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Total Due Now",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 10),
                                  Container(
                                      height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xFF662A09)),
                                      child: const Center(
                                        child: Text("Hold with card",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            )),
                                      )),
                                ],
                              ),
                              const Text("\$0.00",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                           Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Due at Business",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text("\$${widget.price}",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              // Cancellation Policy Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cancellation Policy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We ask that you please reschedule or cancel at least 24 hours before the beginning of your appointment or you may be charged a cancellation fee of \$50.",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF23B816),
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      activeColor: const Color(0xFF23B816),
                      title: const Text(
                        "By Clicking \"Book\" you agree to the Cancellation Policy and conditions of this business.",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      value: _agreeToPolicy,
                      onChanged: (value) {
                        setState(() {
                          _agreeToPolicy = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important to keep it small
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey, // change color as per UI
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  AddToWaitlistScreen(allServicesData: widget.allServicesData,),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if(needCardDetails){
                          setUpPayment();
                        }else{
                          addPayment("");
                        }

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23B816),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> fetchStripeKey() async {

    APIDialog.showAlertDialog(context, "Please Wait...");
    try {
      // Prepare payload
      var requestPayload = {
        "_id": selfUserId,
      };
      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/sendKey',
        requestModel,
        context,
      );
      var responseJSON = json.decode(response.toString());
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      if(responseJSON['statusCode']==200){
        StripeSecrateKey=responseJSON['data']?['client_secret']?.toString()??"";
        if(StripeSecrateKey.isNotEmpty){
          _setupStripe();
        }
      }else{
        Toast.show(responseJSON['message']?.toString()??"Something went wrong. Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
      }






    } catch (e) {
      print("Error fetching addresses: $e");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      Toast.show("Something went wrong. Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }


  }
  _setupStripe()async{
    stripe.Stripe.publishableKey=AppConstant.StripePublicKey;
    stripe.Stripe.merchantIdentifier=AppConstant.StripeReffereUrl;
    await stripe.Stripe.instance.applySettings();
    print("Stripe Implemented");

    setState(() {
      isPaymentInitialize=true;
    });
  }



  Future<void> fetchAppointmentDetail(String appointmentId) async {
    try {
      setState(() => isLoading = true);

      final requestModel = {
        "data": base64.encode(
          utf8.encode(
            json.encode({"_id": appointmentId}),
          ),
        )
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "appointment-management/find",
        requestModel,
        context,
      );

      setState(() {
        isLoading = false;
      });

      final responseJSON = json.decode(response.toString());
      print("Appointment detail response: $responseJSON");

      if (responseJSON["statusCode"] == 200 && responseJSON["data"] != null && responseJSON["data"].isNotEmpty) {


        int isAcceptCard=responseJSON['isAcceptCard']??0;

        if(isAcceptCard==1){needCardDetails=true;}else{needCardDetails=false;}
        setState(() {

        });
        if(needCardDetails){
          fetchStripeKey();
        }
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching appointment detail: $e");
    }
  }


}
class CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final newText = StringBuffer();

    for (int i = 0; i < text.length; i++) {
      newText.write(text[i]);
      if ((i + 1) % 4 == 0 && i + 1 != text.length) {
        newText.write(' ');
      }
    }

    return TextEditingValue(
      text: newText.toString(),
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
class ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var text = newValue.text.replaceAll('/', '');

    if (text.length > 2) {
      text = text.substring(0, 2) + '/' + text.substring(2);
    }

    return TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
  }
}