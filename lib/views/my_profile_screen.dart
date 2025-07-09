import 'package:flutter/material.dart';
import 'package:toast/toast.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfileScreen> {
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFFF7F8FA),
        //backgroundColor: Colors.red,
        body: Column(
          children: [
            Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 10),
              color: Colors.white,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15))),
              child: Container(
                height: 65,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft:
                        Radius.circular(20), // Adjust the radius as needed
                    bottomRight:
                        Radius.circular(20), // Adjust the radius as needed
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
                            size: 17, color: Colors.black)),
                    const Expanded(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.only(right: 10),
                          child: Text("My Profile",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 2),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10.0, vertical: 6.0),
                  child: Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          const Text("First Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 15)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Dummy Text",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("Last Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Dummy Text",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Dummy Text here",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("Username",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Dummy Text here",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("Street Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Dummy Text here",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("City",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(color: Color(0xFFE3E3E3)),
                            ),
                            child: DropdownButtonFormField<String>(
                              icon: Icon(Icons.keyboard_arrow_down),
                              value: null,
                              hint: const Text("Select"),
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text("Select")),
                                DropdownMenuItem(
                                    value: "Dummy City",
                                    child: Text("Dummy City")),
                              ],
                              onChanged: (_) {},
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("State",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE3E3E3)),
                            ),
                            child: DropdownButtonFormField<String>(
                              icon: Icon(Icons.keyboard_arrow_down),
                              value: null,
                              hint: const Text("Select"),
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text("Select")),
                                DropdownMenuItem(
                                    value: "Dummy State",
                                    child: Text("Dummy State")),
                              ],
                              onChanged: (_) {},
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Zip Code",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "Enter",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 16),
                          const Text("Country",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE3E3E3)),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: null,
                              hint: const Text("Select"),
                              items: [
                                DropdownMenuItem(
                                    value: null, child: Text("Select")),
                                DropdownMenuItem(
                                    value: "Dummy Country",
                                    child: Text("Dummy Country")),
                              ],
                              onChanged: (_) {},
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Mobile Phone",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE3E3E3)),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 6),
                                  child: Image.asset(
                                    'assets/india_flag.png', // Add this asset or use a placeholder
                                    width: 28,
                                    height: 20,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.flag, size: 20),
                                  ),
                                ),
                                const Text('+91',
                                    style: TextStyle(fontSize: 15)),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: TextFormField(
                                    initialValue: "8452102354",
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      contentPadding:
                                          EdgeInsets.symmetric(vertical: 12),
                                    ),
                                    readOnly: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text("Gender",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          Container(
                            decoration: BoxDecoration(
                              color: Color(0xFFF7F8FA),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Color(0xFFE3E3E3)),
                            ),
                            child: DropdownButtonFormField<String>(
                              value: "Female",
                              hint: const Text("Select"),
                              items: [
                                DropdownMenuItem(
                                    value: "Female", child: Text("Female")),
                                DropdownMenuItem(
                                    value: "Male", child: Text("Male")),
                                DropdownMenuItem(
                                    value: "Other", child: Text("Other")),
                              ],
                              onChanged: null, // read-only
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "This information is shared with your service provider to better serve you.",
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                          const SizedBox(height: 16),
                          const Text("DOB",
                              style: TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 14)),
                          const SizedBox(height: 6),
                          TextFormField(
                            initialValue: "12/05/2004",
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: Color(0xFFE3E3E3)),
                              ),
                              filled: true,
                              fillColor: Color(0xFFF7F8FA),
                            ),
                            readOnly: true,
                          ),
                          const SizedBox(height: 22),
                        ],
                      ),
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
}
