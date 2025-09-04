import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_family&friends_screen.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_appointment_screen2.dart';

class SelectOtherPersonScreen extends StatefulWidget {
  const SelectOtherPersonScreen({super.key});

  @override
  State<SelectOtherPersonScreen> createState() =>
      _SelectOtherPersonScreenState();
}

class _SelectOtherPersonScreenState extends State<SelectOtherPersonScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;

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
                              "Select Other Person",
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
                    "All Saved Persons (8)",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),

              /// Saved Person List
              ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: customerList.length,
                  itemBuilder: (BuildContext context, int pos) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedServiceIndex = pos;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 13, right: 10),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(width: 1, color: Colors.grey)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: const Color(0xFFC7DEF3),
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
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const Spacer(),
                              selectedServiceIndex == pos
                                  ? const Icon(Icons.radio_button_checked,
                                      color: AppTheme.darkBrown)
                                  : const Icon(Icons.radio_button_off,
                                      color: Color(0xFF707070)),
                              const SizedBox(width: 20),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 12),

              /// Date Picker
              const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    "Add Family and Friends",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )),

              Padding(
                padding: const EdgeInsets.all(14),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddFamilyFriendScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF38328),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Add New Family & Friends",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
