import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';


class MyReviewScreen extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyReviewScreen> {

  bool isLoading=false;
  List<dynamic> reviewList = [];
  String nameStr="";
  String emailIdStr="";
  String userIdStr="";

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        //backgroundColor: Colors.red,
        body: Column(
          children: [
            Card(
              elevation: 2,
              margin: EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(20), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(20), // Adjust the radius as needed
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new_sharp,
                            size: 17, color: Colors.black)),
                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("My Reviews",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            isLoading? Center(child: Loader(),):
            reviewList.isEmpty?
                Padding(padding: EdgeInsets.all(10),
                  child: Center(
                      child: Text("Looks like you haven’t added a review yet. Write one to share your experience!",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),)
                  ),
                )
                :
                Expanded(
                child: ListView.builder(
                    itemCount: reviewList.length,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    itemBuilder: (BuildContext context, int pos) {

                      String date=reviewList[pos]['date']?.toString()??"";
                      String reviewDate=formatDate(date);

                      double rating = (reviewList[pos]['rating'] is int)
                          ? (reviewList[pos]['rating'] as int).toDouble()
                          : double.tryParse(reviewList[pos]['rating'].toString()) ?? 0.0;

                      String reviewtext=reviewList[pos]['review']?.toString()??"";
                      List<String> uploadedImageList = [];
                      List<dynamic> imlist= (reviewList[pos]['additionalImages'] as List?) ?? [];
                      uploadedImageList.addAll(imlist.map((e) =>  e.toString()
                      ));

                      return Column(
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundImage:
                                          AssetImage("assets/user_d2.png"),
                                    ),
                                    SizedBox(width: 12),
                                    Expanded(
                                        child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(nameStr,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black
                                                  .withOpacity(0.92),
                                            )),
                                        SizedBox(height: 3),
                                        Text(
                                            reviewDate,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFF898989)
                                                  .withOpacity(0.92),
                                            )),
                                      ],
                                    )),
                                    SizedBox(width: 5),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Row(
                                  children: [
                                    StarRating(
                                      rating: rating,
                                      allowHalfRating: true,
                                      color: Color(0xFFF4AB3E),
                                      borderColor: Color(0xFFF4AB3E),
                                      onRatingChanged: (rating) => null,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12),
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 5),
                                  child: Text(
                                      reviewtext,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black.withOpacity(0.92),
                                      )),
                                ),
                                SizedBox(height: 22),
                                uploadedImageList.isNotEmpty?
                                GridView.builder(
                                  shrinkWrap: true, // important
                                  physics: const NeverScrollableScrollPhysics(), // ListView scroll handle karega
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 columns
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 1, // square look
                                  ),
                                  itemCount: uploadedImageList.length,
                                  itemBuilder: (context, index) {
                                    final url = AppConstant.appBaseURL+uploadedImageList[index];
                                    return ClipRRect(
                                      borderRadius: BorderRadius.circular(16), // rounded corners
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: Colors.grey[200],
                                          child: const Center(
                                            child: CircularProgressIndicator(strokeWidth: 2),
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                        const Icon(Icons.error, color: Colors.red),
                                      ),
                                    );
                                  },
                                ):Container(),
                                SizedBox(height: 22)
                              ]),
                          SizedBox(height: 12)
                        ],
                      );
                    }))
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  _fetchUserDetails()async{
    String? userId = await MyUtils.getSharedPreferences("user_id");
    String? name = await MyUtils.getSharedPreferences("name");
    String? email = await MyUtils.getSharedPreferences("email");

    userIdStr=userId??"";
    nameStr=name??"NA";
    emailIdStr=email??"";

    fetchMyReviews();
  }
  fetchMyReviews() async {
    setState(() {
      isLoading = true;
    });



    // Create the data object with the userId
    var data = {"user_id": userIdStr};

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('product/get-reviews', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    reviewList = responseJSON["data"];

    setState(() {});
  }
  String formatDate(String dateStr) {
    try {
      // Input format -> 28/03/2025, 17:48:02
      final inputFormat = DateFormat("dd/MM/yyyy, HH:mm:ss");
      final dateTime = inputFormat.parse(dateStr);

      // Output format -> dd MMM, yyyy hh:mm a
      final outputFormat = DateFormat("dd MMM, yyyy hh:mm a");
      return outputFormat.format(dateTime);
    } catch (e) {
      return dateStr; // अगर parsing fail हो जाए तो original string return
    }
  }
}
