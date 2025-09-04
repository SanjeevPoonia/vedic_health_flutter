import 'package:flutter/material.dart';

class DetoxProgramsDetail extends StatefulWidget {
  const DetoxProgramsDetail({super.key});

  @override
  State<DetoxProgramsDetail> createState() => _DetoxProgramsDetailState();
}

class _DetoxProgramsDetailState extends State<DetoxProgramsDetail> {
  int quantity = 1;
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
                              "Detox Programs Detail",
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

              /// Middle Part
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Card(
                      elevation: 1,
                      margin: const EdgeInsets.only(top: 10),
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              child: Image.asset(
                                height: 100,
                                width: 100,
                                "assets/banner2.png",
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "3-Day Cleanse (\$15.00)",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  const Text(
                                    "5 Days Preparation, 5 Days Cleanse, and 5 Days Post-Cleanse Phase",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Container(
                                    height: 25,
                                    width: 75,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              if (quantity > 1) {
                                                quantity--;
                                              }
                                            });
                                          },
                                          child: const Icon(Icons.remove,
                                              size: 16, color: Colors.black87),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Text(
                                            quantity.toString(),
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              quantity++;
                                            });
                                          },
                                          child: const Icon(Icons.add,
                                              size: 16, color: Colors.black87),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Share:",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(Icons.facebook,
                            color: Colors.blue, size: 30),
                        const SizedBox(width: 15),
                        Icon(Icons.one_x_mobiledata,
                            color: Colors.grey[700], size: 30),
                        const SizedBox(width: 15),
                        const Icon(Icons.call, color: Colors.green, size: 30),
                        const SizedBox(width: 15),
                        const Icon(Icons.piano_outlined,
                            color: Colors.red, size: 30),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Signs that you need this cleanse",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBulletPoint("Allergies"),
                    _buildBulletPoint("Menstruation issues"),
                    _buildBulletPoint("General doshic and seasonal imbalance"),
                    _buildBulletPoint("Digestive issues"),
                    _buildBulletPoint("Disturbed sleep"),
                    _buildBulletPoint("Low energy level"),
                    _buildBulletPoint("Low bala (strength)"),
                    const SizedBox(height: 20),
                    const Text(
                      "Your Program includes:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBulletPoint(
                        "Access to online portal for all materials, videos, links and questions"),
                    _buildBulletPoint(
                        "Expert Ayurvedic Guide provided to you during the cleanse phase"),
                    _buildBulletPoint("Instruction booklet"),
                    _buildBulletPoint('''Cleanse Kit (see below)'''),
                    _buildBulletPoint(
                        "Meal menu for each day and meal recipes"),
                    _buildBulletPoint("Yoga videos - asanas for cleansing"),
                    _buildBulletPoint(
                        "Pranayama videos - breathing techniques for cleansing"),
                    _buildBulletPoint(
                        "Yoga Nidra audio for deep relaxation and sleep"),
                    _buildBulletPoint("Abhyanga at home instructional video"),
                    _buildBulletPoint(
                        "Kitchari and ghee preparation - online instructional videos"),
                    _buildBulletPoint("Nasyam at home - instructional video"),
                    _buildBulletPoint(
                        "10% discount on all panchakarma therapies at our center during the 15-day period"),
                    const SizedBox(height: 20),
                    const Text(
                      "Your Program includes:",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _buildBulletPoint("Cleanse Herbs"),
                    _buildBulletPoint("Abhyanga oil"),
                    _buildBulletPoint("Nasya oil"),
                    _buildBulletPoint("Detox Teas"),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF38328),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Add to Cart",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF662A09),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    "Checkout",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star, size: 18, color: Colors.black),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
