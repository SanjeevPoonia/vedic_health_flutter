import 'package:flutter/material.dart';

class Order {
  final String id;
  final String status;
  final String orderId;
  final DateTime orderDate;
  final ShippingAddress shippingAddress;
  final List<OrderItem> items;
  final PaymentDetail paymentDetail;

  Order({
    required this.id,
    required this.status,
    required this.orderId,
    required this.orderDate,
    required this.shippingAddress,
    required this.items,
    required this.paymentDetail,
  });
}

class ShippingAddress {
  final String name;
  final String address;
  final String phone;

  ShippingAddress({
    required this.name,
    required this.address,
    required this.phone,
  });
}

class OrderItem {
  final String id;
  final String name;
  final String quantity;
  final double price;
  final String? imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    this.imageUrl,
  });
}

class PaymentDetail {
  final double subTotal;
  final double discount;
  final double deliveryCharges;
  final double grandTotal;

  PaymentDetail({
    required this.subTotal,
    required this.discount,
    required this.deliveryCharges,
    required this.grandTotal,
  });
}

final List<Order> sampleOrders = [
  Order(
    id: '1',
    status: 'out_for_delivery',
    orderId: 'ODI23456789',
    orderDate: DateTime.now(),
    shippingAddress: ShippingAddress(
      name: 'John Smith',
      address: '123 Main St, Jaipur, Rajasthan 202012',
      phone: '+91-9887889900',
    ),
    items: [
      OrderItem(
        id: '1',
        name: 'Haritaki Powder',
        quantity: 'QTX1',
        price: 14.00,
        imageUrl: 'assets/banner2.png',
      ),
    ],
    paymentDetail: PaymentDetail(
      subTotal: 14.00,
      discount: 0.00,
      deliveryCharges: 2.00,
      grandTotal: 16.00,
    ),
  ),
  Order(
    id: '2',
    status: 'delivered',
    orderId: 'ODI23456790',
    orderDate: DateTime.now(),
    shippingAddress: ShippingAddress(
      name: 'John Smith',
      address: '123 Main St, Jaipur, Rajasthan 202012',
      phone: '+91-9887889900',
    ),
    items: [
      OrderItem(
        id: '2',
        name: 'Annalaki Powder',
        quantity: 'QTX1',
        price: 14.00,
        imageUrl: 'assets/banner4.png',
      ),
    ],
    paymentDetail: PaymentDetail(
      subTotal: 14.00,
      discount: 0.00,
      deliveryCharges: 2.00,
      grandTotal: 16.00,
    ),
  ),
  Order(
    id: '3',
    status: 'delivered',
    orderId: 'ODI23456791',
    orderDate: DateTime.now(),
    shippingAddress: ShippingAddress(
      name: 'John Smith',
      address: '123 Main St, Jaipur, Rajasthan 202012',
      phone: '+91-9887889900',
    ),
    items: [
      OrderItem(
        id: '3',
        name: 'Brahmi Powder',
        quantity: 'QTX1',
        price: 14.00,
        imageUrl: 'assets/dummy22.jpg',
      ),
    ],
    paymentDetail: PaymentDetail(
      subTotal: 14.00,
      discount: 0.00,
      deliveryCharges: 2.00,
      grandTotal: 16.00,
    ),
  ),
  Order(
    id: '4',
    status: 'cancelled',
    orderId: 'ODI23456792',
    orderDate: DateTime.now(),
    shippingAddress: ShippingAddress(
      name: 'John Smith',
      address: '123 Main St, Jaipur, Rajasthan 202012',
      phone: '+91-9887889900',
    ),
    items: [
      OrderItem(
        id: '4',
        name: 'Neem Powder',
        quantity: 'QTX1',
        price: 14.00,
        imageUrl: 'assets/banner1.png',
      ),
    ],
    paymentDetail: PaymentDetail(
      subTotal: 14.00,
      discount: 0.00,
      deliveryCharges: 2.00,
      grandTotal: 16.00,
    ),
  ),
  Order(
    id: '5',
    status: 'returned',
    orderId: 'ODI23456793',
    orderDate: DateTime.now(),
    shippingAddress: ShippingAddress(
      name: 'John Smith',
      address: '123 Main St, Jaipur, Rajasthan 202012',
      phone: '+91-9887889900',
    ),
    items: [
      OrderItem(
        id: '5',
        name: 'Ashwagandha Powder',
        quantity: 'QTX1',
        price: 14.00,
        imageUrl: 'assets/banner_3.png',
      ),
    ],
    paymentDetail: PaymentDetail(
      subTotal: 14.00,
      discount: 0.00,
      deliveryCharges: 2.00,
      grandTotal: 16.00,
    ),
  ),
];

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
    'color': Color(0xFF00BAC7),
  },
};
