import 'package:flutter/material.dart';

class MembershipDetailScreen extends StatefulWidget {
  const MembershipDetailScreen({super.key});

  @override
  State<MembershipDetailScreen> createState() => _MembershipDetailScreenState();
}

class _MembershipDetailScreenState extends State<MembershipDetailScreen> {
  int quantity = 1;

  final List<String> details = [
    "All benefits in Basic and E-Studio included",
    "Benefits apply to your whole family",
    "Entry to Amita Jain's virtual 'Open Office' for Q&A",
    "Entry to all yoga classes at our Studio for you and family",
    "Free 30 minute targeted massage therapy",
    "10% off all our Ayurvedic herbals, teas, and products",
    "10% off all our Ayurvedic panchakarma therapies",
    "10% off all other therapies",
    "20% off all seasonal detox programs",
    "Access to the Premium Video Library of exclusive videos",
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              /// Top Image
              SizedBox(
                height: 250,
                width: double.infinity,
                child: Image.asset(
                  "assets/banner2.png", // replace with your membership image
                  fit: BoxFit.cover,
                ),
              ),

              /// Back + Share Buttons
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
                  onTap: () {},
                ),
              ),

              /// Scrollable Rounded White Container
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
                      /// Title
                      const Text(
                        "Basic Membership - Community & Events",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Quantity Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              color: Color(0xFFF5F5F5),
                            ),
                            child: Row(
                              children: [
                                _qtyButton(Icons.remove, () {
                                  if (quantity > 1) {
                                    setState(() {
                                      quantity--;
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
                                  setState(() {
                                    quantity++;
                                  });
                                }),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// Price Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Price",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            "\$29.00",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF00BE55),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),
                      Divider(),
                      const SizedBox(height: 10),

                      /// Details Header
                      const Text(
                        "Details",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Details List
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: details.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Icon(Icons.check,
                                    color: Colors.green, size: 20),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    details[index],
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ],
                            ),
                          );
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
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {},
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

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        child: Icon(icon, size: 18),
      ),
    );
  }
}
