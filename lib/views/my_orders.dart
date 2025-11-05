import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/network/constants.dart';
import 'package:vedic_health/views/order_detail_screen.dart';
import 'package:vedic_health/utils/order_model.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../network/Utils.dart';
import '../network/api_helper.dart';

const Map<String, Map<String, dynamic>> orderStatusMap = {
  'delivered': {
    'label': 'Delivered',
    'color': Colors.green,
  },
  'out_for_delivery': {
    'label': 'Out for Delivery',
    'color': Colors.orange,
  },
  'cancelled': {
    'label': 'Cancelled',
    'color': Colors.red,
  },
  'returned': {
    'label': 'Returned',
    'color': Color.fromARGB(255, 0, 186, 199),
  },
};

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  _MyOrdersScreen createState() => _MyOrdersScreen();
}

class _MyOrdersScreen extends State<MyOrdersScreen> {
  String _selectedFilterKey = 'all';

  bool isLoading = false;
  bool isReturnLoading=false;
  bool isCancelledLoading=false;

  List<orderFilterList> filterList=[];

  List<dynamic> allOrderDynamicList=[];
  List<dynamic> notShippedDynamicList=[];
  List<dynamic> returnDynamicList=[];
  List<dynamic> cancelledDynamicList=[];

  List<orderListModel> allOrderList=[];
  List<orderListModel> notShippedList=[];
  List<orderListModel> returnOrderList=[];
  List<orderListModel> cancelledOrderList=[];

  String returnDays="2";

  @override
  void initState() {
    super.initState();
    _addFilterList();
    _fetchTheOrders();
  }
  _addFilterList(){
    filterList.add(orderFilterList("All Order", "all", true));
    filterList.add(orderFilterList("Not Yet Shipped", "not_shipped", false));
    filterList.add(orderFilterList("Return Orders", "return_orders", false));
    filterList.add(orderFilterList("Cancelled Orders", "cancelled_orders", false));
  }
   _fetchTheOrders(){
      fetchOrders();
      fetchReturnOrders();
      fetchCancelledOrders();
      }
  fetchOrders() async {
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
        'order-management/findUserOrders', resModel, context);


    var responseJSON= json.decode(response.toString());
    allOrderList.clear();
    allOrderDynamicList.clear();
    notShippedDynamicList.clear();
    notShippedList.clear();

    allOrderDynamicList=(responseJSON['data'] as List?) ?? [];
    for(int i=0;i<allOrderDynamicList.length;i++){
      String orderId=allOrderDynamicList[i]['_id']?.toString()??"";
      String invoiceNo=allOrderDynamicList[i]['invoiceNo']?.toString()??"";
      String totalAmount=allOrderDynamicList[i]['totalAmount']?.toString()??"";
      String deliveryCharge=allOrderDynamicList[i]['deliveryCharge']?.toString()??"";
      String discountAmount=allOrderDynamicList[i]['discountAmount']?.toString()??"";
      String grandTotal=allOrderDynamicList[i]['grandTotal']?.toString()??"";
      String status=allOrderDynamicList[i]['status']?.toString()??"";
      List<dynamic> odItemsProduct=(allOrderDynamicList[i]['orderProducts'] as List?)??[];
      List<orderItemsSeries> odSeriesList=[];
      List<dynamic> odItems=(allOrderDynamicList[i]['orderItems'] as List?) ?? [];
      for(int j=0;j<odItems.length;j++){
        String itemId=odItems[j]['_id']?.toString()??"";
        String quantity=odItems[j]['quantity']?.toString()??"";
        String productPrice=odItems[j]['productPrice']?.toString()??"";
        String productName=odItems[j]['productName']?.toString()??"";
        String productBrand=odItems[j]['productBrand']?.toString()??"";
        String productImage="";
        for(int k=0;k<odItemsProduct.length;k++){
          String proId=odItemsProduct[k]['_id']?.toString()??"";
          String imageUrl=odItemsProduct[k]['coverImage']?.toString()??"";;
         /* List<dynamic> proImages=(odItemsProduct[k]['additionalImages'] as List?) ?? [];
          if(proImages.isNotEmpty){
            imageUrl=proImages[0]?.toString()??"";
          }*/
          if(itemId == proId){
            productImage=imageUrl;
          }



        }
        odSeriesList.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));

      }

      String pickupdate=allOrderDynamicList[i]['deliveryDates']?['pickupDate']?.toString()??"";
      String shippedDate=allOrderDynamicList[i]['deliveryDates']?['shippedDate']?.toString()??"";
      String outForDelivery=allOrderDynamicList[i]['deliveryDates']?['outForDeliveryDate']?.toString()??"";
      String deliveryDate=allOrderDynamicList[i]['deliveryDates']?['deliveredDate']?.toString()??"";
      String statusKey="";
      String statusName="";



      if(status=="orderCanceled"){
        statusName="Order Cancelled";
        statusKey="order_cancelled";
      }else if(pickupdate.isEmpty && shippedDate.isEmpty && deliveryDate.isEmpty ){
        statusName="Order Ready";
        statusKey="order_pack";
        notShippedList.add(orderListModel(orderId, invoiceNo, totalAmount, deliveryCharge,
            discountAmount, grandTotal, status, odSeriesList,pickupdate,shippedDate,deliveryDate,statusKey,statusName));
        notShippedDynamicList.add(allOrderDynamicList[i]);
      }
      else if(pickupdate.isNotEmpty && shippedDate.isEmpty && deliveryDate.isEmpty){
        statusName="Order Shipped";
        statusKey="order_pickup";
      }else if(pickupdate.isNotEmpty && shippedDate.isNotEmpty && deliveryDate.isEmpty){
        statusName="Out For Delivery";
        statusKey="order_shipped";
      }else if(pickupdate.isNotEmpty && shippedDate.isNotEmpty && deliveryDate.isNotEmpty){
        statusName="Order Delivered";
        statusKey="order_delivered";
      }


      allOrderList.add(orderListModel(orderId, invoiceNo, totalAmount, deliveryCharge,
          discountAmount, grandTotal, status, odSeriesList,pickupdate,shippedDate,deliveryDate,statusKey,statusName));
    }

    returnDays=responseJSON['returnDays']?.toString()??"2";



    setState(() {
      isLoading = false;
    });
  }
  fetchReturnOrders() async {
    setState(() {
      isReturnLoading = true;
    });
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      setState(() {
        isReturnLoading = false;
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
        'returnOrder/getUserReturnOrder', resModel, context);


    var responseJSON= json.decode(response.toString());
    returnOrderList.clear();
    returnDynamicList.clear();


    returnDynamicList=(responseJSON['data'] as List?) ?? [];
    for(int i=0;i<returnDynamicList.length;i++){
      String orderId=returnDynamicList[i]['_id']?.toString()??"";
      String invoiceNo=returnDynamicList[i]['invoiceNo']?.toString()??"";
      String totalAmount=returnDynamicList[i]['totalAmount']?.toString()??"";
      String deliveryCharge=returnDynamicList[i]['deliveryCharge']?.toString()??"";
      String discountAmount=returnDynamicList[i]['discountAmount']?.toString()??"";
      String grandTotal=returnDynamicList[i]['grandTotal']?.toString()??"";
      String status=returnDynamicList[i]['status']?.toString()??"";
      List<dynamic> odItemsProduct=(returnDynamicList[i]['orderProducts'] as List?)??[];
      List<orderItemsSeries> odSeriesList=[];
      List<dynamic> odItems=(returnDynamicList[i]['orderItems'] as List?) ?? [];
      for(int j=0;j<odItems.length;j++){
        String itemId=odItems[j]['_id']?.toString()??"";
        String quantity=odItems[j]['quantity']?.toString()??"";
        String productPrice=odItems[j]['productPrice']?.toString()??"";
        String productName=odItems[j]['productName']?.toString()??"";
        String productBrand=odItems[j]['productBrand']?.toString()??"";
        String productImage="";
        for(int k=0;k<odItemsProduct.length;k++){
          String proId=odItemsProduct[k]['_id']?.toString()??"";
          String imageUrl="";
          List<dynamic> proImages=(odItemsProduct[k]['additionalImages'] as List?) ?? [];
          if(proImages.isNotEmpty){
            imageUrl=proImages[0]?.toString()??"";
          }
          if(itemId == proId){
            productImage=imageUrl;
          }
        }
        odSeriesList.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));
      }

      String statusKey="order_return";
      String statusName="Return";


      returnOrderList.add(orderListModel(orderId, invoiceNo, totalAmount, deliveryCharge,
          discountAmount, grandTotal, status, odSeriesList,"","","",statusKey,statusName));
    }



    setState(() {
      isReturnLoading = false;
    });
  }
  fetchCancelledOrders() async {
    setState(() {
      isCancelledLoading = true;
    });
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      setState(() {
        isCancelledLoading = false;
      });
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "userId": userId,
      "page": 1, // Assuming default page number
      "pageSize": 50 // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'order-management/getCancelOrder', resModel, context);


    var responseJSON= json.decode(response.toString());

    print("Cancelled Orders:${response.toString()}");
    cancelledOrderList.clear();
    cancelledDynamicList.clear();


    cancelledDynamicList=(responseJSON['data'] as List?) ?? [];
    for(int i=0;i<cancelledDynamicList.length;i++){
      String orderId=cancelledDynamicList[i]['_id']?.toString()??"";
      String invoiceNo=cancelledDynamicList[i]['invoiceNo']?.toString()??"";
      String totalAmount=cancelledDynamicList[i]['totalAmount']?.toString()??"";
      String deliveryCharge=cancelledDynamicList[i]['deliveryCharge']?.toString()??"";
      String discountAmount=cancelledDynamicList[i]['discountAmount']?.toString()??"";
      String grandTotal=cancelledDynamicList[i]['grandTotal']?.toString()??"";
      String status=cancelledDynamicList[i]['status']?.toString()??"";
      List<dynamic> odItemsProduct=(cancelledDynamicList[i]['orderProducts'] as List?)??[];
      List<orderItemsSeries> odSeriesList=[];
      List<dynamic> odItems=(cancelledDynamicList[i]['orderItems'] as List?) ?? [];
      for(int j=0;j<odItems.length;j++){
        String itemId=odItems[j]['_id']?.toString()??"";
        String quantity=odItems[j]['quantity']?.toString()??"";
        String productPrice=odItems[j]['productPrice']?.toString()??"";
        String productName=odItems[j]['productName']?.toString()??"";
        String productBrand=odItems[j]['productBrand']?.toString()??"";
        String productImage="";
        for(int k=0;k<odItemsProduct.length;k++){
          String proId=odItemsProduct[k]['_id']?.toString()??"";
          String imageUrl="";
          List<dynamic> proImages=(odItemsProduct[k]['additionalImages'] as List?) ?? [];
          if(proImages.isNotEmpty){
            imageUrl=proImages[0]?.toString()??"";
          }
          if(itemId == proId){
            productImage=imageUrl;
          }
        }
        odSeriesList.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));
      }

      String statusKey="order_cancelled";
      String statusName="Order Cancelled";


      cancelledOrderList.add(orderListModel(orderId, invoiceNo, totalAmount, deliveryCharge,
          discountAmount, grandTotal, status, odSeriesList,"","","",statusKey,statusName));
    }



    setState(() {
      isCancelledLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(child: CircularProgressIndicator())
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
                                  "My Orders",
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

                  // Filter Chips
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom:
                            BorderSide(color: Colors.grey.shade200, width: 1),
                      ),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: filterList.length,
                      itemBuilder: (context, index) {
                        String key = filterList[index].filterKey;
                        bool isSelected=filterList[index].isSelected;
                        String filterName=filterList[index].filterName;

                        final selected = _selectedFilterKey == key;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedFilterKey = key;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            decoration: BoxDecoration(
                              color: selected
                                  ? const Color(0xFFF38328)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                filterName,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: selected ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  _selectedFilterKey=="all"?
                    allOrderList.isEmpty?
                        Center(child: Padding(padding: EdgeInsets.all(16),
                          child: Text("You haven’t placed any orders yet. Please go ahead and place your first order to get started.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey
                          ),),

                        ),):
                          Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: allOrderList.length,
                            itemBuilder: (context, index) {

                              var order=allOrderDynamicList[index];

                             /* final order = filteredOrders[index];
                              final statusInfo = orderStatusMap[order.status]!;*/


                              String orderId=allOrderList[index].orderId;
                              String orderStatusName=allOrderList[index].statusName;
                              String orderStatusKey=allOrderList[index].statusKey;
                              String orderTotalAmount=allOrderList[index].grandTotal;
                              var statusLabel = orderStatusName;
                              var statusColor = _findLabelColor(orderStatusKey);

                              List<orderItemsSeries>orderItem=allOrderList[index].orderItems;
                              bool isReturn=false;
                              bool isCancel=false;
                              if(orderStatusKey=="order_cancelled"){
                                isCancel=true;
                              }
                              if(orderStatusKey=="order_return"){
                                isReturn=true;
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          OrderDetailsScreen(order,isReturn,isCancel,returnDays),
                                    ),
                                  ).then((_) {
                                    _fetchTheOrders(); // clear & clean syntax
                                  });
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
                                      Padding(
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
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ):
                            _selectedFilterKey=="not_shipped"?
                            notShippedList.isEmpty?
                            Center(child: Padding(padding: EdgeInsets.all(16),
                              child: Text("No shipped orders found at the moment.",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey
                                ),),

                            ),):
                              Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                itemCount: notShippedList.length,
                                itemBuilder: (context, index) {
                                  var order=notShippedDynamicList[index];
                                  String orderId=notShippedList[index].orderId;
                                  String orderStatusName=notShippedList[index].statusName;
                                  String orderStatusKey=notShippedList[index].statusKey;
                                  String orderTotalAmount=notShippedList[index].grandTotal;
                                  var statusLabel = orderStatusName;
                                  var statusColor = _findLabelColor(orderStatusKey);

                                  List<orderItemsSeries>orderItem=notShippedList[index].orderItems;

                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              OrderDetailsScreen(order,false,false,returnDays),
                                        ),
                                      ).then((_) {
                                        _fetchTheOrders(); // clear & clean syntax
                                      });
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
                                          Padding(
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
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ):
                                _selectedFilterKey=="return_orders"?
                                    isReturnLoading?
                                    Center(child: CircularProgressIndicator()):
                                    returnOrderList.isEmpty?
                                    Center(child: Padding(padding: EdgeInsets.all(16),
                                      child: Text("You don’t have any return requests at the moment.",
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey
                                        ),),

                                    ),):
                                      Expanded(
                                        child: ListView.builder(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          itemCount: returnOrderList.length,
                                          itemBuilder: (context, index) {
                                            var order=returnDynamicList[index];
                                            String orderId=returnOrderList[index].orderId;
                                            String orderStatusName=returnOrderList[index].statusName;
                                            String orderStatusKey=returnOrderList[index].statusKey;
                                            String orderTotalAmount=returnOrderList[index].grandTotal;
                                            var statusLabel = orderStatusName;
                                            var statusColor = _findLabelColor(orderStatusKey);

                                            List<orderItemsSeries>orderItem=returnOrderList[index].orderItems;

                                            return GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderDetailsScreen(order,true,false,returnDays),
                                                  ),
                                                ).then((_) {
                                                  _fetchTheOrders(); // clear & clean syntax
                                                });
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
                                                    Padding(
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
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ):
                                      _selectedFilterKey=="cancelled_orders"?
                                          isCancelledLoading?
                                          Center(child: CircularProgressIndicator()):
                                          cancelledOrderList.isEmpty?
                                          Center(child: Padding(padding: EdgeInsets.all(16),
                                            child: Text("You don’t have any cancelled orders.",
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey
                                              ),),

                                          ),):
                                          Expanded(
                                            child: ListView.builder(
                                              padding: const EdgeInsets.symmetric(vertical: 8),
                                              itemCount: cancelledOrderList.length,
                                              itemBuilder: (context, index) {
                                                var order=cancelledDynamicList[index];
                                                String orderId=cancelledOrderList[index].orderId;
                                                String orderStatusName=cancelledOrderList[index].statusName;
                                                String orderStatusKey=cancelledOrderList[index].statusKey;
                                                String orderTotalAmount=cancelledOrderList[index].grandTotal;
                                                var statusLabel = orderStatusName;
                                                var statusColor = _findLabelColor(orderStatusKey);

                                                List<orderItemsSeries>orderItem=cancelledOrderList[index].orderItems;

                                                return GestureDetector(
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            OrderDetailsScreen(order,false,true,returnDays),
                                                      ),
                                                    ).then((_) {
                                                      _fetchTheOrders(); // clear & clean syntax
                                                    });
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
                                                        Padding(
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
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          )
                                          :Container(),
                ],
              ),
      ),
    );
  }
  _findLabelColor(String key){
    var color=Colors.green;
    if(key=="order_pack"){
      color=Colors.cyan;
    }else if(key=="order_pickup"){
      color=Colors.amber;
    }else if(key=="order_shipped"){
      color=Colors.orange;
    }else if(key=="order_delivered"){
      color=Colors.green;
    }else if(key=="order_return"){
      color=Colors.blueGrey;
    }else if(key=="order_cancelled"){
      color=Colors.red;
    }
    return color;
  }
}


class orderFilterList{
  String filterName;
  String filterKey;
  bool isSelected;

  orderFilterList(this.filterName, this.filterKey, this.isSelected);

}
class orderListModel{
  String orderId;
  String invoiceNo;
  String totalAmount;
  String deliveryCharge;
  String discountAmount;
  String grandTotal;
  String status;
  List<orderItemsSeries> orderItems=[];
  String pickupDate;
  String shippedDate;
  String deliveredDate;
  String statusKey;
  String statusName;

  orderListModel(
      this.orderId,
      this.invoiceNo,
      this.totalAmount,
      this.deliveryCharge,
      this.discountAmount,
      this.grandTotal,
      this.status,
      this.orderItems,
      this.pickupDate,
      this.shippedDate,
      this.deliveredDate,
      this.statusKey,
      this.statusName
      );
}
class orderItemsSeries{
  String itemId;
  String quantity;
  String productPrice;
  String productName;
  String productBrand;
  String productImage;

  orderItemsSeries(this.itemId, this.quantity, this.productPrice,
      this.productName, this.productBrand, this.productImage);
}
