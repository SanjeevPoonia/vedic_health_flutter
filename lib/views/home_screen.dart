import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/network/Utils.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/menu_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import 'package:vedic_health/views/search_product_screen.dart';

import '../network/api_helper.dart';
import '../widgets/drawer/zoom_scaffold.dart' as MEN;
import 'appointments/book_classes/select_class_screen.dart';
import 'category_wise_products.dart';


class HomeScreen extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen> with TickerProviderStateMixin {
  bool isLoading = false;
  bool isPopularLoading=false;
  List<dynamic> categoryList = [];
  MEN.MenuController? menuController;
  List<dynamic> productList = [];
  List<dynamic> popularProductList = [];
  String? name;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  final ApiBaseHelper helper = ApiBaseHelper();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkBrown,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => menuController,
          child: MEN.ZoomScaffold(
            menuScreen: MenuScreen(),
            orangeTheme: false,
            pageTitle: "Home",
            showBoxes: false,
            contentScreen: MEN.Layout(
                contentBuilder: (cc) => Expanded(
                    child: isLoading
                        ? Container(
                            color: Colors.white,
                            child: Center(
                              child: Loader(),
                            ),
                          )
                        : Container(
                            color: Colors.white,
                            child: ListView(
                              padding: EdgeInsets.zero,
                              children: [
                                Container(
                                    height: 1,
                                    color: Colors.grey.withOpacity(0.3),
                                    width: double.infinity),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            name == null
                                                ? Container()
                                                : Text(
                                                    "Hello, $name",
                                                    style: const TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors.black,
                                                    )),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: 71, height: 71, child: Lottie.asset("assets/lotus_pose.json"),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => SearchPage(categoryList)));
                                  },
                                  child: Container(
                                    height: 52,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    child: TextField(
                                      enabled: false,
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(77.0),
                                              borderSide: BorderSide.none),
                                          filled: true,
                                          hintStyle: TextStyle(
                                              color: Color(0xFF707070)
                                                  .withOpacity(0.5),
                                              fontSize: 14),
                                          hintText: "Search Products",
                                          fillColor: Color(0xFFEFEEF1),
                                          prefixIcon: const Icon(Icons.search,
                                              color: Color(0xFF707070))),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 22),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Image.asset("assets/banner1.png"),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 26),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(height: 10),
                                          const Text("The Combination of\nNature and Science",
                                              style: TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white,
                                              )),
                                          const SizedBox(height: 9),
                                          Container(
                                            width: 108,
                                            height: 37,
                                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(77), color: Colors.white),
                                            child: const Center(
                                              child: Text("Shop Now", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: AppTheme.greenColor,)),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(height: 22),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      const Text("CATEGORIES",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          )),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () {
                                          allCategoryBottomSheet(context);
                                        },
                                        child: const Text("See all",
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0XFF3E99C4),
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12),
                                  child: Container(
                                      height: 90,
                                      child: ListView.builder(
                                          itemCount: categoryList.length,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder:
                                              (BuildContext context, int pos) {
                                            String categoryName=categoryList[pos]["cat_name"]?.toString()??"";
                                            String categoryId=categoryList[pos]["cat_id"]?.toString()??"";
                                            return Row(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryWiseProducts(categoryName,categoryId)));
                                                  },
                                                  child: SizedBox(
                                                    height: 84,
                                                    width: 95,
                                                    child: Stack(
                                                      children: [
                                                        Image.asset(
                                                            "assets/grid1.png"),
                                                        Center(
                                                          child: Text(
                                                              categoryName,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 11),
                                              ],
                                            );
                                          })),
                                ),
                                SizedBox(height: 26),
                                SizedBox(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          10, // Horizontal spacing
                                      mainAxisSpacing: 10, // Vertical spacing
                                      childAspectRatio:
                                          1.1 / 1.6, // Width to height ratio
                                    ),
                                    itemCount: productList.length > 4
                                        ? 4
                                        : productList.length,
                                    // Total number of classes
                                    itemBuilder: (context, index) {
                                      String productId=productList[index]["_id"]?.toString()??"";
                                      String categoryId=productList[index]["category_id"]?.toString()??"";
                                      String coverImage=productList[index]["coverImage"]?.toString()??"";
                                      String price=productList[index]["price"]?.toString()??"";
                                      String mrp=productList[index]['mrp']?.toString()??"";
                                      String productName=productList[index]["productName"]?.toString()??"";
                                      String brandName=productList[index]["brand"]?.toString()??"";
                                      String discountedPrice=productList[index]["discounted_price"]?.toString()??"";
                                      String productImage="";
                                      String productprice="";
                                      if(discountedPrice.isNotEmpty){
                                        productprice=discountedPrice;
                                      }else {
                                        productprice=price;
                                      }
                                      if(coverImage.isNotEmpty){
                                        productImage=AppConstant.appBaseURL+coverImage;
                                      }



                                      print("product price $productprice");
                                      print("price $price");
                                      print("discounted $discountedPrice");
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProductDetailScreen(productId,categoryId)));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
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
                                              Container(
                                                height: 135,
                                                child: Stack(
                                                  children: [
                                                    Center(child: Image.network(productImage)),
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _showShareOptions(context, productId);
                                                          },
                                                          child: Padding(padding: const EdgeInsets.only(top: 4, right: 4),
                                                            child: Image.asset(
                                                                "assets/arrow_right.png",
                                                                width: 34,
                                                                height: 26),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //  SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        "\$$productprice",
                                                        style: const TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppTheme
                                                              .darkBrown,
                                                        )),
                                                  ],
                                                ),
                                              ),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                    productName,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme.darkBrown,
                                                    ),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),

                                              SizedBox(height: 3),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(
                                                    brandName,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFF38328),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 32),
                                Container(
                                  height: 166,
                                  margin: EdgeInsets.symmetric(horizontal: 11),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      color: Color(0xFFC1E9EF)),
                                  child: Stack(
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 25),
                                                Text(
                                                    "connect with your inner balance",
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFF662A09),
                                                    )),
                                                SizedBox(height: 10),
                                                Text(
                                                    "Book Your Ayurvedic\nConsultation",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                    )),
                                                SizedBox(height: 10),
                                                InkWell(
                                                  onTap: (){
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                          const SelectClassScreen(),
                                                        ));
                                                  },
                                                  child:Container(
                                                    width: 108,
                                                    height: 37,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            77),
                                                        color: Colors.white),
                                                    child: Center(
                                                      child: Text("Book Now",
                                                          style: TextStyle(
                                                            fontSize: 12,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color: Colors.black,
                                                          )),
                                                    ),
                                                  ) ,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      //consultant_dummy

                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            width: 130,
                                            margin: EdgeInsets.only(
                                                right: 3, top: 35),
                                            height: 120,
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                border: Border.all(
                                                    color: Colors.white,
                                                    width: 15)),
                                          ),
                                        ],
                                      ),

                                      Row(
                                        children: [
                                          Spacer(),
                                          Container(
                                            transform:
                                                Matrix4.translationValues(
                                                    0, -12, 0),
                                            padding: EdgeInsets.only(
                                                top: 47, right: 22),
                                            child: Image.asset(
                                                "assets/consultant_dummy.png",
                                                width: 90,
                                                height: 130),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(height: 28),
                                InkWell(
                                  onTap: (){
                                    launchPhoneCall();
                                  },
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12),
                                        child: Image.asset("assets/banner_3.png"),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 26),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            SizedBox(height: 10),
                                            Text("Want it today?",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                )),
                                            SizedBox(height: 5),
                                            Text(
                                                "Visit the Shop at our center, or call us at 240-753-0151 .",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.white,
                                                ),
                                                textAlign: TextAlign.center),
                                          ],
                                        ),
                                      )
                                    ],
                                  ) ,
                                ),
                                SizedBox(height: 20),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text("POPULAR ITEMS",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black,
                                          )),
                                      Spacer(),
                                      /*Text("See all",
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0XFF3E99C4),
                                          )),*/
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),
                                isPopularLoading?Container(
                                  color: Colors.white,
                                  child: Center(
                                    child: Loader(),
                                  ),
                                ):

                                SizedBox(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // Number of columns
                                      crossAxisSpacing:
                                          10, // Horizontal spacing
                                      mainAxisSpacing: 10, // Vertical spacing
                                      childAspectRatio:
                                          1.1 / 1.6, // Width to height ratio
                                    ),
                                    itemCount: popularProductList.length > 4
                                        ? 4
                                        : popularProductList.length,
                                    // Total number of classes
                                    itemBuilder: (context, index) {
                                      String productId=popularProductList[index]["_id"]?.toString()??"";
                                      String categoryId=popularProductList[index]["category"]?.toString()??"";
                                      String coverImage=popularProductList[index]["coverImage"]?.toString()??"";
                                      String price=popularProductList[index]["price"]?.toString()??"";
                                      String mrp=popularProductList[index]['mrp']?.toString()??"";
                                      String productName=popularProductList[index]["productName"]?.toString()??"";
                                      String brandName=popularProductList[index]["brandName"]?.toString()??"";
                                      String discountedPrice=popularProductList[index]["discounted_price"]?.toString()??"";
                                      String productImage="";
                                      String productprice="";
                                      if(discountedPrice.isNotEmpty){
                                        productprice=discountedPrice;
                                      }else {
                                        productprice=price;
                                      }
                                      if(coverImage.isNotEmpty){
                                        productImage=AppConstant.appBaseURL+coverImage;
                                      }



                                      print("product price $productprice");
                                      print("price $price");
                                      print("discounted $discountedPrice");

                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => ProductDetailScreen(productId,categoryId)));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(5),
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
                                              Container(
                                                height: 135,
                                                child: Stack(
                                                  children: [
                                                    Center(child: Image.network(productImage)),
                                                    Row(
                                                      children: [
                                                        Spacer(),
                                                        GestureDetector(
                                                          onTap: () {
                                                            _showShareOptions(context, productId);
                                                          },
                                                          child: Padding(padding: const EdgeInsets.only(top: 4, right: 4),
                                                            child: Image.asset(
                                                                "assets/arrow_right.png",
                                                                width: 34,
                                                                height: 26),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              //  SizedBox(height: 8),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5),
                                                child: Row(
                                                  children: [
                                                    Text("\$$productprice",
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: AppTheme
                                                              .darkBrown,
                                                        )),
                                                  /*  Spacer(),
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

                                              SizedBox(height: 7),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(productName,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: AppTheme.darkBrown,
                                                    ),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 2,
                                                ),
                                              ),

                                              SizedBox(height: 3),

                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(3.0),
                                                child: Text(brandName,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color: Color(0xFFF38328),
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(height: 22),
                              ],
                            ),
                          ))),
          ),
        ),
      ),
    );
  }

  void allCategoryBottomSheet(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      context: context,
      builder: (bottomSheetContext) => StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text(
                              'Categories',
                              style: TextStyle(
                                fontSize: 19,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(bottomSheetContext);
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Color(0xFFAFAFAF),
                            ),
                          ),
                          const SizedBox(width: 15),
                        ],
                      ),
                      const SizedBox(height: 25),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 35,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1 / 1,
                          ),
                          itemCount: categoryList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {

                                Navigator.pop(bottomSheetContext);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CategoryWiseProducts(
                                      categoryList[index]["cat_name"],
                                      categoryList[index]["cat_id"].toString(),
                                    ),
                                  ),
                                );
                              },
                              child: SizedBox(
                                height: 84,
                                width: 95,
                                child: Stack(
                                  children: [
                                    Image.asset("assets/grid1.png"),
                                    Center(
                                      child: Text(
                                        categoryList[index]["cat_name"].toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  fetchCategories() async {
    setState(() {
      isLoading = true;
    });

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPI('product/by-categories', context);

    setState(() {
      isLoading = false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());

    List<String> categoryIDs = responseJSON["data"].keys.toList();
    print("***");
    print(categoryIDs.toString());

    for (int i = 0; i < categoryIDs.length; i++) {
      categoryList.add({
        "cat_id": categoryIDs[i].toString(),
        "cat_name": responseJSON["data"][categoryIDs[i].toString()]
                ["categoryName"]
            .toString(),
      });
    }

    if (categoryIDs.isNotEmpty) {
      productList = responseJSON["data"][categoryIDs[0].toString()]["products"];
    }

    print(categoryList.toString());
    print("%%%%%");
    print(productList.toString());

    setState(() {});
  }
  void _showShareOptions(BuildContext context, id) {
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
                  final text = "Check this product: " +
                      helper.getFrontEndUrl() +
                      "Shop/product/" +
                      id;
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
                    SnackBar(
                        content:
                            Text("Instagram sharing not supported directly")),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.link, color: Colors.blue),
                title: Text('Copy Link'),
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: helper.getFrontEndUrl() + "Shop/product/" + id));
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
                  Share.share("Check this product: " +
                      helper.getFrontEndUrl() +
                      "Shop/product/" +
                      id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    menuController = MEN.MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
    fetchCategories();
    fetchUserName();
    fetchProducts();
  }
  fetchUserName() async {
    name = await MyUtils.getSharedPreferences("name");

    setState(() {});
  }
  Future<void> fetchProducts() async {
    setState(() {
      isPopularLoading = true;
    });
    var data = {
      "title": "",
      "page":1,
      "pageSize":10,
      "category":[],
      "subcategory":[],
      "brand":[],
      "sortBy":"buy_count",
      "sortOrder":"desc"
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/allProducts', requestModel, context);
    var responseJSON = json.decode(response.toString());
    popularProductList = (responseJSON["productsWithUrls"] as List?)??[];
    setState(() {
      isPopularLoading = false;
    });

  }

  Future<void> launchPhoneCall() async {

    final Uri callUri = Uri.parse('tel:2407530151');


    try {
      if (await canLaunchUrl(callUri)) {
        await launchUrl(
          callUri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        print('Could not launch phone dialer');
      }
    } catch (e) {
      print('Error launching call: $e');
    }
  }
}
