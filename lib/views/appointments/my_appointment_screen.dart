import 'package:flutter/material.dart';
import 'package:vedic_health/views/appointments/appointment_home.dart';
import 'package:vedic_health/views/profile_screen.dart';

// Dummy data classes to make the UI work
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

// Dummy data
final Appointment upcomingAppointment = Appointment(
  practitionerName: "Meena Sankar, AWP",
  practitionerTitle: "Ayurvedic Consult for Chronic Conditions",
  appointmentType: "Ayurvedic Consult for Chronic Conditions",
  date: "Mon, May 05, 2025",
  time: "12:00 PM",
  price: 0.0,
  imagePath: "assets/banner2.png",
  centerName: "Vedic Health Center",
);

final List<Appointment> allAppointments = [
  Appointment(
    practitionerName: "Om Sanduja, AWP",
    practitionerTitle: "Ayurvedic Health Consult - Virtual Visit",
    appointmentType: "Ayurvedic Consult for Chronic Conditions",
    date: "Mon, May 05, 2025",
    time: "12:00 PM",
    price: 60.00,
    imagePath: "assets/banner2.png",
    centerName: "Vedic Health Ayurveda",
  ),
  Appointment(
    practitionerName: "Meena Sankar, AWP",
    practitionerTitle: "Ayurvedic Health Consult - Virtual Visit",
    appointmentType: "Ayurvedic Consult for Chronic Conditions",
    date: "Mon, May 05, 2025",
    time: "12:00 PM",
    price: 60.00,
    imagePath: "assets/banner2.png",
    centerName: "Vedic Health Ayurveda",
  ),
];

class MyAppointmentScreen extends StatefulWidget {
  const MyAppointmentScreen({super.key});

  @override
  State<MyAppointmentScreen> createState() => _MyAppointmentScreenState();
}

class _MyAppointmentScreenState extends State<MyAppointmentScreen> {
  String _selectedFilter = 'All Appointments';

  final List<String> _filters = [
    'All Appointments',
    'My Appointments',
    'Family & Friends',
    'Other',
  ];

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
        _buildUpcomingAppointmentCard(upcomingAppointment),
      ],
    );
  }

  Widget _buildUpcomingAppointmentCard(Appointment appointment) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFC7DEF3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(appointment.imagePath),
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
                      appointment.practitionerName,
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
                                                padding: EdgeInsets.all(5),
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
                  appointment.practitionerTitle,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  "${appointment.date} - ${appointment.time}",
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

  Widget _buildAppointmentList() {
    // Determine which appointments to show based on the filter
    final List<Appointment> filteredList;
    if (_selectedFilter == 'All Appointments' ||
        _selectedFilter == 'My Appointments') {
      filteredList = allAppointments; // Using dummy data
    } else {
      filteredList = []; // No data for other tabs in this example
    }

    return Column(
      children: filteredList.map((appointment) {
        return _buildAppointmentCard(appointment);
      }).toList(),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.grey.shade300, // Set border color
            width: 1.0, // Set border width
          )),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(appointment.imagePath),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.practitionerName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.practitionerTitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.centerName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF865940),
                      ),
                    ),
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
                                          padding: EdgeInsets.all(5),
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
                  const Text(
                    "Date & Time",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${appointment.date} - ${appointment.time}",
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
                  const Text(
                    "Starting at",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "\$${appointment.price.toStringAsFixed(2)}",
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
