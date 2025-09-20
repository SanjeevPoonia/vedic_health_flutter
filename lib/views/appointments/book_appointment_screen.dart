import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_appointment_screen2.dart';
import 'dart:convert';

class BookAppointmentScreen extends StatefulWidget {
  final List<dynamic> consultations;
  final String title;

  const BookAppointmentScreen(
      {super.key, required this.consultations, required this.title});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  bool secondService = false;
  List<Map<String, dynamic>> employees = [];
  String? selectedEmployeeId;
  String? selectedUserId;
  List<Map<String, dynamic>> selectedServices = [];

  bool isLoading = false;
  List<String> unavailableDates = [];

  List serviceList = [];

  @override
  void initState() {
    super.initState();
    serviceList = widget.consultations.map((e) => e["name"] ?? "").toList();

    if (widget.consultations.isNotEmpty) {
      _loadService(widget.consultations[0]["_id"]);
    }
  }

  /// Use ApiBaseHelper instead of direct http
  Future<Map<String, dynamic>?> fetchServiceDetail(String serviceId) async {
    try {
      setState(() => isLoading = true);

      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({"id": serviceId})))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "services_management/view",
        requestModel,
        context,
      );

      setState(() => isLoading = false);

      final responseJSON = json.decode(response.toString());
      print("Service detail response: $responseJSON");

      if (responseJSON["statusCode"] == 200 &&
          responseJSON["data"] != null &&
          responseJSON["data"].isNotEmpty) {
        return responseJSON["data"][0];
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching service detail: $e");
    }
    return null;
  }

  Future<Map<String, dynamic>?> searchSlots(String serviceId) async {
    try {
      setState(() => isLoading = true);

      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({
          "serviceId": serviceId,
          "employeeId": selectedEmployeeId,
          "userId": selectedUserId,
          "date": selectedDate
        })))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "appointment-management/checkAvailableSlot",
        requestModel,
        context,
      );

      setState(() => isLoading = false);

      final responseJSON = json.decode(response.toString());
      print("Service detail response: $responseJSON");

      if (responseJSON["statusCode"] == 200 &&
          responseJSON["data"] != null &&
          responseJSON["data"].isNotEmpty) {
        return responseJSON["data"][0];
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching service detail: $e");
    }
    return null;
  }

  Future<void> _loadService(String serviceId) async {
    final data = await fetchServiceDetail(serviceId);
    if (data != null) {
      setState(() {
        employees = List<Map<String, dynamic>>.from(data["employees"] ?? []);

        selectedEmployeeId = employees.isNotEmpty ? employees[0]["_id"] : null;
        selectedUserId = employees.isNotEmpty ? employees[0]["userId"] : null;
      });
    }
  }

  // Future<void> _loadSecondService(String serviceId) async {
  //   final data = await fetchServiceDetail(serviceId);
  //   if (data != null) {
  //     setState(() {
  //       secondemployees =
  //           List<Map<String, dynamic>>.from(data["employees"] ?? []);
  //       secondselectedEmployeeId =
  //           secondemployees.isNotEmpty ? secondemployees[0]["_id"] : null;
  //     });
  //   }
  // }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = DateTime(now.year, now.month + 3, now.day);

    // Start from today or previously selected date
    DateTime candidate = selectedDate ?? now;

    // Format helper
    String formatDate(DateTime d) => "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";

    // If candidate is in unavailableDates → move forward until valid
    while (unavailableDates.contains(formatDate(candidate)) &&
        candidate.isBefore(lastDate)) {
      candidate = candidate.add(const Duration(days: 1));
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: candidate,
      firstDate: firstDate,
      lastDate: lastDate,
      selectableDayPredicate: (day) {
        final formatted = formatDate(day);
        return !unavailableDates.contains(formatted);
      },
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> fetchUnavailableDates({
    required String serviceId,
    required String employeeId,
    required String userId,
    required String date, // format yyyy-MM-dd
  }) async {
    setState(() => isLoading = true);

    var data = {
      "slotsPayload": [
        {
          "serviceId": serviceId,
          "employeeId": employeeId,
          "userId": userId,
          "date": date,
        }
      ]
    };

    var requestModel = {
      'data': base64.encode(utf8.encode(json.encode(data))),
    };

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
      'appointment-management/getUnavailableDatesInMonth',
      requestModel,
      context,
    );

    setState(() => isLoading = false);

    final responseJSON = json.decode(response.toString());
    print("Unavailable Dates response: $responseJSON");

    if (responseJSON["statusCode"] == 200) {
      final List<dynamic> fetched = responseJSON["data"] ?? [];
      if (fetched.isNotEmpty) {
        setState(() {
          unavailableDates = List<String>.from(
            fetched[0]["unavailableDates"] ?? [],
          );
        });
      }
    } else {
      print("Error fetching unavailable dates: ${responseJSON["message"]}");
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
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              changeServiceBottomSheet(context);
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

              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                children: [
                  MemberCard(
                    name: "Any Employee",
                    isSelected: selectedEmployeeId == null,
                    onTap: () {
                      setState(() {
                        selectedEmployeeId = null; // null means "Any Employee"
                        selectedUserId = null;
                      });
                      fetchUnavailableDates(
                        serviceId: widget.consultations[selectedServiceIndex]
                            ["_id"],
                        employeeId: selectedEmployeeId ??
                            "", // pass empty string for Any Employee
                        userId: selectedUserId ??
                            "", // replace with actual logged-in user ID
                        date: DateTime.now().toIso8601String().substring(0, 10),
                      );
                    },
                  ),
                  for (var emp in employees)
                    MemberCard(
                      name: emp["name"] ?? "Employee",
                      isSelected: selectedEmployeeId == emp["_id"],
                      onTap: () {
                        setState(() {
                          selectedEmployeeId = emp["_id"];
                          selectedUserId = emp["userId"];
                        });
                        fetchUnavailableDates(
                          serviceId: widget.consultations[selectedServiceIndex]
                              ["_id"],
                          employeeId: selectedEmployeeId ??
                              "", // pass empty string for Any Employee
                          userId: selectedEmployeeId ??
                              "", // replace with actual logged-in user ID
                          date:
                              DateTime.now().toIso8601String().substring(0, 10),
                        );
                      },
                    ),
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
                              Container(
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
                                        const Text(
                                          "Select",
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              secondService = false;
                                            });
                                          },
                                          child: Container(
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
                                          ),
                                        )
                                      ])),
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
              secondService
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            secondService = true;
                          });
                          // Debug print to check if the button works
                          // You can remove this after confirming
                          print(
                              "Add Service tapped, secondService: $secondService");
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
                    )
                  : const SizedBox(height: 12),

              const SizedBox(height: 12),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {
              if (unavailableDates.contains(selectedDate!.toString()) ||
                  selectedDate!.isBefore(DateTime.now())) {
                SearchBottomSheet(context);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookAppointmentScreen2(
                              serviceId: serviceList[selectedServiceIndex],
                              employeeId: selectedEmployeeId!,
                              userId: selectedUserId!,
                              date: selectedDate!,
                            )));
              }
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
                                                // ignore: deprecated_member_use
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
                            onTap: () async {
                              final selectedService =
                                  widget.consultations[selectedServiceIndex];
                              await _loadService(selectedService["_id"]);
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

  void selectsecondServiceBottomSheet(BuildContext context) {
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
                                                // ignore: deprecated_member_use
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
                            onTap: () async {
                              final selectedService =
                                  widget.consultations[selectedServiceIndex];
                              await _loadService(selectedService["_id"]);
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
                    Lottie.asset(
                      "assets/anotherdate.json",
                      width: 220,
                      height: 220,
                    ),
                    const SizedBox(height: 20),

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
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookAppointmentScreen2(
                                      date: selectedDate ?? DateTime.now(),
                                      serviceId:
                                          serviceList[selectedServiceIndex],
                                      employeeId: selectedEmployeeId!,
                                      userId: selectedUserId!,
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

class MemberCard extends StatelessWidget {
  final String name;
  final String? role;
  final bool isSelected;
  final VoidCallback onTap;

  const MemberCard({
    Key? key,
    required this.name,
    this.role,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

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
      child: InkWell(
        onTap: onTap,
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
                    text: name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    children: [
                      if (role != null)
                        TextSpan(
                          text: "  ($role)",
                          style: TextStyle(
                              fontWeight: FontWeight.normal,
                              color: Colors.grey[700],
                              fontSize: 14),
                        ),
                    ],
                  ),
                ),
              ),
              Checkbox(value: isSelected, onChanged: (_) => onTap()),
            ],
          ),
        ),
      ),
    );
  }
}
