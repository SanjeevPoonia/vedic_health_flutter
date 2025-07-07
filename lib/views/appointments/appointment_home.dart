import 'package:flutter/material.dart';
import 'package:vedic_health/utils/app_theme.dart'; // Assuming this file exists and defines AppTheme
import 'package:vedic_health/views/appointments/appointment_detail.dart';
import 'package:vedic_health/views/profile_screen.dart';

// Dummy ProfileScreen for navigation
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: const Center(
        child: Text("Profile Screen"),
      ),
    );
  }
}

class AppointmentOption {
  final String title;
  final String description;
  final Color color;

  AppointmentOption({
    required this.title,
    required this.description,
    required this.color,
  });
}

class AppointmentHomeScreen extends StatefulWidget {
  const AppointmentHomeScreen({super.key});

  @override
  State<AppointmentHomeScreen> createState() => _AppointmentHomeScreenState();
}

class _AppointmentHomeScreenState extends State<AppointmentHomeScreen> {
  int selectedCenter = 0;
  final List<AppointmentOption> appointmentOptions = [
    AppointmentOption(
      title: "Ayurvedic Initial Consult",
      description:
          "Simply dummy text of the printing typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
      color: const Color(0xFFB9E0EC), // Light Teal/Blue
    ),
    AppointmentOption(
      title: "Follow Up Appointment",
      description:
          "Simply dummy text of the printing typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
      color: const Color(0xFFDBD4F7), // Light Purple
    ),
    AppointmentOption(
      title: "Panchakarma / Massage",
      description:
          "Simply dummy text of the printing typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
      color: const Color(0xFFFFE5AB), // Light Orange/Peach
    ),
    AppointmentOption(
      title: "Mental Health Counseling",
      description:
          "Simply dummy text of the printing typesetting industry. Lorem Ipsum has been the industry's standard dummy text.",
      color: const Color(0xFFBFF2C9), // Light Green
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Column(
    //       children: [
    //         Card(
    //           elevation: 2,
    //           margin: EdgeInsets.zero,
    //           color: Colors.white,
    //           shape: const RoundedRectangleBorder(
    //               borderRadius: BorderRadius.only(
    //                   bottomLeft: Radius.circular(15),
    //                   bottomRight: Radius.circular(15))),
    //           child: Container(
    //             height: 65,
    //             decoration: const BoxDecoration(
    //               color: Colors.white,
    //             ),
    //             padding: const EdgeInsets.symmetric(horizontal: 14),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //               children: [
    //                 // Menu Icon (Hamburger)
    //                 GestureDetector(
    //                   onTap: () {
    //                     // TODO: Open menu drawer if needed
    //                   },
    //                   child: Image.asset(
    //                     'assets/ham3.png',
    //                     width: 22,
    //                     height: 22,
    //                   ),
    //                 ),
    //                 // Title
    //                 const Text(
    //                   "Appointment",
    //                   style: TextStyle(
    //                     fontSize: 17,
    //                     fontWeight: FontWeight.w600,
    //                     color: Colors.black,
    //                   ),
    //                 ),
    //                 // Profile Icon
    //                 GestureDetector(
    //                   onTap: () {
    //                     Navigator.push(
    //                       context,
    //                       MaterialPageRoute(
    //                         builder: (context) => const ProfileScreen(),
    //                       ),
    //                     );
    //                   },
    //                   child: Image.asset(
    //                     'assets/profile_icc.png',
    //                     width: 32,
    //                     height: 32,
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Card(
              // elevation: 2,
              // margin: EdgeInsets.only(bottom: 10),
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
                    bottomLeft:
                        Radius.circular(20), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(20), // Adjust the radius as needed
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
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
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
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
                            builder: (context) => const ProfileScreen(),
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
                    const SizedBox(height: 20), // Add spacing below app bar
                    // Header with Image and Button
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
                                        // Handle book classes button tap
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
                        // The Positioned widget is now aligned so that the bottom of the image
                        // is flush with the bottom of the container, while still overflowing at the top.
                        Positioned(
                          right: -15,
                          // The bottom of the image is aligned with the bottom of the container.
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

                    // Center Selection Tabs
                    Container(
                      padding: const EdgeInsets.all(4),
                      height: 55,
                      decoration: BoxDecoration(
                        color: Colors.grey
                            .shade200, // Background color for the unselected part
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedCenter = 0),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedCenter == 0
                                      ? Colors.white
                                      : Colors
                                          .transparent, // Changed to transparent for unselected
                                  borderRadius: BorderRadius.circular(24),
                                  // boxShadow: selectedCenter == 0
                                  //     ? [
                                  //         BoxShadow(
                                  //           color: Colors.grey.withOpacity(0.3),
                                  //           spreadRadius: 2,
                                  //           blurRadius: 5,
                                  //           offset: const Offset(0, 3),
                                  //         )
                                  //   ]
                                  // : [],
                                ),
                                child: Center(
                                  child: Text(
                                    "Rockville Center",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedCenter == 0
                                          ? Colors.black
                                          : Colors.grey
                                              .shade700, // Darker grey for unselected
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // No SizedBox here, as the background container handles spacing
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => selectedCenter = 1),
                              child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: selectedCenter == 1
                                      ? Colors.white
                                      : Colors
                                          .transparent, // Changed to transparent for unselected
                                  borderRadius: BorderRadius.circular(24),
                                  // boxShadow: selectedCenter == 1
                                  //     ? [
                                  //         BoxShadow(
                                  //           color: Colors.grey.withOpacity(0.3),
                                  //           spreadRadius: 2,
                                  //           blurRadius: 5,
                                  //           offset: const Offset(0, 3),
                                  //         )
                                  //   ]
                                  // : [],
                                ),
                                child: Center(
                                  child: Text(
                                    "Denver Center",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: selectedCenter == 1
                                          ? Colors.black
                                          : Colors.grey
                                              .shade700, // Darker grey for unselected
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Appointment Grid
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75, // Lowered for more height
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
                          fontSize: 14,
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
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Book Button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: SizedBox(
                width: 100,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ConsultationScreen(),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF07442),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Book Now",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
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

class AsymmetricCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    final curveHeight = size.height * 0.12;

    // Start at top-left
    path.lineTo(0, 0);

    // Line to bottom-left
    path.lineTo(0, size.height - curveHeight);

    // Left inward curve (quadratic bezier)
    path.quadraticBezierTo(size.width * 0.25, size.height, size.width * 0.5,
        size.height - curveHeight);

    // Right outward curve (quadratic bezier)
    path.quadraticBezierTo(size.width * 0.75, size.height - curveHeight * 2,
        size.width, size.height - curveHeight);

    // Line to top-right
    path.lineTo(size.width, 0);

    // Close path
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
