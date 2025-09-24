import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_appointment_screen2.dart';
import 'package:vedic_health/views/appointments/book_classes/select_class_screen.dart';

class BookClassScreen extends StatefulWidget {
  const BookClassScreen({super.key});

  @override
  State<BookClassScreen> createState() => _BookClassScreenState();
}

class _BookClassScreenState extends State<BookClassScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
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
                              "Book Class",
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
                            "Ayurvedic Consult for Mild Conditions",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const SelectClassScreen(),
                                  ));
                            },
                            child: const Text(
                              "Change",
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontWeight: FontWeight.w600,
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

              /// Practitioner Heading
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Select Practitioner",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),

              /// Practitioner List
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                children: const [
                  MemberCard(name: "Amita Jain", role: "AD"),
                  MemberCard(name: "Om Sanduja", role: "AWP"),
                  MemberCard(name: "Meena Sankar", role: "AWP"),
                  MemberCard(name: "Shweta Sharma", role: "BAMS"),
                ],
              ),

              /// Date Picker
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Select Date",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 14),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedDate == null
                                  ? "Select"
                                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                              style: const TextStyle(fontSize: 15),
                            ),
                            SizedBox(
                              height: 18,
                              width: 18,
                              child: SvgPicture.asset(
                                "assets/calendar.svg",
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),
              // Check if secondService is true, show the section
              secondService
                  ? Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Second Service",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Select Service",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    secondService = false;
                                  });
                                },
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 14),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey.shade400),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            "Select",
                                            style: TextStyle(fontSize: 15),
                                          ),
                                          Container(
                                            height: 22,
                                            width: 22,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  width: 5,
                                                  color:
                                                      const Color(0xFFB65303)),
                                              shape: BoxShape.circle,
                                              color: Colors.white,
                                            ),
                                            child: const Icon(
                                              Icons.remove,
                                              color: Color(0xFFB65303),
                                              size: 12,
                                            ),
                                          )
                                        ])),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Select Employee",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Container(
                                width: double.maxFinite,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 14),
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  "Select",
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Select Date",
                                style: TextStyle(
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () => _pickDate(context),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 14),
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        selectedDate == null
                                            ? "Select"
                                            : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                        style: const TextStyle(fontSize: 15),
                                      ),
                                      SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: SvgPicture.asset(
                                          "assets/calendar.svg",
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox(height: 12),

              const SizedBox(height: 12),

              /// Add Service Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      secondService = true;
                    });
                    // Debug print to check if the button works
                    // You can remove this after confirming
                    print("Add Service tapped, secondService: $secondService");
                  },
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text("Add Service"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {
              SearchBottomSheet(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              "Search",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }

  void changeServiceBottomSheet(BuildContext context) {
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
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
                          child: Text('Change Service',
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
                        // height: 150,
                        child: ListView.builder(
                            itemCount: serviceList.length,
                            itemBuilder: (BuildContext context, int pos) {
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedServiceIndex = pos;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 13, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      selectedServiceIndex == pos
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                          : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          serviceList[pos],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
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
                              if (selectedServiceIndex != 9999) {
                                selectedServiceDrop =
                                    serviceList[selectedServiceIndex]
                                            ["duration_terms"]
                                        .toString();
                                setState(() {});
                                Navigator.pop(context);
                              }
                            },
                            child: Container(
                                height: 54,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("Submit",
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
  }

  void SearchBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: SizedBox(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Illustration
                    Lottie.asset(
                      "assets/anotherdate.json",
                      width: 220,
                      height: 220,
                    ),
                    const SizedBox(height: 20),

                    // Title
                    const Text(
                      "Please select another date",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Subtext
                    const Text(
                      "There are no available appointments on this day, "
                      "but call us to check for any last minute openings.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 8),

                    GestureDetector(
                      onTap: () {},
                      child: const Text(
                        "(240) 753-0151",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Next available date card
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFCD9BE),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Center(
                        child: Text(
                          "Next available date: Tue, Apr 1, 2025",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const AddToWaitlistScreen(),
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
                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //       builder: (context) =>
                              //           BookAppointmentScreen2(
                              //         date: selectedDate ?? DateTime.now(),
                              //         serviceId: "",
                              //         employeeId: "",
                              //         userId: "",
                              //       ),
                              //     ));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF662A09),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                            child: const Text(
                              "Go to Date",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class MemberCard extends StatefulWidget {
  final String name;
  final String role;

  const MemberCard({Key? key, required this.name, required this.role})
      : super(key: key);

  @override
  _MemberCardState createState() => _MemberCardState();
}

class _MemberCardState extends State<MemberCard> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.orange,
              child: Icon(Icons.person, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: RichText(
                text: TextSpan(
                  text: widget.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black),
                  children: [
                    TextSpan(
                      text: "  (${widget.role})",
                      style: TextStyle(
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700],
                          fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: (val) {
                setState(() {
                  isSelected = val ?? false;
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
