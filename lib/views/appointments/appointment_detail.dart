import 'package:flutter/material.dart';

class ConsultationScreen extends StatelessWidget {
  const ConsultationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_sharp,
                          size: 17, color: Colors.black),
                    ),
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "Ayurvedic Initial Consult",
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
            const SizedBox(height: 2),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: const [
                  ConsultationCard(
                    title: 'Ayurvedic Consult for Mild Conditions',
                    price: '\$125.00',
                    description:
                        'Our certified Ayurvedic Practitioner will conduct a thorough evaluation to determine the root cause of ...',
                  ),
                  SizedBox(height: 16),
                  ConsultationCard(
                    title: 'Ayurvedic Consult for Chronic Conditions',
                    price: '\$145.00',
                    description:
                        'Our highly trained Ayurvedic Doctors help you regain optimal health using a natural and holistic approach by ...',
                  ),
                  SizedBox(height: 16),
                  ConsultationCard(
                    title: 'Ayurvedic Dosha Evaluation',
                    price: '\$95.00',
                    description:
                        'Identify your dominant dosha, prakriti, and vikriti through a comprehensive evaluation with a certified Ayurvedic Practitioner, who will assess your ...',
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

class ConsultationCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;

  const ConsultationCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Container(
        decoration: BoxDecoration(
          // border: BoxBorder.all(color: Color(0xFFE2D7D7)),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: Row(
          children: [
            // Left: Icon, Price, Button
            Container(
              width: 125,
              decoration: BoxDecoration(
                color: Color(0xFFF8F8F8),
                // border: BoxBorder.fromLTRB(
                //     right: BorderSide(color: Color(0xFFE2D7D7))),
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topLeft: Radius.circular(10)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // border: BoxBorder.all(color: Color(0xFFE2D7D7)),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 18,
                        child: Image.asset(
                          "assets/leaf.png",
                          height: 25,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      price,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 30,
                      child: TextButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF38328),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "Book Now",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),
            // Right: Title and Description
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      height: 1.3,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
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
