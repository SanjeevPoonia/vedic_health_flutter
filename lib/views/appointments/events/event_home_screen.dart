import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/views/appointments/events/event_detail_screen.dart';

class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({super.key});

  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
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
                              "Events",
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

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Event of the month",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Container
              Container(
                padding: const EdgeInsets.all(12),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          "assets/banner2.png",
                          fit: BoxFit.cover,
                        ),
                      ),
                      // Shadow overlay
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black54,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Text on top left
                      const Positioned(
                        top: 16,
                        left: 16,
                        child: Text(
                          "Create your own Yantra: Journey\ninto Sacred Geomtery",
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF38328),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text(
                            "RSVP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF865940),
                                      Color(0xFFE77735)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                "May\n27",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Tue, 6:45 PM - 7:45 PM",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Vedic Health Center",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "UPCOMING EVENTS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  EventCard(
                    imagePath: "assets/banner1.png",
                    title: "Ayurvedic Spring'25 Group Detox",
                    timing: "Thu, May 22 | Vedic Health Center",
                    onRSVP: () {},
                  ),
                  EventCard(
                    imagePath: "assets/banner2.png",
                    title: "Yantras : Key to Cosmic Consciousness",
                    timing: "Thu, May 29 | Vedic Health Center",
                    onRSVP: () {},
                  ),
                  EventCard(
                    imagePath: "assets/banner2.png",
                    title: "Seminar: Dosha Series - Explore Pitta Dosha",
                    timing: "Mon, Jul 21 | Jain Yoga Studio",
                    onRSVP: () {},
                  ),
                  EventCard(
                    imagePath: "assets/banner2.png",
                    title: "Group Hiking and Yoga at Great Falls",
                    timing: "Mon, Jul 21 | Jain Yoga Studio",
                    onRSVP: () {},
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String timing;
  final VoidCallback onRSVP;

  const EventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.timing,
    required this.onRSVP,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const EventDetailScreen(),
            ));
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        // padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imagePath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Title
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Bullet Points
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            timing,
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ]),

                  const SizedBox(height: 4),

                  /// Read More Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: onRSVP,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF38328),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "RSVP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
