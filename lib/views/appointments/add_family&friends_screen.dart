import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';
import 'package:vedic_health/views/appointments/add_to_waitlist_screen.dart';

import '../../network/Utils.dart';
import '../../network/api_dialog.dart';
import '../../network/api_helper.dart';

class AddFamilyFriendScreen extends StatefulWidget {
  const AddFamilyFriendScreen({
    super.key,
  });
  @override
  State<AddFamilyFriendScreen> createState() => _AddFamilyFriendScreenState();
}

class _AddFamilyFriendScreenState extends State<AddFamilyFriendScreen> {

  int selectedRelationPosition=0;
  String selectedRelationType="Parent";

  int selectedGenderIndex=0;
  String selectedGenderType="Male";

  var emailController=TextEditingController();
  var phoneController=TextEditingController();
  var firstNameController=TextEditingController();
  var lastNameController=TextEditingController();
  var speciesController=TextEditingController();
  var weightController=TextEditingController();



  int selectedServiceIndex = 0;
  String selectedServiceDrop = "";
  bool secondService = false;
  int? selectedTimeIndex;
  List relationList = ["Parent", "Spouse", "Child", "Sibling", "Friend","Pet"];
  List genderList = ["Male", "Female"];

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
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
                              "Add Family & Friends",
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

              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Relationship",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              relationBottomSheet(context);
                            });
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey.shade400),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child:  Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedRelationType.isEmpty?"Select":selectedRelationType,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Icon(Icons.arrow_drop_down_rounded)
                                  ])),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
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
                            controller: emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 116, 115, 115)),
                              hintText:
                              "Enter",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Phone",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 15,
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
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 116, 115, 115)),
                              hintText:
                              "Enter",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "First Name",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
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
                            controller: firstNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 116, 115, 115)),
                              hintText:
                              "Enter",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          "Last Name",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
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
                            controller: lastNameController,
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              hintStyle: TextStyle(
                                  color: Color.fromARGB(255, 116, 115, 115)),
                              hintText:
                              "Enter",
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 12),
                            ),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(height: 12),
                        selectedRelationType=="Pet"?
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Species/Breed",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                                    controller: speciesController,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(255, 116, 115, 115)),
                                      hintText:
                                      "Enter",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                const Text(
                                  "Weight",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
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
                                    controller: weightController,
                                    keyboardType: TextInputType.name,
                                    decoration: const InputDecoration(
                                      hintStyle: TextStyle(
                                          color: Color.fromARGB(255, 116, 115, 115)),
                                      hintText:
                                      "Enter weight(lbs)",
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 12),
                                    ),
                                    maxLines: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),

                              ],
                            ):Container(

                        ),



                        const Text(
                          "Gender",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            genderBottomSheet(context);
                          },
                          child: Container(
                            width: double.maxFinite,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:  Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selectedGenderType.isEmpty?"Select":selectedGenderType,
                                  style: TextStyle(fontSize: 15),
                                ),
                                Icon(Icons.arrow_drop_down_rounded)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
      ),
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
                      Navigator.pop(context);
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
                    onPressed: () {
                      addFamilyFriend();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF662A09),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text(
                      "Save",
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
    ));
  }

  void relationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: 400,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Select Relation',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
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
                    Expanded(
                      child: Container(
                        // height: 150,
                        child: ListView.builder(
                            itemCount: relationList.length,
                            itemBuilder: (BuildContext context, int pos) {
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedRelationPosition = pos;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 13, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      selectedRelationPosition == pos
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                          : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          relationList[pos],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedRelationType=relationList[selectedRelationPosition];
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                                height: 54,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("Submit",
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
              ],
            ),
          ),
        );
      }),
    );
  }
  void genderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      // isScrollControlled: true,
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
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: SizedBox(
            height: 300,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Text('Select Gender',
                              style: TextStyle(
                                  fontSize: 19,
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black)),
                        ),
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
                    Expanded(
                      child: Container(
                        // height: 150,
                        child: ListView.builder(
                            itemCount: genderList.length,
                            itemBuilder: (BuildContext context, int pos) {
                              return GestureDetector(
                                onTap: () {
                                  setModalState(() {
                                    selectedGenderIndex = pos;
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10, left: 13, right: 10),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      selectedGenderIndex == pos
                                          ? const Icon(
                                              Icons.radio_button_checked,
                                              color: AppTheme.darkBrown)
                                          : const Icon(Icons.radio_button_off,
                                              color: Color(0xFF707070)),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          genderList[pos],
                                          style: TextStyle(
                                            fontSize: 16,
                                            color:
                                                Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }),
                      ),
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                        Expanded(
                          child: GestureDetector(
                            onTap: () {

                              setState(() {
                                selectedGenderType=genderList[selectedGenderIndex];
                              });
                              Navigator.of(context).pop();
                            },
                            child: Container(
                                height: 54,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: const Color(0xFF662A09)),
                                child: const Center(
                                  child: Text("Submit",
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
              ],
            ),
          ),
        );
      }),
    );
  }

  Future<void> addFamilyFriend() async {

    if(selectedRelationType.isEmpty){
      Toast.show("Please select Relationship",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(emailController.text.isEmpty){
      Toast.show("Please Enter Email",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(phoneController.text.isEmpty){
      Toast.show("Please Enter Phone Number",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(firstNameController.text.isEmpty){
      Toast.show("Please Enter First Name",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(lastNameController.text.isEmpty){
      Toast.show("Please Enter Last Name",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }else if(selectedRelationType=="pet"){
      if(speciesController.text.isEmpty){
        Toast.show("Please Enter First Name",duration: Toast.lengthLong,backgroundColor: Colors.red);
        return ;
      }else if(weightController.text.isEmpty){
        Toast.show("Please Enter Weight",duration: Toast.lengthLong,backgroundColor: Colors.red);
        return ;
      }
    }else if(selectedGenderType.isEmpty){
      Toast.show("Please Select Gender",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return ;
    }
    APIDialog.showAlertDialog(context, "Please Wait...");
    String userId= await MyUtils.getSharedPreferences("user_id")??"";
    try {
      // Prepare payload
      var requestPayload = {
        "relation":selectedRelationType,
        "email":emailController.text,
        "phone":phoneController.text,
        "firstName":firstNameController.text,
        "lastName":lastNameController.text,
        "gender":selectedGenderType,
        "species":speciesController.text,
        "weight":weightController.text,
        "userId":userId
      };
      var requestModel = {
        "data": base64.encode(utf8.encode(json.encode(requestPayload))),
      };
      ApiBaseHelper helper = ApiBaseHelper();
      var response = await helper.postAPI(
        'user-family/create',
        requestModel,
        context,
      );
      var responseJSON = json.decode(response.toString());
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }

      if(responseJSON['statusCode']==201){
        Toast.show(responseJSON['message']?.toString()??"Family Added Successfully",
            duration: Toast.lengthLong,backgroundColor: Colors.green);
        Navigator.of(context).pop();
      }else{
        Toast.show(responseJSON['message']?.toString()??"Failed to create family",
            duration: Toast.lengthLong,backgroundColor: Colors.red);
      }




    } catch (e) {
      print("Error fetching addresses: $e");
      if(Navigator.canPop(context)){
        Navigator.of(context).pop();
      }
    }


  }


}
