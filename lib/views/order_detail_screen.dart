// order_details_screen.dart
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/utils/order_model.dart';
import 'package:vedic_health/views/order_return_screen.dart';
import 'package:vedic_health/views/order_tracking_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import 'package:vedic_health/views/write_review.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';

import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';

class OrderDetailsScreen extends StatefulWidget{
  var order;
  bool isReturnedOrder;
  bool isCancelledOrder;
  String returnDays;
  OrderDetailsScreen(this.order,this.isReturnedOrder,this.isCancelledOrder,this.returnDays,{super.key,});
  orderDetailsState createState()=>orderDetailsState();
}
class orderDetailsState extends State<OrderDetailsScreen> {

  var orderStatusColor=Colors.cyan;
  String orderId="";
  String invoiceNo="";
  String totalAmount="";
  String deliveryCharge="";
  String discountAmount="";
  String grandTotal="";
  String status="";
  List<orderItemsSeries> orderItems=[];
  String pickupDate="";
  String shippedDate="";
  String deliveredDate="";
  String statusKey="";
  String statusName="";

  String shippingAddressName="";
  String shippingAddress="";
  String shippingAddressPhone="";
  String orderCreatedAt="";

  bool isShowReturnHeader=false;
  String returnOrderId="";
  String returnId="";
  List<returnItemsSeries> returnProductList=[];
  String returnStatus="";
  String returnRequestedAt="";

  String productId="";
  String categoryId="";
  bool showReturnBtn=false;





  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    orderStatusColor=_findLabelColor(statusKey);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              // App Bar
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Return Info Card (if returned)
                      if (statusKey == 'order_return' && isShowReturnHeader)
                        Card(
                          elevation: 1,
                          color: const Color(0xFFFCF6EF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                            side: const BorderSide(
                              color: Color(0xFFDD933B),
                            ),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15),
                                    children: [
                                      const TextSpan(
                                          text:
                                          'Order Id: '),
                                      TextSpan(
                                        text: '#$returnOrderId',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4,),
                                RichText(
                                  text: TextSpan(
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 15),
                                    children: [
                                      const TextSpan(
                                          text:
                                          'Return Id: '),
                                      TextSpan(
                                        text: '#$returnId',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 4,),
                                ListView.builder(
                                    itemCount: returnProductList.length,
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (itemContext,itemIndex){
                                      String proId=returnProductList[itemIndex].productId;
                                      String proprice=returnProductList[itemIndex].productPrice;
                                      String quantity=returnProductList[itemIndex].quantity;
                                      String proName=returnProductList[itemIndex].productName;
                                      String discount=returnProductList[itemIndex].discount;
                                      String discountedPrice=returnProductList[itemIndex].discountedPrice;
                                      String status=returnProductList[itemIndex].status;
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 4),
                                        decoration: BoxDecoration(
                                          color: Color(0xFFE1F6F0).withOpacity(0.1), // background color
                                          border: Border.all(
                                            color: Color(0xFFDBDBDB), // border color
                                            width: 1, // border width
                                          ),
                                          borderRadius: BorderRadius.circular(7), // corner radius
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                proName,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                "Quantity: $quantity",
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4,),
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  children: [
                                                    const TextSpan(
                                                        text:
                                                        'Product Price: '),
                                                    TextSpan(
                                                      text: '\$$proprice',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4,),
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  children: [
                                                    const TextSpan(
                                                        text:
                                                        'Discount: '),
                                                    TextSpan(
                                                      text: '\$$discount',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4,),
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  children: [
                                                    const TextSpan(
                                                        text:
                                                        'Discounted Price: '),
                                                    TextSpan(
                                                      text: '\$$discountedPrice',
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              RichText(
                                                text: TextSpan(
                                                  style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 15),
                                                  children: [
                                                    const TextSpan(
                                                        text:
                                                        'Status: '),
                                                    TextSpan(
                                                      text: status,
                                                      style: const TextStyle(
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                                SizedBox(height: 4,),
                                ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                    const Color(0xFF865940),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                        BorderRadius.circular(8)),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 18, vertical: 0),
                                    minimumSize: const Size(0, 32),
                                    elevation: 0,
                                  ),
                                  child:  Text(returnStatus,
                                      style:
                                      TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      // Order Status Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Order Status',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: orderStatusColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              statusName,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Main Product Card
                      Card(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: Colors.white,
                        child: Padding(
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
                                itemCount: orderItems.length,
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (itemContext,itemIndex){
                                  String productId=orderItems[itemIndex].itemId;
                                  String productName=orderItems[itemIndex].productName;
                                  String productImage=orderItems[itemIndex].productImage;
                                  String brandName=orderItems[itemIndex].productBrand;
                                  String productPruce=orderItems[itemIndex].productPrice;
                                  String finalImageUrl="";
                                  String quantitiy=orderItems[itemIndex].quantity;
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
                                            const SizedBox(height: 4,),
                                            Text(
                                              '\$$productPruce',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            if (statusKey == 'order_delivered')
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
                                                        Expanded(
                                                          child: OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) =>
                                                                      WriteReviewScreen(
                                                                        productName: productName,
                                                                        brandName: brandName,
                                                                        productImage: finalImageUrl,
                                                                        productId: productId,
                                                                      ),
                                                                ),
                                                              );
                                                            },
                                                            style: OutlinedButton.styleFrom(
                                                              backgroundColor: Colors.white,
                                                              side: const BorderSide(
                                                                  color: Color(0xFF865940)),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                  BorderRadius.circular(20)),
                                                              padding: const EdgeInsets.symmetric(
                                                                  vertical: 12),
                                                            ),
                                                            child: const Text('Write a Review',
                                                                style: TextStyle(
                                                                    fontSize: 12,
                                                                    color: Color(0xFF865940))),
                                                          ),
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
                            /*const SizedBox(height: 4,),
                            Text(
                              '\$$grandTotal',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),*/
                           /* Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: order.items.isNotEmpty &&
                                          order.items[0].imageUrl != null
                                      ? Image.asset(
                                          order.items[0].imageUrl!,
                                          width: 90,
                                          height: 90,
                                          fit: BoxFit.cover,
                                        )
                                      : Container(
                                          width: 70,
                                          height: 70,
                                          color: Colors.grey[200]),
                                ),
                                const SizedBox(width: 16),
                                // Product Info
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        order.items[0].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Rasa Herbs',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Order ID - ${order.orderId}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${order.items[0].price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),*/


                            if (statusKey == 'order_delivered') ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: showReturnBtn?OutlinedButton(
                                      onPressed: () {
                                       /* Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    OrderReturnScreen(
                                                      order: widget.order,
                                                    )));*/
                                        _modalBottomReturnDialog(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Color(0xFF865940)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text('Return Order',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF865940))),
                                    ):Container(),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => ProductDetailScreen(productId, categoryId)));
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Color(0xFF865940)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text('Buy Again',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF865940))),
                                    ),
                                  ),
                                  const SizedBox(width: 8),

                                ],
                              ),
                            ]
                            else if (statusKey != 'order_delivered'&&widget.isReturnedOrder==false&&widget.isCancelledOrder==false) ...[
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _modelBottomTrackOrder(context);
                                        /*Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const DeliveryTrackingScreen(),
                                            ));*/
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFF865940),
                                        side: BorderSide.none,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text('Track Order',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.white)),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () {
                                        _modalBottomCancelReturn(context);
                                      },
                                      style: OutlinedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        side: const BorderSide(
                                            color: Color(0xFF865940)),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                      ),
                                      child: const Text('Cancel Order',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF865940))),
                                    ),
                                  ),
                                ],
                              ),
                            ]
                          ]),
                        ),
                      ),

                      const SizedBox(height: 18),
                      if (statusKey == 'order_delivered')
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF6FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Center(
                              child: Text(
                                'Download Invoice',
                                style: TextStyle(
                                  color: Color(0xFF1DA1F2),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 18),

                      // Payment Detail
                      const Text(
                        'Payment Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildPaymentRow('Sub Total', totalAmount),
                              _buildPaymentRow('Discount', discountAmount),
                              _buildPaymentRow('Delivery Charges', deliveryCharge),
                              const Divider(height: 24, thickness: 1),
                              _buildPaymentRow('Grand Total', grandTotal, isTotal: true),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),


                      // Shipping Address
                      const Text(
                        'Shipping Address',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildShippingContainer(),
                     /* Card(
                        elevation: 0,
                        color: const Color(0xFFDBDBDB),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        margin: EdgeInsets.zero,
                        child: SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  shippingAddressName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shippingAddress,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  shippingAddressPhone,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),*/
                      const SizedBox(height: 20),

                      // Product Detail
                     /* const Text(
                        'Product Detail',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: order.items.map((item) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      if (item.imageUrl != null)
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: Image.asset(
                                            item.imageUrl!,
                                            width: 40,
                                            height: 40,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(item.name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold)),
                                          Text('QTY. ${item.quantity}',
                                              style: const TextStyle(
                                                  color: Colors.grey,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Text('${item.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 20),*/


                    ],
                  ),
                ),
              ),
            ])));
  }
  String formatCreatedAt(String createdAt) {
    try {
      DateTime dateTime = DateTime.parse(createdAt).toLocal();
      return DateFormat('dd MMM, yyyy hh:mma').format(dateTime);
    } catch (e) {
      return createdAt; // अगर parsing fail हो जाए तो original value लौटाएगा
    }
  }
  Widget _buildShippingContainer(){
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFE1F6F0), // background color
        border: Border.all(
          color: Color(0xFFDBDBDB), // border color
          width: 1, // border width
        ),
        borderRadius: BorderRadius.circular(7), // corner radius
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset("assets/loc_ic.png",height: 24,width: 20,),
            SizedBox(width: 10,),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shippingAddressName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  shippingAddress,
                  style: const TextStyle(color: Colors.black87),
                ),
                const SizedBox(height: 4),
                Text(
                  shippingAddressPhone,
                  style: const TextStyle(color: Colors.black87),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
  Widget _buildPaymentRow(String label, String amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
          Text(
            '\$${amount}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  void _modalBottomCancelReturn(BuildContext context) {
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
                      "Do you really want to cancel order",
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
                        cancelOrder();
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
  void _modalBottomReturnDialog(BuildContext context) {
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
                        "Return?",
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
                          "To return a product, email info@vedichealth.org with your Order ID, the product name and the reason of returning the order.",
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
                                "Back",
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
                            openEmailAppReturn();
                            Navigator.of(ctx).pop();

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
                                "Write a Mail",
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
  void openEmailAppReturn()async{
    final String subject = 'Return Request for Order #$orderId';
    final String body = '''
Hello Team,

I would like to request a return for the product I received under Order #$orderId.

Reason for return: [Please specify the reason, e.g., wrong item delivered, defective product, size issue, etc.]

Kindly let me know the next steps to process the return.

Thank you,
[Your Name]
[Your Contact Number]
''';

    final Uri emailUri = Uri.parse(
      'mailto:info@vedichealth.org?subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );
    try {
      final bool launched = await launchUrl(
        emailUri,
        mode: LaunchMode.externalApplication, // important for Android 12+
      );
      if (!launched) {
        throw Exception('Could not launch email app');
      }
    } catch (e) {
      print('Error launching email app: $e');
      Toast.show(
          "Could not launch email app. Please open the email app and write a email",
          duration: Toast.lengthLong,
          backgroundColor: Colors.red);
    }
    /*if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      Toast.show(
          "Could not launch email app. Please open the email app and write a email",
          duration: Toast.lengthLong,
          backgroundColor: Colors.red);
    }*/
  }
  void _modelBottomTrackOrder(BuildContext context) {

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            int currentIndex = 1;
            String createdDate=formatCreatedAt(orderCreatedAt);
            String pickDate=formatCreatedAt(pickupDate);
            String shipDate=formatCreatedAt(shippedDate);
            String deliverDate=formatCreatedAt(deliveredDate);

            if(pickDate.isNotEmpty && shipDate.isEmpty && deliverDate.isEmpty){
              currentIndex=2;
            }else if(pickDate.isNotEmpty && shipDate.isNotEmpty && deliverDate.isEmpty){
              currentIndex=3;
            }else if(pickDate.isNotEmpty && shipDate.isNotEmpty && deliverDate.isNotEmpty){
              currentIndex=4;
            }




            final List<Map<String, String>> statuses =  [
              {"title": "Order Received", "date": createdDate},
              {"title": "Order Packed", "date": createdDate},
              {"title": "Order Shipped", "date": pickDate},
              {"title": "Out for Delivery", "date": shipDate},
              {"title": "Delivered", "date": deliverDate},
            ];


            return Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
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
                      const Text(
                        "Package Status",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700),
                      ),
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
                  _buildTimeline(statuses, currentIndex),
                ],
              ),
            );
          }),
    );
  }
  Widget _buildTimeline(List<Map<String, String>> statuses, int currentIndex) {
    return Column(
      children: List.generate(statuses.length, (index) {
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == statuses.length - 1;

        return Container(

          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Column(
                children: [
                  // Dot indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF00DB00)
                          : Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: isCompleted
                          ? [
                        BoxShadow(
                          color: const Color(0xFF00DB00).withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 2,
                        )
                      ]
                          : null,
                    ),
                    child: isCurrent
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  // Vertical line
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted
                          ? const Color(0xFF00DB00)
                          : Colors.grey[300],
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Status text
              Expanded(
                child:Padding(  padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statuses[index]["title"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                        isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statuses[index]["date"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isCompleted ? Colors.grey : Colors.grey[400],
                      ),
                    ),
                  ],
                ),)
              ),
            ],
          ),
        );
      }),
    );
  }
   @override
   void initState() {
     super.initState();
     _getDataFromDynamicData();
   }
   _getDataFromDynamicData(){
      var orderDetails=widget.order;
      orderId=orderDetails['_id']?.toString()??"";
      invoiceNo=orderDetails['invoiceNo']?.toString()??"";
      totalAmount=orderDetails['totalAmount']?.toString()??"";
      deliveryCharge=orderDetails['deliveryCharge']?.toString()??"";
      discountAmount=orderDetails['discountAmount']?.toString()??"";
      grandTotal=orderDetails['grandTotal']?.toString()??"";
      status=orderDetails['status']?.toString()??"";
      orderCreatedAt=orderDetails['created_at']?.toString()??"";

      if(orderDetails['address']!=null){
        shippingAddressName=orderDetails['address']?['name']?.toString()??"";
        shippingAddress="${orderDetails['address']?['flatNo']?.toString()??""},${orderDetails['address']?['area']?.toString()??""},${orderDetails['address']?['city']?.toString()??""},${orderDetails['address']?['state']?.toString()??""},${orderDetails['address']?['country']?.toString()??""},${orderDetails['address']?['pincode']?.toString()??""}";
        shippingAddressPhone=orderDetails['address']?['mobile']?.toString()??"";
      }else{
        shippingAddressName="NA";
      }
     List<dynamic> odItemsProduct=(orderDetails['orderProducts'] as List?)??[];
     List<dynamic> odItems=(orderDetails['orderItems'] as List?) ?? [];
     for(int j=0;j<odItems.length;j++){
       String itemId=odItems[j]['_id']?.toString()??"";
       String quantity=odItems[j]['quantity']?.toString()??"";
       String productPrice=odItems[j]['productPrice']?.toString()??"";
       String productName=odItems[j]['productName']?.toString()??"";
       String productBrand=odItems[j]['productBrand']?.toString()??"";
       String productImage="";
       for(int k=0;k<odItemsProduct.length;k++){
         String proId=odItemsProduct[k]['_id']?.toString()??"";
         String imageUrl=odItemsProduct[k]['coverImage']?.toString()??"";
         /*List<dynamic> proImages=(odItemsProduct[k]['additionalImages'] as List?) ?? [];
         if(proImages.isNotEmpty){
           imageUrl=proImages[0]?.toString()??"";
         }*/
         if(itemId == proId){
           productImage=imageUrl;
           productId=proId;
           categoryId=odItemsProduct[k]['category']?.toString()??"";
         }



       }
       orderItems.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));

     }
      pickupDate=orderDetails['deliveryDates']?['pickupDate']?.toString()??"";
      shippedDate=orderDetails['deliveryDates']?['shippedDate']?.toString()??"";
      deliveredDate=orderDetails['deliveryDates']?['deliveredDate']?.toString()??"";
      statusKey="";
      statusName="";
      if(widget.isReturnedOrder){
        statusName="Return Placed";
        statusKey="order_return";
      }
      else if(widget.isCancelledOrder){
        statusName="Order Cancelled";
        statusKey="order_cancelled";
      }
      else if(pickupDate.isEmpty && shippedDate.isEmpty && deliveredDate.isEmpty){
       statusName="Order Ready";
       statusKey="order_pack";
     }
      else if(pickupDate.isNotEmpty && shippedDate.isEmpty && deliveredDate.isEmpty){
       statusName="Order Shipped";
       statusKey="order_pickup";
      }else if(pickupDate.isNotEmpty && shippedDate.isNotEmpty && deliveredDate.isEmpty){
       statusName="Out For Delivery";
       statusKey="order_shipped";
      }else if(pickupDate.isNotEmpty && shippedDate.isNotEmpty && deliveredDate.isNotEmpty){
       statusName="Order Delivered";
       statusKey="order_delivered";
       int rtDays=int.parse(widget.returnDays);
       showReturnBtn=canShowReturnButton(deliveredDate, rtDays);
      }


      if(widget.isReturnedOrder && orderDetails['returnData']!=null){
        isShowReturnHeader=true;
        List<dynamic> returnList=(orderDetails["returnData"] as List?) ?? [];
        for(int j=0;j<returnList.length;j++){
          returnOrderId=returnList[j]['orderId']?.toString()??"";
          returnId=returnList[j]['_id']?.toString()??"";
          returnStatus=returnList[j]['status']?.toString()??"";
          String createdAt=returnList[j]['created_at']?.toString()??"";
          returnRequestedAt=formatCreatedAt(createdAt);
          List<dynamic> productList=(returnList[j]['products'] as List?) ?? [];
          for(int i=0;i<productList.length;i++){
            String proId=productList[i]?['productId']?.toString()??"";
            String proPrice=productList[i]?['productPrice']?.toString()??"";
            String quantity=productList[i]?['quantity']?.toString()??"";
            String proName=productList[i]?['productName']?.toString()??"";
            String discount=productList[i]?['discount']?.toString()??"";
            String status=productList[i]?['status']?.toString()??"";
            String discountedPrice=productList[i]?['discountedPrice']?.toString()??"";
            returnProductList.add(returnItemsSeries(proId, proPrice, quantity, proName, discount, status, discountedPrice));
          }
        }
      }

     /* statusName="Order Delivered";
      statusKey="order_delivered";
      showReturnBtn=true;*/



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
  cancelOrder() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "orderId": orderId // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('order-management/cancelOrder', resModel, context);
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    var responseJSON= json.decode(response.toString());
    print(responseJSON);
    if(responseJSON["statusCode"]==200){
      Toast.show(responseJSON['message']?.toString()??"Order Cancelled Successfully",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _finishScreen();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }



  }
  _finishScreen(){
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
  bool canShowReturnButton(String orderDateString, int allowedDays) {
    try {
      DateTime orderDate = DateTime.parse(orderDateString);
      DateTime currentDate = DateTime.now();
      int differenceInDays = currentDate
          .difference(orderDate)
          .inDays;
      return differenceInDays <= allowedDays;
    }catch(e){
      print("error parsing $e");
      return false;
    }
  }
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
class returnItemsSeries{
  String productId;
  String productPrice;
  String quantity;
  String productName;
  String discount;
  String status;
  String discountedPrice;

  returnItemsSeries(this.productId, this.productPrice, this.quantity,
      this.productName, this.discount, this.status, this.discountedPrice);
}
