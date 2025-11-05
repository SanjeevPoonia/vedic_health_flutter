import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:flutter/material.dart';

import '../../network/Utils.dart';
import '../../network/api_helper.dart';

class BookedEventScreen extends StatefulWidget{
  _bookedEventsScreen createState()=>_bookedEventsScreen();
}
class _bookedEventsScreen extends State<BookedEventScreen>{

  List<dynamic> bookedEventList=[];
  bool isLoading=false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: Loader())
            : Column(
          children: [
            // App Bar
            Card(
              elevation: 2,
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
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text(
                            "My Booked Events",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10,),
            bookedEventList.isEmpty?
            Center(child: Padding(padding: EdgeInsets.all(16),
              child: Text("No event tickets found. Book your first event now to begin your experience with us",
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey
                ),),

            ),):
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: bookedEventList.length,
                itemBuilder: (context, index) {



                  return GestureDetector(
                    onTap: () {
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderDetailsScreen(order,isReturn,isCancel,returnDays),
                        ),
                      ).then((_) {
                        _fetchTheOrders(); // clear & clean syntax
                      });*/
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          /*Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID: $orderId',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ListView.builder(
                                    itemCount: orderItem.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (itemContext,itemIndex){
                                      String productName=orderItem[itemIndex].productName;
                                      String productImage=orderItem[itemIndex].productImage;
                                      String finalImageUrl="";
                                      String quantitiy=orderItem[itemIndex].quantity;
                                      if(productImage.isNotEmpty){
                                        finalImageUrl=AppConstant.appBaseURL+productImage;
                                      }
                                      return Row(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          ClipRRect(
                                            borderRadius: BorderRadius.circular(16), // rounded corners
                                            child: CachedNetworkImage(
                                              height: 80,
                                              width: 80,
                                              imageUrl: finalImageUrl,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) => Container(
                                                color: Colors.grey[200],
                                                child: const Center(
                                                  child: CircularProgressIndicator(strokeWidth: 2),
                                                ),
                                              ),
                                              errorWidget: (context, url, error) =>
                                              const Icon(Icons.error, color: Colors.red),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  productName,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  "Quantity: $quantitiy",
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                if (orderStatusKey == 'order_delivered')
                                                  Column(
                                                    children: [
                                                      const SizedBox(height: 4),
                                                      GestureDetector(
                                                        onTap: () {
                                                          // Handle rate product
                                                        },
                                                        child: Row(
                                                          mainAxisSize:
                                                          MainAxisSize.min,
                                                          children: [
                                                            const Text(
                                                              'Rate this product',
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                            const SizedBox(
                                                                width: 4),
                                                            Row(
                                                              children:
                                                              List.generate(5,
                                                                      (index) {
                                                                    return const Icon(
                                                                      Icons.star_border,
                                                                      size: 18,
                                                                      color:
                                                                      Colors.amber,
                                                                    );
                                                                  }),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                const SizedBox(height: 4,),
                                Text(
                                  '\$$orderTotalAmount',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                              ],
                            ),
                          ),
                          // Status Label
                          Positioned(
                            top: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  bottomLeft: Radius.circular(8),
                                ),
                              ),
                              child: Text(
                                orderStatusName,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          // Arrow icon at center right
                          Positioned(
                            right: 16,
                            top: 0,
                            bottom: 0,
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),*/
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchEventTickets();
  }
  fetchEventTickets() async {
    setState(() {
      isLoading = true;
    });
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "page": 1, // Assuming default page number
      "pageSize": 50 // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'event_management/getAllEventBookings', resModel, context);
    var responseJSON= json.decode(response.toString());





    setState(() {
      isLoading = false;
    });
  }


}