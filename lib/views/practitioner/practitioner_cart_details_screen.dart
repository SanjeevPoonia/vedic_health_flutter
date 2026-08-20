import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/practitioner/practitioner_address_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_product_screen.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import '../../utils/app_theme.dart';
import '../../widgets/notification_bar_widget.dart';

class PractitionerCartDetails extends StatefulWidget{
  _practitionerCartDetails createState()=>_practitionerCartDetails();
}
class _practitionerCartDetails extends State<PractitionerCartDetails>{
  bool isLoading=false;
  List<dynamic> cartList=[];
  List<bool> cartSelectedItems=[];
  List<membershipProducts> membershipProductDisList=[];
  bool isMembershipPurchased=false;
  String membershipId="";
  double subTotalAmount=0;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                      child:Icon(Icons.arrow_back_ios_new_sharp,size: 24,color: Colors.black)),




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
                                  PractitionerProductScreen()));
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


                  Text("Customer Details",
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

                    String cartId=cartList[pos]['_id']?.toString()??"";
                    int maxOrderQuantity=cartList[pos]['productDetails']['maxOrderQuantity']??0;
                    int currentQuantity=cartList[pos]["quantity"]??0;
                    int stock=cartList[pos]['productDetails']['stock']??0;
                  /*  double? itemPrice=double.tryParse({cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"]}.toString());
                    int itemPriceInt=itemPrice??cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];*/
                    num quantity = cartList[pos]["quantity"] ?? 0;
                    num price = cartList[pos]["productDetails"]?["price"] ?? 0;
                    double itemPrice = (quantity * price).toDouble();
                    int itemPriceInt = itemPrice.toInt();

                    String categoryId=cartList[pos]?['productDetails']?['category']?.toString()??"";
                    double discountedPrice=0.0;
                    if(membershipProductDisList.isNotEmpty){
                      discountedPrice=calculateTheAmount(categoryId, itemPriceInt);
                    }

                    String dicountOffer=calculatePercentage(categoryId);

                    String productImage="";
                    String img=cartList[pos]["productDetails"]?["coverImage"]?.toString()??"";
                    if(img.isNotEmpty){
                      productImage=AppConstant.appBaseURL+img;
                    }



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
                                              productImage,
                                            ))

                                    ),
                                  ),
                                  /*GestureDetector(
                                      onTap: (){

                                        if(cartSelectedItems[pos])
                                        {
                                          cartSelectedItems[pos]=false;
                                          // int doubleSingleProductCost= cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];
                                          if(discountedPrice!=0.0){
                                            subTotalAmount=subTotalAmount-discountedPrice;
                                          }else{
                                            subTotalAmount=subTotalAmount-itemPriceInt;
                                          }
                                          setState(() {

                                          });

                                        }
                                        else
                                        {
                                          cartSelectedItems[pos]=true;
                                          *//*int doubleSingleProductCost= cartList[pos]["quantity"] * cartList[pos]["productDetails"]["price"];
                                          subTotalAmount=subTotalAmount+doubleSingleProductCost;*//*
                                          if(discountedPrice!=0.0){
                                            subTotalAmount=subTotalAmount+discountedPrice;
                                          }else{
                                            subTotalAmount=subTotalAmount+itemPriceInt;
                                          }
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


                                  ),*/
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
                                          child: Text(cartList[pos]["productDetails"]["productName"]??"",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              )),
                                        ),


                                        InkWell(
                                          onTap: (){
                                            if(cartId.isNotEmpty){
                                              _modelDeleteConfirmation(context, cartId);
                                            }

                                          },
                                          child: Image.asset("assets/delete_ic.png",width: 14.42,height: 18.14),
                                        ),






                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    Text("Brand: ${cartList[pos]["productDetails"]["brand_name"]??""}",
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Color(0xFFA3A3A3),
                                        )),
                                    SizedBox(height: 6),
                                    Row(
                                      children: [
                                        /* Text("\$"+cartList[pos]["productDetails"]["price"].toString(),
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          )),*/
                                        Text("\$$itemPriceInt",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            )),

                                        SizedBox(width: 13),

                                        Spacer(),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (currentQuantity > 1)
                                              GestureDetector(
                                                onTap: () {
                                                  updateCartProduct(cartList[pos]["productId"].toString(), false);
                                                },
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.red, // Red circle background
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: const EdgeInsets.all(6),
                                                  child: Image.asset(
                                                    "assets/minus_ic.png",
                                                    width: 11,
                                                    height: 11,
                                                    color: Colors.white, // white icon inside red circle
                                                  ),
                                                ),
                                              ),
                                            SizedBox(width: 5,),
                                            Container(
                                              //width: 68,
                                              height: 26,
                                              padding: EdgeInsets.symmetric(horizontal: 10),
                                              decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(30),
                                                  color: Color(0xFFF5F5F5)
                                              ),
                                              child: Center(child: Text(cartList[pos]["quantity"].toString(),
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  )),),

                                            ),
                                            SizedBox(width: 5,),
                                            if (stock > currentQuantity && currentQuantity < maxOrderQuantity)
                                              GestureDetector(
                                                onTap: () {
                                                  updateCartProduct(cartList[pos]["productId"].toString(), true);
                                                },
                                                child: Container(
                                                  decoration: const BoxDecoration(
                                                    color: Colors.green, // Green circle background
                                                    shape: BoxShape.circle,
                                                  ),
                                                  padding: const EdgeInsets.all(6),
                                                  child: Image.asset(
                                                    "assets/plus_ic.png",
                                                    width: 11,
                                                    height: 11,
                                                    color: Colors.white, // white icon inside green circle
                                                  ),
                                                ),
                                              ),

                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 6),
                                    discountedPrice!=0.0?
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text("Member Price",
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.green,
                                              )),
                                        ),
                                        SizedBox(width: 10,),
                                        Text("\$${discountedPrice.toStringAsFixed(2)}",
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green,
                                            )),
                                        SizedBox(width: 5,),
                                        Text(dicountOffer,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                            )),
                                      ],
                                    ):Container(),
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
                                  PractitionerProductScreen()));
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
              ),

              SizedBox(height: 20,),






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
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>PractitionerAddressScreen()));
                    /*if(cartSelectedItems.toString().contains("true"))
                    {
                      placeOrder();
                    }*/
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
    );
  }

  void _modelDeleteConfirmation(BuildContext context,String id) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Image.asset(
                            'assets/close_icc.png',
                            width: 14,
                            height: 14,
                          )),
                      const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Lottie.asset('assets/yoga.json', height: 120, width: 120),
                      const SizedBox(height: 5),
                      Text(
                        "Are you sure?",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "You want to remove this item",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFE3E3E3)),
                            child: Center(
                              child: Text(
                                "No",
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
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.of(ctx).pop();
                            deleteCartProduct(id);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.darkBrown),
                            child: Center(
                              child: Text(
                                "Yes",
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
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }
  double calculateTheAmount(String categoryId,int itemPrice){
    double totalPrice=0.0;
    int discount=0;
    for(var proCat in membershipProductDisList){
      String catId=proCat.categoryId;
      if(categoryId==catId){
        discount=proCat.discount;
        print("discount $discount");
        break;
      }
    }
    double discountAmount= itemPrice * discount / 100;
    totalPrice=itemPrice-discountAmount;
    return totalPrice;
  }
  String calculatePercentage(String categoryId){
    String percentageOff="";
    int discount=0;
    for(var proCat in membershipProductDisList){
      String catId=proCat.categoryId;
      if(categoryId==catId){
        discount=proCat.discount;
        print("discount $discount");
        break;
      }
    }
    percentageOff="($discount% off)";
    return percentageOff;
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
      fetchCartItems(true);
    }
    else
    {
      Toast.show("${responseJSON['message'].toString()} Error: ${responseJSON['error'].toString()}",
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
   // Navigator.push(context, MaterialPageRoute(builder: (context)=>AddressScreen(cartIDs,subTotalAmount.toStringAsFixed(2))));

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
    var data = {"page":1,"user":userId.toString(),"pageSize":100};


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

      String categoryId=cartList[i]?['productDetails']?['category']?.toString()??"";

      num quantity = cartList[i]["quantity"] ?? 0;
      num price = cartList[i]["productDetails"]?["price"] ?? 0;
      int itemPriceInt = (quantity * price).toInt();

      double discountedPrice=0.0;
      if(membershipProductDisList.isNotEmpty){
        discountedPrice=calculateTheAmount(categoryId, itemPriceInt);
      }
      if(discountedPrice!=0.0){
        subTotalAmount=subTotalAmount+discountedPrice;
      }else{
        subTotalAmount=subTotalAmount+itemPriceInt;
      }
      //int totalAmount=cartList[i]["quantity"] * cartList[i]["productDetails"]["price"];
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
    super.initState();
    fetchMembershipCourses();

  }
  fetchMembershipCourses() async {
    setState(() {
      isLoading = true;
    });
    String? userId=await MyUtils.getSharedPreferences("user_id");
    ApiBaseHelper helper = ApiBaseHelper();

    Map<String, dynamic> requestBody = {
      "user_id": userId
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('course_management/getCourseAndMembership', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      membershipId=responseJSON['data']?['membership']?['membership_id']?.toString()??"";
      if(responseJSON['data']?['membership']==null){
        isMembershipPurchased=false;
      }else{
        isMembershipPurchased=true;
      }

    }else{
      isMembershipPurchased=false;
    }
    setState(() {
      isLoading = false;
    });
    if(isMembershipPurchased){
      fetchMembershipDetails();
    }else{
      fetchCartItems(false);
    }



  }
  fetchMembershipDetails() async {
    setState(() {
      isLoading = true;
    });
    String? userId=await MyUtils.getSharedPreferences("user_id");
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "id": membershipId,
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_management/view', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      var result=responseJSON['result'];
      membershipProductDisList.clear();
      var data = result['product_categories'];
      List proList = (data is List) ? data : (data != null ? [data] : []);
      for(var proCat in proList){
        String categoryid=proCat['category_id']?.toString()??"";
        int dicount=proCat['discount']??0;
        String _id=proCat['_id']?.toString()??"";
        membershipProductDisList.add(membershipProducts(categoryid, dicount, _id));
      }

    }
    setState(() {
      isLoading = false;
    });
    fetchCartItems(false);
  }

}
class membershipProducts{
  String categoryId;
  int discount;
  String id;

  membershipProducts(this.categoryId, this.discount, this.id);
}