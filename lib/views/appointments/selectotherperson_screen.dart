import 'package:flutter/material.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_family&friends_screen.dart';

class SelectOtherPersonScreen extends StatefulWidget {
  final Map<String, dynamic> address;

  const SelectOtherPersonScreen({super.key, required this.address});

  @override
  State<SelectOtherPersonScreen> createState() =>
      _SelectOtherPersonScreenState();
}

class _SelectOtherPersonScreenState extends State<SelectOtherPersonScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
  List<Map<String, dynamic>> customerList = [];
  @override
  void initState() {
    super.initState();
    customerList.add(widget.address);
  }

  String getInitials(String fullName) {
    String cleanedName = fullName.split("(")[0].trim();

    List<String> parts =
        cleanedName.split(" ").where((p) => p.isNotEmpty).toList();

    if (parts.isEmpty) return "";

    if (parts.length == 1) {
      return parts[0][0].toUpperCase();
    } else {
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
                    final person = customerList[pos];
                    final name = person["name"] ?? "Unknown";
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
                              CircleAvatar(
                                backgroundColor: const Color(0xFFC7DEF3),
                                child: Text(
                                  getInitials(name),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                name,
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500),
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
