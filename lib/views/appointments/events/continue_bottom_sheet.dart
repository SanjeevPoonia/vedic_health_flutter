import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart'; // Make sure to add the lottie package to your pubspec.yaml

class ContinueBottomSheet extends StatelessWidget {
  const ContinueBottomSheet({Key? key}) : super(key: key);

  static void show(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.85,
          minChildSize: 0.5,
          maxChildSize: 0.98,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: ListView(
                  controller: scrollController,
                  shrinkWrap: true,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Positioned(
                          child: GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.clear,
                                color: Color(0xFFAFAFAF),
                              )),
                        ),
                      ],
                    ),
                    // Illustration
                    Lottie.asset(
                      "assets/check_animation.json",
                      width: 220,
                      height: 220,
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      "Thank you, John",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Subtext
                    const Text(
                      "You're all set for Seminar: Intro to Ayurveda with Amita Jain. A confirmation email has been sent to:",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),

                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        textAlign: TextAlign.center,
                        "john.smith@demo.org",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFFF38328),
                            decoration: TextDecoration.underline,
                            decorationColor: Color(0xFFF38328)),
                      ),
                    ),
                    const SizedBox(height: 8),

                    const Text(
                      "Download Tickets",
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const OrderItemWidget(),
                    const SizedBox(height: 10),
                    const Text(
                      "Add to calendar",
                      style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .pop(); // Close the bottom sheet
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE3E3E3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "No",
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
                              Navigator.of(context)
                                  .pop(); // Close the bottom sheet
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF662A09),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Yes",
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
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // This build method is now empty because show() is a static method
    // and is not part of the widget's layout.
    return const SizedBox.shrink();
  }
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
                            fontSize: 13),
                      ),
                      Text(
                        "May 10, 2025, 10:00 AM - 11:00 AM EDT Vedic Health Center",
                        style: TextStyle(
                            color: Color(0xFF662A09),
                            fontWeight: FontWeight.w500,
                            fontSize: 9),
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
