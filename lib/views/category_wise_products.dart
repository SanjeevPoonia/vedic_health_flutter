import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/cart_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/notification_bar_widget.dart';

class CategoryWiseProducts extends StatefulWidget {
  final String catName;
  final String catID;
  CategoryWiseProducts(this.catName, this.catID);

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CategoryWiseProducts> {
    int selectedIndex = 0;
    int selectedSortIndex = 0;
    final List<String> tabs = ["Category", "Brand"];
    bool isLoading = false;
    List<dynamic> categoryListDynamic = [];
    List<dynamic> productList = [];

    // Map category -> products for filtering/switching
    final Map<String, List<dynamic>> categoryIdToProducts = {};

    // Active filter selections
    final Set<String> selectedCategoryIds = {};
    final Set<String> selectedBrands = {};

    List<bool> categoryCheckList = [];
    List<bool> brandCheckList = [];

    // Dynamic lists shown in filter modal
    List<String> categoryList = [];
    List<String> brandList = [];
    List<String> sortList = [
      "Most Popular",
      "High to Low",
      "Low to High",
      "Highly Rated"
    ];


    // Pagination data



    ScrollController _scrollController=ScrollController();
    String initialCatName="";
    String initialCatId="";
    final ApiBaseHelper helper2 = ApiBaseHelper();
    int totalCount=20;
    int currentPage = 1;
    int perPageSize = 20;
    bool isPaginationLoading = false;
    bool hasMoreData = true;
    String? userName;
    String? userId;


    @override
    Widget build(BuildContext context) {
      return  Scaffold(
          backgroundColor: Colors.white,
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back_ios_new_sharp,
                              size: 24, color: Colors.black)),
                      Text("Categories",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          )),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CartScreen()));
                          },
                          child: Image.asset("assets/cart_bag.png",
                              width: 39, height: 39))
                    ],
                  ),
                ),
              ),
              isLoading ? Container(height: 200, child: Loader()) : Container(),
              isLoading ? Container() : SizedBox(height: 14),
              isLoading
                  ? Container()
                  : Container(
                      height: 89,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.zero,
                          itemCount: categoryListDynamic.length,
                          itemBuilder: (BuildContext context, int pos) {
                            final String catId = categoryListDynamic[pos]["cat_id"].toString();
                            String catImage=categoryListDynamic[pos]['image']?.toString()??"";
                            final bool isSelected = selectedCategoryIds.contains(catId);
                            return Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    selectedCategoryIds
                                      ..clear()
                                      ..add(catId);
                                    _applyFiltersAndSort();

                                    categoryCheckList = categoryCheckList.map((e) => false).toList();
                                    categoryCheckList[pos]=true;

                                  },
                                  child: Container(
                                    height: 84,
                                    width: 95,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color:  Colors.transparent,
                                        width: isSelected ? 3 : 0,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Stack(
                                      children: [
                                        catImage.isNotEmpty?
                                        CachedNetworkImage(
                                          height: 84,
                                          width: 95,
                                          imageUrl: catImage,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => Container(
                                            color: Colors.grey[200],
                                            child: const Center(
                                              child: CircularProgressIndicator(strokeWidth: 2),
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                          const Icon(Icons.error, color: Colors.red),
                                        ):
                                        Image.asset(
                                          "assets/grid1.png",
                                          height: 84,
                                          width: 95,
                                          fit: BoxFit.cover,
                                        ),
                                        Container(
                                          height: 84,
                                          width: 95,
                                          color: Colors.black.withOpacity(0.6),   // 40% black overlay
                                        ),
                                        Center(
                                          child: Text(
                                              categoryListDynamic[pos]
                                                  ["cat_name"],
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        isSelected?
                                        const Positioned(
                                            top: 0,
                                            right: 0,
                                            child: Icon(Icons.check_circle,size: 22,color: Colors.orange,)):Container(),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 11)
                              ],
                            );
                          })),
              isLoading ? Container() : SizedBox(height: 12),
              isLoading
                  ? Container()
                  : productList.isEmpty?Expanded(child: Center(child: Text("No products are available",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w600,color: Colors.grey),),)):Expanded(
                      child: GridView.builder(
                        controller: _scrollController,
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 10, // Horizontal spacing
                          mainAxisSpacing: 10, // Vertical spacing
                          childAspectRatio: 1.1 / 1.6, // Width to height ratio
                        ),
                        itemCount: productList.length,
                        // Total number of classes
                        itemBuilder: (context, index) {

                          String productId=productList[index]["_id"]?.toString()??"";
                          String categoryId=productList[index]["category_id"]?.toString()??"";
                          if(categoryId.isEmpty){
                            categoryId=productList[index]['category']?.toString()??"";
                          }
                          String coverImage=productList[index]["coverImage"]?.toString()??"";
                          String price=productList[index]["price"]?.toString()??"";
                          String mrp=productList[index]['mrp']?.toString()??"";
                          String productName=productList[index]["productName"]?.toString()??"";
                          String brandName=productList[index]["brand"]?.toString()??"";
                          String discountedPrice=productList[index]["discounted_price"]?.toString()??"";
                          String productImage="";
                          String productprice="";
                         /* if(discountedPrice.isNotEmpty){
                            productprice=discountedPrice;
                          }else {
                            productprice=price;
                          }*/
                          productprice=price;
                          if(coverImage.isNotEmpty){
                            productImage=AppConstant.appBaseURL+coverImage;
                          }
                          if(coverImage.isNotEmpty){
                            productImage=AppConstant.appBaseURL+coverImage;
                          }
                          print("product price $productprice");
                          print("price $price");
                          print("discounted $discountedPrice");

                          if (index == productList.length && initialCatId.isEmpty) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ProductDetailScreen(productId, categoryId)));
                            },
                            child: Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  border: Border.all(
                                      color: Color(0xFFE2D7D7), width: 1)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 135,
                                    child: Stack(
                                      children: [
                                        Center(
                                            child: Image.network(productImage)),
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
                                        const EdgeInsets.symmetric(horizontal: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                            "\$$productprice",
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.darkBrown,
                                            )),

                                        /*   Spacer(),

                                  Image.asset("assets/star_ic.png",width: 13,height: 12),

                                  SizedBox(width: 3),


                                  Text("4.5",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                      )),*/
                                      ],
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                        productName,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.darkBrown,
                                        ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,

                                    ),
                                  ),

                                  SizedBox(height: 3),

                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                        brandName,
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFF38328),
                                        ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              isLoading
                  ? Container()
                  : Container(
                      height: 75,
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
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _modalBottomSortFilterMenu(context);
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      SizedBox(width: 15),
                                      Image.asset("assets/sort_ic.png",
                                          width: 17, height: 15),
                                      SizedBox(width: 5),
                                      Text("SORT",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFF38328),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                              flex: 1),
                          Container(
                            height: 20,
                            width: 1,
                            color: Color(0xFF707070),
                          ),
                          Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  _modalBottomSheetFilterMenu(context);
                                },
                                child: Container(
                                  child: Row(
                                    children: [
                                      Spacer(),
                                      Image.asset("assets/filter_ic.png",
                                          width: 17, height: 15),
                                      SizedBox(width: 5),
                                      Text("FILTER",
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFFF38328),
                                          )),
                                      SizedBox(width: 25),
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

    void allCategoryBottomSheet(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 150,
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Categories',
                                style: TextStyle(
                                    fontSize: 19,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          const Spacer(),
                          GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.clear,
                                color: Color(0xFFAFAFAF),
                              )),
                          const SizedBox(width: 15)
                        ],
                      ),
                      SizedBox(height: 25),
                      Expanded(
                        child: GridView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, // Number of columns
                                  crossAxisSpacing: 35, // Horizontal spacing
                                  mainAxisSpacing: 14, // Vertical spacing
                                  childAspectRatio: 1 / 1 // Width to height ratio
                                  ),
                          itemCount: 8, // Total number of classes
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                /*      if(docList[index]["mime_type"].toString().startsWith('image/'))
                                    {
                                      Navigator.push(context,MaterialPageRoute(builder: (context)=>ImageView(AppConstant.filesBaseURL+docList[index]["attachment_file"])));

                                    }*/
                              },
                              child: SizedBox(
                                height: 84,
                                width: 95,
                                child: Stack(
                                  children: [
                                    Image.asset("assets/grid1.png"),
                                    Center(
                                      child: Text("Ayurvedic Herbals",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
      );
    }

    void _modalBottomSheetFilterMenu(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Filter',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          color: Color(0xFFAFAFAF),
                        )),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 22),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(tabs.length, (index) {
                          bool isSelected = index == selectedIndex;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedIndex = index;
                              });
                              setModalState(() {});
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 45,
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      left: 10, top: 5, bottom: 5, right: 10),
                                  padding: EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFFF38328)
                                        : Color(0xFFDEE3E6),
                                    borderRadius: BorderRadius.circular(
                                        8), // Set the radius for all corners
                                  ),
                                  child: Text(
                                    tabs[index],
                                    style: TextStyle(
                                      color: isSelected
                                          ? Color(0xFFFFFFFF)
                                          : Colors.black,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),

                                SizedBox(height: 5)
                                // Spacer will now allocate remaining space
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Container(
                          color:
                              Colors.white, // Background color for right section
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  selectedIndex == 0
                                      ? 'Select Category'
                                      : 'Select Brand',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              SizedBox(height: 5),
                              ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: (selectedIndex == 0 ? categoryList : brandList).length,
                                  itemBuilder: (BuildContext context, int pos) {
                                    final bool isCategoryTab = selectedIndex == 0;
                                    final String label = isCategoryTab
                                        ? categoryList[pos]
                                        : brandList[pos];
                                    final bool isChecked = isCategoryTab
                                        ? categoryCheckList[pos]
                                        : brandCheckList[pos];
                                    return Container(
                                      padding: EdgeInsets.symmetric(vertical: 10),
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              if (isCategoryTab) {
                                                categoryCheckList[pos] =
                                                    !categoryCheckList[pos];
                                              } else {
                                                brandCheckList[pos] =
                                                    !brandCheckList[pos];
                                              }
                                              setModalState(() {});
                                            },
                                            child: isChecked
                                                ? Icon(Icons.check_box,
                                                    color: Color(0xFF079848))
                                                : Icon(
                                                    Icons
                                                        .check_box_outline_blank_outlined,
                                                    color: Color(0xFF9D9CA0)),
                                          ),
                                          SizedBox(width: 7),
                                          Expanded(
                                            child: Text(label,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    fontFamily: "Montserrat",
                                                    color: Color(0xFF9D9CA0))),
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                            ],
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          for (int i = 0; i < categoryCheckList.length; i++) {
                            categoryCheckList[i] = false;
                          }
                          for (int i = 0; i < brandCheckList.length; i++) {
                            brandCheckList[i] = false;
                          }
                          setModalState(() {});
                        },
                        child: Container(
                          height: 55,
                          margin: EdgeInsets.only(left: 16),
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xFFE3E3E3)),
                          child: Center(
                            child: Text(
                              "Reset All",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        onTap: () {
                          _applyFilterSelectionsFromModal();
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 55,
                          margin: EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.only(left: 4, right: 4),
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: AppTheme.darkBrown,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              "Apply",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          );
        }),
      );
    }

    void _modalBottomSortFilterMenu(BuildContext context) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (context) => StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
          return Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20)),
              color: Colors.white,
            ),
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 25),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text('Sort By',
                          style: TextStyle(
                              fontSize: 19,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w600,
                              color: Colors.black)),
                    ),
                    const Spacer(),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.clear,
                          color: Color(0xFFAFAFAF),
                        )),
                    const SizedBox(width: 15)
                  ],
                ),
                const SizedBox(height: 22),
                ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.symmetric(horizontal: 14),
                    itemCount: sortList.length,
                    itemBuilder: (BuildContext context, int pos) {
                      return Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Container(
                              child: selectedSortIndex == pos
                                  ? GestureDetector(
                                      onTap: () {
                                        selectedSortIndex = pos;
                                        setModalState(() {});
                                        Navigator.pop(context);
                                        _applyFiltersAndSort();
                                      },
                                      child: Icon(Icons.radio_button_checked,
                                          color: AppTheme.darkBrown))
                                  : GestureDetector(
                                      onTap: () {
                                        selectedSortIndex = pos;
                                        setModalState(() {});
                                        Navigator.pop(context);
                                        _applyFiltersAndSort();
                                      },
                                      child: Icon(Icons.radio_button_off,
                                          color: Color(0xFF9D9CA0))),
                            ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(sortList[pos],
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontFamily: "Montserrat",
                                      color: Colors.black)),
                            ),
                          ],
                        ),
                      );
                    }),
                SizedBox(height: 30),
              ],
            ),
          );
        }),
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
        categoryListDynamic.add({
          "cat_id": categoryIDs[i].toString(),
          "cat_name": responseJSON["data"][categoryIDs[i].toString()]
                  ["categoryName"]
              .toString(),
        });
        // map products per category
        final List<dynamic> productsForCat = (responseJSON["data"]
                [categoryIDs[i].toString()]["products"] as List<dynamic>?) ??
            [];
        categoryIdToProducts[categoryIDs[i].toString()] = productsForCat;
      }

      // Build category display list and checks
      categoryList = categoryListDynamic.map((e) => e["cat_name"].toString()).toList();
      categoryCheckList = List<bool>.filled(categoryList.length, false);

      // Use widget.catID if available
      /*if (categoryIDs.isNotEmpty) {
        String initCaiId = categoryIDs[0];
        initialCatId=initCaiId;
        initialCatName = categoryListDynamic
            .firstWhere((cat) => cat['cat_id'] == initialCatId,
          orElse: () => null,
        )?['cat_name'] ?? "";




        selectedCategoryIds
          ..clear()
          ..add(initCaiId);
        productList =
            List<dynamic>.from(categoryIdToProducts[initCaiId] ?? []);
      }*/


      if (widget.catID.isNotEmpty && categoryIDs.contains(widget.catID)) {
        initialCatId = widget.catID;
        initialCatName=widget.catName;
        selectedCategoryIds
          ..clear()
          ..add(initialCatId);
        productList =
        List<dynamic>.from(categoryIdToProducts[initialCatId] ?? []);

        for (int i = 0; i < categoryListDynamic.length; i++) {
          categoryCheckList[i] =
              categoryListDynamic[i]['cat_id']?.toString() == initialCatId;
        }
      }

      print("Initial Cat id %%%%%%%%%%%%$initialCatId");
      print("Initial Cat Name %%%%%%%%%%%%$initialCatName");

      _rebuildBrandList();

      print(categoryList.toString());
      print("%%%%%");
      print(productList.toString());

      setState(() {});
      fetchCatTypes();
    }

    fetchCatTypes() async {
      APIDialog.showAlertDialog(context, "Please wait...");
      ApiBaseHelper helper = ApiBaseHelper();
      Map<String, dynamic> requestBody = {
        "dropdown_type":"category",
        "page":1,
        "pageSize":100// Assuming default page size
      };
      var resModel = {
        'data': base64.encode(utf8.encode(json.encode(requestBody)))
      };
      var response = await helper.postAPI('master/allData', resModel, context);
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
      var responseJSON= json.decode(response.toString());
      print(responseJSON);
      if(responseJSON["statusCode"]==200){
        List<dynamic> catList=(responseJSON['result'] as List?)??[];

        for(var item in catList){

          String _id=item['_id']?.toString()??"";
          String _file=item['file']?.toString()??"";
          String iconFile=item['icon_file']?.toString()??"";

          for(int i=0;i<categoryListDynamic.length;i++){
            String catId=categoryListDynamic[i]['cat_id']?.toString()??"";
            if(catId==_id){
              String fileNew="";
              if(_file.isNotEmpty){
                fileNew=AppConstant.appBaseURL+_file;
              }else if(iconFile.isNotEmpty){
                fileNew=AppConstant.appBaseURL+iconFile;
              }
              categoryListDynamic[i]['image']=fileNew;
            }
          }

          setState(() {

          });



        }


      }



    }

    void _rebuildBrandList() {
      final Set<String> brands = {};
      for (final List<dynamic> products in categoryIdToProducts.values) {
        for (final dynamic p in products) {
          final String b = (p["brand"] ?? '').toString();
          if (b.isNotEmpty) brands.add(b);
        }
      }
      brandList = brands.toList()..sort();
      brandCheckList = List<bool>.filled(brandList.length, false);
    }

    void _applyFilterSelectionsFromModal() {
      selectedCategoryIds.clear();
      for (int i = 0; i < categoryCheckList.length; i++) {
        if (categoryCheckList[i]) {
          selectedCategoryIds.add(categoryListDynamic[i]["cat_id"].toString());
        }
      }
      selectedBrands.clear();
      for (int i = 0; i < brandCheckList.length; i++) {
        if (brandCheckList[i]) {
          selectedBrands.add(brandList[i]);
        }
      }
      _applyFiltersAndSort();
    }

    void _applyFiltersAndSort() {
      List<dynamic> combined = [];
      if (selectedCategoryIds.isEmpty) {
        for (final List<dynamic> list in categoryIdToProducts.values) {
          combined.addAll(list);
        }
      } else {
        for (final String id in selectedCategoryIds) {
          combined.addAll(categoryIdToProducts[id] ?? []);
        }
      }

      if (selectedBrands.isNotEmpty) {
        combined = combined
            .where((p) => selectedBrands.contains((p["brand"] ?? '').toString()))
            .toList();
      }

      switch (selectedSortIndex) {
        case 1: // High to Low
          combined.sort((a, b) => _numFrom(a["price"])
              .compareTo(_numFrom(b["price"])));
          combined = combined.reversed.toList();
          break;
        case 2: // Low to High
          combined.sort((a, b) => _numFrom(a["price"])
              .compareTo(_numFrom(b["price"])));
          break;
        case 3: // Highly Rated
          combined.sort(
              (a, b) => _numFrom(b["rating"]).compareTo(_numFrom(a["rating"])));
          break;
        default:
          break;
      }

      setState(() {
        productList = combined;
      });
    }

    num _numFrom(dynamic v) {
      if (v == null) return 0;
      if (v is num) return v;
      final s = v.toString().replaceAll(RegExp(r'[^0-9.\-]'), '');
      return num.tryParse(s) ?? 0;
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
                        helper2.getFrontEndUrl() +
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
                        text: helper2.getFrontEndUrl() + "Shop/product/" + id));
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
                        helper2.getFrontEndUrl() +
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
      super.initState();

      print("Initial Category Id: ${widget.catID}");
      print("Initial Category Name: ${widget.catName}");
      initialCatId=widget.catID;
      initialCatName=widget.catName;

     /* _scrollController.addListener((){
        if(_scrollController.position.pixels>=_scrollController.position.maxScrollExtent-150 && !isPaginationLoading && hasMoreData){
          fetchCategories();
        }
      });
      fetchCategories();*/
      _loadUserData();
    }

    Future<void>_loadUserData()async{
      userId=await MyUtils.getSharedPreferences("user_id")??"";
      userName=await MyUtils.getSharedPreferences("name")??"";
      setState(() {
      });
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 150 &&
            !isPaginationLoading &&
            hasMoreData) {
          if(widget.catID.isEmpty){
            fetchProduct(isLoadMore: true);
          }
        }
      });
      fetchCategories();
      if(widget.catID.isEmpty){
        fetchProduct();
      }

    }
    fetchProduct({bool isLoadMore = false}) async {
      if (!isLoadMore) {
        currentPage = 1;
        hasMoreData = true;
        productList.clear();
        setState(() {});
        APIDialog.showAlertDialog(context, "Please wait...");
      }else{

        setState(() {
          isPaginationLoading=true;
        });
      }


      ApiBaseHelper helper = ApiBaseHelper();
      Map<String, dynamic> requestBody = {
        "brand":"",
        "category":"",
        "subCategory":"",
        "page":currentPage,
        "pageSize":perPageSize// Assuming default page size
      };
      print("request body $requestBody");
      var resModel = {
        'data': base64.encode(utf8.encode(json.encode(requestBody)))
      };
      var response = await helper.postAPI('product/allProducts', resModel, context);

      var responseJSON= json.decode(response.toString());
      print(responseJSON);
      if(responseJSON["statusCode"]==201){
        List<dynamic> newProducts =
            (responseJSON['productsWithUrls'] as List?) ?? [];
        // productList=(responseJSON['productsWithUrls'] as List?)??[];
        totalCount=responseJSON['totalCount']??100;
        setState(() {
          productList.addAll(newProducts);


          if (productList.length < totalCount) {
            currentPage++;
            // 🚫 no more pages
          } else {
            hasMoreData = false;
            // ✅ next page
          }
        });

        _applyFilterSelectionsFromModal();

      }
      if(!isLoadMore) {
        if (Navigator.canPop(context)) {
          Navigator.of(context).pop();
        }
        setState(() {

        });

        print("Product list length final ${productList.length}");
      }else{
        setState(() {
          isPaginationLoading=false;
        });
        print("Product list length final ${productList.length}");
      }
    }
}
