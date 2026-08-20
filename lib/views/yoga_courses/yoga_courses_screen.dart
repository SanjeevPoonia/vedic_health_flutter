import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/views/yoga_courses/yoga_course_detail_screen.dart';
import 'package:vedic_health/widgets/notification_bar_widget.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import 'package:flutter/material.dart';
import '../../network/loader.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:html/parser.dart' show parse;

class YogaCoursesScreen extends StatefulWidget{
  _yogaCoursesState createState()=>_yogaCoursesState();
}
class _yogaCoursesState extends State<YogaCoursesScreen>{
  String _selectedFilterKey = '0';
  String _selectedCategoryName="";
  bool isLoading=false;
  int currentPage=1;
  int pageSize=100;
  int totalPage=1;
  int totalSize=0;
  //List<filtersModel> filterList=[];
  List<dynamic> allCourses=[];

  String bannerTitle="";
  String bannerImagePath="";
  String bannerId="";
  String searchText="";
  List<dynamic> filteredCourses = [];
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
            _buildSearchBar(),
            const SizedBox(height: 10,),
            bannerImagePath.isNotEmpty?
            _buildBannerImage():Container(),
            SizedBox(height: 12,),
            filteredCourses.isNotEmpty?
            ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: filteredCourses.length,
                itemBuilder: (mContext,inx){
                  return _buildCourseCard(filteredCourses[inx]);
                }):
            const Center(child: Padding(padding: EdgeInsets.all(16),
              child: Text("Currently, there are no Courses available",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),),

            ),),
          ],
        ),
        ),

    );
  }
  @override
  void initState() {
    super.initState();
    fetchBannerImage();
  }
  fetchBannerImage() async {
    setState(() {
      isLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "dropdown_type": "courses_banner",
      "page": 1, // Assuming default page number
      "pageSize": 10 // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('master/allData', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      List<dynamic> dynamicResult=(responseJSON['result'] as List?) ?? [];

      if(dynamicResult.isNotEmpty){
        bannerTitle=dynamicResult[0]['name']?.toString()??"";
        bannerId=dynamicResult[0]['_id']?.toString()??"";
        String imagePath=dynamicResult[0]['file']?.toString()??"";
        if(imagePath.isNotEmpty){
          bannerImagePath=AppConstant.appBaseURL+imagePath;
        }
      }


      fetchYogaCourses();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      fetchYogaCourses();
    }
    setState(() {
      isLoading = false;
    });
  }
  fetchYogaCourses() async {
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
    var response = await helper.postAPI('course_management/getAll', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      allCourses.clear();
      filteredCourses.clear();
      allCourses=(responseJSON['result'] as List?) ?? [];
      filteredCourses.addAll(allCourses);
      totalPage=responseJSON['totalPages']??1;
      totalSize=responseJSON['totalCount']??0;

     /* filterList.clear();
      filterList.add(filtersModel("All Classes", "0"));
      allClassesList.clear();
      for(int i=0;i<evList.length;i++){
        String categoryid=evList[i]['_id']?.toString()??"";
        String categoryName=evList[i]['name']?.toString()??"";
        String categoryDescription=evList[i]['description']?.toString()??"";
        String categoryDropdownType=evList[i]['dropdown_type']?.toString()??"";
        filterList.add(filtersModel(categoryName, categoryid));
        List<categoryVideoModel> videoList=[];
        List<dynamic> vList=(evList[i]['videos']as List?)??[];
        for(int j=0;j<vList.length;j++){
          String videoId=vList[j]['_id']?.toString()??"";
          String videoName=vList[j]['name']?.toString()??"";
          String videoDescription=vList[j]['description']?.toString()??"";
          String videoDuration=vList[j]['duration']?.toString()??"";
          String videoCategoryId=vList[j]['categoryId']?.toString()??"";
          String videoLevel=vList[j]['level']?.toString()??"";
          String videoCoverImage=vList[j]['coverImage']?.toString()??"";
          String video=vList[j]['video']?.toString()??"";
          String createdAt=vList[j]['createdAt']?.toString()??"";
          bool isExclusive=vList[j]['is_exclusive']??false;
          String instructorName=vList[j]['employee']?['name']?.toString()??"";
          String instructorEmail=vList[j]['employee']?['email']?.toString()??"";
          String instructorId=vList[j]['employee']?['_id']?.toString()??"";
          String instructorPhone=vList[j]['employee']?['mobileNo']?.toString()??"";
          videoList.add(categoryVideoModel(videoId, videoName, videoDescription, videoDuration, videoCategoryId, videoLevel,
              videoCoverImage, video, isExclusive, createdAt,
              instructorName, instructorEmail, instructorId, instructorPhone));

        }
        allClassesList.add(categoryModel(categoryid, categoryName, categoryDescription, categoryDropdownType, videoList));
      }*/

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
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
                    "Courses",
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
  Widget _buildBannerImage() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: double.infinity,
        height: 250,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            CachedNetworkImage(
              imageUrl: bannerImagePath,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),

            // Black Overlay (20% opacity)
            Container(
              color: Colors.black.withOpacity(0.2),
            ),

            // Centered Title Text
            Center(
              child: Text(
                bannerTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black54,
                      offset: Offset(1, 1),
                      blurRadius: 4,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),);
  }
  Widget _buildSearchBar() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(
                color: Colors.grey.shade400, // Border का रंग
                width: 1.2,                   // Border की मोटाई
              ),
            ),
            child:  Row(
              children: [
                const Icon(Icons.search, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "Search",
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onChanged: (value){
                      searchText=value;
                      applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    ),);
  }
  void applyFilters() {
    setState(() {
      filteredCourses = allCourses.where((course) {
        String courseName=course["courseName"]?.toString()??"";
        final matchesText = searchText.isEmpty || courseName.toLowerCase().contains(searchText.toLowerCase());
        return matchesText;
      }).toList();
    });
  }
  Widget _buildCourseCard(dynamic course) {
    String cImage=course['icon_file']?.toString()??"";
    String coverImg="";
    if(cImage.isNotEmpty){
      coverImg=AppConstant.appBaseURL+cImage;
    }
    String courseTitle=course['courseName']?.toString()??"";
    String courseDescription=course['description']?.toString()??"";
    String courseCategory=course['categoryId']?['name'].toString()??"";
    String price=course['price']?.toString()??"0";
    String id=course['_id']?.toString()??"";
    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YogaCourseDetailScreen(id)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 10),
        child: Container(
          height: 120,
          margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: coverImg,
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        courseTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Category: $courseCategory",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "\$$price",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF865940),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
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
}
class filtersModel{
  String filterName;
  String filterId;
  filtersModel(this.filterName, this.filterId);
}