import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/name_avatar.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_menuscreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_payment_page.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';


class PractitionerAppointmentScreen extends StatefulWidget{
  _practitionerAppointment createState()=>_practitionerAppointment();
}
class _practitionerAppointment extends State<PractitionerAppointmentScreen>{
  String employeeId="";
  String? userName;
  String? userId;
  List<dynamic> employeeNotWorkingDays=[];
  List<dynamic> employeeWorkingDays=[];
  List<dynamic> appointmentListAll=[];
  List<dynamic> appointmentListDateWise=[];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  String selectedDate="";
  String selectedShowDate="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return PopScope(
      canPop: false,
        onPopInvoked: (didPop){
          if (!didPop) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PractitionerHomeScreen()),
            );
          }
        },
        child: Scaffold(
      backgroundColor:AppTheme.darkBrown,
      appBar: CustomCardAppBar(iconStr:"assets/ham3.png",title: "Appointment", onBack: (){
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => PractitionerMenuScreen()));
      }),
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
                  TableCalendar(
                    firstDay: _firstDay,
                    lastDay: _lastDay,
                    focusedDay: _focusedDay,

                    calendarFormat: CalendarFormat.month, // ✅ Always full month
                    availableCalendarFormats: const {
                      CalendarFormat.month: 'Month', // ✅ remove week / twoWeeks options
                    },


                    startingDayOfWeek: StartingDayOfWeek.monday,

                    // 🚫 Disable dates logic
                    enabledDayPredicate: (day) {
                      if (isToday(day)) return true;
                      if (day.isBefore(_firstDay)) return false;
                      if (day.isAfter(_lastDay)) return false;
                      if (isUnavailable(day)) return false;
                      if (!isWorkingDay(day)) return false;
                      return true;
                    },

                    selectedDayPredicate: (day) =>
                        isSameDay(_selectedDay, day),

                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isUnavailable(selectedDay) &&
                          isWorkingDay(selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                          selectedDate=DateFormat('yyyy-MM-dd').format(selectedDay);
                          selectedShowDate=DateFormat('EEEE,dd MMM').format(selectedDay);

                        });
                        fetchSelectedDateAppointments();


                      }
                    },

                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarBuilders: CalendarBuilders(
                      headerTitleBuilder: (context, day) {
                        return Container(
                          width: double.infinity,
                          margin:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0x7AE9E9E9), // #E9E9E97A
                            border: Border.all(
                              color: const Color(0xFFE7E7E7),
                            ),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              DateFormat('MMMM yyyy').format(day),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    calendarStyle: CalendarStyle(
                      todayDecoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration:  const BoxDecoration(
                        color: Color(0xFFF38328),
                        shape: BoxShape.circle,
                      ),
                      disabledTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 15,),
                  Container(
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(selectedShowDate,style: TextStyle(fontWeight: FontWeight.w700,fontSize: 14.5,color: AppTheme.darkBrown),),
                        SizedBox(height: 10,),
                        appointmentListDateWise.isEmpty?
                        Center(child: Text("No appointment available",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),),):
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: appointmentListDateWise.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder:(context,index){
                              String name=appointmentListDateWise[index]['user']?['name']?.toString()??"";
                              String service=appointmentListDateWise[index]['service']?['name']?.toString()??"";
                              String timeRange="";
                              String startTime=appointmentListDateWise[index]['time']?.toString()??"";
                              int duration=appointmentListDateWise[index]['duration']??0;

                              String endTime="";
                              if(startTime.isNotEmpty){
                                endTime=addMinutesToTime(startTime, duration);
                              }
                              timeRange="$startTime-$endTime";

                              String status=appointmentListDateWise[index]['status']?.toString()??"";
                              String _id=appointmentListDateWise[index]['_id']?.toString()??"";
                              String type=appointmentListDateWise[index]['type']?.toString()??"";
                              if(type=="break"){
                                service=appointmentListDateWise[index]['note']?.toString()??"";
                              }

                              return GestureDetector(
                                onTap: (){
                                  if(type!="break") {
                                    _confirmAppointmentData(context, index);
                                  }

                                },
                                child: Container(
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
                                      Padding(padding: EdgeInsets.all(5),
                                        child: NameAvatar(fullName: name),),
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
                                ),
                              );
                            })
                      ],
                    )
                    ,
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    )
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
  String addMinutesToTime(String time, int minutes) {
    final parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime dateTime = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, hour, minute);
    DateTime newTime = dateTime.add(Duration(minutes: minutes));

    return "${newTime.hour.toString().padLeft(2, '0')}:"
        "${newTime.minute.toString().padLeft(2, '0')}";
  }
  @override
  void initState() {
    super.initState();
    _firstDay = DateTime.now();
    _lastDay = DateTime(
      _firstDay.year,
      _firstDay.month + 6,
      _firstDay.day,
    );
    _selectedDay = DateTime.now(); // 🔥 force today selected
    _focusedDay = _selectedDay!;
    _loadUserData();

  }
  bool isToday(DateTime day) {
    final now = DateTime.now();
    return isSameDay(now, day);
  }
  bool isUnavailable(DateTime day) {
    String formatted = DateFormat('yyyy-MM-dd').format(day);
    return employeeNotWorkingDays.contains(formatted);
  }
  bool isWorkingDay(DateTime day) {
    String weekDay = DateFormat('EEE').format(day); // Mon, Tue...
    return employeeWorkingDays.contains(weekDay);
  }
  Future<void>_loadUserData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    userName=await MyUtils.getSharedPreferences("name")??"";
    setState(() {

    });
    fetchEmpdetails();

  }
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
    employeeWorkingDays=(responseJSON['data']?['employee']?['working_days']as List?)??[];
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
    fetchEmployeeNotWorking();

  }
  Future<void> fetchEmployeeNotWorking() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    var today=DateTime.now();
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








    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
    fetchUserDashboardData();
  }
  fetchUserDashboardData(){

    fetchAppointmentData();
  }
  Future<void> fetchAppointmentData() async {
    APIDialog.showAlertDialog(context, "Please wait");
    var data = {
      "employeeId":employeeId,
      "\$or":[{"type":{"\$ne":"appointment"}},{"\$and":[{"type":"appointment"},{"status":{"\$ne":"notPaid"}}]}]
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/find', requestModel, context);
    var responseJSON = json.decode(response.toString());
    appointmentListAll.clear();
    appointmentListAll = (responseJSON["data"] as List?)??[];
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    setDefaultSelectedDate();

    setState(() {

    });

  }

  fetchSelectedDateAppointments(){
    appointmentListDateWise.clear();
    for(int i=0;i<appointmentListAll.length;i++){
      String date=appointmentListAll[i]['date']?.toString()??"";
      if(date.isNotEmpty){
        String conDate=formatDate(date);
        if(conDate==selectedDate){
          appointmentListDateWise.add(appointmentListAll[i]);
        }
      }
    }

    setState(() {

    });
  }
  void setDefaultSelectedDate() {
    DateTime today = DateTime.now();
    selectedDate=DateFormat('yyyy-MM-dd').format(today);
    selectedShowDate=DateFormat('EEEE,dd MMM').format(today);
    fetchSelectedDateAppointments();
  }
  bool isSelectable(DateTime day) {
    if (isToday(day)) return true;
    if (day.isBefore(_firstDay)) return false;
    if (day.isAfter(_lastDay)) return false;
    if (isUnavailable(day)) return false;
    if (!isWorkingDay(day)) return false;
    return true;
  }
  String formatDate(String isoDate) {
    DateTime? dateTime = DateTime.tryParse(isoDate)?.toLocal();
    return DateFormat('yyyy-MM-dd').format(dateTime!);
  }

  void _confirmAppointmentData(BuildContext context,int index) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {

            String name=appointmentListDateWise[index]['user']?['name']?.toString()??"";
            String service=appointmentListDateWise[index]['service']?['name']?.toString()??"";
            String timeRange="";
            String startTime=appointmentListDateWise[index]['time']?.toString()??"";
            int duration=appointmentListDateWise[index]['duration']??0;

            String endTime="";
            if(startTime.isNotEmpty){
              endTime=addMinutesToTime(startTime, duration);
            }
            timeRange="$startTime-$endTime";

            String status=appointmentListDateWise[index]['status']?.toString()??"";
            String _id=appointmentListDateWise[index]['_id']?.toString()??"";
            String type=appointmentListDateWise[index]['type']?.toString()??"";
            String familyMemberId=appointmentListDateWise[index]['familyMemberId']?.toString()??"";
            String bookFor="";
            String familyRelation="";
            String familyFirstname="";
            String familyLastname="";

            if(familyMemberId.isNotEmpty){
              familyRelation=appointmentListDateWise[index]['userfamily']?['relation']?.toString()??"";
              familyFirstname=appointmentListDateWise[index]['userfamily']?['firstName']?.toString()??"";
              familyLastname=appointmentListDateWise[index]['userfamily']?['lastName']?.toString()??"";
              bookFor=familyRelation;
            }else{
              bookFor="Self";
            }


            return GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(), // dismiss keyboard
              child: AnimatedPadding(
                duration: const Duration(milliseconds: 250), // smooth animation
                curve: Curves.easeOut,
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom, // 👈 KEY
                ),
                child: SingleChildScrollView(
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(height: 25),

                        /// ---- HEADER ----
                        Row(
                          children: [
                            const SizedBox(width: 10),
                            const Text(
                              "Appointment Details",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Image.asset(
                                'assets/close_icc.png',
                                width: 14,
                                height: 14,
                              ),
                            ),
                            const SizedBox(width: 20),
                          ],
                        ),

                        const SizedBox(height: 20),

                        /// ---- BODY ----
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text(
                                "Service",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: service),
                              const SizedBox(height: 10),

                              const Text(
                                "Client Name",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: name),
                              const SizedBox(height: 10),

                              const Text(
                                "Start Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: startTime),
                              const SizedBox(height: 10),
                              const Text(
                                "End Time",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: endTime),
                              const SizedBox(height: 10),
                              const Text(
                                "Book For",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: bookFor),
                              const SizedBox(height: 10),

                              familyMemberId.isNotEmpty?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Family Member",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500, fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      _boxTextView(value: "$familyFirstname $familyLastname"),
                                      const SizedBox(height: 10),
                                    ],
                                  ):Container(),
                              const Text(
                                "Payment Status",
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 14),
                              ),
                              const SizedBox(height: 4),
                              _boxTextView(value: status),
                              const SizedBox(height: 10),
                            ],
                          ),
                        ),

                        const SizedBox(height: 35),

                        /// ---- ACTION BUTTONS ----
                        status=="unpaid"?
                        Row(
                          children: [

                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.of(ctx).pop();
                                  takePayment(_id);
                                },
                                child: _actionButton(
                                  title: "Process Payment",
                                  bgColor: AppTheme.darkBrown,
                                  textColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ):Container(),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _boxTextView({
    required String value,
  }) {
    return Container(

      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF2EA),
        border: Border.all(color: const Color(0xFFE2E2E2)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        value,
        style: TextStyle(fontSize: 14,fontWeight: FontWeight.w700,color: Colors.black),
      ),

    );
  }
  Widget _actionButton({
    required String title,
    required Color bgColor,
    required Color textColor,
  }) {
    return Container(
      height: 50,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Center(
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }

  takePayment(String appointmentId) async {
    APIDialog.showAlertDialog(context, "Please wait...");




    var data = {"appointmentId": appointmentId,};


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'appointment-management/takePayment', requestModel, context);
    Navigator.pop(context);
    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['statusCode'] == 200) {
      String paymentUrl=responseJSON['paymentUrl']?.toString()??"";
      String orderId= responseJSON["orderId"]?.toString()??"";
      if(paymentUrl.isNotEmpty){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PractitionerPaymentPage(paymentUrl, orderId)));

      }else{
        Toast.show("Error!! Issue with payment link. Please try again later",
            duration: Toast.lengthLong,
            gravity: Toast.bottom,
            backgroundColor: Colors.red);
      }

    } else {
      Toast.show(responseJSON['messages'].toString(),
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }
}