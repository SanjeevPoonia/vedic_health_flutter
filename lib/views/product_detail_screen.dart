
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating/flutter_rating.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/Utils.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/cart_screen.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/widgets/readMore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'dart:convert' show base64, json, utf8;

import '../network/api_helper.dart';

class ProductDetailScreen extends StatefulWidget {
  final String productID;
  final String catID;

  ProductDetailScreen(this.productID, this.catID);

  ProductState createState() => ProductState();
}

class ProductState extends State<ProductDetailScreen> {
  double rating = 3.5;
  int starCount = 5;
  Map<String, dynamic> productData = {};
  Map<String, dynamic> ratingData = {};
  bool isLoading = false;
  PageController _imagepageController = PageController();
  List<dynamic> imageList = [];
  int _currentPage = 0;
    ApiBaseHelper helper = ApiBaseHelper();

  List<dynamic> similarProducts = [];
  List<dynamic> reviewsList = [];
  void _showShareOptions(BuildContext context,id) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
              title: Text('Share via WhatsApp'),
              onTap: () async {
                final text = "Check this product: "+helper.getFrontEndUrl()+"Shop/product/"+id;
                final whatsappUrl = Uri.parse("whatsapp://send?text=$text");
                if (await canLaunchUrl(whatsappUrl)) {
                  await launchUrl(whatsappUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("WhatsApp not installed")),
                  );
                }
              },
            ),
            ListTile(
              leading: Icon(FontAwesomeIcons.instagram, color: Colors.purple),
              title: Text('Share on Instagram'),
              onTap: () {
                // Instagram doesn't allow direct text sharing
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Instagram sharing not supported directly")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.link, color: Colors.blue),
              title: Text('Copy Link'),
              onTap: () {
                Clipboard.setData(ClipboardData(text: helper.getFrontEndUrl()+"Shop/product/"+id));
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Link copied!")),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.share, color: Colors.black),
              title: Text('More Options'),
              onTap: () {
                Share.share("Check this product: "+ helper.getFrontEndUrl()+ "Shop/product/"+id);
              },
            ),
          ],
        ),
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: isLoading && productData.isEmpty
                  ? Center(
                      child: Loader(),
                    )
                  : ListView(
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: 280,
                              width: double.infinity,
                              child: PageView.builder(
                                controller: _imagepageController,
                                itemCount: imageList.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    AppConstant.appBaseURL + imageList[index],
                                    fit: BoxFit.contain,
                                    width: double.infinity,
                                  );
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 11),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset("assets/back_ic.png",
                                        width: 39, height: 39),
                                  ),
                                  const Spacer(),
                                  GestureDetector(
                                    onTap: () {
                                      _showShareOptions(context,widget.productID);
                                    },
                                    child: Image.asset(
                                      "assets/share_ic.png",
                                      width: 39,
                                      height: 39,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 16,
                              left: 0,
                              right: 0,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  imageList.length,
                                  (index) => Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 4),
                                    width: _currentPage == index ? 12 : 10,
                                    height: _currentPage == index ? 12 : 10,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: _currentPage == index
                                          ? Colors.brown
                                          : Colors.brown.withOpacity(0.3),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Container(
                          transform: Matrix4.translationValues(0, -40, 0),
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40),
                                  topRight: Radius.circular(40))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 32),
                              Text(productData["categoryName"].toString(),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF707070),
                                  )),
                              SizedBox(height: 5),
                              Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                          productData["productName"].toString(),
                                          style: TextStyle(
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ))),
                                  Text(
                                      "\$" +
                                          productData["discounted_price"]
                                              .toString(),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF662A09),
                                      ))
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                children: [
                                  StarRating(
                                    rating: double.parse(
                                        ratingData['averageRating']),
                                    allowHalfRating: true,
                                    color: Color(0xFFF4AB3E),
                                    onRatingChanged: (rating) =>
                                        setState(() => this.rating = rating),
                                  ),
                                  SizedBox(width: 5),
                                  Text(ratingData['averageRating'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF662A09),
                                      )),
                                  SizedBox(width: 10),
                                  Text("${ratingData['totalReviews']} Reviews",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF3872D4),
                                      )),
                                ],
                              ),
                              SizedBox(height: 19),
                              Text("Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 7),
                              ReadMoreText(
                                text: productData["product_description"]
                                    .toString(),
                                maxLines: 4, // or 10 as you want initially
                                style: TextStyle(
                                    fontSize: 14.5, color: Color(0xFF696969)),
                              ),
                              SizedBox(height: 19),
                              Text("About Item",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text("Brand",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(productData["brandName"] ?? "",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 13),
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text("Quantity",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        ((productData["weight"]))
                                                .toStringAsFixed(2) +
                                            " Grams",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 13),
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text("Item Form",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(productData["itemTypeName"],
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 13),
                              Row(
                                children: [
                                  Container(
                                    width: 140,
                                    child: Text("Ingredients",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        productData["ingredients"].length != 0
                                            ? productData["ingredients"][0]
                                                    ["name"]
                                                .toString()
                                            : "NA",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.black,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 28),
                              Text("Similar Products",
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 15),
                              Container(
                                height: 250,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: similarProducts.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProductDetailScreen(
                                                              similarProducts[
                                                                          index]
                                                                      ["_id"]
                                                                  .toString(),
                                                              similarProducts[
                                                                          index]
                                                                      [
                                                                      "category"]
                                                                  .toString())));
                                            },
                                            child: Container(
                                              padding: EdgeInsets.all(5),
                                              width: 200,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.white,
                                                  border: Border.all(
                                                      color: Color(0xFFE2D7D7),
                                                      width: 1)),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  Container(
                                                    height: 135,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(AppConstant
                                                                          .appBaseURL +
                                                                      similarProducts[
                                                                              index]
                                                                          [
                                                                          "coverImage"]),
                                                                  fit: BoxFit
                                                                      .contain)),
                                                        ),

                                                        //  Image.asset("assets/banner4.png"),
                                                        Align(
                                                          alignment: Alignment
                                                              .topRight,
                                                          child: GestureDetector(
                                                            onTap: (){_showShareOptions(context,similarProducts[
                                                                          index]
                                                                      ["_id"]
                                                                  .toString());},
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      right: 4),
                                                              child: Image.asset(
                                                                  "assets/arrow_right.png",
                                                                  width: 34,
                                                                  height: 26),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),

                                                  //  SizedBox(height: 8),

                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 5),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            "\$" +
                                                                similarProducts[
                                                                            index]
                                                                        [
                                                                        "discounted_price"]
                                                                    .toString(),
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: AppTheme
                                                                  .darkBrown,
                                                            )),
                                                        /*      Spacer(),
                                                Image.asset(
                                                    "assets/star_ic.png",
                                                    width: 13,
                                                    height: 12),
                                                SizedBox(width: 3),
                                                Text("4.5",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Colors.black,
                                                    )),*/
                                                      ],
                                                    ),
                                                  ),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                        similarProducts[index]
                                                            ["productName"],
                                                        style: TextStyle(
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppTheme
                                                              .darkBrown,
                                                        ),
                                                        maxLines: 2),
                                                  ),

                                                  SizedBox(height: 3),

                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            3.0),
                                                    child: Text(
                                                        similarProducts[index]
                                                            ["brandName"],
                                                        style: TextStyle(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color:
                                                              Color(0xFFF38328),
                                                        )),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 13)
                                        ],
                                      );
                                    }),
                              ),
                              SizedBox(height: 28),
                              Row(
                                children: [
                                  Text("Rating & Reviews",
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                              SizedBox(height: 13),
                              ratingData.isEmpty
                                  ? Container()
                                  : Row(
                                      children: [
                                        Container(
                                          width: 49,
                                          height: 25,
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(40),
                                              color: Color(0xFFF8B84E)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  ratingData["averageRating"]
                                                      .toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.white,
                                                  )),
                                              SizedBox(width: 2),
                                              Icon(
                                                Icons.star,
                                                color: Colors.white,
                                                size: 12,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: Text(
                                              ratingData["totalReviews"]
                                                      .toString() +
                                                  " reviews",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color: Color(0xFFBEBEBE),
                                              )),
                                        )
                                      ],
                                    ),
                              SizedBox(height: 28),
                              reviewsList.length == 0
                                  ? Center(
                                      child: Text("No reviews found!"),
                                    )
                                  : ListView.builder(
                                      itemCount: reviewsList.length,
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemBuilder:
                                          (BuildContext context, int pos) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                CircleAvatar(
                                                  radius: 24,
                                                  backgroundImage: AssetImage(
                                                      "assets/user_d2.png"),
                                                ),
                                                SizedBox(width: 12),
                                                Expanded(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        reviewsList[pos]
                                                            ["userName"],
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
                                                        "Reviewed on " +
                                                            reviewsList[pos]
                                                                ["date"],
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
                                                  rating: double.parse(
                                                      reviewsList[pos]["rating"]
                                                          .toString()),
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
                                              child: reviewsList[pos]["review"]
                                                          .length >
                                                      150
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
                                            pos == 4
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
                                        );
                                      })
                            ],
                          ),
                        ),
                      ],
                    )),
          Container(
            height: 88,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 1),
                  blurRadius: 6,
                  color: Color(0xFFD6D6D6),
                ),
              ],
            ),
            padding: EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              children: [
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        addProductToCart();
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: AppTheme.darkBrown),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Image.asset("assets/cart_ic.png",
                                width: 24, height: 24),
                            SizedBox(width: 7),
                            Text("Add To Cart",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                    flex: 1),
                SizedBox(width: 15),
                Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartScreen()));
                      },
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFFB65303)),
                        child: Row(
                          children: [
                            SizedBox(width: 15),
                            Image.asset("assets/buy_ic.png",
                                width: 24, height: 24),
                            SizedBox(width: 7),
                            Text("Buy Now",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ),
                    flex: 1),
              ],
            ),
          )
        ],
      ),
    );
  }

  fetchProductDetails() async {
    setState(() {
      isLoading = true;
    });
    var data = {"id": widget.productID};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/view', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['statusCode'] == 200 ||
        responseJSON['statusCode'] == 201) {
      productData = responseJSON["product"];
      var img = [];

      img.add(productData['coverImage']);
      img.addAll(productData['additionalImages']);
      setState(() {
        imageList = img;
      });
    }
  }

  addProductToCart() async {
    APIDialog.showAlertDialog(context, "Adding to cart...");

    String? userId = await MyUtils.getSharedPreferences("user_id");

    var data = {
      "productId": widget.productID,
      "userId": userId.toString(),
      "quantity": productData["minOrderQuantity"]
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('cart_management/addCart', requestModel, context);

    Navigator.pop(context);

    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['message'] == "Cart successfully added!") {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);
    } else {
      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.red);
    }

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchProductDetails();
    fetchSimilarProducts();
    fetchProductsReviews();
    fetchProductsRatings();
  }

  fetchSimilarProducts() async {
    List<String> catList = [];
    catList.add(widget.catID.toString());

    setState(() {
      isLoading = true;
    });
    var data = {
      "page": 1,
      "pageSize": 8,
      "category": catList,
      "brand": [],
      "sortBy": "buy_count",
      "sortOrder": "desc"
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('product/allProducts', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
  

    similarProducts = responseJSON["productsWithUrls"].where((element)=>element["_id"]!=widget.productID).toList();
    

    setState(() {});
  }

  fetchProductsReviews() async {
    setState(() {
      isLoading = true;
    });
    var data = {"product_id": widget.productID, "limit": 5, "page": 1};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('product/get-reviews', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    reviewsList = responseJSON["data"];

    setState(() {});
  }

  fetchProductsRatings() async {
    setState(() {
      isLoading = true;
    });
    var data = {"product_id": widget.productID};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response =
        await helper.postAPI('product/getReviewRating', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    setState(() {
      ratingData = responseJSON["data"];
      print(ratingData);
      print("ratingdata");
    });
  }
}
