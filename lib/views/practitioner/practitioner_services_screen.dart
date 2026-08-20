import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_menuscreen.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../utils/app_theme.dart';
import '../../widgets/custom_appbar_widget.dart';

class PractitionerServiceScreen extends StatefulWidget{
  _practitonerState createState()=>_practitonerState();
}
class _practitonerState extends State<PractitionerServiceScreen>{
  bool isServiceLoading=false;
  List<dynamic> servicesList=[];
  String employeeId="";
  String? userName;
  String? userId;

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
          appBar: CustomCardAppBar(iconStr:"assets/ham3.png",title: "Services", onBack: (){
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
                      isServiceLoading?Center(child: Loader(),):
                      servicesList.isEmpty?
                      Center(child: Text("No Services Available",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),):
                      ListView.builder(
                          itemCount: servicesList.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index){
                            String title=servicesList[index]['serviceName'].toString();
                            String price=servicesList[index]['price'].toString();
                            String duration=servicesList[index]['duration'].toString();
                            return Container(
                              width: double.infinity, // full width
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.all(12), // optional (content spacing)
                              decoration: BoxDecoration(
                                color: const Color(0xFFF9F9F9), // background color
                                border: Border.all(
                                  color: const Color(0xFFD8D8D8), // border color
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(8), // optional
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      // 🔹 Service Name – 50%
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          "Service Name",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),

                                      // 🔹 Duration – 25%
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Duration",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),

                                      // 🔹 Price – 25%
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Price(\$)",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                          ),
                                        ),
                                      ),
                                    ],),
                                  SizedBox(height: 10,),
                                  Row(
                                    children: [
                                      // 🔹 Service Name – 50%
                                      Expanded(
                                        flex: 2,
                                        child: Text(
                                          title,
                                          maxLines: 3,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.orangeColor
                                          ),
                                        ),
                                      ),

                                      // 🔹 Duration – 25%
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "$duration Min",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.orangeColor
                                          ),
                                        ),
                                      ),

                                      // 🔹 Price – 25%
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          price,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: AppTheme.orangeColor
                                          ),
                                        ),
                                      ),
                                    ],)
                                ],

                              ),
                            );
                          }
                      )
                    ],
                  ),
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

    fetchServices();
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

}