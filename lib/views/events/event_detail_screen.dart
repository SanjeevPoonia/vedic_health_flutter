import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vedic_health/network/api_dialog.dart';
import 'package:vedic_health/network/loader.dart';
import 'package:vedic_health/views/events/ticket_form_screen.dart';
import '../../network/Utils.dart';
import '../../network/api_helper.dart';
import '../../network/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../utils/app_theme.dart';
import '../word_webview_screen.dart';
class EventDetailScreen extends StatefulWidget {
  String eventId;
  EventDetailScreen(this.eventId,{super.key});
  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}
class _EventDetailScreenState extends State<EventDetailScreen> {

  int quantity = 1;
  int quantityRSVP = 1;
  String selectedtickettype = 'Paid';
  String selectedRSVPType='RSVP';
  List ticketList = [
    "Social Media",
    "Family or Friends",
    "Youtube/Facebook Ads",
    "Other",
  ];
  bool isLoading=false;

  String eventTitle="";
  String eventImageFile="";
  String eventDescription="";
  String eventDateTimeAddress="";
  String latitude="";
  String longitude="";

  String eventHost="";
  String eventFormat="";
  String eventPrice="";
  String speakerDescription="";

  int maxTicket=0;
  bool isRsvp=false;

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Stack(
      children: [
        SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  /// Top Image
                  /*SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  "assets/banner2.png",
                  fit: BoxFit.cover,
                ),
              ),*/
                  ClipRRect(
                    borderRadius: BorderRadius.circular(0),
                    child: CachedNetworkImage(
                      imageUrl: eventImageFile,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        height: 250,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: _circleIconButton(
                      icon: Icons.arrow_back_ios_new,
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _circleIconButton(
                      icon: Icons.share_outlined,
                      onTap: () {
                        _showShareOptions(context, widget.eventId);
                      },
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 220),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //here
                          Text(
                            eventTitle,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.left,
                          ),
                          const SizedBox(height: 8),
                          Html(
                            data: speakerDescription,
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                color: Colors.black54,
                              ),
                            },
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date & Location",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                              if(latitude.isNotEmpty&&longitude.isNotEmpty)
                                InkWell(
                                  onTap: (){
                                    openMap(latitude, longitude);
                                  },
                                  child:Row(
                                    children: [
                                      Icon(Icons.directions, color: Colors.blue),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        "View Location",
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            eventDateTimeAddress,
                            style: const TextStyle(fontSize: 14, color: Colors.black87),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "About The Event",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text:  TextSpan(
                              style: TextStyle(fontSize: 15, color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: "Host: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: eventHost,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text:  TextSpan(
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: "Format: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: eventFormat,
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          RichText(
                            text:  TextSpan(
                              style: const TextStyle(fontSize: 15, color: Colors.black),
                              children: [
                                const TextSpan(
                                  text: "Cost: ",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: "\$$eventPrice",
                                  style: const TextStyle(color: Colors.black87),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            "Description",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Html(
                            data: eventDescription,
                            style: {
                              "body": Style(
                                fontSize: FontSize(14),
                                color: Colors.black54,
                              ),
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Sticky Bottom Button
            bottomNavigationBar: isLoading?Container():Padding(
              padding:  EdgeInsets.all(14),
              child: ElevatedButton(
                onPressed: () {
                  isRsvp?_showBookBottomDialogRSVP(context):
                  _showBookBottomDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFB65303),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child:  Center(
                child: Loader(),
              ),
            ),
          ),
      ],
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
  Widget _circleIconButton(
      {required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
      child: IconButton(
        icon: Icon(icon, size: 20),
        onPressed: onTap,
      ),
    );
  }
  @override
  void initState() {
    super.initState();
    fetchEventsDetails();
  }
  fetchEventsDetails() async {
    setState(() {
      isLoading = true;
    });
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      setState(() {
        isLoading = false;
      });
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "user": userId,
      "id": widget.eventId, // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'event_management/view', resModel, context);
    var responseJSON= json.decode(response.toString());
    int statusCode=responseJSON['statusCode']??0;
    if(statusCode==200){
      var event=responseJSON['event'];
      if(event!=null){
        eventTitle= event['eventname']?.toString()??"";
        String imagePath= event['coverImage']?.toString()??"";
        String icon_file= event['icon_file']?.toString()??"";
        if(imagePath.isNotEmpty){
          eventImageFile=AppConstant.appBaseURL+imagePath;
        }
        else if(icon_file.isNotEmpty){
          eventImageFile=AppConstant.appBaseURL+icon_file;
        }
        isRsvp=event['is_rsvp']??false;
        eventDescription=event['description']?.toString()??"";
        String address=event['address']?.toString()??"";
        String eventD=event['date']?.toString()??"";
        String time=event['time']?.toString()??"";
        String eventDate=formatDateUtc(eventD);
        eventDateTimeAddress="$eventDate , $time \n$address";
        latitude=event['latitude']?.toString()??"";
        longitude=event['longitude']?.toString()??"";
        eventHost=event['host_name']?.toString()??"";
        eventFormat=event['format']?.toString()??"";
        eventPrice=event['Price']?.toString()??"";
        speakerDescription=event['speakerdescription']?.toString()??"";
        maxTicket=event['max_tickets']??1;




        setState(() {
          isLoading = false;
        });

      }else{
        setState(() {
          isLoading = false;
        });
        Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
        finishScreen();
      }



    }else{
      setState(() {
        isLoading = false;
      });
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
      finishScreen();
    }

  }
  String formatDateUtc(String date) {
    try {
      DateTime dateTime = DateTime.parse(date).toLocal();
      return DateFormat('dd MMM, yyyy').format(dateTime);
    } catch (e) {
      return date;
    }
  }
  Future<void> openMap(String latitude, String longitude) async {
    final Uri googleUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    try {
      if (await canLaunchUrl(googleUrl)) {
        await launchUrl(
          googleUrl,
          mode: LaunchMode.externalApplication,
        );
      } else {
        await launchUrl(
          googleUrl,
          mode: LaunchMode.platformDefault,
        );
      }
    } catch (e) {
      debugPrint("Error opening map: $e");
    }
  }
  void finishScreen(){
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
  void _showShareOptions(BuildContext context, id) {
    final ApiBaseHelper helper = ApiBaseHelper();
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(FontAwesomeIcons.whatsapp, color: Colors.green),
                title: Text('Share via WhatsApp'),
                onTap: () async {
                  final text = "Check this Event: " +
                      helper.getFrontEndUrl() +
                      "Events/Event-Details/" +
                      id;
                  final whatsappUrl = Uri.parse("whatsapp://send?text=$text");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("WhatsApp not installed")),
                    );
                  }
                },
              ),
              ListTile(
                leading: Icon(FontAwesomeIcons.instagram, color: Colors.purple),
                title: Text('Share on Instagram'),
                onTap: () {
                  // Instagram doesn't allow direct text sharing
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content:
                        Text("Instagram sharing not supported directly")),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.link, color: Colors.blue),
                title: Text('Copy Link'),
                onTap: () {
                  Clipboard.setData(ClipboardData(
                      text: helper.getFrontEndUrl() + "Events/Event-Details/" + id));
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Link copied!")),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.share, color: Colors.black),
                title: Text('More Options'),
                onTap: () {
                  Share.share("Check this event: " +
                      helper.getFrontEndUrl() + "Events/Event-Details/" + id);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  _showBookBottomDialog(BuildContext context){
    var coupancodeController= TextEditingController();
    double singleticketAmount=double.parse(eventPrice);
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
                        Text('Register',
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
                    ):Column(
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
      "type": 'event',
      "eventId": widget.eventId,
      "userId":userId,
      "quantity": quantity, // Assuming default page number
      "coupanId": coupanId, // Assuming default page number
      "amount": grandTotalAmount, // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'event_management/createEventPayment', resModel, context);
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
  _showBookBottomDialogRSVP(BuildContext context){

    double singleticketAmount=double.parse(eventPrice);
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
                        Text('Register',
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
                                  setModalState(() {
                                    quantityRSVP++;
                                    totalAmount=totalAmount+singleticketAmount;
                                    grandTotal=totalAmount;

                                  });
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
      "eventId": widget.eventId,
      "userId":userId,
      "quantity": quantityRSVP, // Assuming default page number
      // Assuming default page number
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI(
        'event_management/createEventRSVP', resModel, context);
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



}
