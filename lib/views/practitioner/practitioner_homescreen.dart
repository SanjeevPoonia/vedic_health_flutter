import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/practitioner/practitioner_appointment_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_cart_details_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_menuscreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_services_screen.dart';
import 'package:vedic_health/views/practitioner/prectitioner_personaltask_screen.dart';
import 'package:vedic_health/widgets/appbar_widget.dart';
import 'package:vedic_health/widgets/custom_appbar_widget.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../../widgets/pract_custom_appbar_widget.dart';

class PractitionerHomeScreen extends StatefulWidget{
  _practitionerHomeScreen createState()=>_practitionerHomeScreen();
}
class _practitionerHomeScreen extends State<PractitionerHomeScreen>{
  String? userName;
  String? userId;


  String availableSlotFromDate="";
  String availableSlotToDate="";
  final today = DateTime.now();
  var dates=[];

  bool isSummeryLoading=false;
  String todaysAppointments="";
  String todaysAppointmentChanges="";
  String monthAppointments="";
  String monthAppointmentsChanges="";
  String earnings="";
  String earningsChanges="";
  String availableSlotsToday="";
  String employeeId="";
  String employeeWorkingTimeStart="";
  String employeeWorkingTimeEnd="";
  List<dynamic> centerIdsList=[];

  bool isNextAppointmentLoading=false;
  List<dynamic> nextAppointmentList=[];

  bool isServiceLoading=false;
  List<dynamic> servicesList=[];

  List<String> serviceIconList=['assets/ic_prec_ser1.svg','assets/ic_prec_ser2.svg','assets/ic_prec_ser3.svg','assets/ic_prec_ser4.svg'];


  late var slots;

  List<TimeSlot> morningList=[];
  List<TimeSlot> afternoonList=[];
  List<TimeSlot> eveningList=[];

  List<dynamic> employeeNotWorkingDays=[];
  List<dynamic> employeeWorkingDays=[];
  List<dynamic> employeeAvailableSlots=[];


  String practitionerImageStr="";

  @override
  Widget build(BuildContext context) {
   ToastContext().init(context);
   return Scaffold(
     backgroundColor:AppTheme.darkBrown,
     appBar: PractCustomAppBar
       (title: "Practitioner",
       onBack: (){
         Navigator.of(context).pushReplacement(MaterialPageRoute(
             builder: (BuildContext context) => PractitionerMenuScreen()));
       },
       iconStr: "assets/ham3.png",
       actionIconStr: practitionerImageStr,
       onAction: (){

       },
       isOnlineImage: true,
       empName: userName??"",
     ),
     body: Transform.translate(
       offset: const Offset(0, -20),   // <-- Move UP by 20 px
       child: Container(
         color: Colors.white,
         height: MediaQuery.of(context).size.height,
         width: double.infinity,
         child: SingleChildScrollView(
           child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               SizedBox(height: 40,),
               Text("Welcome Back, ${userName??""}",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black,fontSize: 20),),
               SizedBox(height: 4,),
               Text("Here's your wellness practice overview",style: TextStyle(color: AppTheme.textgrey,fontSize: 16),),

               isSummeryLoading?Center(child: Loader(),):
                   Column(
                     children: [
                       SizedBox(height: 20,),
                       Row(
                         children: [
                           Expanded(child: infoRowWidget(
                               assetPath: "assets/ic_prec_cal.svg",
                               title: "Today's\nAppointment",
                               count: todaysAppointments,
                               changeCount: todaysAppointmentChanges,
                               showChange: true,
                               changeText: "from yesterday"
                           )
                           ),
                           SizedBox(width: 10,),
                           Expanded(child: infoRowWidget(
                               assetPath: "assets/ic_prec_cal.svg",
                               title: "This\Month",
                               count: monthAppointments,
                               changeCount: monthAppointmentsChanges,
                               showChange: true,
                               changeText: "from last month"
                           )),
                         ],),
                       SizedBox(height: 10,),
                       Row(
                         children: [
                           Expanded(child: infoRowWidget(
                               assetPath: "assets/ic_prec_earning.svg",
                               title: "Earning",
                               count: "\$$earnings",
                               changeCount: earningsChanges,
                               showChange: true,
                               changeText: "from last month"
                           )),
                           SizedBox(width: 10,),
                           Expanded(child: infoRowWidget(
                               assetPath: "assets/ic_prec_cal.svg",
                               title: "Available\nSlot Today",
                               count: availableSlotsToday,
                               changeCount: "0",
                               showChange: false,
                               changeText: ""
                           )),
                         ],),
                     ],
                   ),


               SizedBox(height: 20,),
               Row(
                 children: [
                   Expanded(flex: 1,child: Text("Next Appointment",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 18),),),

                   GestureDetector(
                     onTap: (){
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => PractitionerAppointmentScreen()));
                     },
                     child: Text("View All",style: TextStyle(color: AppTheme.textPrectHeader,fontSize: 14,fontWeight: FontWeight.bold),),
                   )

                 ],
               ),
               SizedBox(height: 10,),
               AppointmentWidget(),

               SizedBox(height: 20,),
               Row(
                 children: [
                   Expanded(flex: 1,child: Text("Service Provided",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 18),),),
                 ],
               ),
               SizedBox(height: 10,),
               ServiceProvidedWidget(),

               SizedBox(height: 20,),
               Row(
                 children: [
                   Expanded(flex: 1,child: Text("Add Personal Task",style: TextStyle(fontWeight: FontWeight.w700,color: Colors.black,fontSize: 18),),),

                   GestureDetector(
                     onTap: (){
                       Navigator.push(
                           context,
                           MaterialPageRoute(
                               builder: (context) => PractitionerPersonalTask()));
                     },
                     child: Text("View Calender",style: TextStyle(color: AppTheme.textPrectHeader,fontSize: 14),),
                   )

                 ],
               ),
               SizedBox(height: 10,),
               AvailableSlotsWidget(),


             ],
           ),
           ),
         ),
       ),
     ),
   );
  }
  @override
  void initState() {
    super.initState();

    dates = List.generate(
      7,
          (index) => today.add(Duration(days: index - 3)),
    );
    final DateFormat formatter = DateFormat('dd MMM, yyyy');
    availableSlotFromDate =
    formatter.format(dates.first);
    availableSlotToDate =
    formatter.format(dates.last);
    _loadUserData();

  }
  Future<void>_loadUserData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    userName=await MyUtils.getSharedPreferences("name")??"";
    setState(() {

    });
    fetchEmpdetails();

  }

  Widget infoRowWidget({
    required String assetPath,
    required String title,
    required String count,
    double height = 100,
    required String changeCount,
    required bool showChange,
    required String changeText
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9), // #E9E9E97A
        border: Border.all(
          color: const Color(0xFFE7E7E7), // #E7E7E7
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              /// LEFT ICON
              /* Image.asset(
            assetPath,
            width: 24,
            height: 24,
          ),*/
              SvgPicture.asset(assetPath,width: 24,height: 24,),
              /// TITLE TEXT (Black)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppTheme.textHeader,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),

              /// COUNT TEXT (#F38328)
              Text(
                count,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.orangeColor, // count color
                ),
              ),
            ],
          ),
          showChange?
              countWithIndicator(changeCount,changeText):Container()
        ],
      ),
    );
  }
  Widget AppointmentWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9), // #E9E9E97A
        border: Border.all(
          color: const Color(0xFFE7E7E7), // #E7E7E7
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isNextAppointmentLoading?Center(child: Loader(),):
          nextAppointmentList.isEmpty?
              Center(child: Text("No appointment available",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),),):
      ListView.builder(
          shrinkWrap: true,
          itemCount: nextAppointmentList.length>3?3:nextAppointmentList.length,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder:(context,index){
            String name=nextAppointmentList[index]['name']?.toString()??"";
            String service=nextAppointmentList[index]['service']?.toString()??"";
            String timeRange=nextAppointmentList[index]['timeRange']?.toString()??"";
            String date=nextAppointmentList[index]['date']?.toString()??"";
            String status=nextAppointmentList[index]['status']?.toString()??"";

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 15),
              margin: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF), // #E9E9E97A
                border: Border.all(
                  color: const Color(0xFFE9E9E9), // #E7E7E7
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppTheme.orangeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          SizedBox(height: 4,),
                          Text(
                            service,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),

                  /// COUNT TEXT (#F38328)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.orangeColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4,),
                      Row(
                        children: [

                          SvgPicture.asset("assets/ic_prec_clock.svg",width: 17,height: 17,),
                          const SizedBox(width: 4,),
                          Text(
                            timeRange,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppTheme.textHeader,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4,),
                      statusTag(status),
                    ],
                  )
                ],
              ),
            );
          }),
    );
  }
  Widget statusTag(String status) {
    // Defaults
    Color bgColor = Colors.grey;
    Color textColor = Colors.black;
    String text = status;

    switch (status.toLowerCase()) {
      case "paid":
        bgColor = const Color(0xFF1BE25D);  // #1BE25D
        textColor = const Color(0xFF00AA38); // #00AA38
        text = "Paid";
        break;

      case "failed":
        bgColor = const Color(0xFFEFFEAB); // #EFFEAB
        textColor = const Color(0xFF718900); // #718900
        text = "Failed";
        break;

      case "unpaid":
        bgColor = const Color(0xFFF4A8A8); // #F4A8A8
        textColor = const Color(0xFFAA0000); // #AA0000
        text = "UnPaid";
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400, // regular
          color: textColor,
        ),
      ),
    );
  }
  Widget ServiceProvidedWidget() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9), // #E9E9E97A
        border: Border.all(
          color: const Color(0xFFE7E7E7), // #E7E7E7
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: isServiceLoading?Center(child: Loader(),):
      servicesList.isEmpty?
      const Center(child: Text("No services available",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),),):
      GridView.builder(
          itemCount: servicesList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5),
          itemBuilder: (context,index){
            String title=servicesList[index]['serviceName'].toString();
            final random = Random();
            String iconPath = serviceIconList[random.nextInt(serviceIconList.length)];
            return GestureDetector(
              onTap: (){
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => PractitionerServiceScreen()),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        iconPath,
                        width: 24,
                        height: 24,
                      ),
                      Expanded(flex:1,child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          title,
                          maxLines: 5,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.orangeColor
                          ),
                        ),
                      )),
                    ],
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
  Widget AvailableSlotsWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7,vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFFE9E9E9), // #E9E9E97A
        border: Border.all(
          color: const Color(0xFFE7E7E7), // #E7E7E7
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Row(
            children: [
              SvgPicture.asset("assets/ic_prec_avail.svg",width: 20,height: 20,),
              SizedBox(width: 5,),
              Text("From: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.5,color: Colors.black),),
              Text(availableSlotFromDate,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.5,color: AppTheme.orangeColor),),
              SizedBox(width: 5,),
              Text("To: ",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.5,color: Colors.black),),
              Text(availableSlotToDate,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 12.5,color: AppTheme.orangeColor),),
            ],
          ),
          SizedBox(height: 10,),
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PractitionerPersonalTask()));
            },
            child:Row(
              children: dates.map((date) {
                final isToday = _isSameDay(date, today);
                final isPast = date.isBefore(
                  DateTime(today.year, today.month, today.day),
                );

                Color bgColor;
                Color textColor = Colors.black;

                if (isToday) {
                  bgColor = AppTheme.orangeColor;
                  textColor = Colors.white;
                } else if (isPast) {
                  bgColor = Colors.grey.shade300;
                } else {
                  bgColor = Colors.white;
                }

                return Expanded(
                  child: Container(
                    height: 80,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat('d').format(date), // Day digit
                          style: TextStyle(
                            fontSize: 15.5,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('EEE').format(date), // 3-char day
                          style: TextStyle(
                            fontSize: 11.5,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ) ,
          ),
          SizedBox(height: 10,),
          Row(
            children: [
              SvgPicture.asset("assets/ic_prec_slot_mor.svg",width: 20,height: 20,),
              SizedBox(width: 5,),
              Text("Morning ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.5,color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          morningList.isEmpty?
              Center(child: Text("No Morning Slots",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.5,color: Colors.grey),),):
          GridView.builder(
              itemCount: morningList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3),
              itemBuilder: (context,index){
                String title=morningList[index].start;
                bool isOn=morningList[index].isOn;
                String showTitle=morningList[index].showTime;
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex:1,child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            showTitle,
                            maxLines:1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                          ),
                        )),
                        CupertinoSwitch(
                            value: isOn,
                            onChanged:isOn
                                ? null: (value){
                              setState(() {
                                morningList[index].isOn=value;
                              });
                              addPersonalTaks(title, index, 1);

                            }
                        )
                      ],
                    ),
                  ),
                );
              }
          ),

          SizedBox(height: 10,),
          Row(
            children: [
              SvgPicture.asset("assets/ic_prec_slot_noon.svg",width: 20,height: 20,),
              SizedBox(width: 5,),
              Text("Afternoon ",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.5,color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          afternoonList.isEmpty?
          Center(child: Text("No Afternoon Slots",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.5,color: Colors.grey),),):
          GridView.builder(
              itemCount: afternoonList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3),
              itemBuilder: (context,index){
                String title=afternoonList[index].start;
                bool isOn=afternoonList[index].isOn;
                String showTitle=afternoonList[index].showTime;
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex:1,child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            showTitle,
                            maxLines:1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                          ),
                        )),
                        CupertinoSwitch(
                            value: isOn,
                            onChanged:isOn
                                ? null: (value){
                              setState(() {
                                afternoonList[index].isOn=value;
                              });
                              addPersonalTaks(title, index, 2);

                            }
                        )
                      ],
                    ),
                  ),
                );
              }
          ),


          SizedBox(height: 10,),
          Row(
            children: [
              SvgPicture.asset("assets/ic_prec_slot_eve.svg",width: 20,height: 20,),
              SizedBox(width: 5,),
              Text("Evening",style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.5,color: Colors.black),),
            ],
          ),
          SizedBox(height: 10,),
          eveningList.isEmpty?
          Center(child: Text("No Evening Slots",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14.5,color: Colors.grey),),):
          GridView.builder(
              itemCount: eveningList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3),
              itemBuilder: (context,index){
                String title=eveningList[index].start;
                bool isOn=eveningList[index].isOn;
                String showTitle=eveningList[index].showTime;
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 7,vertical: 7),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(flex:1,child: Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            showTitle,
                            maxLines:1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black
                            ),
                          ),
                        )),
                        CupertinoSwitch(
                            value: isOn,
                            onChanged: isOn
                                ? null: (value){
                              setState(() {
                                eveningList[index].isOn=value;
                              });
                              addPersonalTaks(title, index, 3);
                            }
                        )
                      ],
                    ),
                  ),
                );
              }
          )



        ],
      ),
    );
  }
  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
  Widget countWithIndicator(String count,String changeText) {
    int value = int.tryParse(count) ?? 0;

    bool isPositive = value > 0;
    bool isNegative = value < 0;

    Color color = isPositive
        ? Colors.green
        : isNegative
        ? Colors.red
        : Colors.grey;

    IconData icon = isPositive
        ? Icons.arrow_upward
        : isNegative
        ? Icons.arrow_downward
        : Icons.remove;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 10, color: color),
        const SizedBox(width: 4),
        Text(
          "$count $changeText",
          style: TextStyle(
            color: color,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

 /* Map<String, List<TimeSlot>> generateSlots({
    required String startTime,
    required String endTime,
  })
  {
    final formatter = DateFormat('HH:mm');

    DateTime start = formatter.parse(startTime);
    DateTime end = formatter.parse(endTime);

    List<TimeSlot> morning = [];
    List<TimeSlot> afternoon = [];
    List<TimeSlot> evening = [];

    DateTime current = start;

    while (current.isBefore(end)) {
      DateTime next = current.add(const Duration(hours: 1));

      // 🔥 if remaining time is less than 1 hour
      if (next.isAfter(end)) {
        next = end;
      }

      final slot = TimeSlot(
        formatter.format(current),
        formatter.format(next),
        false,
      );

      if (current.hour < 12) {
        morning.add(slot);
      } else if (current.hour < 16) {
        afternoon.add(slot);
      } else {
        evening.add(slot);
      }

      // ⛔ prevent infinite loop
      if (next == end) break;

      current = next;
    }

    return {
      "morning": morning,
      "afternoon": afternoon,
      "evening": evening,
    };
  }*/
  Map<String, List<TimeSlot>> generateSlotsFromList() {
    final formatter = DateFormat('HH:mm');
    final formatterAM = DateFormat('hh:mm a');
    List<TimeSlot> morning = [];
    List<TimeSlot> afternoon = [];
    List<TimeSlot> evening = [];

    for (final item in employeeAvailableSlots) {
      DateTime start =
      DateTime.parse(item['startTime']).toLocal();
      DateTime end =
      DateTime.parse(item['endTime']).toLocal();

      DateTime now = DateTime.now();
      if (start.isBefore(now)) {
        print("Skipping past slot: ${item['startTime']}");
        continue;
      }

      final slot = TimeSlot(
        formatter.format(start),
        formatter.format(end),
        false,
        formatterAM.format(start)
      );

      if (start.hour < 12) {
        morning.add(slot);
      } else if (start.hour < 16) {
        afternoon.add(slot);
      } else {
        evening.add(slot);
      }
    }

    return {
      "morning": morning,
      "afternoon": afternoon,
      "evening": evening,
    };
  }

  /*************Apis**************************/

  Future<void> fetchEmpdetails() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "userId":userId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('employee-management/findByUserId', requestModel, context);
    var responseJSON = json.decode(response.toString());

    employeeId=responseJSON['data']?['employee']?['_id']?.toString()??"0";
    employeeWorkingTimeStart=responseJSON['data']?['employee']?['working_time_start']?.toString()??"0";
    employeeWorkingTimeEnd=responseJSON['data']?['employee']?['working_time_end']?.toString()??"0";
    centerIdsList=(responseJSON['data']?['employee']?['centerId']as List?)??[];
    employeeWorkingDays=(responseJSON['data']?['employee']?['working_days']as List?)??[];

    String proImage=responseJSON['data']?['employee']?['user']?['file']?.toString()??"";


     print("CenterIds $centerIdsList");
     print("employee Working $employeeWorkingDays");
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    setState(() {
      if(proImage.isNotEmpty){
        practitionerImageStr=AppConstant.appBaseURL+proImage;
        print(practitionerImageStr);
      }
    });
    fetchEmployeeNotWorking();
  }
  Future<void> fetchEmployeeNotWorking() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String todayDate=formatter.format(today);
    DateTime sixMonthsLater = DateTime(
      today.year,
      today.month + 6,
      today.day,
    );

    String futureDate = formatter.format(sixMonthsLater);
    var data = {
      "slotsPayload":[{"employeeId":employeeId,"startDate":todayDate,"endDate":futureDate}]
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/employeeNonWorkingDates', requestModel, context);
    var responseJSON = json.decode(response.toString());


    List<dynamic> dataList=(responseJSON['data']as List?)??[];
    if(dataList.isNotEmpty){
      employeeNotWorkingDays=(dataList[0]['unavailableDates']as List?)??[];
    }

    print("employeeNot working $employeeNotWorkingDays");

    /*if(shouldCallFunction(unavailableDates: employeeNotWorkingDays, workingDays: employeeWorkingDays)){
      if(employeeWorkingTimeStart!="0"&&employeeWorkingTimeEnd!="0"){
        slots= generateSlots(
          startTime: employeeWorkingTimeStart,
          endTime: employeeWorkingTimeEnd,
        );
        morningList=slots['morning'];
        afternoonList=slots['afternoon'];
        eveningList=slots['evening'];
      }else{
        slots=[];
      }
    }*/






    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
    empAvailableSlots();
  }
  Future<void> empAvailableSlots() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String todayDate=formatter.format(today);



    var data = {
      "slotsPayload":[{"employeeId":userId,"date":todayDate}]
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/employeeAvailableSlot', requestModel, context);
    var responseJSON = json.decode(response.toString());

    employeeAvailableSlots.clear();
    List<dynamic> dataList=(responseJSON['slots']as List?)??[];
    if(dataList.isNotEmpty){
      employeeAvailableSlots=(dataList[0]['slots']as List?)??[];
    }


    morningList.clear();
    afternoonList.clear();
    eveningList.clear();
    if(employeeAvailableSlots.isNotEmpty){
      slots= generateSlotsFromList();
      morningList=slots['morning'];
      afternoonList=slots['afternoon'];
      eveningList=slots['evening'];
    }
   /* print("employeeNot working $employeeNotWorkingDays");

    if(shouldCallFunction(unavailableDates: employeeNotWorkingDays, workingDays: employeeWorkingDays)){
      if(employeeWorkingTimeStart!="0"&&employeeWorkingTimeEnd!="0"){

        morningList=slots['morning'];
        afternoonList=slots['afternoon'];
        eveningList=slots['evening'];
      }else{
        slots=[];
      }
    }*/






    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
    fetchUserDashboardData();
  }
  fetchUserDashboardData(){
    fetchSummary();
    fetchNextAppointment();
    fetchServices();
  }
  Future<void> fetchSummary() async {
    setState(() {
      isSummeryLoading = true;
    });
    var data = {
      "employeeId":employeeId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/summary', requestModel, context);
    var responseJSON = json.decode(response.toString());

    todaysAppointments=responseJSON['data']?['todayAppointments']?.toString()??"0";
    todaysAppointmentChanges=responseJSON['data']?['todayChange']?.toString()??"0";
    monthAppointments=responseJSON['data']?['monthAppointments']?.toString()??"0";
    monthAppointmentsChanges=responseJSON['data']?['monthChange']?.toString()??"0";
    earnings=responseJSON['data']?['earnings']?.toString()??"0";
    earningsChanges=responseJSON['data']?['earningsChange']?.toString()??"0";
    availableSlotsToday=responseJSON['data']?['availableSlotsToday']?.toString()??"0";
    setState(() {
      isSummeryLoading = false;
    });

  }
  Future<void> fetchNextAppointment() async {
    setState(() {
      isNextAppointmentLoading = true;
    });
    var data = {
      "employeeId":employeeId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/nextAppointments', requestModel, context);
    var responseJSON = json.decode(response.toString());
    nextAppointmentList = (responseJSON["data"] as List?)??[];
    setState(() {
      isNextAppointmentLoading = false;
    });

  }
  Future<void> fetchServices() async {
    setState(() {
      isServiceLoading = true;
    });
    var data = {
      "employeeId":employeeId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/employee-services', requestModel, context);
    var responseJSON = json.decode(response.toString());
    servicesList = (responseJSON["data"] as List?)??[];
    setState(() {
      isServiceLoading = false;
    });

  }
  bool isFutureTime(String dateStr, String timeStr) {
    // 1. Parse date
    DateTime date = DateTime.parse(dateStr);

    // 2. Split time
    final parts = timeStr.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    // 3. Combine date + time
    DateTime fullDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );

    // 4. Compare with current time
    return fullDateTime.isAfter(DateTime.now());
  }
  Future<void> addPersonalTaks(String timeSlot,int listPos,int listType) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String todayDate=formatter.format(today);
    if(!isFutureTime(todayDate, timeSlot)){
      setState(() {
        if(listType==1){
          morningList[listPos].isOn=false;
        }else if(listType==2){
          afternoonList[listPos].isOn=false;
        }else if(listType==3){
          eveningList[listPos].isOn=false;
        }
      });
      Toast.show("Action cannot be completed because the scheduled time has already passed.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }
    APIDialog.showAlertDialog(context, "Please wait...");

    var data = {
      "serviceId":"",
      "centerId":centerIdsList,
      "employeeId":employeeId,
      "userId":userId,
      "note":"Personal Task",
      "addonId":"",
      "duration":60,
      "price":0,
      "date":todayDate,
      "time":timeSlot,
      "deposit":0,
      "repeat":"Off"
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/addBreak', requestModel, context);
    var responseJSON = json.decode(response.toString());

    if(responseJSON['statusCode']==200){
      Toast.show(responseJSON['message']?.toString()??"Break Added Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      if(listType==1){
        morningList[listPos].isOn=true;
      }else if(listType==2){
        afternoonList[listPos].isOn=true;
      }else if(listType==3){
        eveningList[listPos].isOn=true;
      }
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong. Please try Again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      if(listType==1){
        morningList[listPos].isOn=false;
      }else if(listType==2){
        afternoonList[listPos].isOn=false;
      }else if(listType==3){
        eveningList[listPos].isOn=false;
      }
    }

    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }



    setState(() {

    });

  }

  bool shouldCallFunction({
    required List<dynamic> unavailableDates,
    required List<dynamic> workingDays,
  }) {
    DateTime today = DateTime.now();

    // 1️⃣ format today date → yyyy-MM-dd
    String todayDate = DateFormat('yyyy-MM-dd').format(today);

    // 2️⃣ get today day name → Mon, Tue...
    String todayDay = DateFormat('EEE').format(today);

    // 3️⃣ conditions
    bool isDateAvailable = !unavailableDates.contains(todayDate);
    bool isWorkingDay = workingDays.contains(todayDay);

    return isDateAvailable && isWorkingDay;
  }



  
}
class TimeSlot{
  String start;
  String end;
  bool isOn;
  String showTime;

  TimeSlot(this.start, this.end,this.isOn,this.showTime);
}