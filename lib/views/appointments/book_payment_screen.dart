import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:vedic_health/network/api_helper.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';
import 'package:vedic_health/views/appointments/selectotherperson_screen.dart';

class BookPaymentScreen extends StatefulWidget {
  final DateTime date;
  final String userId;
  final String name;

  const BookPaymentScreen({
    super.key,
    required this.date,
    required this.userId,
    required this.name,
  });
  @override
  State<BookPaymentScreen> createState() => _BookPaymentScreenState();
}

class _BookPaymentScreenState extends State<BookPaymentScreen> {
  bool _sameAsShipping = true;
  bool _agreeToPolicy = false;
  String _bookingFor = 'me'; // 'me' or 'other'
  final TextEditingController _specialRequestController =
      TextEditingController();
  List<Map<String, dynamic>> userAddresses = [];
  bool isLoading = false;
  Map<String, dynamic>? selectedAddress;
  @override
  void initState() {
    super.initState();
    fetchUserAddresses(widget.userId);
  }

  Future<void> fetchUserAddresses(String userId) async {
    setState(() {
      isLoading = true;
      userAddresses = [];
    });

    try {
      // Prepare payload
      var requestPayload = {
        "user": userId,
      };

      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };

      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'users/all-address',
        requestModel,
        context,
      );

      var responseJSON = json.decode(response.toString());

      if (responseJSON["data"] != null &&
          responseJSON["data"]["data"] != null &&
          responseJSON["data"]["data"].isNotEmpty) {
        setState(() {
          userAddresses = List<Map<String, dynamic>>.from(
            responseJSON["data"]["data"],
          );
        });
      } else {
        setState(() {
          userAddresses = [];
        });
      }
    } catch (e) {
      print("Error fetching addresses: $e");
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top App Bar
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
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Icon(Icons.arrow_back_ios_new_sharp,
                            size: 17, color: Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Payment",
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
              const SizedBox(
                height: 12,
              ),

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    width: 1,
                    color: const Color(0xFFDBDBDB),
                  ),
                ),
                margin: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(
                              "https://randomuser.me/api/portraits/men/78.jpg"), // Replace with actual image asset
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                            const Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star, color: Colors.amber, size: 18),
                                Icon(Icons.star_half,
                                    color: Colors.amber, size: 18),
                                SizedBox(width: 5),
                                Text("(8)"),
                              ],
                            ),
                            const SizedBox(height: 5),
                            const Text(
                              "\$125.00", // This price is static, you could also pass this as a parameter
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Who Are You Booking For?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (userAddresses.isEmpty)
                      const Text("No saved addresses found.")
                    else
                      Column(
                        children: userAddresses.map((address) {
                          final fullName = address["name"] ?? "Unknown";
                          final uniqueId = address["_id"];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  width: 1, color: const Color(0xFFDBDBDB)),
                              color: selectedAddress != null &&
                                      selectedAddress!["_id"] == uniqueId
                                  ? const Color.fromARGB(70, 243, 131, 40)
                                  : Colors.white,
                            ),
                            child: Row(
                              children: [
                                Radio(
                                  activeColor: const Color(0xFF865940),
                                  value: uniqueId,

                                  // ignore: deprecated_member_use
                                  groupValue: selectedAddress?["_id"],
                                  // ignore: deprecated_member_use
                                  onChanged: (value) {
                                    setState(() {
                                      selectedAddress = address;
                                    });

                                    // If "Other" type, push SelectOtherPersonScreen
                                    if (address["name"] == "Other Person") {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              SelectOtherPersonScreen(
                                            address:
                                                address, // ✅ Pass selected address
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Text(
                                      "$fullName - ${address["city"]}, ${address["country"]}",
                                      style: TextStyle(
                                        fontWeight: selectedAddress != null &&
                                                selectedAddress!["_id"] ==
                                                    uniqueId
                                            ? FontWeight.bold
                                            : FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // About Your Appointment Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About Your Appointment",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      child: TextField(
                        controller: _specialRequestController,
                        decoration: InputDecoration(
                          hintStyle: const TextStyle(
                              color: Color.fromARGB(255, 116, 115, 115)),
                          hintText:
                              "Do you have any special request or ideas to share with service provider? (Optional)",
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                        ),
                        maxLines: 3,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Price Detail Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Price Detail",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: const Color(0xFFDBDBDB),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Amount",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text("\$125.00",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Divider(),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text("Total Due Now",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600)),
                                  const SizedBox(width: 10),
                                  Container(
                                      height: 20,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 7),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: const Color(0xFF662A09)),
                                      child: const Center(
                                        child: Text("Hold with card",
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white,
                                            )),
                                      )),
                                ],
                              ),
                              const Text("\$0.00",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total Due at Business",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                              Text("\$125.00",
                                  style:
                                      TextStyle(fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Billing Address Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Billing Address",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      activeColor: const Color(0xFF23B816),
                      title: const Text("Same as shipping address"),
                      value: _sameAsShipping,
                      onChanged: (value) {
                        setState(() {
                          _sameAsShipping = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (!_sameAsShipping) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFDBDBDB),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: Image.asset(
                                "assets/usaflag.png",
                                width: 24,
                                height: 24,
                              ),
                            ),
                            Container(
                              height: 32,
                              width: 1,
                              color: const Color(0xFFDBDBDB),
                            ),
                            Expanded(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                  hintText: "Address Line 1",
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            width: 1,
                            color: const Color(0xFFDBDBDB),
                          ),
                        ),
                        child: const TextField(
                          decoration: InputDecoration(
                            hintText: "Address Line 2 (Optional)",
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Cancellation Policy Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Cancellation Policy",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We ask that you please reschedule or cancel at least 24 hours before the beginning of your appointment or you may be charged a cancellation fee of \$50.",
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF23B816),
                          fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 10),
                    CheckboxListTile(
                      activeColor: const Color(0xFF23B816),
                      title: const Text(
                        "By Clicking \"Book\" you agree to the Cancellation Policy and conditions of this business.",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      value: _agreeToPolicy,
                      onChanged: (value) {
                        setState(() {
                          _agreeToPolicy = value!;
                        });
                      },
                      controlAffinity: ListTileControlAffinity.leading,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),

        /// Sticky Bottom Search Button
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisSize: MainAxisSize.min, // important to keep it small
            children: [
              const Divider(
                thickness: 1,
                color: Colors.grey, // change color as per UI
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddToWaitlistScreen(),
                            ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE3E3E3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Back",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF23B816),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                      ),
                      child: const Text(
                        "Book Now",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
