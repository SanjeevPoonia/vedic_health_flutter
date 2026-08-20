import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/membership/join_membership_screen.dart';
import 'package:vedic_health/views/membership/membership_invoices_screen.dart';
import 'package:vedic_health/views/membership/membership_videos_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import 'package:intl/intl.dart';
import '../../widgets/notification_bar_widget.dart';
import '../yoga_classes/yoga_fullscreen_video.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MembershipUserScreen extends StatefulWidget{
  _membershipState createState()=> _membershipState();
}
class _membershipState extends State<MembershipUserScreen>{
  bool isLoading=false;
  String? userId;
  List<dynamic> coursesList=[];
  String Id="";
  String membershipId="";
  int expiresIn=0;
  bool isExpired=false;
  String status="";
  String renewalDate="";
  String paymentSessionId="";
  String planName="";
  String planDescription="";
  int tier=0;
  dynamic membershipDynamic;
  String renewDateStr="";
  String price="";
  int planDays=0;
  List<dynamic> leftPlans=[];

  String selectedForUpgrade="";
  var selectedForUpgradePlan="";

  List<dynamic> subscribedVideos=[];

  bool isVideoloading=false;

  bool isInvoicesLoading=false;
  List<dynamic> invoicesList=[];


  bool isMembershipPurchased=false;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body:  isLoading?Center(child: Loader(),):
        SingleChildScrollView(child:
        Column(
          children: [
            NotificationBarWidget(),
            // App Bar
            _buildAppBar(),
            const SizedBox(height: 20,),
            isMembershipPurchased?
            _buildPlanBanner():
            _buildPlanBannerForSubscribe(),
            SizedBox(height: 12,),
            leftPlans.isNotEmpty?
            _allSubscriptionPlans():Container(),
            SizedBox(height: 12,),
            _allSubscribedVideos(),
            SizedBox(height: 12,),
            _allInvoices(),



          ],
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
    fetchMembershipCourses();
    fetchAccessibleVideo();
    fetchAllInvoices();
  }
  fetchMembershipCourses() async {
    setState(() {
      isLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('course_management/getCourseAndMembership', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      coursesList=(responseJSON['data']['courses'] as List?)??[];
      Id=responseJSON['data']?['membership']?['_id']?.toString()??"";
      membershipId=responseJSON['data']?['membership']?['membership_id']?.toString()??"";
      expiresIn=responseJSON['data']?['membership']?['expire_in']??0;
      isExpired=responseJSON['data']?['membership']?['is_expired']??false;
      status=responseJSON['data']?['membership']?['status']?.toString()??"";
      renewalDate=responseJSON['data']?['membership']?['renewal_date']?.toString()??"";
      paymentSessionId=responseJSON['data']?['membership']?['paymentSessionId']?.toString()??"";
      planName=responseJSON['data']?['membership']?['membershipDetails']?['plan_name']?.toString()??"";
      price=responseJSON['data']?['membership']?['membershipDetails']?['price']?.toString()??"";
      planDays=responseJSON['data']?['membership']?['membershipDetails']?['expiring_in']??0;
      planDescription=responseJSON['data']?['membership']?['membershipDetails']?['plan_description']?.toString()??"";
      membershipDynamic=responseJSON['data']?['membership']?['membershipDetails'];
      String reDate=formatDateUtc(renewalDate);
      renewDateStr= "Next Billing on $reDate";

      List<dynamic> itList=(responseJSON['data']['membership']?['memberships'] as List?)??[];
      for(var item in itList){
        String plId=item['_id']?.toString()??"";
        if(plId!=membershipId){
          leftPlans.add(item);
        }
      }

      for(var course in coursesList){
        List<dynamic> cousList=(course['course'] as List?)??[];


      }



      if(responseJSON['data']?['membership']==null){
        isMembershipPurchased=false;
      }else{
        isMembershipPurchased=true;
      }

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      isMembershipPurchased=false;
    }
    setState(() {
      isLoading = false;
    });
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
                    "Membership",
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
  Widget _buildPlanBanner() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(108 * 3.1415926535 / 180), // 108 degree
            colors: [
              Color(0xFFE77735),
              Color(0xFF8A5A40),
              Color(0xFF865940),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            /// --- Right Side Center SVG ---
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/ic_membership_icon.svg",
                  width: 84,
                  height: 91,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            /// --- Row Over the Gradient (Content on Left) ---
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Expanded(
                        child: Row(
                          children: [
                            Expanded(flex:1,child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  planName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  renewDateStr,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )),
                            SizedBox(width: 10,),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:  [
                                Text(
                                  "\$ $price",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  getPlanFromDays(planDays),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            )

                          ],
                        ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),);
  }
  Widget _buildPlanBannerForSubscribe() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(108 * 3.1415926535 / 180),
            colors: [
              Color(0xFFE77735),
              Color(0xFF8A5A40),
              Color(0xFF865940),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Stack(
          children: [
            /// --- Right Side Center SVG ---
            Positioned(
              right: 0,
              top: 0,
              bottom: 0,
              child: Center(
                child: SvgPicture.asset(
                  "assets/ic_membership_icon.svg",
                  width: 84,
                  height: 91,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            /// --- Center Message + Button ---
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "You don’t have an active membership yet. Please join a membership plan to continue.",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),

                      /// --- Join Membership Button ---
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => JoinMembershipScreen()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            "Join Membership",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String formatDateUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  String getPlanFromDays(int days) {
    double months = days / 30;
    if (months <= 1) {
      return "Per Month";
    } else if (months <= 3) {
      return "Every 3 Months";
    } else if (months <= 6) {
      return "Every 6 Months";
    } else if (months <= 12) {
      return "Per Year";
    } else {
      return "Long-term Plan, Per Person";
    }
  }
  Widget _allSubscriptionPlans() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          const Text(
            "All Subscription plan",
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: leftPlans.length,

            itemBuilder: (context, index) {
              final plan = leftPlans[index];
              String id=plan['_id']?.toString()??"";
              bool isSelected=false;
              if(selectedForUpgrade==id){
                isSelected=true;
              }
              String title=plan['plan_name']?.toString()??"";
              String price=plan['price']?.toString()??"0";
              int expiresIN=plan['expiring_in']??0;
              String upPlan=getPlanFromDays(expiresIN);

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedForUpgrade = id;
                    selectedForUpgradePlan=plan;
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
          SizedBox(height: 12,),
        ],
      ),
    );
  }
  Widget _allSubscribedVideos() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Row(
            children: [
              Expanded(flex:1,child: const Text(
                "Subscribed Videos",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
              SizedBox(width: 5,),
              subscribedVideos.length>2?
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MembershipVideosScreen(subscribedVideos)));
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    color: Color(0xFF5A89AD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ):Container()
            ],
          ),
          const SizedBox(height: 10),
          isVideoloading?Center(child: Loader(),):
          subscribedVideos.isEmpty?
          Center(
            child: Column(
              children: [
                Text("No subscribed videos were found. Please refresh and try again.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                SizedBox(height: 10,),
                IconButton(
                    onPressed: (){
                      fetchAccessibleVideo();
                    },
                    icon: Icon(Icons.refresh,size: 24,color: AppTheme.themeColor,)
                )
              ],
            )
            ):
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Adjust to fit the content well
            ),
            itemCount: subscribedVideos.length>2?2:subscribedVideos.length,
            itemBuilder: (context, index) {
              return _buildGridVideoCard(subscribedVideos[index]);
            },
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
  fetchAccessibleVideo() async {
    setState(() {
      isVideoloading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('yoga_videos/findVideosByUserid', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201){
      subscribedVideos=(responseJSON['membership']?['accessibleVideos'] as List?)??[];
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isVideoloading = false;
    });
  }
  Widget _buildGridVideoCard(var video) {

    String img=video['coverImage']?.toString()??"";
    String coverImg="";
    if(img.isNotEmpty){
      coverImg=AppConstant.appBaseURL+img;
    }
    String videoTitle=video['name']?.toString()??"";
    String videoDescription=video['description']?.toString()??"";
    String videoDuration=video['duration']?.toString()??"";
    String vdo=video['video']?.toString()??"";

    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => VimeoFullScreenPlayer( videoId: vdo,)));

      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300, width: 1),
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: CachedNetworkImage(
                imageUrl: coverImg,
                height: 120,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 120,
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 120,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, color: Colors.grey),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    videoTitle,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF662A09),
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        "$videoDuration min",
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _allInvoices() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Row(
            children: [
              Expanded(flex:1,child: const Text(
                "Invoices",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),
              SizedBox(width: 5,),
              invoicesList.length>5?
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MembershipInvoicesScreen(invoicesList)));
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                    color: Color(0xFF5A89AD),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ):Container()
            ],
          ),
          const SizedBox(height: 10),
          isInvoicesLoading?Center(child: Loader(),):
          invoicesList.isEmpty?

          Center(
            child:Column(
              children: [
                Text("No invoice were found. Please refresh and try again.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                SizedBox(height: 10,),
                IconButton(
                    onPressed: (){
                      fetchAllInvoices();
                    },
                    icon: Icon(Icons.refresh,size: 24,color: AppTheme.themeColor,)
                )
              ],
            )
          ):
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: invoicesList.length>5?5:invoicesList.length,
            itemBuilder: (context, index) {
              final invoice=invoicesList[index];

              String title=invoice['plan_name']?.toString()??"";
              String date=invoice['date']?.toString()??"";
              String status=invoice['status']?.toString()??"";
              String price=invoice['totals']['total']?.toString()??"";

              //String convertedDate=formatDateTimeUtc(date);

              return GestureDetector(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // shadow color
                        blurRadius: 4,  // soften the shadow
                        spreadRadius: 1, // how wide the shadow spreads
                        offset: Offset(0, 4), // shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// Radio Circle
                      SvgPicture.asset("assets/ic_invoices.svg",height: 37,width: 37,fit: BoxFit.contain,),
                      const SizedBox(width: 14),
                      /// Membership Text
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$ $price",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          statusBadge(status),
                        ],
                      )

                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
  }
  Widget statusBadge(String status) {
    bool isActive = status.toLowerCase() == "paid";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  fetchAllInvoices() async {
    setState(() {
      isInvoicesLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId,
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_buy_management/getUserSubscriptionDetails', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 || statusCode==200){
      invoicesList=(responseJSON['data']?['invoices'] as List?)??[];
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isInvoicesLoading = false;
    });
  }
  String formatDateTimeUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return date;
    }
  }


}