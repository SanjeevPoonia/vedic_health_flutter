import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import 'package:flutter/material.dart';

import '../network/constants.dart';
import '../utils/name_avatar.dart';
import '../widgets/notification_bar_widget.dart';
import '../widgets/readMore.dart';
import 'package:cached_network_image/cached_network_image.dart';

class ReviewallScreen extends StatefulWidget{
  String prductId;
  ReviewallScreen(this.prductId);
  reviewState createState()=>reviewState();

}
class reviewState extends State<ReviewallScreen>{
  String nameStr="";
  String emailIdStr="";
  String userIdStr="";
  ScrollController _scrollController=ScrollController();
  bool isPaginationLoading = false;
  bool hasMoreData = false;
  int totalCount=20;
  int currentPage = 1;
  int perPageSize = 20;
  List<dynamic> reviewsList=[];
  double rating = 3.5;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      //backgroundColor: Colors.red,
      body: Column(
        children: [
          NotificationBarWidget(),
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
                          size: 24, color: Colors.black)),
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text("Reviews",
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


          reviewsList.isEmpty?
          Padding(padding: EdgeInsets.all(10),
            child: Center(
                child: Text("No reviews find!",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),)
            ),
          )
              :
          Expanded(
              child: ListView.builder(
                  itemCount: reviewsList.length,
                  itemBuilder:
                      (BuildContext context, int pos) {
                    List<String> uploadedImageList = [];
                    List<dynamic> imlist= (reviewsList[pos]['additionalImages'] as List?) ?? [];
                    uploadedImageList.addAll(imlist.map((e) =>  e.toString()
                    ));

                    if (pos == reviewsList.length && isPaginationLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    return Padding(padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            NameAvatar(fullName: reviewsList[pos]["userName"]?.toString()??"NA",size: 48,),
                            SizedBox(width: 12),
                            Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        reviewsList[pos]["userName"]?.toString()??"",
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight:
                                          FontWeight.w600,
                                          color: Colors.black
                                              .withOpacity(
                                              0.92),
                                        )),
                                    SizedBox(height: 3),
                                    Text(
                                        "Reviewed on ${reviewsList[pos]["date"]?.toString()??""}",
                                        style: TextStyle(
                                          fontSize: 11,
                                          color:
                                          Color(0xFF898989)
                                              .withOpacity(
                                              0.92),
                                        )),
                                  ],
                                )),
                            SizedBox(width: 5),
                            StarRating(
                              rating: double.parse(reviewsList[pos]["rating"]?.toString()??"0"),
                              allowHalfRating: true,
                              color: Color(0xFFF4AB3E),
                              borderColor:
                              Color(0xFFF4AB3E),
                              onRatingChanged: (rating) =>
                                  setState(() =>
                                  this.rating = rating),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 5),
                          child: reviewsList[pos]["review"].length > 150
                              ? ReadMoreText(
                              text: reviewsList[pos]
                              ["review"],
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.black
                                    .withOpacity(0.92),
                              ))
                              : Text(
                            reviewsList[pos]
                            ["review"],
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.black
                                  .withOpacity(0.92),
                            ),
                          ),
                        ),
                        SizedBox(height: 12,),
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
                        pos == 5
                            ? Container()
                            : SizedBox(height: 35),
                        /* Row(
                                          children: [
                                            Container(
                                              width: 68,
                                              height: 68,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        "assets/banner2.png",
                                                      ))),
                                            ),
                                            SizedBox(width: 12),
                                            Container(
                                              width: 68,
                                              height: 68,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  image: DecorationImage(
                                                      fit: BoxFit.cover,
                                                      image: AssetImage(
                                                        "assets/banner2.png",
                                                      ))),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 35)*/
                      ],
                    ),);
                  }))
        ],
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
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 150 &&
          !isPaginationLoading &&
          hasMoreData) {
        fetchProductsReviews(isLoadMore: true);
      }
    });

    fetchProductsReviews();
  }
  fetchProductsReviews({bool isLoadMore = false}) async {
    if (!isLoadMore) {
      currentPage = 1;
      hasMoreData = true;
      setState(() {});
      APIDialog.showAlertDialog(context, "Please wait...");
    }else{
      setState(() {
        isPaginationLoading=true;
      });
    }
    var data = {"product_id": widget.prductId, "limit": perPageSize, "page": currentPage};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);
    ApiBaseHelper helper = ApiBaseHelper();
    var response =
    await helper.postAPI('product/get-reviews', requestModel, context);

    if(!isLoadMore){
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    }else{
      setState(() {
        isPaginationLoading=false;
      });
    }

    var responseJSON = json.decode(response.toString());
    print("reviews :${response.toString()}");
    List<dynamic> newProducts = (responseJSON["data"] as List?) ?? [];
    //reviewsList = responseJSON["data"];
    totalCount=responseJSON['total']??100;
    setState(() {
      reviewsList.addAll(newProducts);
      if (reviewsList.length < totalCount) {
        hasMoreData = false;
      } else {
        currentPage++;
        hasMoreData = true;
        // ✅ next page
      }
    });


  }

}