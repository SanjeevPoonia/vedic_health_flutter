import 'dart:convert';

import 'package:flutter/material.dart';

import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../network/loader.dart';
import '../utils/app_theme.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({super.key});

  @override
  OrderHistoryState createState() => OrderHistoryState();
}

class OrderHistoryState extends State<OrderHistoryScreen> {
  int _isCheckedIndex = 0;
  bool isLoading = false;
  bool filterApplied=false;
  List<dynamic> orderSearchList = [];
  List<dynamic> orderList=[];
  var searchController = TextEditingController();
  int _page = 1;
  bool loadMoreData = true;
  late ScrollController _scrollController;
  bool isPagLoading = false;
  List<String> categoryList = [
    "All Orders",
    "Cancelled items",
    "Returned Orders",
    "Not yet Delivered",
    "Delivered Orders",
  ];

  final List<String> monthItems = [
    '2 Months',
    '3 Months',
    '4 Months',
    '5 Months',
  ];
  String? selectedMonthValue = '2 Months';

  final List<String> nameItems = [
    'Jhon Smith',
    'David',
    'Smith',
  ];
  String? selectedNameValue = 'David';

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.themeColor,
      child: SafeArea(
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
                          child: Text("My Orders",
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




            /*   const Center(
              child: Text(
                'Choose your favorite categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),*/


            const SizedBox(height: 15),
            Expanded(
                child: isLoading
                    ? Center(
                        child: Loader(),
                      )
                  /*  : orderList.length == 0
                        ? Center(
                            child: Text("No orders found !!"),
                          )*/
                        :


                ListView.builder(
                            itemCount: orderList.length,
                            controller: _scrollController,
                            itemBuilder: (BuildContext context, int pos) {
                              return Column(
                                children: [
                                  Container(
                                    margin: EdgeInsets.symmetric(horizontal: 10),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(color: Colors.black.withOpacity(0.5),width: 1)
                                    ),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 40,
                                         // margin: EdgeInsets.symmetric(horizontal: 10),

                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              color: AppTheme.themeColor,

                                          ),

                                          child: Row(
                                            children: [

                                               Padding(
                                                padding: EdgeInsets.only(left: 15),
                                                child: Text('Order Id: ',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 13,
                                                        color: Colors.white)),
                                              ),

                                              Text("#"+orderList[pos]["_id"].toString(),
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w600,
                                                      fontSize: 13,
                                                      color: Colors.white)),


                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 10),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [

                                              Text("Order Placed on: ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),


                                              Text(orderList[pos]["created_at"].toString(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 5),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [

                                              Text("Amount: ",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                  )),


                                              Text("\$"+orderList[pos]["totalAmount"].toString(),
                                                  style: TextStyle(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 5),

                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: Row(
                                            children: [
                                              Text("Order items:",
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    color: Colors.black,
                                                  )),
                                            ],
                                          ),
                                        ),

                                        SizedBox(height: 12),
                                        InkWell(
                                          onTap: () {
                                            /* if (pos == 0) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailScreen('Delivered',"")));
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OrderDetailScreen('Out',"")));
                                    }*/

                                        /*    Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailScreen('Delivered',
                                                            orderList[pos]["_id"])));*/
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                    color: const Color(0xFFD4D4D4),
                                                    width:1),
                                                borderRadius:
                                                    BorderRadius.circular(4)),
                                            width: double.infinity,
                                            padding:
                                                EdgeInsets.symmetric(vertical: 10),
                                            child: ListView.builder(
                                                shrinkWrap: true,
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                itemCount: orderList[pos]["orderItems"].length,
                                                itemBuilder:
                                                    (BuildContext context, int pos2) {
                                                  return Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          const SizedBox(width: 5),
                                                          Container(
                                                            width: 58,
                                                            height: 55,
                                                            decoration: BoxDecoration(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        5),
                                                                image: DecorationImage(
                                                                    fit: BoxFit.cover,
                                                                    image: AssetImage("assets/banner2.png"))),
                                                          ),
                                                          const SizedBox(width: 10),
                                                          Expanded(
                                                            child: Column(
                                                              children: [
                                                                Text(
                                                                    orderList[pos]["orderItems"][pos2]["productName"],
                                                                    style: TextStyle(
                                                                      fontSize: 13,
                                                                      fontWeight:
                                                                          FontWeight.w600,
                                                                      color: const Color(
                                                                          0xFf0B2239),
                                                                    ),
                                                                    maxLines: 3),
                                                                SizedBox(height: 5),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Order Quantity: ",
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w500,
                                                                          color: const Color(
                                                                                  0xFf0B2239)
                                                                              .withOpacity(
                                                                                  0.9),
                                                                        )),
                                                                    Text(
                                                                        orderList[pos]["orderItems"][pos2]["quantity"].toString(),
                                                                        style: TextStyle(
                                                                          fontSize: 13,
                                                                          fontWeight:
                                                                              FontWeight
                                                                                  .w600,
                                                                          color: const Color(
                                                                                  0xFf0B2239)
                                                                              .withOpacity(
                                                                                  0.9),
                                                                        )),
                                                                  ],
                                                                )
                                                              ],
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                            ),
                                                          ),
                                                          const SizedBox(width: 6),

                                                          const SizedBox(width: 4),
                                                        ],
                                                      ),
                                                      SizedBox(height: 5),
                                                     /* pos2==orderList[pos]
                                                      ["productOrders"]
                                                          .length-1?
                                                          Container():*/
                                                      Divider()
                                                    ],
                                                  );
                                                }),
                                          ),
                                        ),
                                        const SizedBox(height: 15)
                                      ],
                                    ),
                                  ),

                                  SizedBox(height: 18)
                                ],
                              );
                            }),




            ),


            isPagLoading
                ? Container(
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: Center(
                child: Loader(),
              ),
            )
                : Container(),

          ],
        ),
      )),
    );
  }

  void filterDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
                insetPadding: const EdgeInsets.all(10),
                scrollable: true,
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5)),
                //this right here
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 50,
                            decoration: BoxDecoration(
                                color: const Color(0xFFF3F3F3),
                                borderRadius: BorderRadius.circular(5)),
                            margin: const EdgeInsets.symmetric(horizontal: 7),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 15),
                                  child: Text('Filter',
                                      style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black)),
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: Image.asset(
                                      'assets/close_icc.png',
                                      width: 20,
                                      height: 20,
                                      color: Colors.black,
                                    )),
                                const SizedBox(width: 10)
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Select By',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCheckedIndex = 0;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isCheckedIndex == 0
                                          ? Image.asset(
                                              'assets/radio_enable.png',
                                              width: 20,
                                              height: 20)
                                          : Image.asset(
                                              'assets/radio_disable.png',
                                              width: 20,
                                              height: 20)),
                                  const SizedBox(width: 12),
                                  Text(categoryList[0],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCheckedIndex = 1;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isCheckedIndex == 1
                                          ? Image.asset(
                                              'assets/radio_enable.png',
                                              width: 20,
                                              height: 20)
                                          : Image.asset(
                                              'assets/radio_disable.png',
                                              width: 20,
                                              height: 20)),
                                  const SizedBox(width: 12),
                                  Text(categoryList[1],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCheckedIndex = 2;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isCheckedIndex == 2
                                          ? Image.asset(
                                          'assets/radio_enable.png',
                                          width: 20,
                                          height: 20)
                                          : Image.asset(
                                          'assets/radio_disable.png',
                                          width: 20,
                                          height: 20)),
                                  const SizedBox(width: 12),
                                  Text(categoryList[2],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCheckedIndex = 3;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isCheckedIndex == 3
                                          ? Image.asset(
                                              'assets/radio_enable.png',
                                              width: 20,
                                              height: 20)
                                          : Image.asset(
                                              'assets/radio_disable.png',
                                              width: 20,
                                              height: 20)),
                                  const SizedBox(width: 12),
                                  Text(categoryList[3],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 12, top: 5, bottom: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _isCheckedIndex = 4;
                                });
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: 30,
                                      height: 30,
                                      child: _isCheckedIndex == 4
                                          ? Image.asset(
                                              'assets/radio_enable.png',
                                              width: 20,
                                              height: 20)
                                          : Image.asset(
                                              'assets/radio_disable.png',
                                              width: 20,
                                              height: 20)),
                                  const SizedBox(width: 12),
                                  Text(categoryList[4],
                                      style: const TextStyle(
                                        fontSize: 13,
                                        color: Colors.black,
                                      )),
                                ],
                              ),
                            ),
                          ),
                        /*  const SizedBox(height: 16),
                          const Padding(
                            padding: EdgeInsets.only(left: 15),
                            child: Text('Ship to',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black)),
                          ),*/
                        /*  const SizedBox(height: 10),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFfF3F3F3)),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton2(
                              underline: Container(),
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 35),
                              hint: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: nameItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedNameValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedNameValue = value as String;
                                });
                              },
                              buttonHeight: 45,
                              itemHeight: 45,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.only(left: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2),
                                color: const Color(0xFfF3F3F3)),
                            margin: const EdgeInsets.symmetric(horizontal: 15),
                            child: DropdownButton2(
                              underline: Container(),
                              isExpanded: true,
                              icon: const Icon(
                                  Icons.keyboard_arrow_down_outlined,
                                  size: 35),
                              hint: Text(
                                'Select Item',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                              items: monthItems
                                  .map((item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                            fontSize: 14,
                                          ),
                                        ),
                                      ))
                                  .toList(),
                              value: selectedMonthValue,
                              onChanged: (value) {
                                setState(() {
                                  selectedMonthValue = value as String;
                                });
                              },
                              buttonHeight: 45,
                              itemHeight: 45,
                            ),
                          ),*/
                          const SizedBox(height: 35),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              //_applyFilters();
                            },
                            child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: AppTheme.themeColor,
                                    borderRadius: BorderRadius.circular(5)),
                                height: 52,
                                child: const Center(
                                  child: Text('Submit',
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white)),
                                )),
                          ),
                          const SizedBox(height: 35),
                        ],
                      ),
                    ),
                  ],
                ));
          });
        });
  }





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();

    fetchMyOrders();


  }

  fetchMyOrders() async {

    setState(() {
      isLoading = true;
    });



    String? userId=await MyUtils.getSharedPreferences("user_id");
    var data = {"user":userId.toString(),"page":1,"pageSize":10};

    print(data.toString());
    var requestModel = {'data': base64.encode(utf8.encode(json.encode(data)))};
    print(requestModel);

    ApiBaseHelper helper = ApiBaseHelper();
    var response = await helper.postAPI('order-management/findUserOrders', requestModel, context);



    setState(() {
      isLoading = false;
    });


    var responseJSON = json.decode(response.toString());
    print(response.toString());

    orderList = responseJSON["data"];

    setState(() {});
  }




}
