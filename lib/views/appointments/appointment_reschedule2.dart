import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/utils/name_avatar.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_payment_screen.dart';

import '../../network/Utils.dart';
import '../../network/constants.dart';
import '../../widgets/notification_bar_widget.dart';
import '../home_screen.dart';
import 'my_appointment_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class RescheduleAppointment2 extends StatefulWidget {
  final List<Map<String, dynamic>> allServicesData;
  final String userId;
  final String appointmentId;
  final String id;
  final String centerId;
  final String serviceId;
  final String employeeId;
  final String employeeName;
  final String serviceName;
  final String employeeProfileImage;
  final String empUserId;
  final DateTime selectedDate;

  const RescheduleAppointment2(
      {super.key,
      required this.allServicesData,
      required this.userId,
      required this.appointmentId,
        required this.id, required this.centerId,required this.serviceId,required this.employeeId,required this.serviceName, required this.employeeName,required this.employeeProfileImage,required this.empUserId,required this.selectedDate
      });

  @override
  State<RescheduleAppointment2> createState() => _RescheduleAppointment2State();
}

class _RescheduleAppointment2State extends State<RescheduleAppointment2> {
  DateTime? selectedDate;
  Map<String, int?> selectedSlots = {};
  bool isLoading = true;
  Map<String, dynamic> servicesWithSlots = {};


  @override
  void initState() {
    super.initState();
    selectedDate=widget.selectedDate;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchAvailableSlots();
    });

  }

  Future<Map<String, dynamic>?> editAppointment(
      Map<String, dynamic> appointmentData) async {
    try {
      setState(() => isLoading = true);

      // Encode full appointment data
      final requestModel = {
        "data": base64.encode(
          utf8.encode(
            json.encode(appointmentData),
          ),
        )
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "appointment-management/editAppointments",
        requestModel,
        context,
      );

      setState(() => isLoading = false);

      final responseJSON = json.decode(response.toString());
      print("Edit Appointment response: $responseJSON");

      if (responseJSON["statusCode"] == 200 && responseJSON["data"] != null) {
        return responseJSON["data"];
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error editing appointment: $e");
    }
    return null;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchAvailableSlots();
    }
  }
  Future<void> fetchAvailableSlots() async {


    setState(() {
      isLoading = true;
      servicesWithSlots = {};
    });

    try {
      /*var slotsPayload = {
        "slotsPayload": widget.allServicesData.map((serviceData) {
          return {
            "serviceId": serviceData["serviceId"],
            "employeeId": serviceData["employeeId"],
            "userId": serviceData["userId"],
            "date": DateFormat('yyyy-MM-dd').format(selectedDate!)
          };
        }).toList(),
      };*/
      var data = {
        "slotsPayload": [
          {
            "serviceId": widget.serviceId,
            "employeeId": widget.employeeId,
            "userId": widget.empUserId,
            "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
          }
        ]
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(data)))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/checkAvailableSlot',
        requestModel,
        context,
      );

      var responseJSON = json.decode(response.toString());

      if (responseJSON["slots"] != null && responseJSON["slots"].isNotEmpty) {
        // Store the response data in the map
        for (var serviceSlot in responseJSON["slots"]) {
          final uniqueKey = "${serviceSlot['serviceDetails']['service']['_id']}_${serviceSlot['employeeData']['_id']}";
          servicesWithSlots[uniqueKey] = {
            'slots': serviceSlot['slots'],
            'employeeData': serviceSlot['employeeData'],
            'serviceDetails': serviceSlot['serviceDetails'],
            'reviews' : serviceSlot['reviews'],
            'allServiceData': widget.allServicesData.firstWhere((element) =>
            element['serviceId'] ==
                serviceSlot['serviceDetails']['service']['_id'], orElse: () => {}),

          };
        }
        /*for (var serviceSlot in responseJSON["slots"]) {
          final uniqueKey =
              "${serviceSlot['serviceDetails']['service']['_id']}_${serviceSlot['employeeData']['_id']}";
          servicesWithSlots[uniqueKey] = {
            'slots': serviceSlot['slots'],
            'employeeData': serviceSlot['employeeData'],
            'serviceDetails': serviceSlot['serviceDetails'],
            'allServiceData': widget.allServicesData.firstWhere(
                (element) =>
                    element['serviceId'] ==
                    serviceSlot['serviceDetails']['service']['_id'],
                orElse: () => {})
          };

        }*/
      }
    } catch (e) {
      print("Error fetching slots: $e");
    }

    setState(() {
      isLoading = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              NotificationBarWidget(),
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
                            size: 24, color: Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Book Appointment",
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

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (!isLoading && servicesWithSlots.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No available services or slots found."),
                  ),
                ),

              ...servicesWithSlots.keys.map((serviceId) {
                final serviceData = servicesWithSlots[serviceId];
                final employeeData = serviceData['employeeData'];
                final serviceDetails = serviceData['serviceDetails'];
                final slots = serviceData['slots'];
                print("slots $slots");
                final reviewData=serviceData['reviews'];
                //double averageReview=reviewData['average']?['overall_review']??0.0;

                double averageReview =
                    (reviewData['average']?['overall_review'] as num?)?.toDouble() ?? 0.0;

                String employeeFile=employeeData['userDetails']?['file']?.toString()??"";
                String empProfileImage="";
                if(employeeFile.isNotEmpty){
                  empProfileImage="${AppConstant.appBaseURL}$employeeFile";
                }

                print(empProfileImage);

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Service Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFCD9BE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: Image.asset(
                                "assets/leaf.png",
                                height: 25,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    serviceDetails['service']['name'] ?? "N/A",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => {
                                     // _pickDate(context)
                                    },
                                    child: Text(
                                      selectedDate != null
                                          ? DateFormat('E, MMM dd, yyyy')
                                              .format(selectedDate!)
                                          : "Select a date",
                                      style: const TextStyle(
                                        decoration: TextDecoration.underline,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Color(0xFF662A09),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),

                      /// Doctor Card
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                empProfileImage.isEmpty?
                                NameAvatar(fullName: employeeData["userDetails"]["name"] ?? "N/A",size: 70,):
                                ClipOval(
                                  child: CachedNetworkImage(
                                    imageUrl: empProfileImage,
                                    width: 70,
                                    height: 70,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const CircularProgressIndicator(strokeWidth: 2),
                                    errorWidget: (context, url, error) => NameAvatar(
                                      fullName: employeeData["userDetails"]["name"] ?? "N/A",
                                      size: 70,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employeeData["userDetails"]["name"] ??
                                          "N/A",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    Row(
                                      children: List.generate(5, (index) {

                                        if (index < averageReview.floor()) {
                                          return const Icon(Icons.star, color: Colors.amber, size: 18);
                                        } else if (index < averageReview) {
                                          return const Icon(Icons.star_half, color: Colors.amber, size: 18);
                                        } else {
                                          return const Icon(Icons.star_border, color: Colors.grey, size: 18);
                                        }
                                      })
                                        ..add(const SizedBox(width: 5))
                                        ..add( Text("($averageReview)")),
                                    ),
                                    const SizedBox(height: 5),
                                    /*Text(
                                      "\$${serviceDetails['price']?.toDouble().toStringAsFixed(2) ?? "0.00"}",
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),*/
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 22),
                            const Text(
                              "Available Time",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                      ),

                      /// Time Slots
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(slots.length, (index) {
                            final slot = slots[index];
                            final start = DateTime.parse(slot["startTime"]);
                            final time = formatDateUtc(slot["startTime"]);

                            final isSelected =
                                selectedSlots[serviceId] == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSlots[serviceId] = null;
                                  } else {
                                    selectedSlots[serviceId] = index;
                                  }
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFF38328)
                                      : const Color(0xFFDEEBF4),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  time,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey,
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
                        backgroundColor: const Color(0xFFF38328),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Add to waitlist",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        // Build appointments from selected slots
                        /*List<Map<String, dynamic>> appointments = [];
                        double totalPrice=0.0;
                        String? userId = await MyUtils.getSharedPreferences("user_id");
                        List<Map<String,dynamic>> selectedEmpList=[];
                        selectedSlots.forEach((serviceKey, slotIndex) {
                          if (slotIndex != null) {
                            final selectedServiceData =
                                servicesWithSlots[serviceKey];
                            final slot =
                                selectedServiceData['slots'][slotIndex];
                            final allServiceData =
                                selectedServiceData['allServiceData'];
                            final serviceDetails =
                                selectedServiceData['serviceDetails'];
                            final employeeData = selectedServiceData['employeeData'];
                            String empName=employeeData["userDetails"]["name"] ?? "N/A";
                            String empId=allServiceData['employeeId'];
                            double price=double.parse(serviceDetails['price']?.toString() ?? "0");
                            final empData={
                              "emp_name":empName,
                              "price":price,
                              "empId":empId
                            };
                            selectedEmpList.add(empData);

                            final appointment = {
                              "serviceId": allServiceData['serviceId'],
                              "employeeId": allServiceData['employeeId'],
                              "userId": userId,
                              //"userId": allServiceData['userId'],
                              "note": "test",
                              "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
                              "time": formatDateUtc24(slot['startTime']?.toString()??""),
                              "deposit": 0,
                              "repeat": "Off",
                              "file": "",
                              // ✅ Take from serviceDetails to avoid null
                              "duration": int.tryParse(
                                      serviceDetails['duration'].toString()) ??
                                  60,
                              "price": serviceDetails['price'] ?? 0,
                            };
                            totalPrice += serviceDetails['price'] ?? 0;
                            appointments.add(appointment);
                          }
                        });

                        if (appointments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please select a time slot to continue.")),
                          );
                          return;
                        }

                        try {
                          // Build edit payload
                          final payload = {
                            "_id": widget.appointmentId,
                            "appointments": appointments,
                          };

                          final result = await editAppointment(payload);
                          if (result != null) {

                            List<String> appointIds=[(widget.appointmentId)];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookPaymentScreen(
                                  date: selectedDate!,
                                  userId: widget.userId,
                                  name: servicesWithSlots[
                                          selectedSlots.keys.first]
                                      ['employeeData']['userDetails']['name'],
                                  price: totalPrice,
                                  allServicesData: widget.allServicesData,
                                  empData: selectedEmpList,
                                  appointIds: appointIds,
                                ),
                              ),
                            );
                            Toast.show(result['message']?.toString()??"Appointment Rescheduled Successfully.",duration: Toast.lengthLong,backgroundColor: Colors.green);
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => MyAppointmentScreen(id: '',)),
                                    (Route<dynamic> route) => false);


                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Failed to reschedule appointment")),
                            );
                          }
                        } catch (e) {
                          print("Error editing appointment: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Something went wrong. Please try again.")),
                          );
                        }*/
                        rescheduleAppointment();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662A09),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Continue",
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
      );
  }
  String formatDateUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  String formatDateUtc24(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  Future<void> rescheduleAppointment() async {


    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    try {

      String timeSlot="";
      String duration="";
      String price="";
      selectedSlots.forEach((serviceKey, slotIndex) {
        if (slotIndex != null) {
          final selectedServiceData = servicesWithSlots[serviceKey];
          final slot = selectedServiceData['slots'][slotIndex];
         timeSlot= formatDateUtc24(slot['startTime']?.toString()??"");
         duration=selectedServiceData['serviceDetails']?['duration']?.toString()??"";
         price=selectedServiceData['serviceDetails']?['price']?.toString()??"0";

        }
      });
      print("Slot Time $timeSlot");
      print("Duration $duration");
      print("price $price");
      if(timeSlot.isEmpty){
        if(Navigator.canPop(context)){
          Navigator.of(context).pop();
        }
        Toast.show("Please select the Available Slot",duration: Toast.lengthLong,backgroundColor: Colors.red);
        return;
      }
      var data = {
        "_id":widget.id,
        "serviceId": widget.serviceId,
        "employeeId": widget.employeeId,
        "userId": userId,
        "note":"Rescheduled via MyAppointments",
        "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
        "time": timeSlot,
        "deposit":0,
        "repeat":"Off",
        "duration":duration,
        "price":price

      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(data)))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/editAppointments',
        requestModel,
        context,
      );

      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
      var responseJSON = json.decode(response.toString());
      String message=responseJSON['message']?.toString()??"";
      if(responseJSON['statusCode']==200){
        Toast.show(message.isNotEmpty?message:"Appointment Resheduled Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
        redirectToHome();
      }else{
        Toast.show(message.isNotEmpty?message:"Error! Something went wrong please try again.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      }


    } catch (e) {
      print("Error fetching slots: $e");
      Toast.show("Error!!! Something went wrong, Please try again later",duration: Toast.lengthLong,backgroundColor: Colors.red);
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    }


  }

  void redirectToHome(){
    Route route = MaterialPageRoute(builder: (context) => HomeScreen());
    Navigator.pushAndRemoveUntil(
        context, route, (Route<dynamic> route) => false);
  }
}
