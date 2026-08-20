import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/appointments/book_appointment_screen.dart';

import '../../network/api_helper.dart';
import '../../widgets/notification_bar_widget.dart';


class AppointmentDetail extends StatefulWidget{
  final String title;
  final String serviceId;
  final String centerId;

  const AppointmentDetail(
      {super.key,required this.title,required this.serviceId,required this.centerId});


  _appointmentDetails createState()=>_appointmentDetails();
}
class _appointmentDetails extends State<AppointmentDetail> {
  List<dynamic> consultations=[];
  bool isLoading = false;
  int pageNo=1;
  int pageSize=100;



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: Colors.white,
        body: isLoading?Center(child: Loader(),):Column(
          children: [
            NotificationBarWidget(),
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
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(Icons.arrow_back_ios_new_sharp,
                          size: 24, color: Colors.black),
                    ),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
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
            const SizedBox(height: 2),
            Expanded(
              child: consultations.isEmpty
                  ? const Center(child: Text("No services available"))
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: consultations.length,
                      itemBuilder: (context, index) {
                        final service = consultations[index] as Map<String, dynamic>;
                        final title = service['name'] ?? 'No name';
                        final description = service['description'] ?? '';
                        final price = service.containsKey('price') ? '\$${service['price']}' : '';
                        final serviceId=service['_id']?.toString()??"";
                        return Column(
                          children: [
                            Card(
                              color: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                side:
                                    const BorderSide(color: Color(0xFFE2D7D7)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Container(
                                decoration: const BoxDecoration(
                                  // border: BoxBorder.all(color: Color(0xFFE2D7D7)),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Row(
                                  children: [
                                    // Left: Icon, Price, Button
                                    Container(
                                      width: 125,
                                      decoration: const BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                              color: Color(0xFFE2D7D7)),
                                        ),
                                        color: Color(0xFFF8F8F8),
                                        // border: BoxBorder.fromLTRB(
                                        //     right: BorderSide(color: Color(0xFFE2D7D7))),
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            topLeft: Radius.circular(10)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: const BoxDecoration(
                                                // border: BoxBorder.all(color: Color(0xFFE2D7D7)),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10)),
                                              ),
                                              child: CircleAvatar(
                                                backgroundColor: Colors.white,
                                                radius: 18,
                                                child: Image.asset(
                                                  "assets/leaf.png",
                                                  height: 25,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Text(
                                              price,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            SizedBox(
                                              height: 30,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            BookAppointmentScreen(
                                                                title: title,
                                                                consultations: consultations,
                                                              selectedServiceId: serviceId,
                                                            ),
                                                      ));
                                                },
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      const Color(0xFFF38328),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                ),
                                                child: const Text(
                                                  "Book Now",
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    const SizedBox(width: 16),
                                    // Right: Title and Description
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            description,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black87,
                                              height: 1.3,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    fetchAppointments();
  }
  Future<void> fetchAppointments() async {
    setState(() => isLoading = true);

    var data = {"page": pageNo, "pageSize": pageSize, "centerId": widget.centerId,"service_type":widget.serviceId};
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('services_management/getAll', requestModel, context);

    final responseJSON = json.decode(response.toString());
    print("Appointments response: $responseJSON");
    if (responseJSON["statusCode"] == 200) {
      consultations= List<dynamic>.from(responseJSON["data"] ?? []);
      setState(() {
      });
    } else {
      print("Error fetching appointments: ${responseJSON["message"]}");
      Toast.show(responseJSON["message"]?.toString()??"Something went wrong.",duration: Toast.lengthLong,backgroundColor: Colors.red);

    }
    setState(() => isLoading = false);
  }
}
