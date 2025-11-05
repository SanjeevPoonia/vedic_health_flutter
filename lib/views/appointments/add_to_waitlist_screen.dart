import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/name_avatar.dart';
import 'package:intl/intl.dart';

import '../home_screen.dart';

class AddToWaitlistScreen extends StatefulWidget {
  final List<Map<String, dynamic>> allServicesData;

  const AddToWaitlistScreen({super.key,required this.allServicesData});

  @override
  State<AddToWaitlistScreen> createState() => _AddToWaitlistScreenState();
}

class _AddToWaitlistScreenState extends State<AddToWaitlistScreen> {
  DateTime? selectedDate;
  int selectedServiceIndex = 0;
  String selectedServiceTitle="";
  String selectedServiceId="";
  List<Map<String, dynamic>> employees = [];
  String? selectedEmployeeId;
  String? selectedUserId;
  String? selectedEmployeeName;
  int selectedEmployeeIndex=0;
  List<String> unavailableDates = [];
  String? userId;
  List<availableTimeSlots> avTimeSlotList=[];

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


  String? selectedTimeFromServer;
  String? selectedTimeLocal;
  int selectedTimePosition=0;

  List<multipleTimeModel> multipletimeList=[];


  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      String selected=DateFormat('yyyy-MM-dd').format(selectedDate!);
      if(unavailableDates.contains(selected)){
        Toast.show(
            "Employee Not available on $selected",duration: Toast.lengthLong,backgroundColor: Colors.red);
      }else{
        fetchAvailableSlots();
      }


    }
  }
  Future<void> _pickDateForServer(BuildContext context,int position,DateTime? alreadySelectedDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != alreadySelectedDate) {

      DateTime? selDate=picked;


      setState(() {
        multipletimeList[position].selectedDate=selDate;
      });

      String selected=DateFormat('yyyy-MM-dd').format(selDate);
      if(unavailableDates.contains(selected)){
        Toast.show(
            "Employee Not available on $selected",duration: Toast.lengthLong,backgroundColor: Colors.red);
      }else{
        fetchAvailableSlotsForService(position,selDate);
      }


    }
  }
  Future<void> _loadService(String serviceId) async {
    final data = await fetchServiceDetail(serviceId);

    if (data != null) {
      setState(() {
        employees = List<Map<String, dynamic>>.from(data["employees"] ?? []);
        selectedEmployeeId = employees.isNotEmpty ? employees[0]["_id"] : null;
        selectedUserId = employees.isNotEmpty ? employees[0]["userId"] : null;
        selectedEmployeeName=employees.isNotEmpty?employees[0]['name'] : null;
      });

      fetchUnavailableDates(
        serviceId: selectedServiceId,
        employeeId: selectedEmployeeId ?? "",
        userId: selectedUserId??"",
        date: DateTime.now().toIso8601String().substring(0, 10),
      );
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
      print("Error fetching service detail: $e");
    }
    return null;
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

    unavailableDates.clear();
    if (responseJSON["statusCode"] == 200) {
      final List<dynamic> fetched = responseJSON["data"] ?? [];
      if (fetched.isNotEmpty) {
        setState(() {
            unavailableDates = List<String>.from(fetched[0]["unavailableDates"] ?? [],
            );
        });
      }
    }
  }
  Future<void> fetchAvailableSlots() async {

    APIDialog.showAlertDialog(context, "Please wait...");

    try {
      var slotsPayload = {
        "slotsPayload": [
          {
            "serviceId": selectedServiceId,
            "employeeId": selectedEmployeeId,
            "userId": selectedUserId ?? "",
            "date": DateFormat('yyyy-MM-dd').format(selectedDate!)
          }
        ],
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(slotsPayload)))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/unAvailableSlotsInDate',
        requestModel,
        context,
      );
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      var responseJSON = json.decode(response.toString());

      avTimeSlotList.clear();

      if (responseJSON["slots"] != null && responseJSON["slots"].isNotEmpty) {

        List<dynamic> slots=responseJSON['slots'][0]['slots'];
        // Store the response data in the map
        for (var serviceSlot in slots) {


          String startTime=serviceSlot['startTime']?.toString()??"";
          String endTime=serviceSlot['endTime']?.toString()??"";
          String slotTime=formatTimeUtc(startTime);
          avTimeSlotList.add(availableTimeSlots(startTime, endTime, slotTime));
        }

        print(avTimeSlotList.length);
        print(avTimeSlotList);
        setState(() {

        });
      }
      setState(() {

      });
    } catch (e) {
      print("Error fetching slots: $e");
      setState(() {

      });
    }



  }
  Future<void> fetchAvailableSlotsForService(int position,DateTime? serviceDate) async {

    APIDialog.showAlertDialog(context, "Please wait...");

    try {
      var slotsPayload = {
        "slotsPayload": [
          {
            "serviceId": selectedServiceId,
            "employeeId": selectedEmployeeId,
            "userId": selectedUserId ?? "",
            "date": DateFormat('yyyy-MM-dd').format(serviceDate!)
          }
        ],
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(slotsPayload)))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'appointment-management/unAvailableSlotsInDate',
        requestModel,
        context,
      );
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      var responseJSON = json.decode(response.toString());

      List<availableTimeSlots> avTimeSlots=[];

      if (responseJSON["slots"] != null && responseJSON["slots"].isNotEmpty) {

        List<dynamic> slots=responseJSON['slots'][0]['slots'];
        // Store the response data in the map
        for (var serviceSlot in slots) {


          String startTime=serviceSlot['startTime']?.toString()??"";
          String endTime=serviceSlot['endTime']?.toString()??"";
          String slotTime=formatTimeUtc(startTime);
          avTimeSlots.add(availableTimeSlots(startTime, endTime, slotTime));
        }

        multipletimeList[position].availableSlotsList=avTimeSlots;


        setState(() {

        });
      }
      setState(() {

      });
    } catch (e) {
      print("Error fetching slots: $e");
      setState(() {

      });
    }



  }
  @override
  void initState() {
    super.initState();
    if (widget.allServicesData.isNotEmpty) {
      _getUserDetails();
    }
  }
  _getUserDetails()async{
    userId= await MyUtils.getSharedPreferences("user_id");
    final selectedService = widget.allServicesData[selectedServiceIndex];
    selectedServiceTitle=selectedService['serviceName']?.toString()??"";
    selectedServiceId=selectedService['serviceId']?.toString()??"";
    _loadService(selectedServiceId);
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
                          "Select Service",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                           // customerBottomSheet(context);
                            changeServiceBottomSheet(context);
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
                                  backgroundColor: Colors.white,
                                  radius: 18,
                                  child: Image.asset(
                                    "assets/leaf.png",
                                    height: 25,
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  selectedServiceTitle,
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
                          "Select Employee",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            // customerBottomSheet(context);
                            selectEmployeeBottomSheet(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(children: [
                                NameAvatar(fullName: selectedEmployeeName,size: 30,),
                                const SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  selectedEmployeeName??"N/A",
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

                        unavailableDates.isNotEmpty?
                        const Text(
                          "Employee Not available on",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ):Container(),
                        SizedBox(height: 10,),
                        unavailableDates.isNotEmpty?
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: List.generate(unavailableDates.length, (index) {
                              String unAvailableDate = unavailableDates[index].toString();
                              String dateStr=formatDate(unAvailableDate);
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 6),
                                decoration: BoxDecoration(
                                  color:  const Color(0xFFFBABB1),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  dateStr,
                                  style: const TextStyle(
                                    color:  Colors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            }),
                          ),
                        ):Container(),


                        const SizedBox(height: 10,),
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
                          "Select Time",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () => selectTimeBottomSheet(context),
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
                                  selectedTimeLocal == null
                                      ? "Select Time"
                                      : selectedTimeLocal??"",
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

              multipletimeList.isNotEmpty?
                  ListView.builder(
                    shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: multipletimeList.length,
                      itemBuilder: (context,index){
                      DateTime? selDate=multipletimeList[index].selectedDate;
                      String? selectedServerTime=multipletimeList[index].selectedDateTimeServer;
                      String? selectedTimeLocal = multipletimeList[index].selectedDateTimeLocal;
                      int selectedSlotPosition = multipletimeList[index].selectedTimePosition??0;
                      List<availableTimeSlots> availableTimeSlotList = multipletimeList[index].availableSlotsList??[];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Select Date",
                                  style: TextStyle(
                                      fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
                               InkWell(
                                 onTap: (){
                                   _removeWaitListMultiTime(index);
                                 },
                                 child: const Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                                 child: Icon(Icons.remove_circle,size: 20,color: Colors.red,),
                                 ),
                               ) 
                              ],
                            ),
                            
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => _pickDateForServer(context,index,selDate),
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
                                      selDate == null
                                          ? "Select Date"
                                          : "${selDate!.day}/${selDate!.month}/${selDate!.year}",
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
                              "Select Time",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            GestureDetector(
                              onTap: () => {
                                if(availableTimeSlotList.isNotEmpty){
                                  selectTimeBottomSheetForService(context,availableTimeSlotList,selectedSlotPosition,index)
                                }
                              },
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
                                      selectedTimeLocal == null
                                          ? "Select Time"
                                          : selectedTimeLocal??"",
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
                      );
                      })
                  :Container(),




              const SizedBox(height: 12),

              /// Add Service Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: ElevatedButton.icon(
                  onPressed: () {
                    _addWaitListMultiTime();
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
                  onTap: () {
                    addWaitList();
                  },
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
  String formatDate(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM,yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  String formatTimeUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('hh:mm a').format(dateTime);
    } catch (e) {
      return date;
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
                                selectedCustomerName = customerList[selectedServiceIndex];
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
                              child: Text('Select Service',
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
                                itemCount: widget.allServicesData.length,
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
                                              widget.allServicesData[pos]['serviceName'],
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
                                  final selectedService = widget.allServicesData[selectedServiceIndex];
                                  selectedServiceTitle=selectedService['serviceName']?.toString()??"";
                                  selectedServiceId=selectedService['serviceId']?.toString()??"";
                                  Navigator.pop(context);
                                  _loadService(selectedServiceId);

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
  void selectEmployeeBottomSheet(BuildContext context) {
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
                              child: Text('Select Employee',
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
                                itemCount: employees.length,
                                itemBuilder: (BuildContext context, int pos) {
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedEmployeeIndex=pos;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, left: 13, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          selectedEmployeeIndex == pos
                                              ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                              : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              employees[pos]['name']??"N/A",
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

                                  final selectedEmployee = employees[selectedEmployeeIndex];
                                  selectedEmployeeId = selectedEmployee["_id"]??"";
                                  selectedUserId = selectedEmployee["userId"]??"";
                                  selectedEmployeeName=selectedEmployee['name']??"";
                                  setState(() {

                                  });
                                  Navigator.pop(context);
                                  fetchUnavailableDates(
                                      serviceId: selectedServiceId,
                                      employeeId: selectedEmployeeId??"",
                                      userId: selectedUserId??"",
                                      date: "");

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
  void selectTimeBottomSheet(BuildContext context) {
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
                              child: Text('Select Time',
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
                                itemCount: avTimeSlotList.length,
                                itemBuilder: (BuildContext context, int pos) {
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        selectedTimePosition=pos;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, left: 13, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          selectedTimePosition == pos
                                              ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                              : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              avTimeSlotList[pos].slotTime,
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

                                  final selectedTime = avTimeSlotList[selectedTimePosition];
                                  selectedTimeLocal = selectedTime.slotTime;
                                  selectedTimeFromServer = selectedTime.startTime;
                                  setState(() {

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
  void selectTimeBottomSheetForService(BuildContext context,List<availableTimeSlots> slotList,int alreadySelectedPositon,int mainListPostion) {

    int timePosition=alreadySelectedPositon;

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
                              child: Text('Select Time',
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
                                itemCount: slotList.length,
                                itemBuilder: (BuildContext context, int pos) {
                                  return GestureDetector(
                                    onTap: () {
                                      setModalState(() {
                                        timePosition=pos;
                                      });
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.only(
                                          top: 10, bottom: 10, left: 13, right: 10),
                                      child: Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          timePosition == pos
                                              ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                              : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              slotList[pos].slotTime,
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

                                  final selectedTime = slotList[timePosition];
                                  String selectedTLocal=selectedTime.slotTime;
                                  String selectedFromServer=selectedTime.startTime;

                                  multipletimeList[mainListPostion].selectedTimePosition=timePosition;
                                  multipletimeList[mainListPostion].selectedDateTimeLocal=selectedTLocal;
                                  multipletimeList[mainListPostion].selectedDateTimeServer=selectedFromServer;
                                  setState(() {

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

  String formatDateUtc24(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('HH:mm').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  addWaitList() async {

    if(selectedServiceId.isEmpty){
      Toast.show("Please Select Service",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else if(selectedEmployeeId==null || selectedEmployeeId!.isEmpty){
      Toast.show("Please Select Employee",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else if(selectedDate==null){
      Toast.show("Please Select Date",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }
    String selected=DateFormat('yyyy-MM-dd').format(selectedDate!);
    if(unavailableDates.contains(selected)){
      Toast.show("Employee Not available on $selected",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }

    if(selectedTimeFromServer==null || selectedTimeFromServer!.isEmpty){
      Toast.show("Please select Time",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }

    List<Map<String, dynamic>> appointments = [];
    final waitTime = {
      "serviceId": selectedServiceId,
      "employeeId": selectedEmployeeId,
      "userId": userId??"",
      "date": DateFormat('yyyy-MM-dd').format(selectedDate!),
      "time": formatDateUtc24(selectedTimeFromServer??""),
    };
    appointments.add(waitTime);

    for(var mulitService in multipletimeList){
      DateTime? selDate=mulitService.selectedDate;
      String? selectedSeTime=mulitService.selectedDateTimeServer;
      if(selDate!=null && selectedSeTime!=null){
        final waitTime = {
          "serviceId": selectedServiceId,
          "employeeId": selectedEmployeeId,
          "userId": userId??"",
          "date": DateFormat('yyyy-MM-dd').format(selDate!),
          "time": formatDateUtc24(selectedSeTime??""),
        };
        appointments.add(waitTime);
      }

    }



    var data={
      'waitlistData':appointments
    };



    APIDialog.showAlertDialog(context, "Please wait...");

    ApiBaseHelper helper = ApiBaseHelper();
    var payload = {
      "data": base64.encode(utf8.encode(json.encode({"data": data})))
    };
    var response = await helper.postAPI('waitlist/addWaitlist', payload, context);
    var responseJSON= json.decode(response.toString());
    Navigator.of(context).pop();
    int statusCode=responseJSON['statusCode']??0;

    if(statusCode==201){
      Toast.show(responseJSON['data']?['message']?.toString()??"Added in Waitlist",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _redirectToHome();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }

  }

  _redirectToHome(){
    Route route = MaterialPageRoute(builder: (context) => HomeScreen());
    Navigator.pushAndRemoveUntil(
        context, route, (Route<dynamic> route) => false);
  }

  _addWaitListMultiTime(){

    multipletimeList.add(multipleTimeModel(null, null, null, 0, null));
    setState(() {

    });
  }
  _removeWaitListMultiTime(int position){

    multipletimeList.removeAt(position);
    setState(() {

    });
  }


}

class multipleTimeModel{
  DateTime? selectedDate;
  String? selectedDateTimeServer;
  String? selectedDateTimeLocal;
  int selectedTimePosition;
  List<availableTimeSlots>? availableSlotsList;

  multipleTimeModel(
      this.selectedDate,
      this.selectedDateTimeServer,
      this.selectedDateTimeLocal,
      this.selectedTimePosition,
      this.availableSlotsList);
}
class availableTimeSlots{
  String startTime;
  String endTime;
  String slotTime;

  availableTimeSlots(this.startTime, this.endTime, this.slotTime);
}
