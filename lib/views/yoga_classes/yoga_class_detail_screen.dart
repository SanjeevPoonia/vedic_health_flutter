import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/yoga_classes/yoga_fullscreen_video.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../utils/yogavideo_model.dart';
import 'package:html/parser.dart' show parse;

import '../../widgets/notification_bar_widget.dart';
import '../membership/membership_user_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';



class YogaClassDetailScreen extends StatefulWidget {
  final categoryVideoModel videoModel;
  const YogaClassDetailScreen(this.videoModel,{super.key});

  @override
  _YogaClassesState createState() => _YogaClassesState();
}

class _YogaClassesState extends State<YogaClassDetailScreen> {
  bool isLoading = false;
  Duration? _previewDuration;
  late final WebViewController _controller;
  String vdo="";
  String coverImg="";
  String videoTitle="";
  String videoDescription="";
  String videoDuration="";
  String instructorName="";
  String id="";
  String videoLevel="";
  String? userId;
  String instructorExperties="";
  String instructorDescription="";
  List<categoryVideoModel>relatedVideoList=[];
  List<dynamic> subscribedVideos=[];

  bool isVideoSubscribed=false;




  @override
  void initState() {
    super.initState();

    categoryVideoModel video=widget.videoModel;



     coverImg=AppConstant.appBaseURL+video.videoCoverImage;
     videoTitle=video.videoName;
     videoDescription=video.videoDescription;
     videoDuration=video.videoDuration;
     instructorName=video.instructorName;
     id=video.videoId;
     //vdo=video.video;
     videoLevel=video.videoLevel;
     print(vdo);
     print(id);
     print(videoLevel);
    String url = video.video;
    if(url.contains("vimeo.com")){
      Uri uri = Uri.parse(url);
      vdo = uri.pathSegments.last;
    }else{
      vdo=url;
    }




    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            _controller.runJavaScript('''
              var player = new Vimeo.Player(document.querySelector('iframe'));
              player.on('timeupdate', function(data) {
                var duration = data.duration;
                var limit = duration * 0.01; // 10% of video
                if (data.seconds >= limit) {
                  player.setCurrentTime(0);
                  player.play();
                }
              });
            ''');
          },
        ),
      )
      ..loadRequest(Uri.parse(
        'https://player.vimeo.com/video/$vdo?autoplay=0&loop=0&muted=1&background=1',
      ));

    _loadVideoData();

  }



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body:  isLoading
            ? Center(child: Loader())
            : Column(
          children: [
            NotificationBarWidget(),
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 300,
                      width: double.infinity,
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.black,
                      ),
                      child: Stack(
                        children: [
                          // 🎥 Video background
                         /* Positioned.fill(
                            child: _isError
                                ? Container(
                              height: 300,
                              alignment: Alignment.center,
                              color: Colors.black,
                              child: const Text(
                                "Unable to load video preview",
                                style:
                                TextStyle(color: Colors.white),
                              ),
                            )
                                : (_videoPlayerController != null &&
                                _videoPlayerController!
                                    .value.isInitialized)
                                ? FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width:
                                _videoPlayerController!
                                    .value.size.width,
                                height:
                                _videoPlayerController!
                                    .value.size.height,
                                child: VideoPlayer(
                                    _videoPlayerController!),
                              ),
                            )
                                : const Center(
                                child:
                                CircularProgressIndicator()),
                          ),*/
                          Positioned.fill(
                            child: SizedBox(
                              height: 300,
                              width: double.infinity,
                              child:  WebViewWidget(controller: _controller),
                            ),
                          ),

                          // 🖤 Overlay 20%
                          Positioned.fill(
                            child: Container(
                                color: Colors.black.withOpacity(0.2)),
                          ),

                          // ▶ Center play button
                          isVideoSubscribed?
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {

                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  VimeoFullScreenPlayer(videoId: vdo),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              label: const Text(
                                "Play This Video",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.black.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                          ):
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showVimeoPopup(vdo);
                               /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>  VimeoFullScreenPlayer(videoId: vdo),
                                  ),
                                );*/
                              },
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              label: const Text(
                                "Preview this course",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                Colors.black.withOpacity(0.4),
                                shape: RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(30)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                              ),
                            ),
                          ),

                          isVideoSubscribed?Container():
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: Container(
                              color: Colors.black.withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  const Expanded(
                                    child: Text(
                                      "Subscribe to enjoy full access to yoga classes",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MembershipUserScreen()));
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                     AppTheme.orangeColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(20),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                    ),
                                    child: const Text(
                                      "Subscribe",
                                      style:
                                      TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),

                    isLoading?Center(child: Loader(),):
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          videoTitle,
                          style:  const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.darkBrown
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          parseHtmlString(videoDescription),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),

                        Text(
                          "About the Class",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Duration",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
                             "$videoDuration min",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF865940),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Teacher",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              "Level",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black,
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
                              videoLevel,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF865940),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "About Instructor",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox( height: 8,),
                        Text(
                          instructorExperties,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox( height: 8,),
                        Text(
                          parseHtmlString(instructorDescription),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "Related Videos",
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.8, // Adjust to fit the content well
                          ),
                          itemCount: relatedVideoList.length,
                          itemBuilder: (context, index) {
                            return _buildGridVideoCard(relatedVideoList[index]);
                          },
                        )





                      ],
                    ),)

                  ],
                ),
              ),
            ),
          ],
        ),

    );
  }
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
        Navigator.pushReplacement(
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
                    "Yoga Class Details",
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
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
  Future<void>_loadVideoData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    final appointments = await fetchVideoDataById(id);
    if(appointments.isNotEmpty){
      relatedVideoList.clear();
      List<dynamic> vList=(appointments[0]['relatedVideo']as List?)??[];
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
        relatedVideoList.add(categoryVideoModel(videoId, videoName, videoDescription, videoDuration, videoCategoryId, videoLevel,
            videoCoverImage, video, isExclusive, createdAt,
            instructorName, instructorEmail, instructorId, instructorPhone));

      }

      instructorDescription=appointments[0]['employeeData']?['description']?.toString()??"";
      instructorExperties=appointments[0]['employeeData']?['expertise']?.toString()??"";

      setState(() {
        videoLevel=appointments[0]['level']?['name']?.toString()??"";
      });

    }
    fetchAccessibleVideo();



  }
  Future<List<Map<String, dynamic>>> fetchVideoDataById(String videoId) async {
    try {
      setState(() => isLoading = true);

      // Prepare request body (base64 encoding of {"_id": userId})
      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({"videoId": videoId,"user_id":userId})))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "yoga_videos/findYogaVideoById", // API endpoint
        requestModel,
        context,
      );

      setState(() => isLoading = false);

      final responseJSON = json.decode(response.toString());
      print("Video response: $responseJSON");

      if (responseJSON["statusCode"] == 201 && responseJSON["result"] != null && responseJSON["result"].isNotEmpty) {

        return List<Map<String, dynamic>>.from(responseJSON["result"]);
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Error fetching appointments: $e");
    }
    return [];
  }
  void _showVimeoPopup(String videoId) {
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot dismiss by tap outside
      builder: (context) {
        Timer? timer;

        // Start a timer to close popup after 30 seconds
        timer = Timer(const Duration(seconds: 30), () {
          if (Navigator.canPop(context)) Navigator.pop(context);
        });

        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.zero,
          content: AspectRatio(
            aspectRatio: 16 / 9,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: WebViewWidget(
                controller: WebViewController()
                  ..setJavaScriptMode(JavaScriptMode.unrestricted)
                  ..loadRequest(
                    Uri.parse(
                      "https://player.vimeo.com/video/$videoId?autoplay=1&loop=0&muted=0&title=0&byline=0&controls=0",
                    ),
                  ),
              ),
            ),
          ),

        );
      },
    );
  }
  fetchAccessibleVideo() async {
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
    var response = await helper.postAPI('yoga_videos/findVideosByUserid', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201){
      subscribedVideos=(responseJSON['membership']?['accessibleVideos'] as List?)??[];
      isVideoSubscribed = subscribedVideos.any(
            (video) => video['_id']?.toString() == id,
      );
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
    setState(() {
      isLoading = false;
    });
  }


}