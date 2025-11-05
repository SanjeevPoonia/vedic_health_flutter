import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/parser.dart' show parse;
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/appointments/membership/join_membership_screen.dart';
import 'package:vedic_health/views/yoga_classes/yoga_class_detail_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../utils/yogavideo_model.dart';

// Dummy Video and dummy data to match the image
class Video {
  final String title;
  final String imagePath;
  final String duration;
  final String instructor;

  Video({
    required this.title,
    required this.imagePath,
    required this.duration,
    required this.instructor,
  });
}

final List<Video> beginnerVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];
final List<Video> advantageVideos = [
  Video(
    title: "Trataka Candle Meditation",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];
final List<Video> hathaVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];
final List<Video> powerVideos = [
  Video(
    title: "Surya Namaskar: Practice",
    imagePath: "assets/banner2.png",
    duration: "44 min",
    instructor: "Amita Jain",
  ),
];

// Main screen widget
class YogaClassesScreen extends StatefulWidget {
  const YogaClassesScreen({super.key});

  @override
  _YogaClassesScreenState createState() => _YogaClassesScreenState();
}

class _YogaClassesScreenState extends State<YogaClassesScreen> {
  String _selectedFilterKey = '0';
  String _selectedCategoryName="";
  bool isLoading=false;
  int currentPage=1;
  int pageSize=100;
  int totalPage=1;
  int totalSize=0;
  List<filtersModel> filterList=[];
  List<categoryModel>allClassesList=[];
  List<categoryVideoModel>categoryWiseVideoList=[];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading?Center(child: Loader(),):Column(
          children: [
            // App Bar
            _buildAppBar(),

            filterList.isNotEmpty?
            _buildFilterChips():Container(),
            // Main Content Area
            allClassesList.isNotEmpty?
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      // Conditionally show content based on the selected filter
                      if (_selectedFilterKey == '0') ...[

                        ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: allClassesList.length,
                            itemBuilder: (context, index){
                              String categoryName=allClassesList[index].categoryName;
                              String categoryId=allClassesList[index].categoryId;
                              String categoryDescription=allClassesList[index].categoryDescription;
                              List<categoryVideoModel>videoList=allClassesList[index].videoList;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        categoryName,
                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      videoList.isEmpty?Container():
                                      GestureDetector(
                                        onTap: () {
                                          _selectedFilterKey=categoryId;
                                          _onFilterClick();
                                          /* setState(() {
                                            _selectedFilterKey=categoryId;
                                          });*/
                                        },
                                        child: const Text(
                                          "See all",
                                          style: TextStyle(
                                            color: Color(0xFF5A89AD),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  videoList.isNotEmpty?
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: videoList.length,
                                      itemBuilder: (mContext,inx){
                                        return _buildVideoCard(videoList[inx]);
                                      }):
                                  Center(child: Padding(padding: EdgeInsets.all(16),
                                    child: Text("Currently, there are no videos available for $categoryName.",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey
                                      ),),

                                  ),),
                                ],
                              );

                            }),



                      ] else ...[
                        categoryWiseVideoList.isNotEmpty?
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8, // Adjust to fit the content well
                          ),
                          itemCount: categoryWiseVideoList.length,
                          itemBuilder: (context, index) {
                            return _buildGridVideoCard(categoryWiseVideoList[index]);
                          },
                        )
                            :Center(child: Padding(padding: EdgeInsets.all(16),
                          child: Text("Currently, there are no videos available for $_selectedCategoryName.",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey
                            ),),

                        ),),
                      ]
                    ],
                  ),
                ),
              ),
            ):
            const Center(child: Padding(padding: EdgeInsets.all(16),
              child: Text("Currently, there are no Yoga classes available. Please visit again later for upcoming Yoga classes.",
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
                  size: 17, color: Colors.black),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Yoga Classes",
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
  Widget _buildFilterChips() {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200, width: 1),
        ),
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filterList.length,
        itemBuilder: (context, index) {
          String filterId=filterList[index].filterId;
          String fName=filterList[index].filterName;
          final isSelected = _selectedFilterKey == filterId;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                _selectedFilterKey = filterId;
                _selectedCategoryName=fName;
                _onFilterClick();
                /*setState(() {


                });*/
              },
              child: Chip(
                label: Text(
                  fName,
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor:
                    isSelected ? const Color(0xFFF38328) : Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide.none,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
  /*Widget _buildVideoSection(String title, List<Video> videos) {
    if (videos.isEmpty) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                if (title.toLowerCase().contains('beginner yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Beginner Yoga';
                  });
                } else if (title.toLowerCase().contains('advantage yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Advantage Yoga';
                  });
                } else if (title.toLowerCase().contains('hatha yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Hatha Yoga';
                  });
                } else if (title.toLowerCase().contains('power yoga')) {
                  setState(() {
                    _selectedFilterKey = 'Power Yoga';
                  });
                }
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF5A89AD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...videos.map((video) => _buildVideoCard(video)).toList(),
      ],
    );
  }
  // New widget for the Beginner Yoga grid layout
  Widget _buildBeginnerYogaGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "BEGINNER YOGA VIDEOS",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            GestureDetector(
              onTap: () {
                // TODO: Implement "See all" functionality for Beginner Yoga
              },
              child: const Text(
                "See all",
                style: TextStyle(
                  color: Color(0xFF5A89AD),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8, // Adjust to fit the content well
          ),
          itemCount: beginnerVideos.length,
          itemBuilder: (context, index) {
            return _buildGridVideoCard(beginnerVideos[index]);
          },
        ),
      ],
    );
  }*/
  Widget _buildGridVideoCard(categoryVideoModel video) {
    String coverImg=AppConstant.appBaseURL+video.videoCoverImage;
    String videoTitle=video.videoName;
    String videoDescription=video.videoDescription;
    String videoDuration=video.videoDuration;
    String instructorName=video.instructorName;
    String id=video.videoId;
    String vdo=video.video;

    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YogaClassDetailScreen(video)));

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
                      ),
                      const Text(
                        " | ",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          instructorName,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
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

  Widget _buildMembershipBanner() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const JoinMembershipScreen(),
            ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF38328),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Join our membership",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Choose now and start experiencing the full value of our community!",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 30,
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildVideoCard(categoryVideoModel video) {

    String coverImg=AppConstant.appBaseURL+video.videoCoverImage;
    String videoTitle=video.videoName;
    String videoDescription=video.videoDescription;
    String videoDuration=video.videoDuration;
    String instructorName=video.instructorName;
    String id=video.videoId;
    String vdo=video.video;





    return InkWell(
      onTap: (){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => YogaClassDetailScreen(video)));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
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
                        videoTitle,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        parseHtmlString(videoDescription),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            "$videoDuration min",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF865940),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Text(
                            " | ",
                            style: TextStyle(
                              color: Color(0xFF865940),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            instructorName,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF865940),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

  @override
  void initState() {
    super.initState();
    fetchYogaClasses();
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
      "page": currentPage, // Assuming default page number
      "pageSize": pageSize // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('yoga_videos/getAll', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201){
      List<dynamic>evList=(responseJSON['result'] as List?) ?? [];
      totalPage=responseJSON['totalPages']??1;
      totalSize=responseJSON['totalCount']??0;
      filterList.clear();
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
      }

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }
  _onFilterClick(){
    categoryWiseVideoList.clear();
    for(int i=0;i<allClassesList.length;i++){
      String categoryId=allClassesList[i].categoryId;
      List<categoryVideoModel>list=allClassesList[i].videoList;
      if(_selectedFilterKey==categoryId){
        categoryWiseVideoList.addAll(list);
        break;
      }
    }
    setState(() {

    });
  }
}

class filtersModel{
  String filterName;
  String filterId;
  filtersModel(this.filterName, this.filterId);
}

