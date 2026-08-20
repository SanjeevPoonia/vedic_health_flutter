import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:printing/printing.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/invoices_item.dart';

import '../network/Utils.dart';
import '../network/api_helper.dart';
import '../network/constants.dart';
import '../network/loader.dart';
import '../utils/app_theme.dart';
import '../utils/invoice_pdf.dart';
import '../widgets/notification_bar_widget.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pdf/pdf.dart';


class InvoicesScreen extends StatefulWidget{

  _InvoicesScreen createState()=>_InvoicesScreen();
}

class _InvoicesScreen extends State<InvoicesScreen> {
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
  String? userId;
  String? email;
  String? stripeCustomerId;
  String? customerName;
  List<dynamic> membershipInvoiceList=[];
  List<dynamic> orderInvoiceList=[];
  bool isMembershipLoading=false;
  bool isOrderLoading=false;
  int membershipCurrentPage=1;
  int membershipPageSize=5;
  int totalMembership=0;
  bool isMembershipLoadMore=false;

  int orderCurrentPage=1;
  int orderPageSize=5;
  int totalOrder=0;
  bool isOrderLoadingMore=false;
  List<orderListModel> allOrderList=[];


  bool isInfoLoading=false;

  String companyAddress="";
  String companyEmail="";
  String companyPhone="";



  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          NotificationBarWidget(),
          _buildAppBar(),

          SizedBox(height: 24),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text("MEMBERSHIP INVOICES", style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 12),
            )
          ),
          _allMembershipInvoices(),
          SizedBox(height: 16),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("SHOP/ORDER INVOICE",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12)),
          ),

          isOrderLoading?
              Center(child: Loader(),):
          _allOrderInvoices(),
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
  Widget _buildAppBar() {
    return Card(
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
                  size: 24, color: Colors.black),
            ),
            const Expanded(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: Text(
                    "Invoices",
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
    );
  }
  @override
  void initState() {
    super.initState();
    _loadUserData();
  }
  Future<void>_loadUserData()async{
    userId=await MyUtils.getSharedPreferences("user_id")??"";
    stripeCustomerId=await MyUtils.getSharedPreferences("customer_id")??"";
    email=await MyUtils.getSharedPreferences("email")??"";
    customerName=await MyUtils.getSharedPreferences("name")??"";
    fetchVedicHealthInfo();
    fetchMembershipTransactions();
    fetchOrderTransactions();
  }
  fetchVedicHealthInfo() async {
    setState(() {
      isInfoLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      //"id": userId,
      "id": "67f4da7497d93651914eb2f7",
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('master/view', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 ||statusCode==200){
      companyAddress=responseJSON['data']?['address']?.toString()??"";
      companyEmail=responseJSON['data']?['email']?.toString()??"";
      companyPhone=responseJSON['data']?['number']?.toString()??"";
    }
    setState(() {
      isInfoLoading = false;
    });
  }
  fetchMembershipTransactions() async {
    setState(() {
      isMembershipLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId,
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_buy_management/getUserSubscriptionDetails', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 ||statusCode==200){
      List<dynamic> dyList=(responseJSON['data']?['invoices'] as List?)??[];
      membershipInvoiceList.addAll(dyList);
      //totalMembership=responseJSON['pagination']?['total']??0;
      
    }
    setState(() {
      isMembershipLoading = false;
    });
  }
  fetchMembershipTransactionsLoadMore() async {
    setState(() {
      isMembershipLoadMore = true;
      membershipCurrentPage++;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user_id": userId,
      "page":membershipCurrentPage,
      "pageSize":membershipPageSize
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('membership_buy_management/membership_transactions', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 ||statusCode==200){
      List<dynamic> dyList=(responseJSON['membershipData'] as List?)??[];
      membershipInvoiceList.addAll(dyList);
      totalMembership=responseJSON['pagination']?['total']??0;
    }
    setState(() {
      isMembershipLoadMore = false;
    });
  }
  double toDouble(dynamic value) {
    if (value == null) return 0.0;

    if (value is num) {
      return value.toDouble(); // int or double
    }

    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    }

    return 0.0;
  }
  int toInteger(dynamic value) {
    if (value == null) return 0;

    if (value is num) {
      return value.toInt(); // int or double
    }

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    return 0;
  }
  Widget _allMembershipInvoices() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [

          isMembershipLoading?Center(child: Loader(),):
          membershipInvoiceList.isEmpty?

          Center(
              child:Column(
                children: [
                  Text("No Membership invoice were found. Please refresh and try again.",style: TextStyle(fontWeight: FontWeight.w500,fontSize: 14,color: Colors.grey),),
                  SizedBox(height: 10,),
                  IconButton(
                      onPressed: (){
                        fetchMembershipTransactions();
                      },
                      icon: Icon(Icons.refresh,size: 24,color: AppTheme.themeColor,)
                  )
                ],
              )
          ):
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: membershipInvoiceList.length,
            itemBuilder: (context, index) {
              final invoice=membershipInvoiceList[index];

              String title=invoice['plan_name']?.toString()??"";
              String date=invoice['date']?.toString()??"";
              String status=invoice['status']?.toString()??"";
              String price=invoice['totals']?['total']?.toString()??"";
              String invoiceNo=invoice['invoiceNumber']?.toString()??"";
              double newValue = toDouble(price);

              String custName=invoice['customer']?['name']?.toString()??"";
              String custid=invoice['customer']?['id']?.toString()??"";
              String custEmail=invoice['customer']?['email']?.toString()??"";
              String custPhone=invoice['customer']?['mobile']?.toString()??"";

              return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // shadow color
                        blurRadius: 4,  // soften the shadow
                        spreadRadius: 1, // how wide the shadow spreads
                        offset: Offset(0, 4), // shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      /// Radio Circle
                      SvgPicture.asset("assets/ic_invoices.svg",height: 37,width: 37,fit: BoxFit.contain,),
                      const SizedBox(width: 14),
                      /// Membership Text
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              date,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text(
                            "\$ $price",
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          statusBadge(status),
                          const SizedBox(height: 4,),
                          status=="Paid"?
                              isInfoLoading?Container():
                          ElevatedButton.icon(
                            onPressed: () async{
                              showLoading(context);

                              try {
                                final items = [
                                  InvoiceItem(title: title, cost: newValue, unit: 1),
                                ];

                                // ✅ Generate PDF File
                                final file = await InvoicePDF.generateInvoice(
                                  invoiceNo: invoiceNo,
                                  customerName: custName,
                                  email: custEmail,
                                  status: status,
                                  date: date,
                                  customerId: custid,
                                  storeName: "Vedic Health Inc.",
                                  storeAddress: companyAddress,
                                  storePhone: companyPhone,
                                  storeEmail: companyEmail,
                                  customerAddress: "",
                                  customerPhone: custPhone,
                                  items: items,
                                  subTotal: price,
                                  discount: "0",
                                  delivery: "0",
                                  grandTotal: price
                                );

                                // ✅ Hide Loader
                                hideLoading(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("File saved on: ${file.path}")),
                                );

                                // ✅ Open PDF Preview Instead of Share
                                await Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async => file.readAsBytes(),
                                );

                              } catch (e) {

                                // Hide loader if error
                                hideLoading(context);

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            },
                            icon: const Icon(
                              Icons.download,
                              color: Colors.white,
                              size: 14,
                            ),
                            label: const Text(
                              "Download",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB65303),
                              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 6,
                              shadowColor: Colors.black54,
                            ),
                          ):Container(),


                        ],
                      )

                    ],
                  ),
                );
            },
          ),
          SizedBox(height: 12,),
          /*totalMembership>membershipInvoiceList.length?
          Center(
            child: ElevatedButton(
              onPressed: isMembershipLoadMore
                  ? null
                  : () {
                fetchMembershipTransactionsLoadMore();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.courseTileBack,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: isMembershipLoadMore
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.darkBrown,
                ),
              )
                  : const Text(
                "Load More",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppTheme.orangeColor),
              ),
            ),
          ):Container(),*/
        ],
      ),
    );
  }
  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 20),
            Text("Preparing PDF..."),
          ],
        ),
      ),
    );
  }

  void hideLoading(BuildContext context) {
    Navigator.pop(context);
  }
  Widget _allOrderInvoices(){
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          orderInvoiceList.isEmpty?
          Center(child: Padding(padding: EdgeInsets.all(16),
            child: Text("Currently No Invoices Availble",
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey
              ),),

          ),):
          ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: allOrderList.length,
            itemBuilder: (context, index) {
              var order=allOrderList[index];
              /* final order = filteredOrders[index];
                              final statusInfo = orderStatusMap[order.status]!;*/
              String orderId=allOrderList[index].orderId;
              String orderStatusName=allOrderList[index].statusName;
              String orderStatusKey=allOrderList[index].statusKey;
              String orderTotalAmount=allOrderList[index].grandTotal;
              String createdAt=allOrderList[index].createdAt;
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
              String createdDate="";

              if(createdAt.isNotEmpty){
                createdDate=formatDateTimeUtc(createdAt);
              }


              String invoiceNo=orderInvoiceList[index]?['invoiceNo']?.toString()??"";
              String status=orderInvoiceList[index]?['status']?.toString()??"";
              String billingAddress1=orderInvoiceList[index]?['billingAddress1']?.toString()??"";
              String billingAddress2=orderInvoiceList[index]?['billingAddress2']?.toString()??"";

              return Container(
                  margin: const EdgeInsets.only(bottom: 12),

                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15), // shadow color
                        blurRadius: 4,  // soften the shadow
                        spreadRadius: 1, // how wide the shadow spreads
                        offset: Offset(0, 4), // shadow position (x, y)
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*Text(
                              'Order ID: $orderId',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),*/
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

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$$orderTotalAmount',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                Text(
                                  createdDate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),

                                orderStatusKey=='order_delivered'?
                                ElevatedButton.icon(
                                  onPressed: ()async {

                                    showLoading(context);

                                    try {
                                      List<InvoiceItem> items = [];
                                      for(int i=0;i<orderItem.length;i++){
                                        double newValue = toDouble(orderItem[i].productPrice);
                                        int quantity=toInteger(orderItem[i].quantity);
                                        items.add(InvoiceItem(
                                            title: orderItem[i].productName,
                                            cost: newValue, unit: quantity));
                                      }

                                      // ✅ Generate PDF File
                                      final file = await InvoicePDF.generateInvoice(
                                        invoiceNo: "#$invoiceNo",
                                        customerName: customerName??"",
                                        email: email??"",
                                        status: status.toUpperCase(),
                                        date: createdDate,
                                        customerId: orderId,
                                        storeName: "Vedic Health Inc.",
                                        storeAddress: companyAddress,
                                        storePhone: companyPhone,
                                        storeEmail: companyEmail,
                                        customerAddress: "$billingAddress1 , $billingAddress2",
                                        customerPhone: "",
                                        items: items,
                                        subTotal: orderTotalAmount,
                                        discount: "0",
                                        delivery: "0",
                                        grandTotal: orderTotalAmount
                                      );

                                      // ✅ Hide Loader
                                      hideLoading(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("File saved on: ${file.path}")),
                                      );

                                      // ✅ Open PDF Preview Instead of Share
                                      await Printing.layoutPdf(
                                        onLayout: (PdfPageFormat format) async => file.readAsBytes(),
                                      );

                                    } catch (e) {
                                      // Hide loader if error
                                      hideLoading(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Error: $e")),
                                      );
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.download,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                  label: const Text(
                                    "Download",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFB65303),
                                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 7),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 6,
                                    shadowColor: Colors.black54,
                                  ),
                                )
                                :Container()
                              ],
                            )


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


                    ],
                  ),
                );
            },
          ),
          SizedBox(height: 12,),
          totalOrder>allOrderList.length?
          Center(
            child: ElevatedButton(
              onPressed: isOrderLoadingMore
                  ? null
                  : () {
                fetchOrderTransactionsLoadMore();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.courseTileBack,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              child: isOrderLoadingMore
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppTheme.darkBrown,
                ),
              )
                  : const Text(
                "Load More",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppTheme.orangeColor),
              ),
            ),
          ):Container(),

        ],
      ),
    );
  }
  String formatDateTimeUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  Widget statusBadge(String status) {
    bool isActive = status.toLowerCase() == "paid";
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: isActive ? Colors.green : Colors.red,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
  fetchOrderTransactions() async {
    setState(() {
      isOrderLoading = true;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "page":orderCurrentPage,
      "pageSize":orderPageSize
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('order-management/findUserOrders', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 ||statusCode==200){
      List<dynamic> dyList=(responseJSON['data'] as List?) ?? [];
      orderInvoiceList.addAll(dyList);
      totalOrder=responseJSON['total']??0;
      for(int i=0;i<dyList.length;i++){
        String orderId=dyList[i]['_id']?.toString()??"";
        String invoiceNo=dyList[i]['invoiceNo']?.toString()??"";
        String totalAmount=dyList[i]['totalAmount']?.toString()??"";
        String deliveryCharge=dyList[i]['deliveryCharge']?.toString()??"";
        String discountAmount=dyList[i]['discountAmount']?.toString()??"";
        String grandTotal=dyList[i]['grandTotal']?.toString()??"";
        String status=dyList[i]['status']?.toString()??"";
        String createdAt=dyList[i]['created_at']?.toString()??"";
        List<dynamic> odItemsProduct=(dyList[i]['orderProducts'] as List?)??[];
        List<orderItemsSeries> odSeriesList=[];
        List<dynamic> odItems=(dyList[i]['orderItems'] as List?) ?? [];
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
            if(itemId == proId){
              productImage=imageUrl;
            }



          }
          odSeriesList.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));

        }

        String pickupdate=dyList[i]['deliveryDates']?['pickupDate']?.toString()??"";
        String shippedDate=dyList[i]['deliveryDates']?['shippedDate']?.toString()??"";
        String outForDelivery=dyList[i]['deliveryDates']?['outForDeliveryDate']?.toString()??"";
        String deliveryDate=dyList[i]['deliveryDates']?['deliveredDate']?.toString()??"";
        String statusKey="";
        String statusName="";



        if(status=="orderCanceled"){
          statusName="Order Cancelled";
          statusKey="order_cancelled";
        }else if(pickupdate.isEmpty && shippedDate.isEmpty && deliveryDate.isEmpty ){
          statusName="Order Ready";
          statusKey="order_pack";
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
            discountAmount, grandTotal, status, odSeriesList,pickupdate,shippedDate,deliveryDate,statusKey,statusName,createdAt));
      }
    }
    setState(() {
      isOrderLoading = false;
    });
  }
  fetchOrderTransactionsLoadMore() async {
    setState(() {
      isOrderLoadingMore = true;
      orderCurrentPage++;
    });
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "page":orderCurrentPage,
      "pageSize":orderPageSize
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('order-management/findUserOrders', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201 ||statusCode==200){
      List<dynamic> dyList=(responseJSON['data'] as List?)??[];
      orderInvoiceList.addAll(dyList);
      totalOrder=responseJSON['total']??0;
      for(int i=0;i<dyList.length;i++){
        String orderId=dyList[i]['_id']?.toString()??"";
        String invoiceNo=dyList[i]['invoiceNo']?.toString()??"";
        String totalAmount=dyList[i]['totalAmount']?.toString()??"";
        String deliveryCharge=dyList[i]['deliveryCharge']?.toString()??"";
        String discountAmount=dyList[i]['discountAmount']?.toString()??"";
        String grandTotal=dyList[i]['grandTotal']?.toString()??"";
        String status=dyList[i]['status']?.toString()??"";
        String createdAt=dyList[i]['created_at']?.toString()??"";
        List<dynamic> odItemsProduct=(dyList[i]['orderProducts'] as List?)??[];
        List<orderItemsSeries> odSeriesList=[];
        List<dynamic> odItems=(dyList[i]['orderItems'] as List?) ?? [];
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
            if(itemId == proId){
              productImage=imageUrl;
            }
          }
          odSeriesList.add(orderItemsSeries(itemId, quantity, productPrice, productName, productBrand, productImage));

        }

        String pickupdate=dyList[i]['deliveryDates']?['pickupDate']?.toString()??"";
        String shippedDate=dyList[i]['deliveryDates']?['shippedDate']?.toString()??"";
        String outForDelivery=dyList[i]['deliveryDates']?['outForDeliveryDate']?.toString()??"";
        String deliveryDate=dyList[i]['deliveryDates']?['deliveredDate']?.toString()??"";
        String statusKey="";
        String statusName="";



        if(status=="orderCanceled"){
          statusName="Order Cancelled";
          statusKey="order_cancelled";
        }else if(pickupdate.isEmpty && shippedDate.isEmpty && deliveryDate.isEmpty ){
          statusName="Order Ready";
          statusKey="order_pack";
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
            discountAmount, grandTotal, status, odSeriesList,pickupdate,shippedDate,deliveryDate,statusKey,statusName,createdAt));
      }
    }
    setState(() {
      isOrderLoadingMore = false;
    });
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
  String createdAt;

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
      this.statusName,
      this.createdAt
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