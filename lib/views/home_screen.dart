




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/Utils.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/menu_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';

import '../network/api_helper.dart';
import '../widgets/drawer/zoom_scaffold.dart' as MEN;
import 'category_wise_products.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {

  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomeScreen>  with TickerProviderStateMixin{
  bool isLoading=false;
  List<dynamic> categoryList=[];
  MEN.MenuController? menuController;

  List<dynamic> productList=[];
  String? name;
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.darkBrown,
      child: SafeArea(
        child: ChangeNotifierProvider(
          create: (context) => menuController,
          child: MEN.ZoomScaffold(
            menuScreen:  MenuScreen(),
            orangeTheme: false,
            pageTitle: "Home",
            showBoxes: false,
            contentScreen: MEN.Layout(
                contentBuilder: (cc) =>  Expanded(child:

                isLoading?

                Container(
                  color: Colors.white,
                  child: Center(
                    child: Loader(),
                  ),
                ):


                Container(
                  color: Colors.white,
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [

                      Container(height: 1,color: Colors.grey.withOpacity(0.3),width: double.infinity),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  name==null?Container():
                                  Text("Hello, "+name.toString(),
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),

                                  /*   SizedBox(height: 3),

                              Text("Lorem Ipsum Dummy Text here",
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFFB8B8B8),
                                  )),
                  */
                                ],
                              ),
                            ),

                            SizedBox(
                              width: 71,
                              height: 71,
                              child: Lottie.asset("assets/lotus_pose.json"),
                            )





                          ],
                        ),
                      ),

                      SizedBox(height: 16),

                      Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(77.0),
                                  borderSide: BorderSide.none
                              ),
                              filled: true,
                              hintStyle: TextStyle(color: Color(0xFF707070).withOpacity(0.5),fontSize: 14),
                              hintText: "Search Products",
                              fillColor: Color(0xFFEFEEF1),
                              prefixIcon: Icon(Icons.search,color: Color(0xFF707070))
                          ),
                        ),
                      ),

                      SizedBox(height: 22),

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

                                SizedBox(height: 10),


                                Text("The Combination of\nNature and Science",
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    )),


                                SizedBox(height: 9),

                                Container(
                                  width: 108,
                                  height: 37,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(77),
                                      color: Colors.white
                                  ),

                                  child: Center(
                                    child: Text("Shop Now",
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: AppTheme.greenColor,
                                        )),
                                  ),



                                )







                              ],
                            ),
                          )


                        ],
                      ),

                      SizedBox(height: 22),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text("CATEGORIES",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),

                            /*  Spacer(),
                        GestureDetector(
                          onTap: (){
                            allCategoryBottomSheet(context);
                          },
                          child: Text("See all",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0XFF3E99C4),
                              )),
                        ),
                  */

                          ],
                        ),
                      ),
                      SizedBox(height: 16),

                      Padding(padding: EdgeInsets.symmetric(horizontal: 12),

                        child: Container(
                            height: 90,
                            child: ListView.builder(
                                itemCount: categoryList.length,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (BuildContext context,int pos)
                                {
                                  return Row(
                                    children: [



                                      GestureDetector(
                                        onTap:(){

                                          Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoryWiseProducts(categoryList[pos]["cat_name"],categoryList[pos]["cat_id"].toString())));

                                        },
                                        child: SizedBox(
                                          height: 84,
                                          width: 95,
                                          child: Stack(
                                            children: [

                                              Image.asset("assets/grid1.png"),

                                              Center(
                                                child:
                                                Text(categoryList[pos]["cat_name"],
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: Colors.white,
                                                    ),textAlign: TextAlign.center,maxLines:3),
                                              )



                                            ],
                                          ),
                                        ),
                                      ),

                                      SizedBox(width: 11),






                                    ],
                                  );
                                }



                            )
                        ),

                      ),

                      SizedBox(height: 26),


                      SizedBox(
                        child:    GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                          itemCount: productList.length>4?4:productList.length,
                          // Total number of classes
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailScreen(productList[index]["_id"].toString(),productList[index]["category_id"].toString())));

                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFFE2D7D7),width: 1)
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(height: 135,
                                      child: Stack(
                                        children: [

                                          Center(child: Image.network(AppConstant.appBaseURL+productList[index]["coverImage"].toString())),
                                          Row(
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4,right: 4),
                                                child: Image.asset("assets/arrow_right.png",width: 34,height: 26),
                                              ),
                                            ],
                                          ),




                                        ],
                                      ),

                                    ),




                                    //  SizedBox(height: 8),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(
                                        children: [

                                          Text("\$"+productList[index]["discounted_price"].toString(),
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
                                      child: Text(productList[index]["productName"].toString(),
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkBrown,
                                          )),
                                    ),

                                    SizedBox(height: 3),

                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text(productList[index]["brand"].toString(),
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

                      SizedBox(height: 32),

                      Container(
                        height: 166,
                        margin: EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: Color(0xFFC1E9EF)
                        ),

                        child: Stack(
                          children: [


                            Row(
                              children: [

                                SizedBox(width: 12),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      SizedBox(height: 25),

                                      Text("connect with your inner balance",
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF662A09),
                                          )),

                                      SizedBox(height: 10),


                                      Text("Book Your Ayurvedic\nConsultation",
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),

                                      SizedBox(height: 10),
                                      Container(
                                        width: 108,
                                        height: 37,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(77),
                                            color: Colors.white
                                        ),

                                        child: Center(
                                          child: Text("Book Now",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),
                                        ),



                                      )



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
                                  margin: EdgeInsets.only(right: 3,top: 35),
                                  height: 120,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white,width: 15)
                                  ),
                                ),
                              ],
                            ),


                            Row(
                              children: [

                                Spacer(),

                                Container(
                                  transform: Matrix4.translationValues(0, -12, 0),
                                  padding: EdgeInsets.only(top: 47,right: 22),
                                  child:  Image.asset("assets/consultant_dummy.png",width: 90,height: 130),

                                )
                              ],
                            )




                          ],
                        ),
                      ),


                      SizedBox(height: 28),



                      Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Image.asset("assets/banner_3.png"),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 26),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [

                                SizedBox(height: 10),


                                Text("Want it today?",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    )),

                                SizedBox(height: 5),

                                Text("Visit the Shop at our center, or call us at 240-753-0151 .",
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),textAlign: TextAlign.center),







                              ],
                            ),
                          )


                        ],
                      ),


                      SizedBox(height: 20),



                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          children: [
                            Text("POPULAR ITEMS",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.black,
                                )),

                            Spacer(),
                            Text("See all",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0XFF3E99C4),
                                )),


                          ],
                        ),
                      ),

                      SizedBox(height: 16),



                      SizedBox(
                        child:    GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.symmetric(horizontal: 10),
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
                          itemCount: 4,
                          // Total number of classes
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                //  Navigator.push(context, MaterialPageRoute(builder: (context)=>ViewPDFScreen(AppConstant.digitalContentBaseURL+chapterList[currentChapter]["resources"][index]["attachment_file"])));

                              },
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    border: Border.all(color: Color(0xFFE2D7D7),width: 1)
                                ),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Container(height: 138,
                                      child: Stack(
                                        children: [

                                          Image.asset("assets/banner4.png"),
                                          Row(
                                            children: [
                                              Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(top: 4,right: 4),
                                                child: Image.asset("assets/arrow_right.png",width: 34,height: 26),
                                              ),
                                            ],
                                          ),




                                        ],
                                      ),

                                    ),




                                    //  SizedBox(height: 8),

                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 5),
                                      child: Row(
                                        children: [

                                          Text("\$15.00",
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: AppTheme.darkBrown,
                                              )),


                                          Spacer(),

                                          Image.asset("assets/star_ic.png",width: 13,height: 12),

                                          SizedBox(width: 3),


                                          Text("4.5",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.black,
                                              )),





                                        ],
                                      ),
                                    ),


                                    SizedBox(height: 7),




                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text("Amalaki Powder",
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.darkBrown,
                                          )),
                                    ),

                                    SizedBox(height: 3),

                                    Padding(
                                      padding: const EdgeInsets.all(3.0),
                                      child: Text("Rasa Herbs",
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
                height: MediaQuery.of(context).size.height-150,
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
                                child: Icon(Icons.clear,color: Color(0xFFAFAFAF),)),
                            const SizedBox(width: 15)
                          ],
                        ),
                        SizedBox(height: 25),

                        Expanded(
                          child: GridView.builder(
                            padding: EdgeInsets.symmetric(horizontal: 25),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // Number of columns
                                crossAxisSpacing: 35, // Horizontal spacing
                                mainAxisSpacing: 14, // Vertical spacing
                                childAspectRatio: 1 / 1 // Width to height ratio
                            ),
                            itemCount: 8, // Total number of classes
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: (){





                              //    Navigator.push(context,MaterialPageRoute(builder: (context)=>CategoryWiseProducts()));



                                },
                                child:   SizedBox(
                                  height: 84,
                                  width: 95,
                                  child: Stack(
                                    children: [

                                      Image.asset("assets/grid1.png"),

                                      Center(
                                        child:
                                        Text("Ayurvedic Herbals",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            ),textAlign: TextAlign.center),
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

  fetchCategories() async {

    setState(() {
      isLoading=true;
    });

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.getAPI('product/by-categories', context);

    setState(() {
      isLoading=false;
    });

    var responseJSON = json.decode(response.toString());
    print(response.toString());


    List<String> categoryIDs=responseJSON["data"].keys.toList();
    print("***");
    print(categoryIDs.toString());



    for(int i=0;i<categoryIDs.length;i++)
      {
        categoryList.add(
          {
            "cat_id":categoryIDs[i].toString(),
            "cat_name":responseJSON["data"][categoryIDs[i].toString()]["categoryName"].toString(),
          }
        );
      }

    if(categoryIDs.length!=0)
      {
        productList=responseJSON["data"][categoryIDs[0].toString()]["products"];
      }


    print(categoryList.toString());
    print("%%%%%");
    print(productList.toString());




    setState(() {

    });






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
  }
  fetchUserName() async {
    name=await MyUtils.getSharedPreferences("name");

    setState(() {

    });

  }
}