import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/yoga_classes/schedule_class_model.dart';
import 'package:html/parser.dart' show parse;
import 'package:vedic_health/views/yoga_classes/schedule_classdetails_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/loader.dart';
import '../../widgets/notification_bar_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ScheduleClassesScreen extends StatefulWidget{
  _scheduleClassState createState()=> _scheduleClassState();
}
class _scheduleClassState extends State<ScheduleClassesScreen>{
  bool isLoading=false;
  int selectedTab = 1;
  int selectedMonth = 0;
  int selectedDate = -1;
  List<String> months = [];
  List<int> dateList = [];


  List<dynamic> dynamicClassList=[];
  List<dynamic> filteredList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    filteredList.clear();
     filteredList = getFilteredClasses();
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      isLoading?Center(child: Loader(),):Column(
        children: [
          NotificationBarWidget(),
          _buildAppBar(),
         // buildBanner(),
         // buildTabs(),
          buildMonthFilter(),
          const SizedBox(height: 10),
          buildDateFilter(),
          const SizedBox(height: 10),

          Expanded(
            child: filteredList.isEmpty?Center(child: Text("No Classes found for selected month or date"),):ListView.builder(
              itemCount:
              filteredList.length,
              itemBuilder:
                  (context, index) {
                    var item = filteredList[index];
                    return buildClassCardFromApi(item,index);
              },
            ),
          ),
        ],
      ),

    );
  }
  Widget _buildAppBar() {
    return Card(
      elevation: 2,
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
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Schedule Yoga Classes",
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
    );
  }
  @override
  void initState() {
    super.initState();
    generateMonths();
    generateDates();
    fetchYogaClasses();
  }
  String _monthName(int month) {
    const names = [
      "",
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];

    return names[month];
  }
  void generateMonths() {
    DateTime current = DateTime.now();

    for (int i = 0; i < 12; i++) {
      DateTime month =
      DateTime(current.year, current.month + i);

      months.add(
        "${_monthName(month.month)} ${month.year}",
      );
    }
  }
  void generateDates() {
    dateList.clear();

    DateTime now = DateTime.now();

    DateTime selectedMonthDate = DateTime(
      now.year,
      now.month + selectedMonth,
    );

    Set<int> uniqueDates = {};

    for (var item in dynamicClassList) {
      DateTime classDate =
      DateTime.parse(item['date']);

      if (classDate.month ==
          selectedMonthDate.month &&
          classDate.year ==
              selectedMonthDate.year) {
        uniqueDates.add(classDate.day);
      }
    }

    dateList = uniqueDates.toList()..sort();

    setState(() {});
  }
  Widget buildBanner() {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            "assets/banner1.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black54,
              Colors.transparent,
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            mainAxisAlignment:
            MainAxisAlignment.end,
            children: [
              Text(
                "Book Your Yoga Class",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 5),
              Text(
                "Every Body Welcome, Every Level Supported",
                style: TextStyle(
                  color: Colors.white70,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  Widget buildTabs() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          buildTabButton("All Classes", 0),
          buildTabButton("Upcoming", 1),
        ],
      ),
    );
  }
  Widget buildTabButton(
      String title,
      int index,
      ) {
    bool selected = selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding:
          const EdgeInsets.symmetric(
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xff6B4423)
                : Colors.transparent,
            borderRadius:
            BorderRadius.circular(30),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected
                  ? Colors.white
                  : Colors.black,
            ),
          ),
        ),
      ),
    );
  }
  Widget buildMonthFilter() {
    return SizedBox(
      height: 45,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: months.length,
        itemBuilder: (_, index) {
          bool selected =
              selectedMonth == index;

          return GestureDetector(
            onTap: () {
              setState(() {
                selectedMonth = index;
                selectedDate = -1;
              });
              generateDates();
            },
            child: Container(
              margin:
              const EdgeInsets.only(
                left: 10,
              ),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: selected
                    ? AppTheme.darkBrown
                    : Colors.white,
                borderRadius:
                BorderRadius.circular(
                    20),
                border: Border.all(
                  color:
                  Colors.grey.shade300,
                ),
              ),
              child: Text(
                months[index],
                style: TextStyle(
                  color: selected
                      ? Colors.white
                      : Colors.black,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  Widget buildDateFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dateList.length + 1,
        itemBuilder: (_, index) {

          if (index == 0) {
            return buildDateChip(
              "All",
              -1,
            );
          }

          return buildDateChip(
            dateList[index - 1].toString(),
            index - 1,
          );
        },
      ),
    );
  }
  Widget buildDateChip(
      String text,
      int index,
      ) {
    bool selected = selectedDate == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedDate = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(
          left: 10,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.darkBrown
              : Colors.white,
          borderRadius:
          BorderRadius.circular(15),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: selected
                ? Colors.white
                : Colors.black,
          ),
        ),
      ),
    );
  }
  Widget buildClassCard(
      ScheduleClassModel item,
      ) {



    return InkWell(onTap: (){
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              ScheduleClassDetailsScreen(
                classData: filteredList[item.listIndex],
              ),
        ),
      );
    },
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 2,
        shape:
        RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: CachedNetworkImage(
                  imageUrl: item.image,
                  width: 110,
                  height: 130,
                  fit: BoxFit.cover,

                  placeholder: (context, url) => Container(
                    width: 110,
                    height: 130,
                    color: Colors.grey.shade100,
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    ),
                  ),

                  errorWidget: (context, url, error) => Container(
                    width: 110,
                    height: 130,
                    color: Colors.grey.shade200,
                    child: const Icon(
                      Icons.broken_image_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      item.title,
                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),


                    Text(
                      parseHtmlString(item.description),
                      maxLines: 2,
                      overflow:
                      TextOverflow
                          .ellipsis,
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "Speaker: ${item.speaker}",
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "${item.classDate.day}/${item.classDate.month}/${item.classDate.year}",
                        ),
                        Text(" | "),
                        Text(item.time),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.availableTicket>0?"${item.availableTicket} Tickets are available":"No ticket is available",
                      style:
                      TextStyle(
                          fontWeight:
                          FontWeight.w600,
                          color: item.availableTicket>0?Colors.green:Colors.red
                      ),
                    ),
                    const SizedBox(height: 8),

                    Container(
                      padding:
                      const EdgeInsets
                          .symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration:
                      BoxDecoration(
                        color:
                        item.type ==
                            "PAID"
                            ? AppTheme.orangeColor
                            : AppTheme.darkBrown,
                        borderRadius:
                        BorderRadius
                            .circular(
                            20),
                      ),
                      child: Text(
                        item.type,
                        style:
                        const TextStyle(
                          color:
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
  List<dynamic> getFilteredClasses() {
    List<dynamic> filtered =
    List.from(dynamicClassList);

    DateTime now = DateTime.now();

    DateTime monthDate = DateTime(
      now.year,
      now.month + selectedMonth,
    );

    filtered = filtered.where((item) {
      DateTime classDate =
      DateTime.parse(item['date']);

      return classDate.month ==
          monthDate.month &&
          classDate.year ==
              monthDate.year;
    }).toList();

    if (selectedDate != -1) {
      int day = dateList[selectedDate];

      filtered = filtered.where((item) {
        DateTime classDate =
        DateTime.parse(item['date']);

        return classDate.day == day;
      }).toList();
    }

    return filtered;
  }
  Widget buildClassCardFromApi(
      Map<String, dynamic> item,int index) {

    String type =
    item["is_rsvp"] == true
        ? "RSVP"
        : "PAID";
    int availableTicket=item['availableTickets']??0;

    return buildClassCard(
      ScheduleClassModel(
        id: item["_id"],
        image: item["coverUrl"] ?? "",
        title: item["classname"] ?? "",
        description: item["description"] ?? "",
        speaker: item["speakername"] ?? "",
        classDate:
        DateTime.parse(item["date"]),
        time: item["time"] ?? "",
        type: type,
        availableTicket: availableTicket,
        listIndex: index
      ),
    );
  }
  fetchYogaClasses() async {
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
      "page": 1, // Assuming default page number
      "pageSize": 9999 // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('yoga_class_management/all', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      List<dynamic>evList=(responseJSON['classes'] as List?) ?? [];

      dynamicClassList.clear();
      DateTime today = DateTime.now();
      DateTime currentDate =
      DateTime(today.year, today.month, today.day);
      for (var item in evList) {
        DateTime classDate =
        DateTime.parse(item['date']);
        DateTime compareDate = DateTime(
          classDate.year,
          classDate.month,
          classDate.day,
        );
        if (!compareDate.isBefore(currentDate)) {
          dynamicClassList.add(item);
        }
      }

      generateDates();
      setState(() {});


    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }

}