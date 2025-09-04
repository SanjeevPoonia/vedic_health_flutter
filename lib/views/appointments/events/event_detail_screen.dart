import 'package:flutter/material.dart';
import 'package:vedic_health/views/appointments/events/ticket_form_screen.dart';

class EventDetailScreen extends StatefulWidget {
  const EventDetailScreen({super.key});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  int quantity = 1;

  String selectedtickettype = 'Select';

  List ticketList = [
    "Social Media",
    "Family or Friends",
    "Youtube/Facebook Ads",
    "Other",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              /// Top Image
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  "assets/banner2.png",
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 12,
                left: 12,
                child: _circleIconButton(
                  icon: Icons.arrow_back_ios_new,
                  onTap: () => Navigator.pop(context),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: _circleIconButton(
                  icon: Icons.share_outlined,
                  onTap: () {},
                ),
              ),

              Container(
                margin: const EdgeInsets.only(top: 220),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //here
                      const Text(
                        "Seminar: Intro To Ayurveda With\nAmita Jain",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Know everything about Yantras, their mystical powers, types of yantras and the correct way to use them to fulfil your desires. Spaces are limited—reserve your spot today! Free for Members.",
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                      const SizedBox(height: 24),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Date & Location",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Row(
                            children: [
                              Icon(Icons.directions, color: Colors.blue),
                              SizedBox(
                                width: 4,
                              ),
                              Text(
                                "View Location",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "May 10, 2025, 10:00 AM - 11:00 AM EDT |\nVedic Health Center, 15235 Shady Grove Road, Suite 100,\nRockville MD 20850",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "About The Event",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Host: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " Amita Jain, Founder Vedic Health, AD",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Format: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "In Person Seminar",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontSize: 15, color: Colors.black),
                          children: [
                            TextSpan(
                              text: "Cost: ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: "\$0.00",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "What is the Ayurvedic medical system? What are the doshas and how does lifestyle and herbs help create balance? How can Ayurveda lead us back to a state of health and harmony? Learn about the philosophy of Ayurveda and it’s healing benefits. Ayurveda is an ancient system of medicine that originated in India over 3,000 years ago. It focuses on balancing the body, mind, and spirit to promote overall health and well-being. Participants will learn how simple lifestyle changes can enhance overall physical and emotional well-being. Everyone will have a chance to make their own custom herbal formula and meal plan. Registration is required. Free and open to the public.",
                        style: TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        /// Sticky Bottom Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {
              showModalBottomSheet(
                // isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => StatefulBuilder(
                    builder: (BuildContext context, StateSetter setModalState) {
                  return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Colors.white,
                    ),
                    padding: EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: SizedBox(
                      height: 350,
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Text('Register',
                                      style: TextStyle(
                                          fontSize: 19,
                                          fontFamily: "Montserrat",
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
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
                              const Text(
                                "Ticket ype",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(children: [
                                      // CircleAvatar(
                                      //   maxRadius: 18,
                                      //   backgroundColor:
                                      //       const Color(0xFFC7DEF3),
                                      //   child: Text(
                                      //     getInitials(selectedtickettype),
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
                                        selectedtickettype,
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
                                height: 15,
                              ),

                              /// Quantity Row
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Quantity",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: const Color(0xFFF5F5F5),
                                    ),
                                    child: Row(
                                      children: [
                                        _qtyButton(Icons.remove, () {
                                          if (quantity > 1) {
                                            setState(() {
                                              quantity--;
                                            });
                                          }
                                        }),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Text(
                                            "$quantity",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                        _qtyButton(Icons.add, () {
                                          setState(() {
                                            quantity++;
                                          });
                                        }),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 7),
                              Divider(),
                              const SizedBox(height: 7),

                              /// Price Row
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Price",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "\$29.00",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00BE55),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          height: 54,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  TicketFormScreen(),
                                            ));
                                      },
                                      child: Container(
                                          height: 54,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: const Color(0xFF662A09)),
                                          child: const Center(
                                            child: Text("Checkout",
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
                              const SizedBox(height: 20),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Register",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18),
      ),
    );
  }

  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
      ),
    );
  }
}
