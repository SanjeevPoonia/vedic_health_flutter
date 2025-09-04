import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/utils/app_theme.dart';

class AddToWaitlistScreen extends StatefulWidget {
  const AddToWaitlistScreen({super.key});

  @override
  State<AddToWaitlistScreen> createState() => _AddToWaitlistScreenState();
}

class _AddToWaitlistScreenState extends State<AddToWaitlistScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
  String selectedCustomerName = 'Customer Name'; // Default value

  List customerList = [
    "Smith Jhons  (Me)",
    "Rachel Smith  (Spouse)",
    "Jordan Houstan  (Child)",
    "Case Richardson  (Friend)",
    "Alexa Brown  (Parent)",
    "Emilia Smith  (Sibling)",
    "Lillie  (Pet)"
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
                              "Add to Waitlist",
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
                        const SizedBox(height: 12),
                        const Text(
                          "Customer Name",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            customerBottomSheet(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                CircleAvatar(
                                  maxRadius: 18,
                                  backgroundColor: const Color(0xFFC7DEF3),
                                  child: Text(
                                    getInitials(selectedCustomerName),
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  selectedCustomerName,
                                  style: const TextStyle(fontSize: 15),
                                ),
                                Spacer(),
                                const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color(0xFFB65303),
                                  size: 25,
                                ),
                              ])),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Service Provider",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
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
                            "Service provider",
                            style: TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Preferred Date",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
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
                        const SizedBox(height: 12),
                        const Text(
                          "Time",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
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
                                    "assets/time.svg",
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
              ),
              const SizedBox(height: 12),
              // Check if secondService is true, show the section
              secondService
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Select Date",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
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
                                children: [
                                  Container(
                                    height: 22,
                                    width: 22,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 5,
                                          color: const Color(0xFFB65303)),
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Icon(
                                      Icons.remove,
                                      color: Color(0xFFB65303),
                                      size: 12,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    selectedDate == null
                                        ? "Select"
                                        : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Spacer(),
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
                          const SizedBox(height: 12),
                          const Text(
                            "Time",
                            style: TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
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
                                      "assets/time.svg",
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
                  icon: const Icon(Icons.add, color: Colors.orange),
                  label: const Text("Add waitlist Date & Time "),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange,
                    elevation: 0,
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
                  onTap: () {},
                  child: Container(
                      height: 54,
                      margin: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: const Color(0xFF662A09)),
                      child: const Center(
                        child: Text("Save",
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

  String getInitials(String fullName) {
    // Remove any suffix in parentheses
    String cleanedName = fullName.split("(")[0].trim();

    // Split by spaces
    List<String> parts =
        cleanedName.split(" ").where((p) => p.isNotEmpty).toList();

    if (parts.isEmpty) return "";

    if (parts.length == 1) {
      // Only one word -> take first letter
      return parts[0][0].toUpperCase();
    } else {
      // First letter of first name + first letter of last name
      return parts[0][0].toUpperCase() + parts.last[0].toUpperCase();
    }
  }

  void customerBottomSheet(BuildContext context) {
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
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Select Member',
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
                            itemCount: customerList.length,
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
                                        CrossAxisAlignment.center,
                                    children: [
                                      selectedServiceIndex == pos
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                          : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                      const SizedBox(width: 20),
                                      Row(
                                        children: [
                                          CircleAvatar(
                                            backgroundColor:
                                                const Color(0xFFC7DEF3),
                                            child: Text(
                                              getInitials(customerList[pos]),
                                              style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            customerList[pos],
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ],
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
                              setState(() {
                                selectedCustomerName =
                                    customerList[selectedServiceIndex];
                              });
                              Navigator.pop(context);
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
}
