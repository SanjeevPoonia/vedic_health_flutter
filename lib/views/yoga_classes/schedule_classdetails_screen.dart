import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/utils/app_theme.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';
import '../word_webview_screen.dart';

class ScheduleClassDetailsScreen extends  StatefulWidget {

  final Map<String,dynamic> classData;

  const ScheduleClassDetailsScreen({
    Key? key,
    required this.classData,
  }) : super(key: key);

  @override
  State<ScheduleClassDetailsScreen> createState() =>
      _YogaClassDetailScreenState();
}
class _YogaClassDetailScreenState extends State<ScheduleClassDetailsScreen> {
  late Map<String, dynamic> item;
  int quantity = 1;
  int quantityRSVP = 1;
  String selectedtickettype = 'Paid';
  String selectedRSVPType='RSVP';
  String classPrice="";
  int maxTicket=0;
  int availableTicket=0;
  String classId="";


  @override
  void initState() {
    super.initState();
    item = widget.classData;
    classPrice=item['Price']?.toString()??"0";
    maxTicket=item['maxTicketsPerUser']??1;
    availableTicket=item['availableTickets']??0;
    classId=item['_id']?.toString()??"";
    setState(() {

    });
    print(item);
  }
  Future<void> openMap() async {
    double latitude = double.tryParse(item["latitude"].toString()) ?? 0;
    double longitude = double.tryParse(item["longitude"].toString()) ?? 0;
    final Uri url = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
    );
    if(await canLaunchUrl(url)){
      await launchUrl(
        url,
        mode: LaunchMode.externalApplication,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Column(
              children: [
                buildInfoCard(),
                buildDescriptionCard(),
                buildSpeakerCard(),
                buildSpeakerProfileCard(),
                const SizedBox(height: 30),
              ],
            ),
          )
        ],
      ),
    );
  }
  Widget buildSliverAppBar() {

    return SliverAppBar(

      expandedHeight: 280,

      pinned: true,

      backgroundColor: Colors.white,

      leading: GestureDetector(

        onTap: (){
          Navigator.pop(context);
        },

        child: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black45,
            borderRadius:
            BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),

      flexibleSpace: FlexibleSpaceBar(

        background: CachedNetworkImage(
          imageUrl:
          item["coverUrl"] ?? "",
          fit: BoxFit.cover,
          placeholder: (_,__) =>
          const Center(
            child:
            CircularProgressIndicator(),
          ),
          errorWidget: (_,__,___) =>
              Container(
                color: Colors.grey.shade200,
                child: const Icon(
                  Icons.broken_image,
                  size: 50,
                ),
              ),
        ),
      ),
    );
  }
  Widget buildInfoCard() {

    DateTime classDate =
    DateTime.parse(item["date"]);

    bool isRSVP =
        item["is_rsvp"] ?? false;
    int availableTicket=item['availableTickets']??0;

    return Card(

      margin:
      const EdgeInsets.all(16),

      shape:
      RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(20),
      ),

      child: Padding(
        padding:
        const EdgeInsets.all(16),

        child: Column(

          children: [

            Row(

              children: [

                Expanded(
                  child: buildInfoItem(
                    Icons.calendar_month,
                    "Date & Time",
                    "${DateFormat("dd MMM yyyy").format(classDate)}\n${item["time"]}",
                  ),
                ),

                Expanded(
                  child: buildInfoItem(
                    Icons.location_on,
                    "Location",
                    item["address"] ?? "",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 15),

            Row(

              children: [

                Expanded(
                  child: buildInfoItem(
                    Icons.person,
                    "Host",
                    item["host_name"] ?? "",
                  ),
                ),

                Expanded(
                  child: buildInfoItem(
                    Icons.info_outline,
                    "Format",
                    item["format"] ?? "",
                  ),
                ),
              ],
            ),

            const Divider(height: 30),
            Row(
              children: [

                Expanded(
                  child: Text(
                    isRSVP
                        ? "RSVP"
                        : "\$${item["Price"]}",
                    style: TextStyle(
                      fontSize: 22,
                      color: isRSVP
                          ? Colors.brown
                          : Colors.green,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton.icon(

                  onPressed: openMap,

                  icon: const Icon(
                    Icons.map_outlined,
                  ),

                  label: const Text(
                    "View Map",
                  ),
                ),
              ],
            ),
            SizedBox(height: 8,),
            Text(
              availableTicket>0?"$availableTicket Tickets are available":"No ticket is available",
              style:
              TextStyle(
                  fontWeight:
                  FontWeight.w600,
                  color: availableTicket>0?Colors.green:Colors.red
              ),
            ),
            const SizedBox(height: 8),
            availableTicket>0?
            ElevatedButton.icon(
              onPressed: () {
                isRSVP?
                _showBookBottomDialogRSVP(context):  _showBookBottomDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isRSVP
                    ? AppTheme.darkBrown
                    : Colors.green,
                foregroundColor: Colors.white,
              ),
              icon: Icon(
                isRSVP
                    ? Icons.event_available
                    : Icons.shopping_cart_checkout,
              ),
              label: Text(
                isRSVP ? "RSVP Now" : "Enroll",
              ),
            ):SizedBox()
          ],
        ),
      ),
    );
  }
  Widget buildInfoItem(
      IconData icon,
      String title,
      String value) {
    return Column(

      crossAxisAlignment:
      CrossAxisAlignment.start,

      children: [

        Icon(
          icon,
          color: Colors.orange,
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          value,
          maxLines: 3,
          overflow:
          TextOverflow.ellipsis,
        ),
      ],
    );
  }
  Widget buildDescriptionCard() {

    return Card(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Description",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Html(
              data:
              item["description"] ?? "",
            ),
          ],
        ),
      ),
    );
  }
  Widget buildSpeakerCard() {

    return Card(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Row(

          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage:
              NetworkImage(item["fileUrl"] ?? "",),
            ),
            const SizedBox(width: 15),

            Expanded(

              child: Column(

                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [

                  Text(
                    item["speakername"] ?? "",
                    style:
                    const TextStyle(
                      fontSize: 18,
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    item["speakerdesignation"] ?? "",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget buildSpeakerProfileCard() {

    return Card(

      margin:
      const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),

      child: Padding(

        padding:
        const EdgeInsets.all(16),

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            const Text(
              "Speaker Profile",
              style: TextStyle(
                fontSize: 18,
                fontWeight:
                FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Html(
              data:
              item["speakerdescription"] ?? "",
            ),
          ],
        ),
      ),
    );
  }
  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18),
      ),
    );
  }
  _showBookBottomDialogRSVP(BuildContext context){

    double singleticketAmount=double.parse(classPrice);
    double totalAmount=singleticketAmount;
    double grandTotal=totalAmount;
    quantityRSVP=1;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 15),
              child: SingleChildScrollView(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Class Registration',
                            style: TextStyle(
                                fontSize: 19,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Color(0xFFAFAFAF),
                            )),
                        const SizedBox(width: 15)
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Ticket type",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            // CircleAvatar(
                            //   maxRadius: 18,
                            //   backgroundColor:
                            //       const Color(0xFFC7DEF3),
                            //   child: Text(
                            //     getInitials(selectedtickettype),
                            //     style: const TextStyle(
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            Text(
                              selectedRSVPType,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFB65303),
                              size: 25,
                            ),
                          ])),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /// Quantity Row
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            children: [
                              _qtyButton(Icons.remove, () {
                                if (quantityRSVP > 1) {
                                  setModalState(() {
                                    quantityRSVP--;
                                    totalAmount=totalAmount-singleticketAmount;
                                  });
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  "$quantityRSVP",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _qtyButton(Icons.add, () {
                                if(quantityRSVP<maxTicket){
                                  if(quantityRSVP>=availableTicket){
                                    Toast.show(
                                        "$availableTicket tickets are available only.",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red);
                                  }else{
                                    setModalState(() {
                                      quantityRSVP++;
                                      totalAmount=totalAmount+singleticketAmount;
                                      grandTotal=totalAmount;

                                    });
                                  }

                                }else{
                                  Toast.show(
                                      "Booking is limited to a maximum of $maxTicket tickets per user.",
                                      duration: Toast.lengthLong,
                                      backgroundColor: Colors.red);
                                }

                              }),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 7,),





                    Divider(),
                    const SizedBox(height: 7),

                    /// Price Row
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$$totalAmount",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BE55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: const Color(0xFFE3E3E3)),
                                child: const Center(
                                  child: Text("Back",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              bookRSVP(grandTotal.toStringAsFixed(2));
                            },
                            child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("RSVP",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }
  bookRSVP(String grandTotalAmount) async {
    print("Selected Quantity $quantityRSVP");
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "type": 'RSVP',
      "classId": classId,
      "userId":userId,
      "quantity": quantityRSVP, // Assuming default page number
      // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'yoga_class_management/createYogaClassRSVP', resModel, context);
    var responseJSON= json.decode(response.toString());
    Navigator.of(context).pop();
    int statusCode=responseJSON['statusCode']??0;

    if(statusCode==200){
      String message=responseJSON['message']?.toString()??" RSVP Resgistered Successfully.";

      Toast.show(
          '$message For More details please check your email address.'
          ,duration: Toast.lengthLong,backgroundColor: Colors.green);
      finishScreen();

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }

  }
  void finishScreen(){
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
  _showBookBottomDialog(BuildContext context){
    var coupancodeController= TextEditingController();
    double singleticketAmount=double.parse(classPrice);
    double totalAmount=singleticketAmount;
    bool isCoupanApplied=false;
    String coupanId="";
    String coupanType="";
    String coupanValue="";
    String maxCoupanValue="";
    String coupanTitle="";
    double discountAmount=0.0;
    double grandTotal=totalAmount;
    quantity=1;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(12),
              margin: const EdgeInsets.symmetric(
                  horizontal: 15, vertical: 15),
              child: SingleChildScrollView(
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text('Class Registration',
                            style: TextStyle(
                                fontSize: 19,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w600,
                                color: Colors.black)),
                        const Spacer(),
                        GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: const Icon(
                              Icons.clear,
                              color: Color(0xFFAFAFAF),
                            )),
                        const SizedBox(width: 15)
                      ],
                    ),
                    const SizedBox(height: 25),
                    const Text(
                      "Ticket type",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey.shade400),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(children: [
                            // CircleAvatar(
                            //   maxRadius: 18,
                            //   backgroundColor:
                            //       const Color(0xFFC7DEF3),
                            //   child: Text(
                            //     getInitials(selectedtickettype),
                            //     style: const TextStyle(
                            //       fontSize: 15,
                            //       fontWeight: FontWeight.bold,
                            //       color: Colors.black,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(
                            //   width: 15,
                            // ),
                            Text(
                              selectedtickettype,
                              style: const TextStyle(fontSize: 15),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.arrow_drop_down,
                              color: Color(0xFFB65303),
                              size: 25,
                            ),
                          ])),
                    ),
                    const SizedBox(
                      height: 10,
                    ),

                    /// Quantity Row
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Quantity",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: const Color(0xFFF5F5F5),
                          ),
                          child: Row(
                            children: [
                              _qtyButton(Icons.remove, () {
                                if (quantity > 1) {
                                  setModalState(() {
                                    quantity--;
                                    totalAmount=totalAmount-singleticketAmount;
                                    if(isCoupanApplied){
                                      double maxAm=double.parse(maxCoupanValue);
                                      double percent=double.parse(coupanValue);
                                      double disAmount=0.0;
                                      if(coupanType=="percentage"){
                                        disAmount= totalAmount * percent / 100;
                                      }else{
                                        disAmount=percent;
                                      }
                                      if(disAmount<maxAm){
                                        discountAmount=disAmount;
                                        grandTotal=totalAmount-discountAmount;
                                      }else{
                                        discountAmount=maxAm;
                                        grandTotal=totalAmount-discountAmount;
                                      }
                                    }else{
                                      grandTotal=totalAmount;
                                      discountAmount=0.0;
                                    }


                                  });
                                }
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Text(
                                  "$quantity",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              _qtyButton(Icons.add, () {
                                if(quantity<maxTicket){
                                  if(quantity>=availableTicket){
                                    Toast.show(
                                        "$availableTicket tickets are available only.",
                                        duration: Toast.lengthLong,
                                        backgroundColor: Colors.red);
                                  }else{
                                    setModalState(() {
                                      quantity++;
                                      totalAmount=totalAmount+singleticketAmount;
                                      if(isCoupanApplied){
                                        double maxAm=double.parse(maxCoupanValue);
                                        double percent=double.parse(coupanValue);
                                        double disAmount=0.0;
                                        if(coupanType=="percentage"){
                                          disAmount= totalAmount * percent / 100;
                                        }else{
                                          disAmount=percent;
                                        }
                                        if(disAmount<maxAm){
                                          discountAmount=disAmount;
                                          grandTotal=totalAmount-discountAmount;
                                        }else{
                                          discountAmount=maxAm;
                                          grandTotal=totalAmount-discountAmount;
                                        }
                                      }else{
                                        grandTotal=totalAmount;
                                        discountAmount=0.0;
                                      }
                                    });
                                  }

                                }else{
                                  Toast.show(
                                      "Booking is limited to a maximum of $maxTicket tickets per user.",
                                      duration: Toast.lengthLong,
                                      backgroundColor: Colors.red);
                                }

                              }),
                            ],
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 7,),

                    isCoupanApplied?
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Promo Code Applied",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            )),
                        SizedBox(height: 7),
                        Text("Name: $coupanTitle",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        SizedBox(height: 7),
                        Text("Type: $coupanType",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        SizedBox(height: 7),
                        Text("Value: ${coupanType=="percentage"?"":"\$"} $coupanValue ${coupanType=="percentage"?"%":""}",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),
                        SizedBox(height: 7),
                        Text("Discount Upto: \$$maxCoupanValue",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                            )),

                      ],
                    ):
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Promo Code",
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            )),
                        SizedBox(height: 7),
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Color(0xFFEBD8D8), width: 1),
                                    borderRadius: BorderRadius.circular(6)),
                                child: TextFormField(
                                    controller: coupancodeController,
                                    style: const TextStyle(
                                      fontSize: 15.0,
                                      height: 1.6,
                                      color: Colors.black,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Enter promo code',
                                      contentPadding: EdgeInsets.only(
                                          left: 10, bottom: 5),
                                      fillColor: Colors.white,
                                      border: InputBorder.none,
                                      hintStyle: TextStyle(
                                        fontSize: 13.0,
                                        color: Colors.grey,
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(height: 15),
                            GestureDetector(
                              onTap: () async {
                                if(coupancodeController.text.isNotEmpty){
                                  var result= await checkCoupanCode(coupancodeController.text.toString());
                                  isCoupanApplied=result['valid'];
                                  if(isCoupanApplied){
                                    coupanId=result['id'];
                                    coupanType=result['type'];
                                    coupanValue=result['value'];
                                    maxCoupanValue=result['max'];
                                    coupanTitle=result['title'];
                                    double maxAm=double.parse(maxCoupanValue);
                                    double percent=double.parse(coupanValue);
                                    double disAmount=0.0;
                                    if(coupanType=="percentage"){
                                      disAmount= totalAmount * percent / 100;
                                    }else{
                                      disAmount=percent;
                                    }
                                    if(disAmount<maxAm){
                                      discountAmount=disAmount;
                                      grandTotal=totalAmount-discountAmount;
                                    }else{
                                      discountAmount=maxAm;
                                      grandTotal=totalAmount-discountAmount;
                                    }

                                  }
                                  setModalState(() {

                                  });
                                }else{
                                  Toast.show(
                                      "Please enter the Promo code",
                                      duration: Toast.lengthLong,
                                      backgroundColor: Colors.red);
                                }
                              },
                              child: Container(
                                height: 48,
                                // margin: const EdgeInsets.only(right: 15),
                                decoration: BoxDecoration(
                                    color: AppTheme.darkBrown,
                                    border: Border.all(
                                        color: AppTheme.darkBrown, width: 1),
                                    borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(6),
                                        topRight: Radius.circular(6))),
                                child: const Center(
                                  child: Padding(
                                    padding:
                                    EdgeInsets.symmetric(horizontal: 18),
                                    child: Text('Apply',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        )),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),



                    const SizedBox(height: 7),
                    Divider(),
                    const SizedBox(height: 7),

                    /// Price Row
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Price",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$$totalAmount",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BE55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7,),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Discount",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$${discountAmount.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BE55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 7,),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Grand Total",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "\$${grandTotal.toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF00BE55),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: const Color(0xFFE3E3E3)),
                                child: const Center(
                                  child: Text("Back",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      )),
                                )),
                          ),
                        ),
                        SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              getPaymentUrl(grandTotal.toStringAsFixed(2),coupanId);
                              /*Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TicketFormScreen(),
                                      ));*/
                            },
                            child: Container(
                                height: 54,
                                decoration: BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("Checkout",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      )),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }),
    );
  }
  getPaymentUrl(String grandTotalAmount,String coupanId) async {
    print("Selected Quantity $quantity");
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "type": 'class',
      "classId": classId,
      "userId":userId,
      "quantity": quantity, // Assuming default page number
      "coupanId": coupanId, // Assuming default page number
      "amount": grandTotalAmount, // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'yoga_class_management/createYogaClassPayment', resModel, context);
    var responseJSON= json.decode(response.toString());
    Navigator.of(context).pop();
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      print("Payment Url$responseJSON");
      String paymentUrl=responseJSON['paymentUrl']?.toString()??"";
      String sessionId=responseJSON['sessionId']?.toString()??"";
      String bookingId=responseJSON['bookingId']?.toString()??"";
      if(paymentUrl.isNotEmpty){
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => WebViewWordDoc(paymentUrl, bookingId)));
      }else{
        Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      }
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }
  Future<Map<String, dynamic>> checkCoupanCode(String promoCode) async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return {'valid':false,'message':"User id not found"};
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "couponCode": promoCode,
      "userId":userId, // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'coupon/applyCoupon', resModel, context);
    var responseJSON= json.decode(response.toString());
    Navigator.of(context).pop();
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==201){
      var coupan=responseJSON['coupon'];
      String id=coupan['_id']?.toString()??"";
      String discountType=coupan['discountType']?.toString()??"";
      String discountValue=coupan['discountValue']?.toString()??"";
      String maxDiscount=coupan['maxDiscount']?.toString()??"";
      String title=coupan['title']?.toString()??"";
      return {'valid':true,'id':id,'type':discountType,'value':discountValue,'max':maxDiscount,'title':title};

    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return {'valid':false,'message':responseJSON['message']?.toString()??"Something went wrong! Please try again"};
    }

  }

}