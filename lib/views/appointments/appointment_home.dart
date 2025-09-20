import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/views/appointments/appointment_detail.dart';
import 'package:vedic_health/views/appointments/book_classes/select_class_screen.dart';
import 'package:vedic_health/views/appointments/detox_programs/detox_programs_home.dart';
import 'package:vedic_health/views/appointments/events/event_home_screen.dart';
import 'package:vedic_health/views/appointments/membership/join_membership_screen.dart';
import 'package:vedic_health/views/appointments/yoga_classes/yoga_classes_screen.dart';
import 'package:vedic_health/views/menu_screen.dart';

class AppointmentOption {
  final String title;
  final String description;
  final Color color;
  final String? id;
  final List<dynamic>? services; // <-- raw list from API

  AppointmentOption({
    required this.title,
    required this.description,
    required this.color,
    this.id,
    this.services,
  });
}

class AppointmentHomeScreen extends StatefulWidget {
  const AppointmentHomeScreen({super.key});

  @override
  State<AppointmentHomeScreen> createState() => _AppointmentHomeScreenState();
}

class _AppointmentHomeScreenState extends State<AppointmentHomeScreen> {
  int selectedCenter = 0;
  List<dynamic> centers = [];
  List<dynamic> appointments = [];
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    fetchAllCenters(1, 10, false);
    if (centers.isNotEmpty) {
      fetchAppointments(centers[0]["_id"]);
    }
  }

  Future<void> fetchAllCenters(
      int page, int pageSize, bool progressDialog) async {
    if (progressDialog) {
      APIDialog.showAlertDialog(context, "Please wait...");
    } else {
      setState(() => isLoading = true);
    }

    var data = {"page": page, "pageSize": pageSize};
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
      'center_management/allCenterManagement',
      requestModel,
      context,
    );

    if (progressDialog) {
      Navigator.pop(context);
    } else {
      setState(() => isLoading = false);
    }

    var responseJSON = json.decode(response.toString());
    if (responseJSON["statusCode"] == 200 ||
        responseJSON["statusCode"] == 201) {
      setState(() {
        centers = responseJSON["centers"];
      });

      // Fetch appointments for the first center by default
      if (centers.isNotEmpty) {
        fetchAppointments(centers[0]["_id"]);
      }
    } else {
      print("Error: ${responseJSON["message"]}");
    }
  }

  Future<void> fetchAppointments(String centerId) async {
    setState(() => isLoading = true);

    var data = {"page": 1, "pageSize": 30, "centerId": centerId};
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('service_type/getAll', requestModel, context);

    setState(() => isLoading = false);

    final responseJSON = json.decode(response.toString());
    print("Appointments response: $responseJSON");

    if (responseJSON["statusCode"] == 200) {
      final List<Color> palette = [
        const Color(0xFFB9E0EC),
        const Color(0xFFDBD4F7),
        const Color(0xFFFFE5AB),
        const Color(0xFFBFF2C9),
        const Color(0xFFB9E0EC),
      ];
      final List<dynamic> fetched =
          List<dynamic>.from(responseJSON["data"] ?? []);
      final List<AppointmentOption> mapped = [];

      for (var i = 0; i < fetched.length; i++) {
        final item = fetched[i] as Map<String, dynamic>;
        mapped.add(AppointmentOption(
          id: item['_id'] as String?,
          title: item['name'] ?? 'No name',
          description: item['description'] ?? '',
          color: palette[i % palette.length],
          services: List<dynamic>.from(
              item['service'] ?? []), // <-- store services here
        ));
      }

      setState(() {
        appointmentOptions.clear();
        appointmentOptions.addAll(mapped);
      });
    } else {
      print("Error fetching appointments: ${responseJSON["message"]}");
    }
  }

  final List<AppointmentOption> appointmentOptions = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Card(
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
                    bottomLeft:
                        Radius.circular(20), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(20), // Adjust the radius as needed
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
                        Navigator.pop(context);
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
                          child: Text("Appointment",
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
                            builder: (context) => MenuScreen(),
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
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF71A17B),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Book An Appointment At Our Ayurvedic Center",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectClassScreen(),
                                            ));
                                      },
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10)),
                                      child: const Text(
                                        "Book Classes",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 130,
                                width: 100,
                                child: Container(
                                  color: Colors.transparent,
                                ),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                          right: -15,
                          bottom: 0,
                          child: Image.asset(
                            'assets/consultant_dummy.png',
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Section Title
                    const Text(
                      "WHAT WOULD YOU LIKE TO BOOK?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.all(2),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: List.generate(centers.length, (index) {
                            var center = centers[index];
                            return GestureDetector(
                              onTap: () {
                                setState(() => selectedCenter = index);

                                if (centers.isNotEmpty) {
                                  fetchAppointments(centers[0]["_id"]);
                                }
                                fetchAppointments(center["_id"]);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 12),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  color: selectedCenter == index
                                      ? Colors.white
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                child: Text(
                                  center["centerName"] ?? "Unknown",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: selectedCenter == index
                                        ? Colors.black
                                        : Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                      childAspectRatio: 0.75,
                      children: appointmentOptions
                          .map((option) => _buildAppointmentCard(option))
                          .toList(),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(AppointmentOption option) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 4), // Prevents shadow cutoff
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored Header with custom curved corner
            Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8)),
                  color: option.color,
                ),
                height: 90,
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 16,
                      child: Image.asset(
                        "assets/leaf.png",
                        height: 28,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        option.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.black,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                )),

            // Description
            Expanded(
              child: Flexible(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Text(
                    option.description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      height: 1.3,
                    ),
                    maxLines: 5,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Book Button
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 0),
              child: SizedBox(
                height: 35,
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    switch (option.title) {
                      case "Yoga Classes":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const YogaClassesScreen()),
                        );
                        break;
                      case "Membership":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const JoinMembershipScreen()),
                        );
                        break;
                      case "Detox Programs":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DetoxProgramsHome()),
                        );
                        break;
                      case "Event Sign-Up":
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EventHomeScreen()),
                        );
                        break;
                      default:
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AppointmentDetail(
                              consultations: option.services ?? [],
                              title: option.title,
                            ),
                          ),
                        );
                        break;
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF38328),
                    // shape: RoundedRectangleBorder(
                    //   borderRadius: BorderRadius.circular(20),
                    // ),
                    padding: const EdgeInsets.all(8),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
