import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_payment_screen.dart';

class BookAppointmentScreen2 extends StatefulWidget {
  final List<Map<String, dynamic>> allServicesData;
  final String userId;

  const BookAppointmentScreen2(
      {super.key, required this.allServicesData, required this.userId});

  @override
  State<BookAppointmentScreen2> createState() => _BookAppointmentScreen2State();
}

class _BookAppointmentScreen2State extends State<BookAppointmentScreen2> {
  DateTime? selectedDate;
  Map<String, int?> selectedSlots = {};

  bool isLoading = true;

  Map<String, dynamic> servicesWithSlots = {};

  @override
  void initState() {
    super.initState();
    if (widget.allServicesData.isNotEmpty) {
      selectedDate = widget.allServicesData[0]['date'];
    }
    fetchAvailableSlots();
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2023),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      fetchAvailableSlots();
    }
  }

  Future<void> fetchAvailableSlots() async {
    if (widget.allServicesData.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      servicesWithSlots = {};
    });

    try {
      var slotsPayload = {
        "slotsPayload": widget.allServicesData.map((serviceData) {
          return {
            "serviceId": serviceData["serviceId"],
            "employeeId": serviceData["employeeId"],
            "userId": serviceData["userId"],
            "date": DateFormat('yyyy-MM-dd').format(selectedDate!)
          };
        }).toList(),
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(slotsPayload)))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/checkAvailableSlot',
        requestModel,
        context,
      );

      var responseJSON = json.decode(response.toString());

      if (responseJSON["slots"] != null && responseJSON["slots"].isNotEmpty) {
        // Store the response data in the map
        for (var serviceSlot in responseJSON["slots"]) {
          final uniqueKey =
              "${serviceSlot['serviceDetails']['service']['_id']}_${serviceSlot['employeeData']['_id']}";
          servicesWithSlots[uniqueKey] = {
            'slots': serviceSlot['slots'],
            'employeeData': serviceSlot['employeeData'],
            'serviceDetails': serviceSlot['serviceDetails'],
            'allServiceData': widget.allServicesData.firstWhere(
                (element) =>
                    element['serviceId'] ==
                    serviceSlot['serviceDetails']['service']['_id'],
                orElse: () => {})
          };
        }
      }
    } catch (e) {
      print("Error fetching slots: $e");
    }

    setState(() {
      isLoading = false;
    });
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

              if (isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                ),

              if (!isLoading && servicesWithSlots.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text("No available services or slots found."),
                  ),
                ),

              ...servicesWithSlots.keys.map((serviceId) {
                final serviceData = servicesWithSlots[serviceId];
                final employeeData = serviceData['employeeData'];
                final serviceDetails = serviceData['serviceDetails'];
                final slots = serviceData['slots'];

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                                    serviceDetails['service']['name'] ?? "N/A",
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  GestureDetector(
                                    onTap: () => _pickDate(context),
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
                                      "https://randomuser.me/api/portraits/men/78.jpg"),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      employeeData["userDetails"]["name"] ??
                                          "N/A",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                      ),
                                    ),
                                    const Row(
                                      children: [
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                        Icon(Icons.star,
                                            color: Colors.amber, size: 18),
                                        Icon(Icons.star_half,
                                            color: Colors.amber, size: 18),
                                        SizedBox(width: 5),
                                        Text("(8)"),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "\$${serviceDetails['price']?.toDouble().toStringAsFixed(2) ?? "0.00"}",
                                      style: const TextStyle(
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

                      /// Time Slots
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(slots.length, (index) {
                            final slot = slots[index];
                            final start = DateTime.parse(slot["startTime"]);
                            final time = DateFormat("hh:mm a").format(start);

                            final isSelected =
                                selectedSlots[serviceId] == index;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (isSelected) {
                                    selectedSlots[serviceId] = null;
                                  } else {
                                    selectedSlots[serviceId] = index;
                                  }
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
                                  time,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey,
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
                      onPressed: () async {
                        // Build appointments from selected slots
                        List<Map<String, dynamic>> appointments = [];

                        selectedSlots.forEach((serviceKey, slotIndex) {
                          if (slotIndex != null) {
                            final selectedServiceData =
                                servicesWithSlots[serviceKey];
                            final slot =
                                selectedServiceData['slots'][slotIndex];
                            final allServiceData =
                                selectedServiceData['allServiceData'];
                            final serviceDetails =
                                selectedServiceData['serviceDetails'];

                            final appointment = {
                              "serviceId": allServiceData['serviceId'],
                              "employeeId": allServiceData['employeeId'],
                              "userId": allServiceData['userId'],
                              "note": "test",
                              "date": DateFormat('yyyy-MM-dd')
                                  .format(selectedDate!),
                              "time": DateFormat('HH:mm')
                                  .format(DateTime.parse(slot['startTime'])),
                              "deposit": 0,
                              "repeat": "Off",
                              "file": "",
                              // ✅ Take from serviceDetails to avoid null
                              "duration": int.tryParse(
                                      serviceDetails['duration'].toString()) ??
                                  60,
                              "price": serviceDetails['price'] ?? 0,
                            };

                            appointments.add(appointment);
                          }
                        });

                        if (appointments.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Please select a time slot to continue.")),
                          );
                          return;
                        }

                        try {
                          ApiBaseHelper helper = ApiBaseHelper();

                          // ✅ Encode same as checkAvailableSlot
                          var payload = {
                            "data": base64.encode(utf8.encode(
                                json.encode({"appointments": appointments})))
                          };

                          var response = await helper.postAPI(
                            'appointment-management/add',
                            payload,
                            context,
                          );

                          var responseJSON = json.decode(response.toString());

                          if (responseJSON["statusCode"] == 201) {
                            // success → navigate
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BookPaymentScreen(
                                  date: selectedDate!,
                                  userId: widget.userId,
                                  name: servicesWithSlots[
                                          selectedSlots.keys.first]
                                      ['employeeData']['userDetails']['name'],
                                ),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(responseJSON["message"] ??
                                      "Failed to book appointment")),
                            );
                          }
                        } catch (e) {
                          print("Error booking appointment: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    "Something went wrong. Please try again.")),
                          );
                        }
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
