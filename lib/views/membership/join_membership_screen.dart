import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../widgets/notification_bar_widget.dart';
import 'membership_detail_screen.dart';

class JoinMembershipScreen extends StatefulWidget {
  const JoinMembershipScreen({super.key});

  @override
  State<JoinMembershipScreen> createState() => _JoinMembershipScreenState();
}

class _JoinMembershipScreenState extends State<JoinMembershipScreen> {


  List<dynamic> membershipPlans = [];
  var selectedPan;

  bool isLoading=false;
  int pageNo=1;
  int pageSize=50;
  String selectedPlanId="";
  String userId="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
        backgroundColor: const Color(0xFFF2F6FF),
        body: isLoading?Center(child: Loader(),):SingleChildScrollView(
          child: Column(
            children: [
              NotificationBarWidget(),
              /// Back Button
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              /// Title & Subtitle
              const Text(
                "Join A Membership",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Get access to classes, events,\n discounts and more",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.w500
                ),
              ),

              const SizedBox(height: 20),

              /// Lottie Animation
              Lottie.asset(
                "assets/yoga_mem.json",
                height: 220,
              ),

              const SizedBox(height: 20),

              /// Membership Options
              membershipPlans.isEmpty?
              const Center(child: Text("No membership plans are available at the moment. Please check again later.", style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.grey),),):
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: membershipPlans.length,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemBuilder: (context, index) {
                  final plan = membershipPlans[index];
                  String id=plan['_id']?.toString()??"";
                  bool isSelected=false;
                  if(selectedPlanId==id){
                    isSelected=true;
                  }
                  String title=plan['plan_name']?.toString()??"";
                  String price=plan['price']?.toString()??"0";
                  int expiresIN=plan['expiring_in']??0;
                  String upPlan=getPlanFromDays(expiresIN);

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedPlanId = id;
                        selectedPan=plan;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFB65303)
                              : Colors.grey.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          /// Radio Circle
                          Container(
                            height: 22,
                            width: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFB65303)
                                    : Colors.grey,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      height: 12,
                                      width: 12,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFB65303),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 14),

                          /// Membership Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  upPlan,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          /// Price
                          Text(
                            "\$ $price",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              const SizedBox(height: 80),
            ],
          ),
        ),

        /// Sticky Bottom Subscribe Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: selectedPlanId.isEmpty
                ? null
                : () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  MembershipDetailScreen(selectedPan),
                      ),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Subscribe",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      );
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void>_loadUserData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    fetchMembershipList();
  }
  fetchMembershipList() async {
    setState(() {
      isLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId,
      "page":pageNo,
      "pageSize":pageSize
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_management/getAll', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      membershipPlans=(responseJSON['result'] as List?)??[];
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }
  String getPlanFromDays(int days) {
    double months = days / 30;
    if (months <= 1) {
      return "Per Month, Per Person";
    } else if (months <= 3) {
      return "Every 3 Months, Per Person";
    } else if (months <= 6) {
      return "Every 6 Months, Per Person";
    } else if (months <= 12) {
      return "Per Year, Per Person";
    } else {
      return "Long-term Plan, Per Person";
    }
  }


}
