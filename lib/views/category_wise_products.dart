import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/cart_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';

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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_new_sharp,
                            size: 17, color: Colors.black)),
                    Text(widget.catName,
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
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  final String catId = categoryListDynamic[pos]
                                          ["cat_id"]
                                      .toString();
                                  selectedCategoryIds
                                    ..clear()
                                    ..add(catId);
                                  _applyFiltersAndSort();
                                },
                                child: SizedBox(
                                  height: 84,
                                  width: 95,
                                  child: Stack(
                                    children: [
                                      Image.asset("assets/grid1.png"),
                                      Center(
                                        child: Text(
                                            categoryListDynamic[pos]
                                                ["cat_name"],
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
                              ),
                              SizedBox(width: 11)
                            ],
                          );
                        })),
            isLoading ? Container() : SizedBox(height: 12),
            isLoading
                ? Container()
                : Expanded(
                    child: GridView.builder(
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
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                        productList[index]["_id"].toString(),
                                        productList[index]["category_id"]
                                            .toString())));
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
                                          child: Image.network(AppConstant
                                                  .appBaseURL +
                                              productList[index]["coverImage"]
                                                  .toString())),
                                      Row(
                                        children: [
                                          Spacer(),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 4, right: 4),
                                            child: Image.asset(
                                                "assets/arrow_right.png",
                                                width: 34,
                                                height: 26),
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
                                          "\$" +
                                              productList[index]
                                                      ["discounted_price"]
                                                  .toString(),
                                          style: TextStyle(
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
                                      productList[index]["productName"]
                                          .toString(),
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.darkBrown,
                                      )),
                                ),

                                SizedBox(height: 3),

                                Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Text(
                                      productList[index]["brand"].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
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
                                itemCount: (selectedIndex == 0
                                        ? categoryList
                                        : brandList)
                                    .length,
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
    categoryList =
        categoryListDynamic.map((e) => e["cat_name"].toString()).toList();
    categoryCheckList = List<bool>.filled(categoryList.length, false);

    // Use widget.catID if available
    if (categoryIDs.isNotEmpty) {
      String initialCatId = categoryIDs[0];
      if (widget.catID.isNotEmpty && categoryIDs.contains(widget.catID)) {
        initialCatId = widget.catID;
      }
      selectedCategoryIds
        ..clear()
        ..add(initialCatId);
      productList =
          List<dynamic>.from(categoryIdToProducts[initialCatId] ?? []);
    }

    _rebuildBrandList();

    print(categoryList.toString());
    print("%%%%%");
    print(productList.toString());

    setState(() {});
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
        combined.sort((a, b) => _numFrom(a["discounted_price"])
            .compareTo(_numFrom(b["discounted_price"])));
        combined = combined.reversed.toList();
        break;
      case 2: // Low to High
        combined.sort((a, b) => _numFrom(a["discounted_price"])
            .compareTo(_numFrom(b["discounted_price"])));
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategories();
  }
}
