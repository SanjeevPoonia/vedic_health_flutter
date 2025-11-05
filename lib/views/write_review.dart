import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:toast/toast.dart';

import '../network/Utils.dart';
import '../network/api_dialog.dart';
import '../network/api_helper.dart';

class WriteReviewScreen extends StatefulWidget {
  final String productName;
  final String brandName;
  final String productImage;
  final String productId;

  const WriteReviewScreen({
    super.key,
    required this.productName,
    required this.brandName,
    required this.productImage,
    required this.productId
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
    ToastContext().init(context);
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(child: Column(children: [
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

              Padding(
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
                                      ? ClipRRect(
                                    borderRadius: BorderRadius.circular(16), // rounded corners
                                    child: CachedNetworkImage(
                                      height: 80,
                                      width: 80,
                                      imageUrl: widget.productImage??"",
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
                                  )
                                      : Container(
                                    width: 60,
                                    height: 60,
                                    color: Colors.grey[200],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
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
                    /*// Share a video or photo
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
                    const SizedBox(height: 16),*/
                    // Title your Review
                    /*const Text(
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
                    ),*/

                  ],
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
                          }else if(_reviewController.text.isEmpty){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please write your review'),
                              ),
                            );
                            return;
                          }
                          writeOrder();
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
            ]),)));
  }
  writeOrder() async {
    APIDialog.showAlertDialog(context, "Please wait...");
    String? userId = await MyUtils.getSharedPreferences("user_id");
    if (userId == null) {
      return;
    }
    ApiBaseHelper helper = ApiBaseHelper();
    Map<String, dynamic> requestBody = {
      "rating": _rating,
      "review": _reviewController.text,
      "product_id": widget.productId,
      "user_id": userId // Assuming default page size
    };
    var resModel = {
      'data': base64.encode(utf8.encode(json.encode(requestBody)))
    };
    var response = await helper.postAPI('product/add-review', resModel, context);
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
    var responseJSON= json.decode(response.toString());
    print(responseJSON);
    if(responseJSON["statusCode"]==200||responseJSON["statusCode"]==201){
      Toast.show(responseJSON['message']?.toString()??"Review submitted Successfully!",duration: Toast.lengthLong,backgroundColor: Colors.green);
      _finishScreen();
    }else{
      Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }



  }
  _finishScreen(){
    if(Navigator.canPop(context)){
      Navigator.of(context).pop();
    }
  }
}
