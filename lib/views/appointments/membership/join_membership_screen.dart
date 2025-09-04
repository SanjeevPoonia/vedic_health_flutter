import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/views/appointments/membership/membership_detail_screen.dart';

class JoinMembershipScreen extends StatefulWidget {
  const JoinMembershipScreen({super.key});

  @override
  State<JoinMembershipScreen> createState() => _JoinMembershipScreenState();
}

class _JoinMembershipScreenState extends State<JoinMembershipScreen> {
  int selectedMembership = -1;

  final List<Map<String, dynamic>> membershipPlans = [
    {
      "title": "Basic Membership",
      "subtitle": "Every month Per person",
      "price": "\$29.00"
    },
    {
      "title": "E-Studio Membership",
      "subtitle": "Every month Per household",
      "price": "\$49.00"
    },
    {
      "title": "Premium Membership",
      "subtitle": "Every month Per person",
      "price": "\$99.00"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        body: SingleChildScrollView(
          child: Column(
            children: [
              /// Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Title & Subtitle
              const Text(
                "Join A Membership",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Get access to classes, events,\n discounts and more",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                ),
              ),

              const SizedBox(height: 20),

              /// Lottie Animation
              Lottie.asset(
                "assets/anotherdate.json",
                height: 220,
              ),

              const SizedBox(height: 20),

              /// Membership Options
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: membershipPlans.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final plan = membershipPlans[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedMembership = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: selectedMembership == index
                              ? const Color(0xFFB65303)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          /// Radio Circle
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: selectedMembership == index
                                    ? const Color(0xFFB65303)
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: selectedMembership == index
                                ? Center(
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFB65303),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),

                          /// Membership Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  plan["title"],
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  plan["subtitle"],
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Price
                          Text(
                            plan["price"],
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),

        /// Sticky Bottom Subscribe Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: selectedMembership == -1
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MembershipDetailScreen(),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Subscribe",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
