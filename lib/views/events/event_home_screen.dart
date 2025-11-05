import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import 'event_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';


class EventHomeScreen extends StatefulWidget {
  const EventHomeScreen({super.key});
  @override
  State<EventHomeScreen> createState() => _EventHomeScreenState();
}

class _EventHomeScreenState extends State<EventHomeScreen> {
  bool isLoading=false;
  int currentPage=1;
  int pageSize=20;
  int totalPage=1;
  int totalSize=0;
  List<dynamic> eventList=[];

  String eventBannerImage="";
  String eventName="";
  bool isRSVP=false;
  String eventDate="";
  String eventTime="";
  String eventAddress="";

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
                              "Events",
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
             /* const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Event of the month",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),*/
              /// Container
              isLoading?Center(child: Loader(),):
              eventList.isNotEmpty?
              Container(
                padding: const EdgeInsets.all(12),
                width: double.maxFinite,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                height: 200,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: eventBannerImage,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            height: 250,
                            width: double.infinity,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            height: 200,
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image, color: Colors.grey),
                          ),
                        ),
                      ),
                      // Shadow overlay
                      Positioned.fill(
                        child: Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.topRight,
                              colors: [
                                Colors.black54,
                                Colors.transparent,
                                Colors.black54,
                              ],
                              stops: [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                      // Text on top left
                       Positioned(
                        top: 16,
                        left: 16,
                        child: Text(
                          eventName,
                          maxLines: 2,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      isRSVP?
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 5),
                          decoration: BoxDecoration(
                              color: const Color(0xFFF38328),
                              borderRadius: BorderRadius.circular(20)),
                          child: const Text(
                            "RSVP",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ):Container(),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            Container(
                              height: 50,
                              width: 50,
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      Color(0xFF865940),
                                      Color(0xFFE77735)
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Text(
                                eventDate,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  eventTime,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  eventAddress,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ):Container(),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  "UPCOMING EVENTS",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),

              isLoading?Center(child: Loader(),):
                  eventList.isNotEmpty?
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: eventList.length,

                itemBuilder: (context, index) {
                  String eventId=eventList[index]['_id']?.toString()??"";
                  bool isRsvp=eventList[index]['is_rsvp']??false;
                  String title= eventList[index]['eventname']?.toString()??"";
                  String imagePath= eventList[index]['coverImage']?.toString()??"";
                  String icon_file= eventList[index]['icon_file']?.toString()??"";
                  String eventImage="";
                  if(icon_file.isNotEmpty){
                    eventImage=AppConstant.appBaseURL+icon_file;
                  }else if(imagePath.isNotEmpty){
                    eventImage=AppConstant.appBaseURL+imagePath;
                  }
                  String address=eventList[index]['address']?.toString()??"";
                  String eventD=eventList[index]['date']?.toString()??"";
                  String eventDate=formatDateUtc(eventD);
                  String timing= "$eventDate | $address";

                  return Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: EventCard(
                    imagePath: eventImage,
                    title: title,
                    timing: timing,
                    onRSVP: () {},
                    isRsvp: isRsvp,
                    eventId: eventId,
                  ),);
                },
              ):Center(child: Padding(padding: EdgeInsets.all(16),
                    child: Text("Currently, there are no events available. Please visit again later for upcoming events.",
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey
                      ),),

                  ),)

            ],
          ),
        ),
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    fetchEvents();
  }
  String formatDateUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  String formatDateUtcForBanner(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      String dd= DateFormat('dd').format(dateTime);
      String MMM= DateFormat('MMM').format(dateTime);
      return '$dd\n$MMM';
    } catch (e) {
      return date;
    }
  }
  fetchEvents() async {
    setState(() {
      isLoading = true;
    });
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "page": currentPage, // Assuming default page number
      "pageSize": pageSize // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'event_management/all', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      List<dynamic>evList=(responseJSON['events'] as List?) ?? [];
      totalPage=responseJSON['totalPages']??1;
      totalSize=responseJSON['totalCount']??0;
      eventList.addAll(evList);

      if(eventList.isNotEmpty){
        String eventId=eventList[0]['_id']?.toString()??"";
        isRSVP=eventList[0]['is_rsvp']??false;
        eventName= eventList[0]['eventname']?.toString()??"";
        String imagePath= eventList[0]['coverImage']?.toString()??"";
        String icon_file= eventList[0]['icon_file']?.toString()??"";
        if(imagePath.isNotEmpty){
          eventBannerImage=AppConstant.appBaseURL+imagePath;
        }else if(icon_file.isNotEmpty){
          eventBannerImage=AppConstant.appBaseURL+icon_file;
        }
        eventAddress=eventList[0]['address']?.toString()??"";
        String eventD=eventList[0]['date']?.toString()??"";
        eventDate=formatDateUtcForBanner(eventD);
        eventTime=eventList[0]['time']?.toString()??"";
      }



    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }
}

class EventCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final String timing;
  final VoidCallback onRSVP;
  final bool isRsvp;
  final String eventId;

  const EventCard({
    super.key,
    required this.imagePath,
    required this.title,
    required this.timing,
    required this.onRSVP,
    required this.isRsvp,
    required this.eventId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  EventDetailScreen(eventId),
            ));
      },
      child: Container(
        height: 120,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        // padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// Image
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: imagePath,
                height: 120,
                width: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  width: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            const SizedBox(width: 12),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// Title
                  Text(
                    title,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Bullet Points
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(
                            timing,
                            style: const TextStyle(
                                fontSize: 12,
                                height: 1.4,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ]),

                  const SizedBox(height: 4),

                  /// Read More Button
                  isRsvp?Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: onRSVP,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 5),
                        decoration: BoxDecoration(
                            color: const Color(0xFFF38328),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          "RSVP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ):Container(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
