import 'package:flutter/material.dart';
// import 'package:flutter_number_captcha/flutter_number_captcha.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/utils/app_theme.dart';

import 'continue_bottom_sheet.dart';

class TicketFormScreen extends StatefulWidget {
  const TicketFormScreen({super.key});

  @override
  State<TicketFormScreen> createState() => _TicketFormScreenState();
}

class _TicketFormScreenState extends State<TicketFormScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
  String selectedwayName = 'Enter';
  bool agreeToPolicy = false;
  List waysList = [
    "Social Media",
    "Family or Friends",
    "Youtube/Facebook Ads",
    "Other",
  ];

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                              "Ticket Form",
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

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Color(0xFF662A09),
                              borderRadius: BorderRadius.circular(5)),
                          child: Text(
                            "Time Remaining: 20:01",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const OrderItemWidget(),
                        const SizedBox(height: 12),
                        const Text(
                          "ADD YOUR DETAILS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "*First Name",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Enter",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "*Last Name",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Enter",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "*Email",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Enter",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "Phone Number",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          width: double.maxFinite,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Enter",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          "How did you hear about us? *",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                // CircleAvatar(
                                //   maxRadius: 18,
                                //   backgroundColor: const Color(0xFFC7DEF3),
                                //   child: Text(
                                //     getInitials(selectedwayName),
                                //     style: const TextStyle(
                                //       fontSize: 15,
                                //       fontWeight: FontWeight.bold,
                                //       color: Colors.black,
                                //     ),
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 15,
                                // ),
                                Text(
                                  selectedwayName,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFFB65303),
                                  size: 25,
                                ),
                              ])),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        const Text(
                          "EVENT POLICIES",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const Text(
                          "Please indicate that you've read and agree to the event's policies",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF662A09),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Checkbox(
                              value: agreeToPolicy,
                              onChanged: (bool? value) {
                                setState(() {
                                  agreeToPolicy = value ?? false;
                                });
                              },
                              activeColor: const Color(0xFFB65303),
                            ),
                            Text(
                              "I agree to: ",
                              style: TextStyle(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              "Refund and Cancellation Policy",
                              style: TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
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
                  onTap: () {
                    ContinueBottomSheet.show(context);
                  },
                  child: Container(
                      height: 54,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF662A09)),
                      child: const Center(
                        child: Text("Continue",
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
        ),
      ),
    );
  }

  // void continueBottomSheet(BuildContext context) {
  //   showModalBottomSheet(
  //       backgroundColor: Colors.transparent,
  //       context: context,
  //       isScrollControlled: true, // Important for DraggableScrollableSheet
  //       builder: (context) => StatefulBuilder(
  //               builder: (BuildContext context, StateSetter setModalState) {
  //             return DraggableScrollableSheet(
  //                 initialChildSize: 0.8,
  //                 minChildSize: 0.5,
  //                 maxChildSize: 0.98,
  //                 expand: false,
  //                 builder: (context, scrollController) {
  //                   return Container(
  //                       margin: const EdgeInsets.symmetric(
  //                           horizontal: 15, vertical: 15),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white,
  //                         borderRadius: BorderRadius.circular(20),
  //                       ),
  //                       child: Padding(
  //                           padding: const EdgeInsets.all(20),
  //                           child: ListView(
  //                             controller: scrollController,
  //                             shrinkWrap: true,
  //                             children: [
  //                               // Illustration
  //                               Lottie.asset(
  //                                 "assets/check_animation.json",
  //                                 width: 220,
  //                                 height: 220,
  //                               ),
  //                               const SizedBox(height: 20),

  //                               // Title
  //                               const Text(
  //                                 "Please select another date",
  //                                 textAlign: TextAlign.center,
  //                                 style: TextStyle(
  //                                   fontSize: 20,
  //                                   fontWeight: FontWeight.bold,
  //                                   color: Colors.black87,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 15),

  //                               // Subtext
  //                               const Text(
  //                                 "You're all set for Seminar: Intro to Ayurveda with Amita Jain. A confirmation email has been sent to:",
  //                                 textAlign: TextAlign.center,
  //                                 maxLines: 3,
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: Colors.black54,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 8),

  //                               GestureDetector(
  //                                 onTap: () {},
  //                                 child: const Text(
  //                                   "john.smith@demo.org",
  //                                   style: TextStyle(
  //                                     fontSize: 14,
  //                                     color: Color(0xFFF38328),
  //                                     decoration: TextDecoration.underline,
  //                                   ),
  //                                 ),
  //                               ),
  //                               const Text(
  //                                 "Download Tickets",
  //                                 textAlign: TextAlign.center,
  //                                 maxLines: 3,
  //                                 style: TextStyle(
  //                                   fontSize: 14,
  //                                   color: Colors.black54,
  //                                 ),
  //                               ),
  //                               const SizedBox(height: 20),
  //                               const OrderItemWidget(),
  //                               const SizedBox(height: 10),
  //                               Text(
  //                                 "Add to calendar",
  //                                 style: TextStyle(
  //                                     // fontSize: 14,
  //                                     decoration: TextDecoration.underline,
  //                                     color: Colors.blue),
  //                               ),
  //                               const SizedBox(height: 20),
  //                               Row(
  //                                 children: [
  //                                   Expanded(
  //                                     child: ElevatedButton(
  //                                       onPressed: () {},
  //                                       style: ElevatedButton.styleFrom(
  //                                         backgroundColor:
  //                                             const Color(0xFFE3E3E3),
  //                                         shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(10),
  //                                         ),
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 15),
  //                                       ),
  //                                       child: const Text(
  //                                         "No",
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Colors.black,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   const SizedBox(width: 12),
  //                                   Expanded(
  //                                     child: ElevatedButton(
  //                                       onPressed: () {},
  //                                       style: ElevatedButton.styleFrom(
  //                                         backgroundColor:
  //                                             const Color(0xFF662A09),
  //                                         shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(10),
  //                                         ),
  //                                         padding: const EdgeInsets.symmetric(
  //                                             vertical: 15),
  //                                       ),
  //                                       child: const Text(
  //                                         "Yes",
  //                                         style: TextStyle(
  //                                           fontSize: 16,
  //                                           fontWeight: FontWeight.w600,
  //                                           color: Colors.white,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               )
  //                             ],
  //                           )));
  //                 });
  //           }));
  // }
}

class CustomTicketShape extends CustomClipper<Path> {
  final double borderRadius;
  CustomTicketShape(this.borderRadius);
  @override
  Path getClip(Size size) {
    final path = Path();
    final radius = Radius.circular(borderRadius);
// Starting point for the clipping path
    path.moveTo(0, size.height / 2 - 20);
// Create a curved edge on the left side of the ticket
    path.quadraticBezierTo(
        size.width * 0.10, size.height / 2, 0, size.height / 2 + 20);

    // Bottom left corner with rounded edge
    path.lineTo(0, size.height - borderRadius);
    path.arcToPoint(
      Offset(borderRadius, size.height),
      radius: radius,
      clockwise: false,
    );
// Bottom side and right corners
    path.lineTo(size.width - borderRadius, size.height);
    path.arcToPoint(
      Offset(size.width, size.height - borderRadius),
      radius: radius,
      clockwise: false,
    );
// Right-side curved notch
    path.lineTo(size.width, size.height / 2 + 20);
    path.quadraticBezierTo(
        size.width * 0.90, size.height / 2, size.width, size.height / 2 - 20);
// Finish top edge with rounded corners
    path.lineTo(size.width, borderRadius);
    path.arcToPoint(
      Offset(size.width - borderRadius, 0),
      radius: radius,
      clockwise: false,
    );
    path.lineTo(borderRadius, 0);
    path.arcToPoint(
      Offset(0, borderRadius),
      radius: radius,
      clockwise: false,
    );
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}

class OrderItemWidget extends StatelessWidget {
  const OrderItemWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main ticket-shaped container
        ClipPath(
          clipper: CustomTicketShape(10),
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFFCF6EF),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.all(18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 50,
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Seminar: Intro to Ayurveda with Amita Jain",
                        style: TextStyle(
                            color: Color(0xFF662A09),
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        "May 10, 2025, 10:00 AM - 11:00 AM EDT Vedic Health Center",
                        style: TextStyle(
                            color: Color(0xFF662A09),
                            fontWeight: FontWeight.w500,
                            fontSize: 10),
                      )
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Divider(
                    color: Colors.black,
                    height: 2,
                  ),
                ),
                Container(
                  height: 40,
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'RSVP',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            '\$0.00',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Qty.',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            '2',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Price',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          Text(
                            '\$0.00',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        // Border for the ticket shape
        CustomPaint(
          size: const Size(double.infinity, 150),
          painter: TicketBorderPainter(),
        ),
      ],
    );
  }
}

class TicketBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path =
        CustomTicketShape(10).getClip(size); // Adjust borderRadius as needed
    final paint = Paint()
      ..color = const Color(0xFFF38328)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
