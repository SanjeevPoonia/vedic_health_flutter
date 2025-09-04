import 'package:flutter/material.dart';
import 'package:vedic_health/views/appointments/book_classes/book_class_screen.dart';

class SelectClassScreen extends StatefulWidget {
  const SelectClassScreen({super.key});

  @override
  State<SelectClassScreen> createState() => _SelectClassScreenState();
}

class _SelectClassScreenState extends State<SelectClassScreen> {
  List<String> classList = [
    "Pranayama and Meditation",
    "Surya Namaskar: Practice and Form",
    "Hatha Yoga Level I",
    "Trataka Candle Meditation",
    "Kids Yoga & Fitness",
    "Indian Dance & Stretch",
    "Chinmaya Mission Yoga",
    "Chair Yoga",
    "Gentle Yoga",
    "Hatha Yoga All Levels",
    "Hatha Yoga Level II"
  ];

  /// Track which classes are selected
  List<bool> selected = [];

  @override
  void initState() {
    super.initState();
    selected = List.generate(classList.length, (index) => false);
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
                            "Book Class",
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

            /// Class List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: classList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  decoration: BoxDecoration(
                      color: Color(0xFFF8F8F8),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            borderRadius: BorderRadius.circular(20)),
                        child: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: Image.asset(
                            "assets/leaf.png",
                            height: 25,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      /// Class Name
                      Expanded(
                        child: Text(
                          classList[index],
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),

                      /// Checkbox
                      Checkbox(
                        value: selected[index],
                        activeColor: const Color(0xFFB65303),
                        onChanged: (value) {
                          setState(() {
                            selected[index] = value ?? false;
                          });
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        )),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(14),
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BookClassScreen(),
                  ));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFB65303),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              "Continue",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
