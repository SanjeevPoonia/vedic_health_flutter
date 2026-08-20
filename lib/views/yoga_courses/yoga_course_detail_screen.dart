import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/views/membership/join_membership_screen.dart';
import 'package:vedic_health/views/yoga_courses/document_viewer_class.dart';
import 'package:vedic_health/widgets/notification_bar_widget.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';
import '../word_webview_screen.dart';
import '../yoga_classes/yoga_fullscreen_video.dart';
import 'package:html/parser.dart' show parse;
import 'package:vedic_health/network/api_dialog.dart';

class YogaCourseDetailScreen extends StatefulWidget{
  String courseId;
  YogaCourseDetailScreen(this.courseId);
  _YogaCourseState createState()=>_YogaCourseState();
}
class _YogaCourseState extends State<YogaCourseDetailScreen>{
  String? userId;
  bool isLoading=false;
  String courseName="";
  String coursePrice="";
  String courseDescription="";
  String courseImagePath="";
  String courseCategoryId="";
  String courseCategoryName="";
  String courseViewCount="0";
  List<dynamic> learningList=[];
  List<dynamic> courseContentList=[];
  bool isPurchaged=false;
  late final WebViewController _controller;
  String firstVdo="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
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
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if(isPurchaged){
                                   Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>  VimeoFullScreenPlayer(videoId: firstVdo),
                                    ),
                                  );
                                }else{
                                  _showVimeoPopup(firstVdo);
                                }


                              },
                              icon: const Icon(Icons.play_arrow,
                                  color: Colors.white),
                              label:  Text(
                                isPurchaged?"Play":
                                "Preview",
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

                          // ⬛ Bottom text bar
                         /* !isPurchaged?Positioned(
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
                                      "Subscribe to enjoy full access to this Course",
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
                                      // TODO: Subscribe button
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
                          ):Container(),*/
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),

                    isLoading?Center(child: Loader(),):
                    Padding(padding: EdgeInsets.symmetric(horizontal: 10),child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(flex:1,child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  courseName,
                                  style:  const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                  ),
                                ),
                                SizedBox(height: 4,),
                                Text(
                                  "Category: $courseCategoryName",
                                  style:  const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black
                                  ),
                                ),
                              ],
                            )),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Text(
                              "\$$coursePrice",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF865940),
                                fontWeight: FontWeight.bold,
                              ),
                            ),)
                          ],
                        ),

                        const SizedBox(height: 20,),
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          parseHtmlString(courseDescription),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.w500
                          ),
                        ),
                        const SizedBox(height: 20),

                        const Text(
                          "What You'll learn",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: learningList.length,
                          itemBuilder: (context,index){
                            String learnPoint=learningList[index]?['title']?.toString()??"";
                            String learnId=learningList[index]?['_id']?.toString()??"";
                            return _buildLearningCard(learnId, learnPoint);
                          }),
                        const SizedBox(height: 20),
                        const Text(
                          "Course Content",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.black
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: courseContentList.length,
                            itemBuilder: (context,index){
                              String contentTitle=courseContentList[index]?['sectionTitle']?.toString()??"";
                              String id=courseContentList[index]?['_id']?.toString()??"";
                              List<dynamic> lectureList=(courseContentList[index]['lectures'] as List?) ?? [];
                              int position=index+1;
                              String totalLecture="${lectureList.length} Lectures";
                              int totalMin = lectureList
                                  .where((l) => l['type']?.toString() == 'video')
                                  .map((l) => int.tryParse(l['videoId']?['duration']?.toString() ?? '0') ?? 0)
                                  .fold(0, (sum, val) => sum + val);

                              return _buildLectureTile(position,id,contentTitle,totalLecture,totalMin,lectureList);
                            }),
                        const SizedBox(height: 20),
                        !isPurchaged?
                        Row(
                          children: [
                            Expanded(child: GestureDetector(
                              onTap: (){
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => JoinMembershipScreen()));
                              },
                              child: Container(
                                  height: 54,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xFFB65303)
                                  ),
                                  child: const Center(
                                    child:
                                    Text("Join Membership",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )),
                                  )
                              ),
                            )),
                            SizedBox(width: 10,),
                            Expanded(child: GestureDetector(
                              onTap: (){
                                placeOrder();
                              },
                              child: Container(
                                  height: 54,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: AppTheme.darkBrown
                                  ),
                                  child: const Center(
                                    child:
                                    Text("Buy Now",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        )),
                                  )
                              ),
                            )),
                          ],
                        ):Container(),



                        SizedBox(height: 10,)








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
  @override
  void initState() {
    super.initState();
    _loadCourseData();

  }
  Future<void>_loadCourseData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    _fetchCourseById();
  }
   _fetchCourseById() async {
    try {
      setState(() => isLoading = true);
      final requestModel = {
        "data": base64.encode(utf8.encode(json.encode({"_id": widget.courseId,"user_id":userId})))
      };

      ApiBaseHelper helper = ApiBaseHelper();
      final response = await helper.postAPI(
        "course_management/getById", // API endpoint
        requestModel,
        context,
      );

      setState(() => isLoading = false);
      final responseJSON = json.decode(response.toString());
      print("Video response: $responseJSON");
      if (responseJSON["statusCode"] == 200 ) {

        courseName=responseJSON['data']?['courseName']?.toString()??"";
        coursePrice=responseJSON['data']?['price']?.toString()??"0";
        String img=responseJSON['data']?['icon_file']?.toString()??"";
        if(img.isNotEmpty){
          courseImagePath=AppConstant.appBaseURL+img;
        }
        courseDescription=responseJSON['data']?['description']?.toString()??"";

        courseCategoryId=responseJSON['data']?['categoryId']?['_id']?.toString()??"";
        courseCategoryName=responseJSON['data']?['categoryId']?['name']?.toString()??"";
        courseViewCount=responseJSON['data']?['viewCount']?.toString()??"0";
        learningList=(responseJSON['data']['learnings'] as List?) ?? [];
        courseContentList=(responseJSON['data']['courseContent'] as List?) ?? [];
        isPurchaged=responseJSON['data']?['isPurchased']??false;

        if (courseContentList.isNotEmpty) {
          final bannerVideo = courseContentList
              .expand((courseContent) => (courseContent['lectures'] as List?) ?? [])
              .firstWhere(
                (lecture) => lecture['type']?.toString() == 'video' &&
                (lecture['videoId']?['video']?.toString().isNotEmpty ?? false),
            orElse: () => null,
          )?['videoId']?['video']?.toString() ?? "";

          if (bannerVideo.isNotEmpty) {
            firstVdo=bannerVideo;
            _setCourseVideoContent(bannerVideo);
          }
        }

        setState(() {
        });

      }else{
        Toast.show(responseJSON["message"]?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
        _finishScreen();
      }
    } catch (e) {
      setState(() => isLoading = false);
      Toast.show("Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      _finishScreen();
    }
  }
  _finishScreen(){
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
  _setCourseVideoContent(String vdo){
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
                    "Course Details",
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
  void _showVimeoPopup(String videoId) {
    showDialog(
      context: context,
      barrierDismissible: false, // User cannot dismiss by tap outside
      builder: (context) {
        ValueNotifier<int> secondsLeft = ValueNotifier<int>(30);
        Future.delayed(const Duration(seconds: 2),(){
          Timer.periodic(const Duration(seconds: 1), (timer) {
            if (secondsLeft.value > 0) {
              secondsLeft.value--;
            } else {
              timer.cancel();
              if (Navigator.canPop(context)) Navigator.pop(context);
            }
          });
        });


        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: EdgeInsets.zero,
          content: Stack(
            children: [
              /// --- Video Player ---
              AspectRatio(
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

              /// --- Countdown Text on Top Center ---
              Positioned(
                top: 10,
                left: 0,
                right: 0,
                child: ValueListenableBuilder<int>(
                  valueListenable: secondsLeft,
                  builder: (context, value, _) {
                    return Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "$value sec left",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  String parseHtmlString(String htmlString) {
    final document = parse(htmlString);
    final String parsedString = parse(document.body!.text).documentElement!.text;
    return parsedString;
  }
  Widget _buildLearningCard(String id, String title) {


    return InkWell(
      onTap: (){

      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(4),
            child: Icon(Icons.check,size: 12,color: Colors.green,),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildLectureTile(int position,String id, String title,String totalLecture,int totalMin,List<dynamic> lectureList) {
    String formattedPosition = position.toString().padLeft(2, '0');

    return InkWell(
      onTap: (){
        showContentBottomSheet(context, lectureList);
      },
      child: Container(
        height: 100,
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 2),
        decoration: BoxDecoration(
          color: AppTheme.courseTileBack,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color(0xFFDBF3F3)),
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
             Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
              child: Text(formattedPosition,
                style: const TextStyle(fontSize: 27,fontWeight: FontWeight.bold,color: AppTheme.greyTextColor),
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
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4,),
                    Text(
                      "$totalLecture . $totalMin min",
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF707070),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
  void showContentBottomSheet(BuildContext context,List<dynamic> lectures) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Course Content',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
                        const Spacer(),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child:
                            const Icon(Icons.clear, color: Color(0xFFAFAFAF))),
                        const SizedBox(width: 15)
                      ],
                    ),
                    const SizedBox(height: 25),
                    Expanded(
                      child: ListView.builder(
                        //itemCount: serviceList.length,
                          itemCount: lectures.length,
                          itemBuilder: (BuildContext context, int pos) {

                            String type=lectures[pos]?['type']?.toString()??"";
                            String title=lectures[pos]?['title']?.toString()??"";
                            String videoCatId=lectures[pos]?['videoCategoryId']?['_id'].toString()??"";
                            String videoCatName=lectures[pos]?['videoCategoryId']?['name'].toString()??"";
                            String videoName=lectures[pos]?['videoId']?['name'].toString()??"";
                            String videoDescription=lectures[pos]?['videoId']?['description'].toString()??"";
                            String videoDuration=lectures[pos]?['videoId']?['duration'].toString()??"";
                            String videocoverImage=lectures[pos]?['videoId']?['coverImage'].toString()??"";
                            String video=lectures[pos]?['videoId']?['video'].toString()??"";
                            String showText="";
                            bool isShowFull=false;
                            String bottomTypeTitle="";
                            if(type=='video'){
                              bottomTypeTitle="$type . $videoDuration mins";
                            }else{
                              bottomTypeTitle=type;
                            }
                            if(isPurchaged && type=='video'){
                              showText="Play";
                              isShowFull=true;
                            }else if(isPurchaged && type!='video'){
                              showText="View";
                              isShowFull=true;
                            }else if(!isPurchaged && type=='video' && (pos==0 || pos==1)){
                              showText="Preview";
                              isShowFull=false;
                            }else{
                              showText="";
                              isShowFull=false;
                            }

                            String fileUrl=lectures[pos]?['documentId']?['file'].toString()??"";
                            String documentUrl="";
                            if(fileUrl.isNotEmpty){
                              documentUrl=AppConstant.appBaseURL+fileUrl;
                            }


                            return GestureDetector(
                              onTap: () {

                                if(isShowFull && type == 'video'){
                                  if(Navigator.canPop(context)){
                                    Navigator.of(context).pop();
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  VimeoFullScreenPlayer(videoId: video),),);
                                }else if (isShowFull && type !='video' && documentUrl.isNotEmpty){
                                  if(Navigator.canPop(context)){
                                    Navigator.of(context).pop();
                                  }
                                  Navigator.push(context, MaterialPageRoute(builder: (_) =>  DocumentViewerPage(url: documentUrl,),),);

                                }else if (isShowFull==false && type=='video' && video.isNotEmpty){
                                  if(Navigator.canPop(context)){
                                    Navigator.of(context).pop();
                                  }
                                  _showVimeoPopup(video);
                                }



                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: AppTheme.courseTileBack,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Color(0xFFDBF3F3)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.05),
                                      blurRadius: 4,
                                      offset: const Offset(2, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 5,),
                                        SizedBox(
                                          height: 16,
                                          width: 12,
                                          child: SvgPicture.asset("assets/ic_course_lec.svg",),
                                        ),
                                        SizedBox(width: 5,),
                                        Expanded(child: Text(
                                          title,
                                          style:  const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.darkBrown
                                          ),

                                        ),),
                                        showText.isNotEmpty?
                                        Text(
                                          showText,
                                          style:  const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: AppTheme.textBlue,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppTheme.textBlue,
                                          ),

                                        ): const Icon(Icons.lock_outline,size: 20,color: AppTheme.textBlue,),
                                        SizedBox(width: 5,),
                                      ],
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      parseHtmlString(videoDescription),
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700
                                      ),
                                    ),
                                    SizedBox(height: 5,),
                                    Text(
                                      bottomTypeTitle,
                                      style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                    ),
                                    SizedBox(height: 5,),

                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          }),
    );
  }



  placeOrder() async {
    APIDialog.showAlertDialog(context, "Placing order...");

    var data= {
      "_id": widget.courseId,
      "user_id": userId,
    };
    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI(
        'course_management/paymentLink', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    if (responseJSON['statusCode'] == 201) {
      Toast.show(responseJSON['data']?['message']?.toString()??"Course Placed",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      String paymentUrl = responseJSON['data']?["paymentUrl"]?.toString()??"";
      String orderId= responseJSON['data']?["orderId"]?.toString()??"NA";
      if(paymentUrl.isNotEmpty && orderId !="NA"){
         Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => WebViewWordDoc(paymentUrl, orderId)));
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