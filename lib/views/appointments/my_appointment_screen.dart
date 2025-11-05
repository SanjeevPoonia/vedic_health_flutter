import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/name_avatar.dart';
import 'package:vedic_health/views/appointments/appointment_reschedule.dart';
import 'package:vedic_health/views/profile_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../utils/app_theme.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String practitionerName;
  final String practitionerTitle;
  final String appointmentType;
  final String date;
  final String time;
  final double price;
  final String imagePath;
  final String centerName;

  Appointment({
    required this.practitionerName,
    required this.practitionerTitle,
    required this.appointmentType,
    required this.date,
    required this.time,
    required this.price,
    required this.imagePath,
    required this.centerName,
  });
}

class Practitioner {
  final String name;
  final String title;
  final String imagePath;

  Practitioner({
    required this.name,
    required this.title,
    required this.imagePath,
  });
}
class MyAppointmentScreen extends StatefulWidget {
  final String id;
  const MyAppointmentScreen({super.key, required this.id});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  String _selectedFilter = 'All Appointments';
  bool isLoading = false;
  List<Map<String, dynamic>> allAppointments = [];
  List<dynamic> centers = [];
  List<Map<String,dynamic>> familyFriendAppointments=[];
  List<Map<String,dynamic>> myAppointments=[];
  Map<String, dynamic>? upcomingAppointment;
  String? selectedAppointmentId;
  String? userId;
  final List<String> _filters = [
    'All Appointments',
    'My Appointments',
    'Family & Friends',
  ];


  String searchText="";
  DateTime? selectedDate;
  List<Map<String, dynamic>> filteredAppointments = [];


  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {

    userId=await MyUtils.getSharedPreferences("user_id")??"";
    fetchAllCenters();
    final appointments = await fetchUserAppointments(userId!); // your userId
    setState(() {
      allAppointments = appointments;
      filteredAppointments.addAll(allAppointments);
      for (var appointment in allAppointments){
        String familyMemberId=appointment['familyMemberId']?.toString()??"";
        if(familyMemberId.isNotEmpty){
          familyFriendAppointments.add(appointment);
        }else{
          myAppointments.add(appointment);
        }
      }



      // Find nearest upcoming appointment
      final now = DateTime.now();
      final futureAppointments = appointments.where((a) {


        DateTime? appointmentDateTime;
        try {
          final dateStr = a["date"];
          final timeStr = a["time"];

          if (dateStr != null && timeStr != null) {
            final parsedDate = DateTime.parse(dateStr);
            final parsedTime = TimeOfDay(
              hour: int.parse(timeStr.split(":")[0]),
              minute: int.parse(timeStr.split(":")[1]),
            );
            appointmentDateTime = DateTime(
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

        return appointmentDateTime != null && appointmentDateTime.isAfter(now);
      }).toList();
      if (futureAppointments.isNotEmpty) {
        futureAppointments.sort((a, b) => DateTime.parse(a["date"])
            .compareTo(DateTime.parse(b["date"])));
        upcomingAppointment = futureAppointments.first;
      } else {
        upcomingAppointment = null;
      }
    });

    filterByTab();
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
    } else {
      print("Error: ${responseJSON["message"]}");
    }
  }

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

            isLoading?Expanded(child: Center(child: Loader(),)):
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Search and Calendar Bar
                    _buildSearchBar(),
                    const SizedBox(height: 20),
                    // Upcoming Appointment Section
                    _buildUpcomingAppointmentSection(),
                    const SizedBox(height: 20),
                    // Appointment Filters
                    _buildAppointmentFilters(),
                    const SizedBox(height: 20),
                    // Appointment List
                    _buildAppointmentList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildAppBar() {
    return Card(
      // elevation: 2,
      // margin: EdgeInsets.only(bottom: 10),
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
                  child: Text("My Appointments",
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
  Widget _buildSearchBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child:  Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value){
                      searchText=value;
                      applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        InkWell(
          onTap: () async{
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: selectedDate ?? DateTime.now(),
              firstDate: DateTime.now(),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              selectedDate = pickedDate;
              applyFilters();
            }
          },

          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.calendar_month, color: Colors.grey),
          ),
        ),
      ],
    );
  }
  Widget _buildUpcomingAppointmentSection() {
    if (upcomingAppointment == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today_outlined,
                color: Color(0xFF5A89AD), size: 20),
            SizedBox(width: 8),
            Text(
              "UPCOMING APPOINTMENT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildUpcomingAppointmentCard(upcomingAppointment!),
      ],
    );
  }
  Widget _buildUpcomingAppointmentCard(Map<String, dynamic> appointment) {

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

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC7DEF3),
        borderRadius: BorderRadius.circular(10),
      ),
      child:Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              NameAvatar(fullName: employeeName,size: 70,),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          employeeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
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
                                                                          id: appointmentId,
                                                                          centerId: centerId,
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
                                                        /*TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Directions",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),*/
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
                            child:
                            const Icon(Icons.more_vert, color: Colors.black)),
                      ],
                    ),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Accepted",
                      style: TextStyle(fontSize: 14, color: Color(0xFF23B816),fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${appointment["price"]?.toStringAsFixed(2) ?? "0.00"}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23B816),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget _buildAppointmentFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "APPOINTMENTS",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _filters.length,
            itemBuilder: (context, index) {
              final filter = _filters[index];
              final isSelected = _selectedFilter == filter;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedFilter = filter;
                  });
                  filterByTab();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color:
                        isSelected ? const Color(0xFFF38328) : Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Center(
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void filterByTab() {
    List<Map<String, dynamic>> sourceList=[];

    /*if (_selectedFilter == 'All Appointments') {
      sourceList.addAll(allAppointments);
    } else if (_selectedFilter == 'My Appointments') {
      for (var appointment in allAppointments){
        String familyMemberId=appointment['familyMemberId']?.toString()??"";
        if(familyMemberId.isEmpty){
          sourceList.add(appointment);
        }
      }
    } else if (_selectedFilter == 'Family & Friends') {
      for (var appointment in allAppointments){
        String familyMemberId=appointment['familyMemberId']?.toString()??"";
        if(familyMemberId.isNotEmpty){
          sourceList.add(appointment);
        }
      }
    } */
    sourceList = allAppointments.where((appointment) {
      final familyMemberId = appointment['familyMemberId']?.toString() ?? '';

      switch (_selectedFilter) {
        case 'All Appointments':
          return true;
        case 'My Appointments':
          return familyMemberId.isEmpty;
        case 'Family & Friends':
          return familyMemberId.isNotEmpty;
        default:
          return false;
      }
    }).toList();
    // Apply text/date filters on this list
    filteredAppointments = sourceList.where((appointment) {
      DateTime? appointmentDateTime;
      try {
        final dateStr = appointment["date"];
        final timeStr = appointment["time"];
        if (dateStr != null && timeStr != null) {
          final parsedDate = DateTime.parse(dateStr);
          final parsedTime = TimeOfDay(
            hour: int.parse(timeStr.split(":")[0]),
            minute: int.parse(timeStr.split(":")[1]),
          );
          appointmentDateTime = DateTime(
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
      final matchesText = searchText.isEmpty || appointment["service"]['name'].toString().toLowerCase().contains(searchText.toLowerCase());
      final matchesDate = selectedDate == null || (appointmentDateTime !=null && appointmentDateTime.year==selectedDate!.year&& appointmentDateTime.month==selectedDate!.month&& appointmentDateTime.day==selectedDate!.day);
      return matchesText && matchesDate;
    }).toList();
    setState(() {});
  }
  Future<List<Map<String, dynamic>>> fetchUserAppointments(String userId) async {
    try {
      setState(() => isLoading = true);

      // Prepare request body (base64 encoding of {"_id": userId})
      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({"_id": userId})))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "appointment-management/findByUser", // API endpoint
        requestModel,
        context,
      );

      setState(() => isLoading = false);

      final responseJSON = json.decode(response.toString());
      print("Appointments response: $responseJSON");

      if (responseJSON["statusCode"] == 200 && responseJSON["data"] != null && responseJSON["data"].isNotEmpty) {
        // Return list of appointments
        selectedAppointmentId = responseJSON["data"][0]["_id"];
        return List<Map<String, dynamic>>.from(responseJSON["data"]);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching appointments: $e");
    }
    return [];
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

    if (filteredAppointments.isEmpty) {
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

    // Filter logic
    /*List<Map<String, dynamic>> filteredList;
    if (_selectedFilter == 'All Appointments') {
      filteredList = allAppointments;
    } else if (_selectedFilter == 'My Appointments') {
      filteredList = myAppointments;
    } else if (_selectedFilter == 'Family & Friends') {
      filteredList = familyFriendAppointments;
    } else {
      filteredList = [];
    }

    return Column(
      children: filteredList.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );*/


    return Column(
      children: filteredAppointments.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );
  }
  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
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
              GestureDetector(
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
                                                            id: appointmentId,
                                                            centerId: centerId,
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
                                              /*TextButton(
                                                  onPressed: () {},
                                                  child: const Text(
                                                    "Directions",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  )),*/
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
                  child: const Icon(Icons.more_vert, color: Colors.black)),
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("Accepted",
                      style: TextStyle(fontSize: 14, color: Color(0xFF23B816),fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(
                    "\$${appointment["price"]?.toStringAsFixed(2) ?? "0.00"}",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF23B816),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
  String _getCenterName(String centerId) {
    final center = centers.firstWhere(
          (item) => item['_id']?.toString() == centerId,
      orElse: () => null,
    );
    return center?['centerName']?.toString() ?? "Unknown";
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Do you really want to cancel this Appointment",
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
                            cancelOrder(appointmentId);
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
  cancelOrder(String appointmentId) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "_id": appointmentId // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('appointment-management/cancel', resModel, context);
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    var responseJSON= json.decode(response.toString());
    print(responseJSON);
    if(responseJSON["statusCode"]==200){
      Toast.show(responseJSON['message']?.toString()??"Appointment Cancelled Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _loadAppointments();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }
  void applyFilters() {
    setState(() {
      filteredAppointments = allAppointments.where((appointment) {

        DateTime? appointmentDateTime;
        try {
          final dateStr = appointment["date"];
          final timeStr = appointment["time"];

          if (dateStr != null && timeStr != null) {
            final parsedDate = DateTime.parse(dateStr);
            final parsedTime = TimeOfDay(
              hour: int.parse(timeStr.split(":")[0]),
              minute: int.parse(timeStr.split(":")[1]),
            );

            appointmentDateTime = DateTime(
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


        final matchesText = searchText.isEmpty || appointment["service"]['name'].toString().toLowerCase().contains(searchText.toLowerCase());
        final matchesDate = selectedDate == null || (appointmentDateTime !=null && appointmentDateTime.year==selectedDate!.year&& appointmentDateTime.month==selectedDate!.month&& appointmentDateTime.day==selectedDate!.day);
        return matchesText && matchesDate;
      }).toList();
    });
  }
}
