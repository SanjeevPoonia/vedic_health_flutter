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

  List<dynamic> similarProducts=[];
  List<dynamic> reviewsList=[];
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
                            Container(
                              width: double.infinity,
                              height: 280,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                        AppConstant.appBaseURL +
                                            productData["coverImage"]
                                                .toString(),
                                      ))),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 11),
                              child: Row(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Image.asset("assets/back_ic.png",
                                          width: 39, height: 39)),

                                  //share_ic

                                  Spacer(),

                                  GestureDetector(
                                      onTap: () {},
                                      child: Image.asset("assets/share_ic.png",
                                          width: 39, height: 39))
                                ],
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
                              Text(productData["brandName"].toString(),
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
/*
                    SizedBox(height: 10),




                    Row(
                      children: [
                        StarRating(
                          rating: 4,
                          allowHalfRating: true,
                          color: Color(0xFFF4AB3E),
                          onRatingChanged: (rating) => setState(() => this.rating = rating),
                        ),

                        SizedBox(width: 5),


                        Text("4.2",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF662A09),
                            )),

                        SizedBox(width: 10),

                        Text("1,200 ratings",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF3872D4),
                            )),


                      ],
                    ),*/

                              SizedBox(height: 19),
                              Text("Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black,
                                  )),
                              SizedBox(height: 7),
                              Text(
                                  productData["product_description"].toString(),
                                  style: TextStyle(
                                    fontSize: 14.5,
                                    color: Color(0xFF696969),
                                  ),
                                  maxLines: 10),
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
                                    child: Text(productData["brandName"]??"",
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
                                    child: Text("Weight",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black,
                                        )),
                                  ),
                                  Expanded(
                                    child: Text(
                                        ((productData["weight"]) / 1000)
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
                                    child: Text("Ingredient",
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
                                height:250,

                                child: ListView.builder(

                                    scrollDirection: Axis.horizontal,
                                    itemCount: similarProducts.length,
                                    itemBuilder: (BuildContext context,int index)

                                {
                                  return Row(
                                    children: [

                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailScreen(similarProducts[index]["_id"].toString(),similarProducts[index]["category"].toString())));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          width:200,
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

                                              SizedBox(height:10),
                                              Container(
                                                height: 135,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          image: DecorationImage(
                                                              image: NetworkImage(
                                                                  AppConstant.appBaseURL+similarProducts[index]["coverImage"]),
                                                              fit: BoxFit.cover)),
                                                    ),

                                                    //  Image.asset("assets/banner4.png"),
                                                  Align(
                                                    alignment: Alignment.topRight,
                                                    child:   Padding(
                                                      padding:
                                                      const EdgeInsets.only(
                                                           right: 4),
                                                      child: Image.asset(
                                                          "assets/arrow_right.png",
                                                          width: 34,
                                                          height: 26),
                                                    ),
                                                  )
                                                  ],
                                                ),
                                              ),

                                              //  SizedBox(height: 8),

                                              Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Text("\$"+similarProducts[index]["discounted_price"].toString(),
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                          color: AppTheme.darkBrown,
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
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(similarProducts[index]["productName"],
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.bold,
                                                      color: AppTheme.darkBrown,
                                                    ),maxLines: 2),
                                              ),

                                              SizedBox(height: 3),

                                              Padding(
                                                padding: const EdgeInsets.all(3.0),
                                                child: Text(similarProducts[index]["brandName"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color(0xFFF38328),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 13)
                                    ],
                                  );
                                }


                                ),
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
                              /*    Spacer(),
                                  GestureDetector(
                                    onTap: () {},
                                    child: Text("See all",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0XFF3E99C4),
                                        )),
                                  ),*/
                                ],
                              ),
                              SizedBox(height: 13),

                              ratingData.isEmpty?Container():
                              Row(
                                children: [
                                  Container(
                                    width: 49,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(40),
                                        color: Color(0xFFF8B84E)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(ratingData["averageRating"].toString(),
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
                                    child: Text(ratingData["totalReviews"].toString()+" reviews",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFBEBEBE),
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(height: 28),

                              reviewsList.length==0?

                                  Center(
                                    child: Text("No reviews found!"),
                                  ):


                              ListView.builder(
                                  itemCount: reviewsList.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (BuildContext context, int pos) {
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
                                                Text(reviewsList[pos]["userName"],
                                                    style: TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black
                                                          .withOpacity(0.92),
                                                    )),
                                                SizedBox(height: 3),
                                                Text("Reviewed on "+reviewsList[pos]["date"],
                                                    style: TextStyle(
                                                      fontSize: 11,
                                                      color: Color(0xFF898989)
                                                          .withOpacity(0.92),
                                                    )),
                                              ],
                                            )),
                                            SizedBox(width: 5),
                                            StarRating(
                                              rating: double.parse(reviewsList[pos]["rating"].toString()),
                                              allowHalfRating: true,
                                              color: Color(0xFFF4AB3E),
                                              borderColor: Color(0xFFF4AB3E),
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
                                          child: Text(
                                              reviewsList[pos]["review"],
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black
                                                    .withOpacity(0.92),
                                              )),
                                        ),

                                        pos==4?Container():
                                        SizedBox(height: 35),
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

    productData = responseJSON["product"];

    setState(() {});
  }


  addProductToCart() async {

    APIDialog.showAlertDialog(context, "Adding to cart...");

    String? userId=await MyUtils.getSharedPreferences("user_id");




    var data = {"productId": widget.productID,"userId":userId.toString(),"quantity":productData["minOrderQuantity"]};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/addCart', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['message'] == "Cart successfully added!") {

      Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

    }
    else
      {
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

    List<String> catList=[];
    catList.add(widget.catID.toString());


    setState(() {
      isLoading = true;
    });
    var data = {
      "page": 1,
      "pageSize": 8,
      "category":catList,
      "brand": [],
      "sortBy": "buy_count",
      "sortOrder": "desc"
    };

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/allProducts', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    similarProducts = responseJSON["productsWithUrls"];

    setState(() {});
  }


  fetchProductsReviews() async {

    setState(() {
      isLoading = true;
    });
    var data = {"product_id":widget.productID,"limit":5,"page":1};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/get-reviews', requestModel, context);

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
    var data = {"product_id":widget.productID};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/getReviewRating', requestModel, context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    ratingData = responseJSON["data"];

    setState(() {});
  }
}
