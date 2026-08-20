import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/membership/join_membership_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import 'package:intl/intl.dart';
import '../yoga_classes/yoga_fullscreen_video.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MembershipVideosScreen extends StatefulWidget{
  List<dynamic> videoList;
  MembershipVideosScreen(this.videoList);
  _membershipState createState()=> _membershipState();
}
class _membershipState extends State<MembershipVideosScreen>{
  List<dynamic> subscribedVideos=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(child:
        Column(
          children: [
            // App Bar
            _buildAppBar(),
            const SizedBox(height: 20,),
            _allSubscribedVideos(),
          ],
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
    subscribedVideos=widget.videoList;
    setState(() {

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
            ],
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.8, // Adjust to fit the content well
            ),
            itemCount: subscribedVideos.length,
            itemBuilder: (context, index) {
              return _buildGridVideoCard(subscribedVideos[index]);
            },
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
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



}