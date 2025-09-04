import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_payment_screen.dart';

class BookAppointmentScreen2 extends StatefulWidget {
  final DateTime date;
  final String name;
  final String title;

  const BookAppointmentScreen2({
    super.key,
    required this.date,
    required this.name,
    required this.title,
  });
  @override
  State<BookAppointmentScreen2> createState() => _BookAppointmentScreen2State();
}

class _BookAppointmentScreen2State extends State<BookAppointmentScreen2> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
  int? selectedTimeIndex;
  List<String> availableTimes = [
    "10:00 AM",
    "11:00 AM",
    "12:00 PM",
    "01:00 PM",
    "02:00 PM",
  ];

  @override
  void initState() {
    super.initState();
    selectedDate = widget.date;
  }

  List serviceList = [
    "Ayurvedic Consult for Mild Conditions",
    "Ayurvedic Consult for Chronic Conditions",
    "Ayurvedic Consult for Mild Conditions",
    "Ayurvedic Health Consult - Virtual Visit",
    "Ayurvedic Follow Up"
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
                              "Book Appointment",
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

              // ... inside your build method

              /// Service Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCD9BE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 20,
                      child: Image.asset(
                        "assets/leaf.png",
                        height: 25,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Ayurvedic Consult for Mild Conditions", // This seems to be static, but you could pass it as a parameter as well
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              selectedDate != null
                                  ? DateFormat('E, MMM dd, yyyy')
                                      .format(selectedDate!)
                                  : "Select a date",
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Color(0xFF662A09),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              /// Doctor Card
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/men/78.jpg"), // Replace with actual image asset
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${widget.name}, ${widget.title}",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star_half,
                                    color: Colors.amber, size: 18),
                                SizedBox(width: 5),
                                Text("(8)"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "\$125.00", // This price is static, you could also pass this as a parameter
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const Text(
                      "Available Time",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 12, // horizontal spacing
                  runSpacing: 12, // vertical spacing
                  children: List.generate(availableTimes.length, (index) {
                    bool isSelected = selectedTimeIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedTimeIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFFF38328)
                              : const Color(0xFFDEEBF4),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          availableTimes[index],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              )
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important to keep it small
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey, // change color as per UI
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddToWaitlistScreen(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFF38328),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Add to waitlist",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookPaymentScreen(
                                date: widget.date,
                                name: widget.name,
                                title: widget.title,
                              ),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF662A09),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Continue",
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
      ),
    );
  }
}
