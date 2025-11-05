import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/book_appointment_screen2.dart';
import 'dart:convert';

class BookAppointmentScreen extends StatefulWidget {
  final List<dynamic> consultations;
  final String title;
  final String selectedServiceId;

  const BookAppointmentScreen(
      {super.key, required this.consultations, required this.title,required this.selectedServiceId});

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  List<Map<String, dynamic>> employees = [];
  String? selectedEmployeeId;
  String? selectedUserId;
  List<Map<String, dynamic>> additionalServices = [];
  bool isLoading = false;
  List<String> unavailableDates = [];
  List serviceList = [];
  String selectedServiceTitle="";
  String selectedServiceId="";
  @override
  void initState() {
    super.initState();
    selectedServiceTitle=widget.title;
    selectedServiceId=widget.selectedServiceId;
    serviceList = widget.consultations.map((e) => e["name"] ?? "").toList();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadService(selectedServiceId);
    });
  }
  Future<void> _loadService(String serviceId) async {
    final data = await fetchServiceDetail(serviceId);
    if (data != null) {
      setState(() {
        employees = List<Map<String, dynamic>>.from(data["employees"] ?? []);
        selectedEmployeeId = employees.isNotEmpty ? employees[0]["_id"] : null;
        selectedUserId = employees.isNotEmpty ? employees[0]["userId"] : null;
      });
      fetchUnavailableDates(
        serviceId: selectedServiceId,
        employeeId: selectedEmployeeId ?? "",
        userId: selectedEmployeeId ?? "",
        date: DateTime.now().toIso8601String().substring(0, 10),
      );
    }
  }
  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = DateTime(now.year, now.month + 3, now.day);

    DateTime candidate = selectedDate ?? now;

    String formatDate(DateTime d) => "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";

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
  Future<void> fetchUnavailableDates({required String serviceId, required String employeeId, required String userId, required String date,}) async {
    await fetchUnavailableDatesForService(
      serviceId: serviceId,
      employeeId: employeeId,
      userId: userId,
      date: date,
      serviceIndex: null, // null for main service
    );
  }
  Future<void> _loadServiceForAdditional(String serviceId, int serviceIndex) async {
    final data = await fetchServiceDetail(serviceId);
    if (data != null) {
      setState(() {
        additionalServices[serviceIndex]['employees'] =
            List<Map<String, dynamic>>.from(data["employees"] ?? []);
        additionalServices[serviceIndex]['selectedEmployeeId'] =
            additionalServices[serviceIndex]['employees'].isNotEmpty
                ? additionalServices[serviceIndex]['employees'][0]["_id"]
                : null;
        additionalServices[serviceIndex]['selectedUserId'] =
            additionalServices[serviceIndex]['employees'].isNotEmpty
                ? additionalServices[serviceIndex]['employees'][0]["userId"]
                : null;
      });
    }
  }
  Future<void> fetchUnavailableDatesForService({required String serviceId, required String employeeId, required String userId, required String date, int? serviceIndex,}) async {

    APIDialog.showAlertDialog(context, "Please Wait...");

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

    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    final responseJSON = json.decode(response.toString());
    print("Unavailable Dates response: $responseJSON");

    if (responseJSON["statusCode"] == 200) {
      final List<dynamic> fetched = responseJSON["data"] ?? [];
      if (fetched.isNotEmpty) {
        setState(() {
          if (serviceIndex == null) {
            unavailableDates = List<String>.from(
              fetched[0]["unavailableDates"] ?? [],
            );
          } else {
            additionalServices[serviceIndex]['unavailableDates'] =
                List<String>.from(
              fetched[0]["unavailableDates"] ?? [],
            );
          }
        });
      }
    }
  }
  void _addNewService() {
    setState(() {
      additionalServices.add({
        'selectedServiceIndex': 0,
        'selectedServiceId': widget.consultations[0]["_id"],
        'selectedServiceName': widget.consultations[0]["name"] ?? "",
        'employees': <Map<String, dynamic>>[],
        'selectedEmployeeId': null,
        'selectedUserId': null,
        'selectedDate': null,
        'unavailableDates': <String>[],
      });
    });
  }
  void _removeService(int index) {
    setState(() {
      additionalServices.removeAt(index);
    });
  }
  Future<void> _pickDateForService(BuildContext context, int? serviceIndex) async {
    final now = DateTime.now();
    final firstDate = now;
    final lastDate = DateTime(now.year, now.month + 3, now.day);

    List<String> serviceDates = serviceIndex == null
        ? unavailableDates
        : additionalServices[serviceIndex]['unavailableDates'] ?? [];

    DateTime? currentDate = serviceIndex == null
        ? selectedDate
        : additionalServices[serviceIndex]['selectedDate'];

    DateTime candidate = currentDate ?? now;

    String formatDate(DateTime d) => "${d.year.toString().padLeft(4, '0')}-"
        "${d.month.toString().padLeft(2, '0')}-"
        "${d.day.toString().padLeft(2, '0')}";

    while (serviceDates.contains(formatDate(candidate)) &&
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
        return !serviceDates.contains(formatted);
      },
    );

    if (picked != null) {
      setState(() {
        if (serviceIndex == null) {
          selectedDate = picked;
        } else {
          additionalServices[serviceIndex]['selectedDate'] = picked;
        }
      });
    }
  }
  Future<Map<String, dynamic>?> fetchServiceDetail(String serviceId) async {
    try {
      APIDialog.showAlertDialog(context, "Please wait...");

      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({"id": serviceId})))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "services_management/view",
        requestModel,
        context,
      );

      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

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
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                            selectedServiceTitle,
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
                        /*selectedEmployeeId = null;
                        selectedUserId = null;*/
                        selectedEmployeeId = employees.isNotEmpty ? employees[0]["_id"] : null;
                        selectedUserId = employees.isNotEmpty ? employees[0]["userId"] : null;
                      });
                      fetchUnavailableDates(
                        serviceId: selectedServiceId,
                        employeeId: selectedEmployeeId ?? "",
                        userId: selectedUserId ?? "",
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
                          serviceId: selectedServiceId,
                          employeeId: selectedEmployeeId ?? "",
                          userId: selectedEmployeeId ?? "",
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

              ...additionalServices.asMap().entries.map((entry) {
                int index = entry.key;
                Map<String, dynamic> service = entry.value;

                return Column(
                  children: [
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Service ${index + 2}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Spacer(),
                              GestureDetector(
                                onTap: () => _removeService(index),
                                child: Container(
                                  height: 22,
                                  width: 22,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2,
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
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          const Text("Select Service",
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: () =>
                                selectServiceBottomSheet(context, index),
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
                                    service['selectedServiceName'] ?? "Select",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text("Select Employee",
                              style: TextStyle(fontSize: 13)),
                          const SizedBox(height: 10),
                          GestureDetector(
                            onTap: service['employees'].isNotEmpty
                                ? () =>
                                    selectEmployeeBottomSheet(context, index)
                                : null,
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
                                    service['selectedEmployeeId'] == null
                                        ? "Any Employee"
                                        : (service['employees'] as List)
                                                .firstWhere(
                                                    (emp) =>
                                                        emp["_id"] ==
                                                        service[
                                                            'selectedEmployeeId'],
                                                    orElse: () => {
                                                          "name": "Select"
                                                        })["name"] ??
                                            "Select",
                                    style: const TextStyle(fontSize: 15),
                                  ),
                                  const Icon(Icons.keyboard_arrow_down,
                                      color: Colors.grey),
                                ],
                              ),
                            ),
                          ),
                          if (service['selectedEmployeeId'] != null ||
                              service['employees'].isNotEmpty) ...[
                            const SizedBox(height: 12),
                           /* const Text("Select Date",
                                style: TextStyle(fontSize: 13)),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _pickDateForService(context, index),
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
                                      service['selectedDate'] == null
                                          ? "Select"
                                          : "${service['selectedDate'].day}/${service['selectedDate'].month}/${service['selectedDate'].year}",
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
                            ),*/
                          ],
                        ],
                      ),
                    ),
                  ],
                );
              }).toList(),

              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  onPressed: _addNewService,
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

              if(selectedDate==null){
                Toast.show("Please select your date",duration: Toast.lengthLong,backgroundColor: Colors.red);
                return;
              }
              List<Map<String, dynamic>> allServicesData = [
                {
                  'serviceId': selectedServiceId,
                  'employeeId': selectedEmployeeId,
                  'userId': selectedUserId,
                  'date': selectedDate,
                  'serviceName': serviceList[selectedServiceIndex],
                }
              ];



              for (var service in additionalServices) {




                allServicesData.add({
                  'serviceId': service['selectedServiceId'],
                  'employeeId': service['selectedEmployeeId'],
                  'userId': service['selectedUserId'],
                  //'date': service['selectedDate'],
                  'date': selectedDate,
                  'serviceName': service['selectedServiceName'],
                });
              }

              bool hasUnavailableDate = false;

              if (selectedDate != null &&
                  (unavailableDates.contains(selectedDate!.toString()) ||
                      selectedDate!.isBefore(DateTime.now()))) {
                hasUnavailableDate = true;
              }

              for (int i = 0; i < additionalServices.length; i++) {
                var service = additionalServices[i];
                var serviceDate = service['selectedDate'];
                var serviceUnavailableDates = service['unavailableDates'] ?? [];

                if (serviceDate != null &&
                    (serviceUnavailableDates.contains(serviceDate.toString()) ||
                        serviceDate.isBefore(DateTime.now()))) {
                  hasUnavailableDate = true;
                  break;
                }
              }

              if (hasUnavailableDate) {
                SearchBottomSheet(context,allServicesData);
              } else {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookAppointmentScreen2(
                              allServicesData: allServicesData,
                              userId: selectedUserId ?? "",
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

                              final selectedService = widget.consultations[selectedServiceIndex];
                              selectedServiceTitle=selectedService['name']?.toString()??"";
                              selectedServiceId=selectedService['_id']?.toString()??"";
                              _loadService(selectedServiceId);
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
                              await _loadService(selectedServiceId);
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
  void SearchBottomSheet(BuildContext context, List<Map<String, dynamic>> allServicesData) {
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
                    /*Container(
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
                    ),*/
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
                                         AddToWaitlistScreen(allServicesData: allServicesData,),
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
                              List<Map<String, dynamic>> allServicesData = [
                                {
                                  'serviceId':selectedServiceId,
                                  'employeeId': selectedEmployeeId,
                                  'userId': selectedUserId,
                                  'date': selectedDate,
                                  'serviceName': serviceList[selectedServiceIndex],
                                }
                              ];

                              for (var service in additionalServices) {
                                allServicesData.add({
                                  'serviceId': service['selectedServiceId'],
                                  'employeeId': service['selectedEmployeeId'],
                                  'userId': service['selectedUserId'],
                                  'date': service['selectedDate'],
                                  'serviceName': service['selectedServiceName'],
                                });
                              }

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        BookAppointmentScreen2(
                                      allServicesData: allServicesData,
                                      userId: selectedUserId ?? "",
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
  void selectServiceBottomSheet(BuildContext context, int serviceIndex) {
    int tempSelectedIndex =
        additionalServices[serviceIndex]['selectedServiceIndex'];

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Select Service',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                            const Icon(Icons.clear, color: Color(0xFFAFAFAF))),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView.builder(
                      itemCount: serviceList.length,
                      itemBuilder: (BuildContext context, int pos) {
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              tempSelectedIndex = pos;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 10, bottom: 10, left: 13, right: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                tempSelectedIndex == pos
                                    ? const Icon(Icons.radio_button_checked,
                                        color: AppTheme.darkBrown)
                                    : const Icon(Icons.radio_button_off,
                                        color: Color(0xFF707070)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    serviceList[pos],
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black.withOpacity(0.6),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                        onTap: () async {
                          setState(() {
                            additionalServices[serviceIndex]
                                ['selectedServiceIndex'] = tempSelectedIndex;
                            additionalServices[serviceIndex]
                                    ['selectedServiceId'] =
                                widget.consultations[tempSelectedIndex]["_id"];
                            additionalServices[serviceIndex]
                                    ['selectedServiceName'] =
                                serviceList[tempSelectedIndex];
                            additionalServices[serviceIndex]
                                ['selectedEmployeeId'] = null;
                            additionalServices[serviceIndex]['selectedUserId'] =
                                null;
                            additionalServices[serviceIndex]['selectedDate'] =
                                null;
                          });
                          await _loadServiceForAdditional(
                              widget.consultations[tempSelectedIndex]["_id"],
                              serviceIndex);
                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 54,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
          ),
        );
      }),
    );
  }
  void selectEmployeeBottomSheet(BuildContext context, int serviceIndex) {
    List<Map<String, dynamic>> serviceEmployees =
        additionalServices[serviceIndex]['employees'] ?? [];
    String? tempSelectedEmployeeId =
        additionalServices[serviceIndex]['selectedEmployeeId'];

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
        return Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            color: Colors.white,
          ),
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Select Employee',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child:
                            const Icon(Icons.clear, color: Color(0xFFAFAFAF))),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 25),
                Expanded(
                  child: ListView(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            tempSelectedEmployeeId = null;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10, bottom: 10, left: 13, right: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              tempSelectedEmployeeId == null
                                  ? const Icon(Icons.radio_button_checked,
                                      color: AppTheme.darkBrown)
                                  : const Icon(Icons.radio_button_off,
                                      color: Color(0xFF707070)),
                              const SizedBox(width: 12),
                              const Expanded(
                                child: Text(
                                  "Any Employee",
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black54),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      ...serviceEmployees
                          .map((emp) => GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    tempSelectedEmployeeId = emp["_id"];
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 13, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      tempSelectedEmployeeId == emp["_id"]
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                          : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          emp["name"] ?? "Employee",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.black54),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ))
                          .toList(),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
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
                        onTap: () async {
                          setState(() {
                            additionalServices[serviceIndex]
                                ['selectedEmployeeId'] = tempSelectedEmployeeId;
                            additionalServices[serviceIndex]['selectedUserId'] =
                                tempSelectedEmployeeId != null
                                    ? serviceEmployees.firstWhere((emp) =>
                                        emp["_id"] ==
                                        tempSelectedEmployeeId)["userId"]
                                    : null;
                          });

                          // Fetch unavailable dates for this service
                          await fetchUnavailableDatesForService(
                            serviceId: additionalServices[serviceIndex]
                                ['selectedServiceId'],
                            employeeId: tempSelectedEmployeeId ?? "",
                            userId: tempSelectedEmployeeId ?? "",
                            date: DateTime.now()
                                .toIso8601String()
                                .substring(0, 10),
                            serviceIndex: serviceIndex,
                          );

                          Navigator.pop(context);
                        },
                        child: Container(
                            height: 54,
                            margin: const EdgeInsets.symmetric(horizontal: 15),
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
          ),
        );
      }),
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
