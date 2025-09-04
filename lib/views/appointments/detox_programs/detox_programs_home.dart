import 'package:flutter/material.dart';
import 'package:vedic_health/views/appointments/detox_programs/detox_programs_details.dart';

class DetoxProgramsHome extends StatefulWidget {
  const DetoxProgramsHome({super.key});

  @override
  State<DetoxProgramsHome> createState() => _DetoxProgramsHomeState();
}

class _DetoxProgramsHomeState extends State<DetoxProgramsHome> {
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
                              "Detox Programs",
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
                  child: Text(
                    "Our Cleanse Programs",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                children: [
                  CleanseCard(
                    imagePath: "assets/banner1.png",
                    title: "3-Day Cleanse",
                    benefits: [
                      "Mild digestive issues",
                      "Struggling with regular elimination",
                      "Occasional sleep disruptions",
                    ],
                    onReadMore: () {},
                  ),
                  CleanseCard(
                    imagePath: "assets/banner2.png",
                    title: "5-Day Cleanse",
                    benefits: [
                      "Food cravings",
                      "Frequent colds and flu",
                      "Brain fog, forgetfulness",
                    ],
                    onReadMore: () {},
                  ),
                  CleanseCard(
                    imagePath: "assets/banner2.png",
                    title: "15-Day Cleanse",
                    benefits: [
                      "Menstruation issues",
                      "Allergies",
                      "Digestive issues",
                    ],
                    onReadMore: () {},
                  ),
                  CleanseCard(
                    imagePath: "assets/banner2.png",
                    title: "30-Day Cleanse",
                    benefits: [
                      "Weight loss",
                      "Fogginess in the mind",
                      "Chronic fatigue",
                    ],
                    onReadMore: () {},
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

class CleanseCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final List<String> benefits;
  final VoidCallback onReadMore;

  const CleanseCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.benefits,
    required this.onReadMore,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const DetoxProgramsDetail(),
            ));
      },
      child: Container(
        height: 150,
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
                height: 150,
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
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Bullet Points
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: benefits.map((benefit) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "• ",
                              style: TextStyle(
                                  fontSize: 14,
                                  height: 1.4,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w900),
                            ),
                            Expanded(
                              child: Text(
                                benefit,
                                style: const TextStyle(
                                    fontSize: 12,
                                    height: 1.4,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 0),

                  /// Read More Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: onReadMore,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF38328),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "Read More",
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
