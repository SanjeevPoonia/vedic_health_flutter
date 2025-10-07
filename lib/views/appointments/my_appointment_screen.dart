import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/views/appointments/appointment_reschedule.dart';
import 'package:vedic_health/views/profile_screen.dart';

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

// // Dummy data
// final Appointment upcomingAppointment = Appointment(
//   practitionerName: "Meena Sankar, AWP",
//   practitionerTitle: "Ayurvedic Consult for Chronic Conditions",
//   appointmentType: "Ayurvedic Consult for Chronic Conditions",
//   date: "Mon, May 05, 2025",
//   time: "12:00 PM",
//   price: 0.0,
//   imagePath: "assets/banner2.png",
//   centerName: "Vedic Health Center",
// );

// final List<Appointment> allAppointments = [
//   Appointment(
//     practitionerName: "Om Sanduja, AWP",
//     practitionerTitle: "Ayurvedic Health Consult - Virtual Visit",
//     appointmentType: "Ayurvedic Consult for Chronic Conditions",
//     date: "Mon, May 05, 2025",
//     time: "12:00 PM",
//     price: 60.00,
//     imagePath: "assets/banner2.png",
//     centerName: "Vedic Health Ayurveda",
//   ),
//   Appointment(
//     practitionerName: "Meena Sankar, AWP",
//     practitionerTitle: "Ayurvedic Health Consult - Virtual Visit",
//     appointmentType: "Ayurvedic Consult for Chronic Conditions",
//     date: "Mon, May 05, 2025",
//     time: "12:00 PM",
//     price: 60.00,
//     imagePath: "assets/banner2.png",
//     centerName: "Vedic Health Ayurveda",
//   ),
// ];

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
  Map<String, dynamic>? upcomingAppointment;
  String? selectedAppointmentId;

  final List<String> _filters = [
    'All Appointments',
    'My Appointments',
    'Family & Friends',
    'Other',
  ];
  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  Future<void> _loadAppointments() async {
    final appointments =
        await fetchUserAppointments("67f385744d5e4bbd8189e116"); // your userId
    setState(() {
      allAppointments = appointments;

      // Find nearest upcoming appointment
      final now = DateTime.now();
      final futureAppointments = appointments.where((a) {
        final date = DateTime.tryParse(a["dateTime"] ?? "");
        return date != null && date.isAfter(now);
      }).toList();

      if (futureAppointments.isNotEmpty) {
        futureAppointments.sort((a, b) => DateTime.parse(a["dateTime"])
            .compareTo(DateTime.parse(b["dateTime"])));
        upcomingAppointment = futureAppointments.first;
      } else {
        upcomingAppointment = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            // Custom App Bar
            _buildAppBar(),
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
            // GestureDetector(
            //     onTap: () {
            //       Navigator.pop(context);
            //     },
            //     child: Icon(Icons.arrow_back_ios_new_sharp,
            //         size: 17, color: Colors.black)),
            GestureDetector(
              onTap: () {
                // TODO: Open menu drawer if needed
              },
              child: Image.asset(
                'assets/ham3.png',
                width: 22,
                height: 22,
              ),
            ),
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
            GestureDetector(
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
            ),
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
            child: const Row(
              children: [
                Icon(Icons.search, color: Colors.grey, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search Subject",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.calendar_month, color: Colors.grey),
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
    final service = appointment["service"] ?? {};
    final employee = appointment["employee"] ?? {};
    final employeeName = employee["userDetails"]?["name"] ?? "Unknown";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC7DEF3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage("assets/banner2.png"),
          ),
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
                                (BuildContext context,
                                    StateSetter setModalState) {
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
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 15),
                                                child: Text('More',
                                                    style: TextStyle(
                                                        fontSize: 19,
                                                        fontFamily:
                                                            "Montserrat",
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                padding:
                                                    const EdgeInsets.all(5),
                                                // height: 150,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Reschedule",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Cancel Appointment",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
                                                        )),
                                                    TextButton(
                                                        onPressed: () {},
                                                        child: const Text(
                                                          "Directions",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black),
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
                        child:
                            const Icon(Icons.more_vert, color: Colors.black)),
                  ],
                ),
                Text(
                  service["description"] ?? "No description",
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  service["name"] ?? "Vedic Health Center",
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF865940),
                  ),
                ),
              ],
            ),
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

  Future<List<Map<String, dynamic>>> fetchUserAppointments(
      String userId) async {
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

      if (responseJSON["statusCode"] == 200 &&
          responseJSON["data"] != null &&
          responseJSON["data"].isNotEmpty) {
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

    if (allAppointments.isEmpty) {
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
    List<Map<String, dynamic>> filteredList;
    if (_selectedFilter == 'All Appointments') {
      filteredList = allAppointments;
    } else if (_selectedFilter == 'My Appointments') {
      filteredList = allAppointments
          .where((a) => a["user"]["_id"] == "67f385744d5e4bbd8189e116")
          .toList();
    } else if (_selectedFilter == 'Family & Friends') {
      filteredList = allAppointments
          .where((a) => a["type"] == "family") // adjust based on your API data
          .toList();
    } else {
      filteredList = [];
    }

    return Column(
      children: filteredList.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );
  }

  Widget _buildAppointmentCard(Map<String, dynamic> appointment) {
    final service = appointment["service"] ?? {};
    final employee = appointment["employee"] ?? {};
    final employeeName = employee["userDetails"]?["name"] ?? "Unknown";

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
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage("assets/banner2.png"),
              ),
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
                    Text(service["description"] ?? "No description",
                        style: const TextStyle(
                            fontSize: 14, color: Colors.black87)),
                    const SizedBox(height: 4),
                    Text(service["name"] ?? "Vedic Health Center",
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
                                                  onPressed: () {},
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
                  const Text("Starting at",
                      style: TextStyle(fontSize: 12, color: Colors.black)),
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
}
