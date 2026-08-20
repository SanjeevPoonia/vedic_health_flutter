import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_menuscreen.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_appbar_widget.dart';

class PractitionerPersonalTask extends StatefulWidget{
  _prectitionerPersonal createState()=>_prectitionerPersonal();
}
class _prectitionerPersonal extends State<PractitionerPersonalTask>{
  String employeeId="";
  String? userName;
  String? userId;
  List<dynamic> employeeNotWorkingDays=[];
  List<dynamic> employeeWorkingDays=[];
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late final DateTime _firstDay;
  late final DateTime _lastDay;

  String selectedDate="";
  String selectedShowDate="";
  late var slots;

  List<TimeSlot> morningList=[];
  List<TimeSlot> afternoonList=[];
  List<TimeSlot> eveningList=[];
  String employeeWorkingTimeStart="";
  String employeeWorkingTimeEnd="";
  List<dynamic> centerIdsList=[];
  List<dynamic> employeeAvailableSlots=[];

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
          appBar: CustomCardAppBar(iconStr:"assets/ham3.png",title: "Add Personal Task", onBack: (){
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
                            empAvailableSlots();


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
                                  String showtitle=morningList[index].showTime;
                                  bool isOn=morningList[index].isOn;
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
                                              showtitle,
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
                                  String showtitle=afternoonList[index].showTime;
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
                                              showtitle,
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
                                  String showtitle=eveningList[index].showTime;
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
                                              showtitle,
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
                        )
                        ,
                      )

                    ],
                  ),
                ),
              ),
            ),
          ),
        ))
      ;
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
    selectedDate=DateFormat('yyyy-MM-dd').format(DateTime.now());
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
    employeeWorkingTimeStart=responseJSON['data']?['employee']?['working_time_start']?.toString()??"0";
    employeeWorkingTimeEnd=responseJSON['data']?['employee']?['working_time_end']?.toString()??"0";
    centerIdsList=(responseJSON['data']?['employee']?['centerId']as List?)??[];

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
    empAvailableSlots();

  }

  bool shouldCallFunction({
    required List<dynamic> unavailableDates,
    required List<dynamic> workingDays,
  }) {


    // 1️⃣ format today date → yyyy-MM-dd
    String todayDate = DateFormat('yyyy-MM-dd').format(_selectedDay!);

    // 2️⃣ get today day name → Mon, Tue...
    String todayDay = DateFormat('EEE').format(_selectedDay!);

    // 3️⃣ conditions
    bool isDateAvailable = !unavailableDates.contains(todayDate);
    bool isWorkingDay = workingDays.contains(todayDay);

    return isDateAvailable && isWorkingDay;
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
  Future<void> empAvailableSlots() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "slotsPayload":[{"employeeId":userId,"date":selectedDate}]
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

  }
  /*Map<String, List<TimeSlot>> generateSlots({
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
  Future<void> addPersonalTaks(String timeSlot,int listPos,int listType) async {
    if(!isFutureTime(selectedDate, timeSlot)){
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
      "date":selectedDate,
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


}
class TimeSlot{
  String start;
  String end;
  bool isOn;
  String showTime;

  TimeSlot(this.start, this.end,this.isOn,this.showTime);
}