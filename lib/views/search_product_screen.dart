import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/api_helper.dart';
import '../network/constants.dart';
import '../utils/app_theme.dart';
import '../utils/debouncer_helper.dart';
class SearchPage extends StatefulWidget {
  List<dynamic> catlist;
  SearchPage(this.catlist);
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  final Debouncer debouncer = Debouncer(milliseconds: 500);
  List<dynamic> productList = [];
  bool isLoading = false;
  final ApiBaseHelper helper = ApiBaseHelper();
  List<String> categoryIds=[];
  int pageNo=1;
  int pageSize=50;


  Future<void> fetchProducts(String query) async {
    setState(() {
      isLoading = true;
    });
    var data = {
      "title": query,
      "page":pageNo,
      "pageSize":pageSize,
      "category":categoryIds,
      "subcategory":[],
      "brand":[],
      "sortBy":"",
      "sortOrder":""
    };
    print("Request Params $data");

    // Encode the data object into a Base64 string
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('product/allProducts', requestModel, context);
    var responseJSON = json.decode(response.toString());
    productList = (responseJSON["productsWithUrls"] as List?)??[];
    setState(() {
      isLoading = false;
    });

  }

  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
        backgroundColor: Colors.white,
            body: Column(
              children: [
                Card(
                  elevation: 1,
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
                              size: 17, color: Colors.black),
                        ),
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            autofocus: true,
                            onChanged: (value) {
                              debouncer.run(() {
                                fetchProducts(value); // ✅ Debounced API call
                              });
                            },
                            decoration: const InputDecoration(
                              hintText: "Search Products",
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                isLoading? Center(child: Loader(),):
                productList.isEmpty?
                    const Expanded(child: Center(child: Text("We couldn't find any result for your search.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),)):

                Expanded(child: GridView.builder(
                      shrinkWrap: true,
                      padding:
                      EdgeInsets.symmetric(horizontal: 10),
                      
                      gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Number of columns
                        crossAxisSpacing:
                        10, // Horizontal spacing
                        mainAxisSpacing: 10, // Vertical spacing
                        childAspectRatio:
                        1.1 / 1.6, // Width to height ratio
                      ),
                      itemCount:  productList.length,
                      // Total number of classes
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(
                                            productList[index]["_id"].toString(),
                                            productList[index]["category_id"].toString())));
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
                                      Center(
                                          child: Image.network(AppConstant.appBaseURL + productList[index]["coverImage"].toString())),
                                      Row(
                                        children: [
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              _showShareOptions(
                                                  context,
                                                  productList[
                                                  index]
                                                  ['_id']);
                                            },
                                            child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .only(
                                                  top: 4,
                                                  right: 4),
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
                                          "\$" + productList[index]["discounted_price"].toString(),
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight:
                                            FontWeight.bold,
                                            color: AppTheme.darkBrown,
                                          )),
                                    ],
                                  ),
                                ),

                                Padding(
                                  padding:
                                  const EdgeInsets.all(3.0),
                                  child: Text(
                                    productList[index]["productName"].toString(),
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
                                      productList[index]["brandName"]
                                          .toString(),
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
                    ))
              ],
            ),
    ));
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
                  final text = "Check this product: " + helper.getFrontEndUrl() +
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
    super.initState();
    fetchCategoryList();
  }

  void fetchCategoryList() {
    categoryIds = widget.catlist
        .map((e) => e["cat_id"]?.toString() ?? "")
        .where((id) => id.isNotEmpty)
        .toList();

    fetchProducts("");
  }


}