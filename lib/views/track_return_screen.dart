// order_details_screen.dart
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/utils/order_model.dart';
import 'package:vedic_health/views/order_return_screen.dart';
import 'package:vedic_health/views/write_review.dart';

class TrackReturnScreen extends StatelessWidget {
  final Order order;

  const TrackReturnScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final statusInfo = orderStatusMap[order.status]!;
    final statusLabel = statusInfo['label'];
    final statusColor = statusInfo['color'];

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
                                    Row(
                                      children: [
                                        Icon(Icons.attach_money,
                                            color: Color(0xFF865940)),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: RichText(
                                            text: TextSpan(
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 15),
                                              children: [
                                                const TextSpan(
                                                    text:
                                                        'Refund is initiated for order ID: '),
                                                TextSpan(
                                                  text: '#${order.orderId}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
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
                                          child: const Text('Track',
                                              style: TextStyle(
                                                  color: Colors.white)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      'Estimated refund timing: Within 2-4 hours after we receive the item',
                                      style: TextStyle(
                                          color: Colors.brown,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),

                            // Main Product Card
                            Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              color: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              style:
                                                  TextStyle(color: Colors.grey),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Order ID - ${order.orderId}',
                                              style: const TextStyle(
                                                  color: Colors.grey),
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
                                  ),
                                  // const SizedBox(
                                  //   height: 16,
                                  // ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              _modalBottomCancelReturn(context),
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
                                          child: const Text('Cancel Return',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF865940))),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    WriteReviewScreen(
                                                  productName:
                                                      order.items[0].name,
                                                  brandName: 'Rasa Herbs',
                                                  productImage:
                                                      order.items[0].imageUrl,
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
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Expanded(
                                        child: OutlinedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderReturnScreen(
                                                          order: order,
                                                        )));
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
                                          child: const Text('Shop More',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: Color(0xFF865940))),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'Product Return',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 12),

                            Row(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 243,
                                      width: 8,
                                      margin: EdgeInsets.only(top: 5, left: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(1),
                                          color: Color(0xFFC4C4C4)),
                                    ),
                                    Container(
                                      height: 250,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFF00DB00),
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                              boxShadow: [
                                                BoxShadow(
                                                  offset: Offset(0, 1),
                                                  blurRadius: 6,
                                                  color: Color(0xFF00DB00)
                                                      .withOpacity(0.5),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Container(
                                            width: 18,
                                            height: 18,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.grey,
                                              border: Border.all(
                                                  width: 1,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding:
                                          EdgeInsets.only(left: 35, top: 5),
                                      height: 246,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Return Initiated",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF00DB00),
                                              )),
                                          Text("Drop of the item by Thu, May 1",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),
                                          Text(
                                              "Refund sent once we get the item",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),
                                          Text("Refund Initiated",
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.grey,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                          ])))
            ])));
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
                      "Do you really want to cancel return",
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
                        ToastContext().init(context);
                        Navigator.of(ctx).pop();

                        SharedPreferences preferences =
                            await SharedPreferences.getInstance();
                        await preferences.clear();

                        // Route route = MaterialPageRoute(
                        //     builder: (context) => TrackReturnScreen(
                        //           order: order,
                        //         ));
                        Navigator.pop(context);
                        // Navigator.push(context, route);
                        Toast.show("Product return successful!",
                            duration: Toast.lengthLong,
                            gravity: Toast.bottom,
                            backgroundColor: Colors.greenAccent);
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
}
