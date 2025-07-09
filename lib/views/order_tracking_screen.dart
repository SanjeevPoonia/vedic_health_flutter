import 'package:flutter/material.dart';

class DeliveryTrackingScreen extends StatelessWidget {
  const DeliveryTrackingScreen({super.key});

  // Sample statuses
  final List<Map<String, String>> statuses = const [
    {"title": "Order Received", "date": "06 June, 2025"},
    {"title": "Order Packed", "date": "07 June, 2025"},
    {"title": "Order Dispatched", "date": "07 June, 2025"},
    {"title": "In Transit", "date": "07 June, 2025"},
    {"title": "Out for Delivery", "date": "08 June, 2025"},
    {"title": "Delivered", "date": "09 June, 2025"},
  ];

  @override
  Widget build(BuildContext context) {
    // Index of current status (0-based)
    int currentIndex = 4; // Changed to 4 since "Out for Delivery" is index 4

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Map image at top
          SizedBox(
            height: 400, // Fixed height for map
            width: double.infinity,
            child: Image.asset(
              'assets/map.png',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(color: Colors.blueGrey);
              },
            ),
          ),

          // Back button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          // Draggable bottom sheet
          DraggableScrollableSheet(
            initialChildSize: 0.6, // 60% of screen
            minChildSize: 0.6,
            maxChildSize: 0.9,
            builder: (context, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header row
                        Row(
                          children: [
                            Image.asset(
                              'assets/delivery_package.png',
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey.shade300,
                                  child: const Icon(Icons.local_shipping),
                                );
                              },
                            ),
                            const SizedBox(width: 12),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Out for Delivery",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Estimated Delivery: 12 Mar, 2025",
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Text(
                              "\$45.00",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Order ID
                        const Text(
                          "Order ID - CDTJ23456789",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        const SizedBox(height: 24),

                        const Divider(height: 1),
                        const SizedBox(height: 24),

                        // Package status title
                        const Text(
                          "Package Status",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 16),

                        // Timeline
                        _buildTimeline(statuses, currentIndex),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(List<Map<String, String>> statuses, int currentIndex) {
    return Column(
      children: List.generate(statuses.length, (index) {
        final isCompleted = index <= currentIndex;
        final isCurrent = index == currentIndex;
        final isLast = index == statuses.length - 1;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline indicator
              Column(
                children: [
                  // Dot indicator
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isCompleted
                          ? const Color(0xFF00DB00)
                          : Colors.grey[300],
                      border: Border.all(
                        color: Colors.white,
                        width: 2,
                      ),
                      boxShadow: isCompleted
                          ? [
                              BoxShadow(
                                color: const Color(0xFF00DB00).withOpacity(0.5),
                                blurRadius: 6,
                                spreadRadius: 2,
                              )
                            ]
                          : null,
                    ),
                    child: isCurrent
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : null,
                  ),
                  // Vertical line
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted
                          ? const Color(0xFF00DB00)
                          : Colors.grey[300],
                    ),
                ],
              ),

              const SizedBox(width: 16),

              // Status text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statuses[index]["title"]!,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            isCurrent ? FontWeight.bold : FontWeight.normal,
                        color: isCompleted ? Colors.black : Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      statuses[index]["date"]!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isCompleted ? Colors.grey : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
