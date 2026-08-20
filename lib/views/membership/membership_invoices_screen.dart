import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/views/membership/join_membership_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import '../../network/loader.dart';
import 'package:intl/intl.dart';
import '../yoga_classes/yoga_fullscreen_video.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MembershipInvoicesScreen extends StatefulWidget{
  List<dynamic> invoList;
  MembershipInvoicesScreen(this.invoList);
  _membershipState createState()=> _membershipState();
}
class _membershipState extends State<MembershipInvoicesScreen>{
  List<dynamic> invoicesList=[];
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(child:
        Column(
          children: [
            // App Bar
            _buildAppBar(),
            SizedBox(height: 20,),
            _allInvoices(),
          ],
        ),
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
    invoicesList=widget.invoList;
    setState(() {

    });
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
                    "Membership",
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
  Widget _allInvoices() {
    return Padding(padding: EdgeInsets.symmetric(horizontal: 10),
      child:  Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:  [
          Row(
            children: [
              Expanded(flex:1,child: const Text(
                "Invoices",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ),

            ],
          ),
          const SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: invoicesList.length>5?5:invoicesList.length,
            itemBuilder: (context, index) {
              final invoice=invoicesList[index];

              String title=invoice['plan_name']?.toString()??"";
              String date=invoice['date']?.toString()??"";
              String status=invoice['status']?.toString()??"";
              String price=invoice['totals']['total']?.toString()??"";

              //String convertedDate=formatDateTimeUtc(date);

              return GestureDetector(
                onTap: () {
                  setState(() {

                  });
                },
                child: Container(
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                        ],
                      )

                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 12,),
        ],
      ),
    );
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
  String formatDateTimeUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy hh:mm a').format(dateTime);
    } catch (e) {
      return date;
    }
  }



}