import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';

import 'invoices_item.dart';
import 'package:flutter/services.dart';

class InvoicePDF {
  static Future<File> generateInvoice({
    required String invoiceNo,
    required String customerName,
    required String email,
    required String status,
    required String date,
    required String customerId,
    required String storeName,
    required String storeAddress,
    required String storePhone,
    required String storeEmail,
    required String customerAddress,
    required String customerPhone,
    required List<InvoiceItem> items,
    required String subTotal,
    required String discount,
    required String delivery,
    required String grandTotal
  }) async {
    final pdf = pw.Document();

    // Calculate Total
    /*double grandTotal =
    items.fold(0, (sum, item) => sum + item.total);*/
    final logoBytes = await rootBundle.load("assets/app_logo.png");
    final logo = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [

              /// HEADER
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Image(
                    logo,
                    width: 150,
                    height: 120,
                  ),

                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("INVOICE",
                          style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 4),
                      pw.Text("Invoice #Ved$invoiceNo"),
                      pw.Text("Invoice Date: $date"),
                      pw.Text("Invoice Amount: \$$grandTotal"),
                      pw.Text("Customer ID: $customerId"),
                      pw.Text(status,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              pw.Divider(),

              pw.SizedBox(height: 20),

              /// FROM - TO
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("From:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 6),
                        pw.Text(storeName),
                        pw.Text(storeAddress),
                        pw.Text(storePhone),
                        pw.Text(storeEmail),
                      ],
                    ),
                  ),


                  pw.SizedBox(width: 30),

                  pw.Expanded(
                    flex: 1,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text("To:", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                        pw.SizedBox(height: 6),
                        pw.Text(customerName),
                        pw.Text(customerAddress),
                        pw.Text(customerPhone),
                        pw.Text(email),

                      ],
                    )
                  ),
                ],
              ),

              pw.SizedBox(height: 25),

              /// TABLE HEADER
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: PdfColors.grey300,
                child: pw.Row(
                  children: [
                    pw.Expanded(
                      flex: 4,
                      child: pw.Text("DESCRIPTION",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("COST",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Expanded(
                      flex: 1,
                      child: pw.Text("UNIT",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Expanded(
                      flex: 2,
                      child: pw.Text("AMOUNT",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                  ],
                ),
              ),

              /// ITEMS LOOP
              pw.ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];

                  return pw.Container(
                    padding: const pw.EdgeInsets.all(10),
                    decoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          color: PdfColors.grey300,
                        ),
                      ),
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 4, child: pw.Text(item.title)),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text("\$${item.cost}")),
                        pw.Expanded(
                            flex: 1,
                            child: pw.Text("${item.unit}")),
                        pw.Expanded(
                            flex: 2,
                            child: pw.Text("\$${item.total.toStringAsFixed(2)}")),
                      ],
                    ),
                  );
                },
              ),

              pw.Divider(),

              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Sub Total: \$$subTotal",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal),
                  ),

                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Discount: \$$discount",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal),
                  ),

                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Delivery: \$$delivery",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.normal),
                  ),

                ],
              ),
              /// TOTAL SECTION
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    "Total: \$$grandTotal",
                    style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold),
                  ),

                ],
              ),

              pw.Spacer(),

              /// FOOTER
              pw.Center(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text(
                      "Thank you for trusting us",
                      style: pw.TextStyle(
                        fontSize: 16,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text(
                      storeAddress,
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                  ]
                )
              ),
            ],
          );
        },
      ),
    );

    /// SAVE FILE
    final output = await getApplicationDocumentsDirectory();
    final file = File("${output.path}/invoice_Ved$invoiceNo.pdf");

    await file.writeAsBytes(await pdf.save());
    return file;
  }
}