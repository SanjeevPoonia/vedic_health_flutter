import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_menuscreen.dart';
import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_appbar_widget.dart';
import 'package:flutter/material.dart';

class PractitionerEarningScreen extends StatefulWidget{
  _practitionerState createState()=>_practitionerState();
}
class _practitionerState extends State<PractitionerEarningScreen>{

  String employeeId="";
  String? userName;
  String? userId;

  List<dynamic> topServicesList=[];
  List<dynamic> monthlyRevenueList=[];
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
          appBar: CustomCardAppBar(iconStr:"assets/ham3.png",title: "Earning", onBack: (){
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40,),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      child: Text(
                        "Monthly Revenue",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 10,),
                    monthlyRevenueList.isEmpty?
                    Center(child: Text("Month wise data not availble",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),),):
                    monthlyRevenueChart(),
                    const SizedBox(height: 10),
                    topServicesList.isEmpty?
                    topServicesWidgetNotAvailable():topServicesWidget(),

                  ],
                ),
              ),
            ),
          ),
        ));
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();

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
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });
    fetchUserDashboardData();

  }
  fetchUserDashboardData(){

    fetchAnalysis();
  }
  Future<void> fetchAnalysis() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    var data = {
      "employeeId":employeeId
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('appointment-management/analytics', requestModel, context);
    var responseJSON = json.decode(response.toString());
    topServicesList.clear();
    monthlyRevenueList.clear();

    topServicesList = (responseJSON["data"]?['topServices'] as List?)??[];
    monthlyRevenueList = (responseJSON["data"]?['monthlyRevenue'] as List?)??[];

    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }

    setState(() {
    });

  }
  double getMaxRevenueInK() {
    double max = 0;
    for (var item in monthlyRevenueList) {
      max = math.max(max, item['revenue'].toDouble());
    }
    return max / 1000;
  }
  double getYAxisInterval(double maxK) {
    if (maxK <= 0.2) return 0.05;
    if (maxK <= 0.5) return 0.1;
    if (maxK <= 1) return 0.2;
    if (maxK <= 5) return 1;
    if (maxK <= 10) return 2;
    return 5;
  }
  String formatYAxis(double value) {
    if (value == 0) return "\$0k";
    if (value < 1) {
      return "\$${value.toStringAsFixed(2)}k";
    }
    return "\$${value.toInt()}k";
  }
  Widget monthlyRevenueChart() {
    final double maxK = getMaxRevenueInK();
    final double interval = getYAxisInterval(maxK);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        border: Border.all(
          color: const Color(0xFFD8D8D8),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: SizedBox(
        height: 220,

        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceBetween,
            maxY: (maxK / interval).ceil() * interval,
            gridData: FlGridData(show: false),
            borderData: FlBorderData(show: false),

            titlesData: FlTitlesData(
              topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),
              rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false)),

              // 🔹 Y Axis
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: interval,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      formatYAxis(value),
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),

              // 🔹 X Axis
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index < 0 ||
                        index >= monthlyRevenueList.length) {
                      return const SizedBox.shrink();
                    }
                    return Text(
                      monthlyRevenueList[index]['month'],
                      style: const TextStyle(fontSize: 10),
                    );
                  },
                ),
              ),
            ),

            // 🔹 Bars
            barGroups:
            List.generate(monthlyRevenueList.length, (index) {
              final double revenueK =
                  monthlyRevenueList[index]['revenue'] / 1000;

              return BarChartGroupData(
                x: index,
                barRods: [
                  BarChartRodData(
                    toY: revenueK,
                    width: 14,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(4),
                      topRight: Radius.circular(4),
                    ),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFFF38328),
                        Color(0xFFF8AC6D),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    )
    ;

  }
  Widget topServicesWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            "Top Services",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        ...topServicesList.map((service) {
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF9F9F9),
              border: Border.all(color: const Color(0xFFD8D8D8)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🔸 Title
                Text(
                  service['name'],
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFF38328),
                  ),
                ),
                const SizedBox(height: 6),

                // 🔸 Details Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$${service['revenue']}",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA7A7A7)),
                    ),
                    Text(
                      "${service['sessions']} Sessions",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA7A7A7)),
                    ),

                    Text(
                      service['percentage'],
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFFA7A7A7)),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }
  Widget topServicesWidgetNotAvailable() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: Text(
            "Top Services",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(height: 10,),
        Center(child: Text("Services not availabe",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),)
        
      ],
    );
  }


}