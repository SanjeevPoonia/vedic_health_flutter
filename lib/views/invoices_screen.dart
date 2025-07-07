import 'package:flutter/material.dart';

class InvoicesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> invoices = [
    {
      "title": "Simply Dummy Test",
      "date": "27 Jan, 2024",
      "amount": "\$ 16.00",
      "status": "Paid"
    },
    {
      "title": "Simply Dummy Test",
      "date": "27 Jan, 2024",
      "amount": "\$ 16.00",
      "status": "Paid"
    },
    {
      "title": "Simply Dummy Test",
      "date": "27 Jan, 2024",
      "amount": "\$ 16.00",
      "status": "Unpaid"
    },
    {
      "title": "Simply Dummy Test",
      "date": "27 Jan, 2024",
      "amount": "\$ 16.00",
      "status": "Paid"
    },
    {
      "title": "Simply Dummy Test",
      "date": "27 Jan, 2024",
      "amount": "\$ 16.00",
      "status": "Paid"
    },
  ];

  InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoices', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 16),
            // Search Bar
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Color(0xFFF5F6FA),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search",
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 24),
            Text("Transaction List",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 16),
            Text("LATEST INVOICE",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            _invoiceTile(context, invoices[0]),
            SizedBox(height: 16),
            Text("PREVIOUS INVOICE",
                style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 12)),
            ...invoices
                .sublist(1)
                .map((inv) => _invoiceTile(context, inv))
                .toList(),
          ],
        ),
      ),
    );
  }

  Widget _invoiceTile(BuildContext context, Map<String, dynamic> invoice) {
    Color statusColor =
        invoice['status'] == 'Paid' ? Color(0xFF1BC47D) : Color(0xFFFF4C4C);
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/Group 65681.png',
            width: 40,
            height: 40,
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(invoice['title'],
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                SizedBox(height: 4),
                Text(invoice['date'],
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(invoice['amount'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  invoice['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
