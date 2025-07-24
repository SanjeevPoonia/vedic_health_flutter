import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/order_detail_screen.dart';
import 'package:vedic_health/utils/order_model.dart';

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
  List<Order> _orders = sampleOrders;

  @override
  void initState() {
    super.initState();
    // fetchOrders();
  }

  // fetchOrders() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   String? userId = await MyUtils.getSharedPreferences("user_id");
  //   if (userId == null) {
  //     setState(() {
  //       isLoading = false;
  //     });
  //     return;
  //   }
  //   ApiBaseHelper helper = ApiBaseHelper();
  //   Map<String, dynamic> requestBody = {
  //     "user": userId,
  //     "page": 1, // Assuming default page number
  //     "pageSize": 10 // Assuming default page size
  //   };
  //   var resModel = {
  //     'data': base64.encode(utf8.encode(json.encode(requestBody)))
  //   };
  //   var response = await helper.postAPI(
  //       'order-management/findUserOrders', resModel, context);
  //   setState(() {
  //     isLoading = false;
  //   });
  //   var responseJSON = response;
  //   try {
  //     responseJSON = response is String ? json.decode(response) : response;
  //   } catch (e) {}
  //   if (responseJSON != null && responseJSON["data"] != null) {
  //     _orders = responseJSON["data"];
  //   } else {
  //     _orders = [];
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);

    final filterKeys = ['all', ...orderStatusMap.keys];
    final filterLabels = {
      'all': 'All',
      ...orderStatusMap.map((k, v) => MapEntry(k, v['label'] as String)),
    };

    final filteredOrders = _selectedFilterKey == 'all'
        ? _orders
        : _orders.where((order) => order.status == _selectedFilterKey).toList();

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
                      itemCount: filterKeys.length,
                      itemBuilder: (context, index) {
                        final key = filterKeys[index];
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
                                filterLabels[key]!,
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

                  // Orders List
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      itemCount: filteredOrders.length,
                      itemBuilder: (context, index) {
                        final order = filteredOrders[index];
                        final statusInfo = orderStatusMap[order.status]!;
                        final statusLabel = statusInfo['label'];
                        final statusColor = statusInfo['color'];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    OrderDetailsScreen(order: order),
                              ),
                            );
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
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.grey[200],
                                        ),
                                        child: order.items.isNotEmpty &&
                                                order.items[0].imageUrl != null
                                            ? Image.asset(
                                                order.items[0].imageUrl!,
                                                fit: BoxFit.cover)
                                            : null,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              order.items.isNotEmpty
                                                  ? order.items[0].name
                                                  : '',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Order ID: ${order.orderId}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              '\$${order.items.isNotEmpty ? order.items[0].price.toStringAsFixed(2) : ''}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (order.status == 'delivered')
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
                                      statusLabel,
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
                  ),
                ],
              ),
      ),
    );
  }
}
