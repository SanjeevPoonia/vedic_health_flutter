import 'package:flutter/material.dart';

class WriteReviewScreen extends StatefulWidget {
  final String productName;
  final String brandName;
  final String? productImage;

  const WriteReviewScreen({
    super.key,
    required this.productName,
    required this.brandName,
    this.productImage,
  });

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final TextEditingController _reviewController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Column(children: [
              // App Bar
              Card(
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
                            size: 17, color: Colors.black),
                      ),
                      const Expanded(
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Text(
                              "Write Review",
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // How was the product?
                      const Text(
                        'How was the product?',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: widget.productImage != null
                                        ? Image.asset(
                                            widget.productImage!,
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Container(
                                            width: 60,
                                            height: 60,
                                            color: Colors.grey[200],
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.productName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          widget.brandName,
                                          style: const TextStyle(
                                              color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              // Star Rating
                              Row(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: List.generate(5, (index) {
                                      return IconButton(
                                        icon: Icon(
                                          index < _rating
                                              ? Icons.star
                                              : Icons.star_border,
                                          size: 32,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _rating = index + 1.0;
                                          });
                                        },
                                      );
                                    }),
                                  ),
                                  const Spacer(),
                                  TextButton(
                                    onPressed: () {
                                      _reviewController.clear();
                                      _titleController.clear();
                                      setState(() => _rating = 0);
                                    },
                                    child: const Text(
                                      'Clear',
                                      style: TextStyle(color: Colors.orange),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Write a Review
                      const Text(
                        'Write a Review',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _reviewController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: 'Enter about product',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Share a video or photo
                      Container(
                        width: double.infinity,
                        height: 56,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image_outlined, color: Colors.grey),
                            SizedBox(width: 8),
                            Text(
                              'Share a video or photo',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Title your Review
                      const Text(
                        'Title your Review',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                          hintText: 'Enter',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Back'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (_rating < 1) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please select a rating'),
                              ),
                            );
                            return;
                          }
                          // Process review submission
                          Navigator.pop(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5A2D0C),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ])));
  }
}
