import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/utils/order_model.dart';
import 'package:vedic_health/views/login_screen.dart';
import 'package:vedic_health/views/product_detail_screen.dart';
import 'package:vedic_health/views/track_return_screen.dart';
import 'package:vedic_health/views/write_review.dart';

class OrderReturnScreen extends StatefulWidget {
  final Order order;
  const OrderReturnScreen({super.key, required this.order});

  @override
  State<OrderReturnScreen> createState() => _OrderReturnScreenState();
}

class _OrderReturnScreenState extends State<OrderReturnScreen> {
  String? selectedReason;

  String? _selectedReturnReason;
  String? _selectedPickupTime;
  final TextEditingController _otherReasonController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final statusInfo = orderStatusMap[widget.order.status]!;
    final statusLabel = statusInfo['label'];
    final statusColor = statusInfo['color'] as Color;

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
                              "Product Return",
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
                  padding: const EdgeInsets.all(14),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order ID - ${widget.order.orderId}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: statusColor,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                statusLabel,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),

                        // Product Info
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Product Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: widget.order.items.isNotEmpty &&
                                          widget.order.items[0].imageUrl != null
                                      ? Image.asset(
                                          widget.order.items[0].imageUrl!,
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
                                        widget.order.items[0].name,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Rasa Herbs',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Category - Ayurvedic Herbals',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${widget.order.items[0].price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ),

                        // Payment Detail
                        const Text(
                          'Payment Detail',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                            elevation: 0,
                            color: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(color: Colors.grey),
                            ),
                            child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(children: [
                                  _buildPaymentRow('Sub Total',
                                      widget.order.paymentDetail.subTotal),
                                  _buildPaymentRow('Discount',
                                      widget.order.paymentDetail.discount),
                                  _buildPaymentRow(
                                      'Delivery Charges',
                                      widget
                                          .order.paymentDetail.deliveryCharges),
                                  _buildPaymentRow('Grand Total',
                                      widget.order.paymentDetail.grandTotal),
                                ]))),
                        const SizedBox(
                          height: 12,
                        ),
                        // Return Reason
                        const Text(
                          'Product Return',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Card(
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text("Return Reason"),
                                  const SizedBox(height: 8),
                                  GestureDetector(
                                    onTap: () async {
                                      String? result = await showDialog<String>(
                                        context: context,
                                        builder: (context) =>
                                            const ReturnReasonDialog(),
                                      );
                                      if (result != null) {
                                        setState(() {
                                          selectedReason = result;
                                        });
                                      }
                                    },
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        // hintText: "data",
                                        // hint: Text("data"),
                                        hintStyle:
                                            TextStyle(color: Colors.black),
                                        border: OutlineInputBorder(),
                                        // hintText: "Select",
                                      ),
                                      child: Text(
                                        selectedReason ?? '',
                                        style: TextStyle(
                                          color: selectedReason == null
                                              ? Colors.grey
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Mention other Reason"),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _otherReasonController,
                                    maxLines: 2,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Enter",
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Pick up Date"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Select",
                                    ),
                                    items: ["Tomorrow", "Day After Tomorrow"]
                                        .map((date) => DropdownMenuItem(
                                              value: date,
                                              child: Text(date),
                                            ))
                                        .toList(),
                                    onChanged: (value) {},
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Pick up Time"),
                                  const SizedBox(height: 8),
                                  DropdownButtonFormField<String>(
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: "Select",
                                    ),
                                    items: [
                                      "10 AM - 12 PM",
                                      "1 PM - 3 PM",
                                      "4 PM - 6 PM"
                                    ]
                                        .map((time) => DropdownMenuItem(
                                              value: time,
                                              child: Text(time),
                                            ))
                                        .toList(),
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedPickupTime = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  const Text("Comment"),
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: _commentController,
                                    maxLines: 3,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText:
                                          "Enter any additional details...",
                                    ),
                                  ),
                                ]),
                          ),
                        ),
                      ]),
                ),
              ),
              // Bottom Action Buttons
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: const Color(0xFFD10028),
                          side: const BorderSide(color: Color(0xFFD10028)),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel Return',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_selectedReturnReason == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a return reason'),
                              ),
                            );
                            _modalBottomReturn();
                            return;
                          }
                          // Process return request
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF662A09),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Yes, Return',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }

  void _modalBottomReturn() {
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
                      "Do you really want to return order",
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

                        Route route = MaterialPageRoute(
                            builder: (context) => TrackReturnScreen(
                                  order: widget.order,
                                ));
                        Navigator.pop(context);
                        Navigator.push(context, route);
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

  Widget _buildPaymentRow(String label, double amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            label == 'Discount'
                ? '₹ ${amount.toStringAsFixed(2)}'
                : '\$${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
      ),
    );
  }
}

class ReturnReasonDialog extends StatefulWidget {
  const ReturnReasonDialog({super.key});

  @override
  State<ReturnReasonDialog> createState() => _ReturnReasonDialogState();
}

class _ReturnReasonDialogState extends State<ReturnReasonDialog> {
  int? selectedIndex;

  final List<String> reasons = [
    'Damage or Defect',
    'Did not meet Expectations',
    'Wrong Product received',
    'Packaging Issue',
    'Other',
  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Return Reason",
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ),
            const SizedBox(height: 8),

            // Checkbox options
            ...List.generate(reasons.length, (index) {
              return CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(reasons[index]),
                value: selectedIndex == index,
                onChanged: (val) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              );
            }),
            const SizedBox(height: 8),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Back"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF560F17), // brown color
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: selectedIndex != null
                        ? () => Navigator.pop(context, reasons[selectedIndex!])
                        : null,
                    child: const Text("Continue"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
