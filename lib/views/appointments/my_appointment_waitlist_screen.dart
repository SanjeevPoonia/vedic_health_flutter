import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import 'package:flutter/material.dart';
import '../../network/loader.dart';
import '../../utils/name_avatar.dart';
import 'package:intl/intl.dart';

class MyAppointmentWaitlistScreen extends StatefulWidget{
  _waitlistState createState()=>_waitlistState();
}
class _waitlistState extends State<MyAppointmentWaitlistScreen>{
  String userId="";
  bool isLoading=false;
  List<dynamic> mywaitlist=[];
  List<dynamic> centers = [];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),

            isLoading?
            Expanded(child: Center(child: Loader(),)):

            Expanded(child: _buildAppointmentList()),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Card(
      color: Colors.white,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15))),
      child: Container(
        height: 65,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), // Adjust the radius as needed
            bottomRight: Radius.circular(20), // Adjust the radius as needed
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(Icons.arrow_back_ios_new_sharp,
                    size: 17, color: Colors.black)),
            /*GestureDetector(
              onTap: () {
                // TODO: Open menu drawer if needed
              },
              child: Image.asset(
                'assets/ham3.png',
                width: 22,
                height: 22,
              ),
            ),*/
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text("My Waitlist",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            /* GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              child: Image.asset(
                'assets/profile_icc.png',
                width: 32,
                height: 32,
              ),
            ),*/
          ],
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }
  Future<void> _loadAppointments() async {
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    fetchAllCenters();
  }
  Future<void> fetchMyWaitList() async {
    setState(() => isLoading = true);
    var data = {
      "id": userId
    };
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
      'waitlist/user',
      requestModel,
      context,
    );
    setState(() => isLoading = false);
    var responseJSON = json.decode(response.toString());
    if (responseJSON["statusCode"] == 200 || responseJSON["statusCode"] == 201) {

      mywaitlist=responseJSON['data']??[];
      setState(() {
      });
    } else {
      Toast.show(responseJSON["message"]?.toString()??"Something went wrong. Please try again");
    }
  }
  Widget _buildAppointmentList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: CircularProgressIndicator(color: Color(0xFFF38328)),
        ),
      );
    }

    if (mywaitlist.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Text(
            "No appointments found",
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
        ),
      );
    }

    return ListView.builder(
        itemCount: mywaitlist.length,
        itemBuilder: (BuildContext context,int index){
          var waitList=mywaitlist[index];
          return _buildAppointmentCard(waitList);
        }
    );



  }
  String _getCenterName(String centerId) {
    final center = centers.firstWhere(
          (item) => item['_id']?.toString() == centerId,
      orElse: () => null,
    );
    return center?['centerName']?.toString() ?? "Unknown";
  }
  Widget _buildAppointmentCard(var appointment) {
    String appointmentId=appointment['_id']?.toString()??"";
    final service = appointment["service"] ?? {};
    final employee = appointment["employee"] ?? {};
    final employeeName = employee["userDetails"]?["name"] ?? "Unknown";

    List<dynamic> centerList=employee['centerId']??[];
    String centerId="";
    String centerName="";
    if(centerList.isNotEmpty){
      centerId=centerList[0]?.toString()??"";
    }

    if(centerId.isNotEmpty){
      centerName=_getCenterName(centerId);
    }

    // Parse date + time
    DateTime? dateTime;
    try {
      final dateStr = appointment["date"];
      final timeStr = appointment["time"];

      if (dateStr != null && timeStr != null) {
        final parsedDate = DateTime.parse(dateStr);
        final parsedTime = TimeOfDay(
          hour: int.parse(timeStr.split(":")[0]),
          minute: int.parse(timeStr.split(":")[1]),
        );

        dateTime = DateTime(
          parsedDate.year,
          parsedDate.month,
          parsedDate.day,
          parsedTime.hour,
          parsedTime.minute,
        );
      }
    } catch (e) {
      print("Error parsing date/time: $e");
    }

    String preferredDateTime="";
    if(dateTime!=null){
      preferredDateTime=DateFormat('MMM dd,yyyy hh:mm a').format(dateTime);
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300, width: 1.0),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NameAvatar(fullName: employeeName,size: 70,),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(employeeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 4),
                    Text(service["name"] ?? " ",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(centerName,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF865940),
                        )),


                  ],
                ),
              ),
             /* GestureDetector(
                  onTap: () {
                    showModalBottomSheet(
                      // isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (context) => StatefulBuilder(builder:
                          (BuildContext context, StateSetter setModalState) {
                        return Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                            color: Colors.white,
                          ),
                          margin: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 15),
                          child: SizedBox(
                            height: 280,
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
                                          child: Text('More',
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
                                            child: const Icon(
                                              Icons.clear,
                                              color: Color(0xFFAFAFAF),
                                            )),
                                        const SizedBox(width: 15)
                                      ],
                                    ),
                                    const SizedBox(height: 25),
                                    Expanded(
                                      child: Container(
                                          padding: const EdgeInsets.all(5),
                                          // height: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              RescheduleAppointment(
                                                                id: selectedAppointmentId ??
                                                                    "",
                                                                centerId: service[
                                                                "centerId"] !=
                                                                    null &&
                                                                    service["centerId"]
                                                                    is List &&
                                                                    (service["centerId"]
                                                                    as List)
                                                                        .isNotEmpty
                                                                    ? (service[
                                                                "centerId"]
                                                                as List)[0]
                                                                    : "",
                                                              ),
                                                        ));
                                                  },
                                                  child: const Text(
                                                    "Reschedule",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                              TextButton(
                                                  onPressed: () {
                                                    _modalBottomCancelReturn(context, appointmentId);
                                                  },
                                                  child: const Text(
                                                    "Cancel Appointment",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                              TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Directions",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),
                                            ],
                                          )),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  },
                  child: const Icon(Icons.more_vert, color: Colors.black)),*/
            ],
          ),
          const SizedBox(height: 4),
          const Divider(color: Colors.grey),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Date & Time",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
                  const SizedBox(height: 4),
                  Text(
                      preferredDateTime.isNotEmpty?
                          preferredDateTime:
                    dateTime != null
                        ? "${dateTime.toLocal()}".split('.')[0]
                        : "N/A",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  _modalBottomCancelReturn(context, appointmentId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkBrown,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Padding(padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  "Remove",
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
    );
  }
  Future<void> fetchAllCenters() async {
    setState(() => isLoading = true);
    var data = {"page": 1, "pageSize": 100};
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
      'center_management/allCenterManagement',
      requestModel,
      context,
    );
    setState(() => isLoading = false);
    var responseJSON = json.decode(response.toString());
    if (responseJSON["statusCode"] == 200 || responseJSON["statusCode"] == 201) {
      setState(() {
        centers = responseJSON["centers"];
      });
      fetchMyWaitList();
    } else {
      print("Error: ${responseJSON["message"]}");
      fetchMyWaitList();
    }
  }
  void _modalBottomCancelReturn(BuildContext context,String appointmentId) {
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Do you really want to remove this appointment from waitlist",
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
                            removeWaitlist(appointmentId);
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
  removeWaitlist(String appointmentId) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "id": appointmentId // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('waitlist/delete', resModel, context);
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    var responseJSON= json.decode(response.toString());
    print(responseJSON);
    if(responseJSON["statusCode"]==200){
      Toast.show(responseJSON['message']?.toString()??"Appointment Removed from Waitlist",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _loadAppointments();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }



  }
}