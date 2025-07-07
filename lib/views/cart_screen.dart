




import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/address_details_screen.dart';
import 'package:vedic_health/views/home_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';


import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class CartScreen extends StatefulWidget {
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<CartScreen> {
  int selectedIndex = 0;
  int selectedSortIndex = 0;
  final List<String> tabs = ["Category", "Brand"];

  double subTotalAmount=0;
  List<bool> categoryCheckList=[false,false,false,false];
  List<bool> brandCheckList=[false,false,false,false];

  List<String> categoryList=[
    "All Categories (390)",
    "Health & Beauty (195)",
    "Health Care (195)",
    "Personal Care (0)"
  ];

  List<String> brandList=[
    "Auromere",
    "Thorne",
    "J. Crow's",
    "Kerala Ayurveda"
  ];
  List<String> sortList=[
    "Most Popular",
    "High to Low",
    "Low to High",
    "Highly Rated"
  ];

  bool isLoading=false;
  List<dynamic> cartList=[];


  List<bool> cartSelectedItems=[];


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
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
              ),
              child: Container(
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20), // Adjust the radius as needed
                    bottomRight: Radius.circular(20), // Adjust the radius as needed
                  ),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [



                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);

                        },
                        child:Icon(Icons.arrow_back_ios_new_sharp,size: 17,color: Colors.black)),




                    Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: Text("Shopping Bag",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),







/*

                    GestureDetector(
                      onTap: (){


                      },
                      child: Image.asset("assets/cart_bag.png",width: 39,height: 39)
                    )
*/




                  ],
                ),
              ),
            ),

            SizedBox(height: 16),


            Expanded(child:
            isLoading?

                Center(
                  child: Loader(),
                ):

                cartList.length==0?


            Center(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: SizedBox(
                          height: 250,
                          child: Lottie.asset(
                              'assets/cart_animation.json')),
                    ),
                    const SizedBox(height: 15),
                    const Center(
                      child: Text('Your Cart Bag Is Empty',
                          style: TextStyle(
                              fontSize: 17, color: Colors.black)),
                    ),
                    const SizedBox(height: 35),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen()));
                      },
                      child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 55),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: AppTheme.darkBrown,
                              borderRadius:
                              BorderRadius.circular(5)),
                          height: 50,
                          child: const Center(
                            child: Text('Add Products',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white)),
                          )),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ):





            ListView(
              padding: EdgeInsets.symmetric(horizontal: 12),
              children: [


                Stack(
                  children: [

                    Container(
                      height: 8,
                      margin: EdgeInsets.only(top: 5,left: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(1),
                          color: Color(0xFFC4C4C4)
                      ),
                    ),


                    Container(
                      width: 18,
                      height: 18,

                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF00DB00),
                        border: Border.all(width: 1,color: Colors.white),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            blurRadius: 6,
                            color: Color(0xFF00DB00).withOpacity(0.5),
                          ),
                        ],

                      ),
                    )



                  ],
                ),


                SizedBox(height: 10),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [


                    Text("Bag",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF00DB00),
                        )),


                    Text("Address",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),


                    Text("Payment",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),
                  ],
                ),

                SizedBox(height: 25),
                
                
                ListView.builder(
                    itemCount: cartList.length,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context,int pos)
                {
                  return Column(
                    children: [

                      Container(
                       // height: 108,
                        padding: EdgeInsets.symmetric(horizontal: 11),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [

                            BoxShadow(
                              offset: Offset(0, 1),
                              blurRadius: 6,
                              color: Color(0xFFD6D6D6),
                            ),
                          ],

                        ),

                        child: Row(
                          children: [

                            Stack(
                              children: [
                                Container(
                                  width: 83,
                                  height: 76,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                          fit: BoxFit
                                              .cover,
                                          image: NetworkImage(
                                            AppConstant.appBaseURL+cartList[pos]["productDetails"]["coverImage"],
                                          ))

                                  ),
                                ),

                                GestureDetector(
                                    onTap: (){

                                      if(cartSelectedItems[pos])
                                        {
                                          cartSelectedItems[pos]=false;

                                          int doubleSingleProductCost= cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];

                                          subTotalAmount=subTotalAmount-doubleSingleProductCost;
                                          setState(() {

                                          });




                                        }
                                      else
                                        {
                                          cartSelectedItems[pos]=true;

                                          int doubleSingleProductCost= cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];

                                          subTotalAmount=subTotalAmount+doubleSingleProductCost;
                                          setState(() {

                                          });


                                        }

                                      setState(() {

                                      });


                                    },

                                    child:


                                    cartSelectedItems[pos]?
                                    Icon(Icons.check_box,color: AppTheme.themeColor):
                                Icon(Icons.check_box_outline_blank_outlined)


                                ),


                              ],
                            ),

                            SizedBox(width: 15),

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [


                                  SizedBox(height: 15),


                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(cartList[pos]["productDetails"]["productName"],
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            )),
                                      ),


                                      Image.asset("assets/delete_ic.png",width: 14.42,height: 18.14)





                                    ],
                                  ),

                                  SizedBox(height: 6),

                                  Text("Brand: "+cartList[pos]["productDetails"]["brand_name"],
                                      style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0xFFA3A3A3),
                                      )),

                                  SizedBox(height: 6),


                                  Row(
                                    children: [
                                      Text("\$"+cartList[pos]["productDetails"]["price"].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),

                                      SizedBox(width: 13),

                                      Spacer(),


                               /*       Container(
                                        width: 49,
                                        height: 25,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(40),
                                            color: Color(0xFFF8B84E)
                                        ),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [

                                            Text("4.5",
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white,
                                                )),

                                            SizedBox(width: 2),

                                            Icon(Icons.star,color: Colors.white,size: 12,)


                                          ],
                                        ),
                                      ),

                                      Spacer(),*/


                                      Container(
                                        //width: 68,
                                        height: 26,
                                        padding: EdgeInsets.symmetric(horizontal: 10),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Color(0xFFF5F5F5)
                                        ),

                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [

                                            GestureDetector(
                                              onTap:(){

                                                updateCartProduct(cartList[pos]["productId"].toString(), false);
                                      },
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset("assets/minus_ic.png",width: 9,height: 9,),
                                              ),
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 5),
                                              child: Text(cartList[pos]["quantity"].toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  )),
                                            ),

                                            GestureDetector(
                                              onTap:(){

                                                updateCartProduct(cartList[pos]["productId"].toString(), true);
                                              },


                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Image.asset("assets/plus_ic.png",width: 9,height: 9,),
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),







                                    ],
                                  ),

                                  SizedBox(height: 15),

                                ],
                              ),
                            )









                          ],
                        ),


                      ),

                      SizedBox(height: 15),
                    ],
                  );
                }



                ),


                SizedBox(height: 10),

                Row(
                  children: [


                    Text("Missed something?",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        )),

                    Spacer(),

                    GestureDetector(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    HomeScreen()));
                      },
                      child: Container(
                        height: 37,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: AppTheme.darkBrown
                        ),
                        child:    Center(
                          child: Text("Continue Shopping",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.white,
                              )),
                        ),
                      ),
                    )



                  ],
                )






              ],
            )),


            cartList.length==0?Container():


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


                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text("Sub Total("+cartList.length.toString()+" Item)",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF9EA8AA),
                            )),

                        SizedBox(height: 6),

                        Text("\$"+subTotalAmount.toStringAsFixed(2),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF00BE55),
                            )),





                      ],
                    ),
                  ),flex: 1),



                  Expanded(child: GestureDetector(
                    onTap: (){


                      if(cartSelectedItems.toString().contains("true"))
                        {

                          placeOrder();
                        }


                    },
                    child: Container(
                      height: 54,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: cartSelectedItems.toString().contains("true")?Color(0xFFB65303):Colors.grey
                      ),
                      child: Center(
                        child:
                        Text("Place Order",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            )),
                      )
                    ),
                  ),flex: 1),











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





                                  /*      if(docList[index]["mime_type"].toString().startsWith('image/'))
                                  {
                                    Navigator.push(context,MaterialPageRoute(builder: (context)=>ImageView(AppConstant.filesBaseURL+docList[index]["attachment_file"])));

                                  }*/



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
                    topLeft: Radius.circular(20), topRight: Radius.circular(20),bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
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
                          child: Icon(Icons.clear,color: Color(0xFFAFAFAF),)),
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
                                setModalState(() {

                                });
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 45,
                                    width: 100,
                                    margin: EdgeInsets.only(left: 10, top: 5, bottom: 5, right: 10),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? Color(0xFFF38328) : Color(0xFFDEE3E6),
                                      borderRadius: BorderRadius.circular(8), // Set the radius for all corners
                                    ),
                                    child: Text(
                                      tabs[index],
                                      style: TextStyle(
                                        color: isSelected ? Color(0xFFFFFFFF) : Colors.black,
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
                            color: Colors.white, // Background color for right section
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                Text('Select Category',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Montserrat",
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black)),

                                SizedBox(height: 5),

                                ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: categoryList.length,
                                    itemBuilder: (BuildContext context,int pos)
                                    {
                                      return Container(
                                        padding: EdgeInsets.symmetric(vertical: 10),
                                        child: Row(
                                          children: [





                                            GestureDetector(
                                              onTap:(){


                                                categoryCheckList[pos]=!categoryCheckList[pos];

                                                setModalState(() {

                                                });


                                              },


                                              child: Container(
                                                child:   categoryCheckList[pos]?Icon(Icons.check_box,color: Color(0xFF079848)):

                                                Icon(Icons.check_box_outline_blank_outlined,color: Color(0xFF9D9CA0)),
                                              ),
                                            ),

                                            SizedBox(width: 7),


                                            Expanded(
                                              child: Text(categoryList[pos],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontFamily: "Montserrat",
                                                      color: Color(0xFF9D9CA0))),
                                            ),

















                                          ],
                                        ),
                                      );
                                    }


                                ),
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(flex:1,child: GestureDetector(
                        onTap: (){
                          setModalState(() {

                          });

                        },

                        child: Container(
                          height: 55,
                          margin: EdgeInsets.only(left: 16),
                          padding: const EdgeInsets.only(left: 4,right: 4),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              borderRadius: BorderRadius.circular(4),
                              color: Color(0xFFE3E3E3)
                          ),
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
                      ),),
                      const SizedBox(width: 20),
                      Expanded(flex:1,child: GestureDetector(
                        onTap: (){
                          setModalState(() {

                          });

                        },
                        child: Container(
                          height: 55,
                          margin: EdgeInsets.only(right: 16),
                          padding: const EdgeInsets.only(left: 4,right: 4),
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
                      ),),



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
                    topLeft: Radius.circular(20), topRight: Radius.circular(20),bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 15),
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
                          child: Icon(Icons.clear,color: Color(0xFFAFAFAF),)),
                      const SizedBox(width: 15)
                    ],
                  ),
                  const SizedBox(height: 22),
                  ListView.builder(
                      shrinkWrap: true,
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      itemCount: sortList.length,
                      itemBuilder: (BuildContext context,int pos)
                      {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [





                              Container(
                                child:   selectedSortIndex==pos?GestureDetector(
                                    onTap:(){


                                      selectedSortIndex=pos;

                                      setModalState(() {

                                      });

                                      Navigator.pop(context);


                                    },


                                    child: Icon(Icons.radio_button_checked,color: AppTheme.darkBrown)):

                                Icon(Icons.radio_button_off,color: Color(0xFF9D9CA0)),
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
                      }


                  ),
                  SizedBox(height: 30),
                ],
              ),
            );
          }),
    );
  }

  fetchCartItems(bool progressDialog) async {

    if(progressDialog)
      {
        APIDialog.showAlertDialog(context, "Please wait...");
      }
    else
      {
        setState(() {
          isLoading = true;
        });
      }



    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {"page":1,"user":userId.toString(),"pageSize":6};


    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/findUserCart', requestModel, context);



    if(progressDialog)
    {
    Navigator.pop(context);
    }
    else
    {
      setState(() {
        isLoading = false;
      });
    }





    var responseJSON = json.decode(response.toString());
    print(response.toString());
    subTotalAmount=0;


    cartList = responseJSON["data"];

    for(int i=0;i<cartList.length;i++)
      {
        int totalAmount=cartList[i]["quantity"] * cartList[i]["productDetails"]["price"];
        
        subTotalAmount=subTotalAmount+totalAmount;
      }

    if(cartSelectedItems.length==0)
      {
        for(int i=0;i<cartList.length;i++)
        {
          cartSelectedItems.add(true);
        }
      }



    print("***rrrr");
    print(cartSelectedItems.toString());
    print(subTotalAmount.toString());

    
    





    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCartItems(false);
  }


  updateCartProduct(String productID,bool addMore) async {

    APIDialog.showAlertDialog(context, "Please wait...");

    String? userId=await MyUtils.getSharedPreferences("user_id");




    var data = {"productId": productID,"userId":userId.toString(),"quantity":addMore?1:-1};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/addCart', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['message'] == "Cart successfully added!") {

   /*   Toast.show(responseJSON['message'],
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);*/

      fetchCartItems(true);



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


  placeOrder() async {

    APIDialog.showAlertDialog(context, "Please wait...");

    String? userId=await MyUtils.getSharedPreferences("user_id");

    List<String> cartIDs=[];

    for(int i=0;i<cartSelectedItems.length;i++)
      {

        if(cartSelectedItems[i])
          {
            cartIDs.add(cartList[i]["_id"].toString());
          }



      }







    var data ={"ids":cartIDs,"user":userId.toString()};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/selectItems', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());

    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreen(cartIDs)));


    setState(() {});
  }


  deleteCartProduct(String cartID) async {

    APIDialog.showAlertDialog(context, "Removing item...");

    String? userId=await MyUtils.getSharedPreferences("user_id");




    var data = {"id": cartID,"user_id":userId.toString()};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('cart_management/delete', requestModel, context);


    Navigator.pop(context);



    var responseJSON = json.decode(response.toString());
    print(response.toString());
    if (responseJSON['message'] == "File deleted successfully") {

         Toast.show("Item removed successfully!",
          duration: Toast.lengthLong,
          gravity: Toast.bottom,
          backgroundColor: Colors.green);

      fetchCartItems(true);



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

}