import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:vedic_health/utils/app_theme.dart';

import '../network/Utils.dart';
import '../network/app_exceptions.dart';
import '../network/constants.dart';
import '../widgets/notification_bar_widget.dart';
import 'package:flutter/services.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

import 'home_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyProfileScreen> {
  String? name;
  String? email;
  String? userId;
  String? profileImage;

  String? firstName;
  String? lastName;
  String? dob;
  String? phone;
  String? gender;
  String? Address1;
  String? Address2;
  String? city;
  String? state;
  String? zipCode;
  String? country;

  bool isEdit=false;

  var firstNameController= TextEditingController();
  var lastNameController= TextEditingController();
  var phoneController= TextEditingController();
  var dobController= TextEditingController();
  var address1Controller= TextEditingController();
  var address2Controller= TextEditingController();
  var cityController= TextEditingController();
  var stateController= TextEditingController();
  var zipcodeController= TextEditingController();
  var countryController= TextEditingController();

  File? selectedImageFile;
  String selectedGender="";


  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(

        children: [
          NotificationBarWidget(),
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
                          size: 24, color: Colors.black)),
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

                        Center( child: Stack(
                          children: [
                            profileImageWidget(),
                            /*profileImage == null || profileImage!.isEmpty?
                            Container(
                              width: 88,
                              height: 88,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border:
                                  Border.all(width: 2, color: Colors.white)),
                              child: Container(
                                width: 88,
                                height: 88,
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/user_d2.png"))
                                ),
                              ),
                            ):
                            ClipRRect(borderRadius: BorderRadius.circular(44), // rounded corners
                              child: CachedNetworkImage(
                                height: 88,
                                width: 88,
                                imageUrl: profileImage??"",
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  color: Colors.grey[200],
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Image.asset("assets/user_d2.png",height: 88,width: 88,),
                              ),
                            ),*/
                            Positioned(
                                top: 55,
                                left: 55,
                                child: GestureDetector(
                                  onTap: () {
                                    if(isEdit){
                                      pickImageFromGallery();
                                    }
                                  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    padding: const EdgeInsets.all(7),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                            color: Colors.white, width: 1),
                                        color: const Color(0xFFF38328)),
                                    child: Image.asset("assets/edit_img.png",
                                        color: Colors.white),
                                  ),
                                )),
                          ],
                        ),),
                        const SizedBox(width: 12),
                        const Text("Email", style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(
                          initialValue: email,
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

                        const SizedBox(height: 8),
                         Text(isEdit?"First Name*":"First Name",
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 15)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: firstNameController,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("Last Name",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: lastNameController,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                         Text(isEdit?"DOB*":"DOB",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),

                        TextFormField(

                          onTap: (){
                            if(isEdit){
                              selectDOB(context);
                            }
                          },
                          controller: dobController,
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
                        const Text("Gender",
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
                            value: gender!.isEmpty?null:gender,
                            hint: const Text("Select"),
                            items: [
                              DropdownMenuItem(
                                  value: null, child: Text("Select")),
                              DropdownMenuItem(
                                  value: "Male",
                                  child: Text("Male")),
                              DropdownMenuItem(
                                  value: "Female",
                                  child: Text("Female")),
                              DropdownMenuItem(
                                  value: "Other",
                                  child: Text("Other")),
                              DropdownMenuItem(
                                  value: "Prefer not to say",
                                  child: Text("Prefer not to say")),
                            ],
                            onChanged: isEdit?(value) {
                              setState(() {
                                selectedGender=value??"";
                                gender=value??"";
                              });
                            }:null,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                         Text(isEdit?"Mobile*":"Mobile",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: phoneController,
                          keyboardType: TextInputType.phone,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),


                        const Text("Address 1",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: address1Controller,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("Address 2",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: address2Controller,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("City",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: cityController,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("State",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: stateController,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("Zipcode",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: zipcodeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),
                        const Text("Country",
                            style: TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 14)),
                        const SizedBox(height: 6),
                        TextFormField(

                          controller: countryController,
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
                          readOnly: !isEdit,
                        ),
                        const SizedBox(height: 16),




                        const SizedBox(height: 8),
                        const Text(
                          "This information is shared with your service provider to better serve you.",
                          style: TextStyle(fontSize: 12, color: Colors.black),
                        ),

                        isEdit?
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              validateTheValues();
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.darkBrown, // button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Save Changes",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ):SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isEdit=true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.darkBrown, // button color
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
    );
  }
  Future<void> pickImageFromGallery() async {

    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (image != null) {
      selectedImageFile = File(image.path);
      setState(() {});
    }
  }

  void validateTheValues(){
    String firName=firstNameController.text.trim();
    String dobStr=dobController.text.trim();
    String phoneStr=phoneController.text.trim();
    final RegExp globalPhoneRegex = RegExp(
      r'^\+?[1-9]\d{7,14}$',
    );

    if(firName.isEmpty){
      Toast.show("Please enter your first name to continue.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else if(dobStr.isEmpty){
      Toast.show("Please select your DOB to continue.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else if(phoneStr.isEmpty){
      Toast.show("Please enter your mobile number to continue.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else if(phoneStr.isEmpty || !globalPhoneRegex.hasMatch(phoneStr)){
      Toast.show("Mobile should be a valid mobile number.",duration: Toast.lengthLong,backgroundColor: Colors.red);
      return;
    }else{
      updateProfileApi(context);
    }
  }
  Widget profileImageWidget() {

    if (selectedImageFile != null) {

      return ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: Image.file(
          selectedImageFile!,
          height: 88,
          width: 88,
          fit: BoxFit.cover,
        ),
      );

    } else if (profileImage != null && profileImage!.isNotEmpty) {

      return ClipRRect(
        borderRadius: BorderRadius.circular(44),
        child: CachedNetworkImage(
          height: 88,
          width: 88,
          imageUrl: profileImage!,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.grey[200],
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (context, url, error) =>
              Image.asset("assets/user_d2.png", height: 88, width: 88),
        ),
      );

    } else {

      return Container(
        width: 88,
        height: 88,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2, color: Colors.white),
        ),
        child: const CircleAvatar(
          backgroundImage: AssetImage("assets/user_d2.png"),
        ),
      );
    }
  }

  Future<void> selectDOB(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(), // future dates disabled
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";

      dobController.text = formattedDate;
    }
  }
  @override
  void initState() {
    super.initState();
    fetchUserDetails();
  }
  fetchUserDetails() async {
    name = await MyUtils.getSharedPreferences("name");
    email = await MyUtils.getSharedPreferences("email");
    userId = await MyUtils.getSharedPreferences("user_id");
    String? image = await MyUtils.getSharedPreferences("image");
    if(image!=null && image.isNotEmpty){
      profileImage=AppConstant.appBaseURL+image;
    }
     firstName=await MyUtils.getSharedPreferences("firstName");
     lastName=await MyUtils.getSharedPreferences("lastName");
     dob=await MyUtils.getSharedPreferences("dob");
     phone=await MyUtils.getSharedPreferences("mobile");
     gender=await MyUtils.getSharedPreferences("gender")??"";
     Address1=await MyUtils.getSharedPreferences("address_1");
     Address2=await MyUtils.getSharedPreferences("address_2");
     city=await MyUtils.getSharedPreferences("city");
     state=await MyUtils.getSharedPreferences("state");
     zipCode=await MyUtils.getSharedPreferences("zipcode");
     country=await MyUtils.getSharedPreferences("country");

     firstNameController.text=firstName??"";
     lastNameController.text=lastName??"";
     dobController.text=dob??"Select DOB";
     phoneController.text=phone??"";
     address1Controller.text=Address1??"";
     address2Controller.text=Address2??"";
     cityController.text=city??"";
     stateController.text=state??"";
     zipcodeController.text=zipCode??"";
     countryController.text=country??"";
     selectedGender=gender??"";

    setState(() {});
  }

  Future<void> updateProfileApi(BuildContext context) async {

    Dio dio = Dio();
    ValueNotifier<double> progressNotifier = ValueNotifier(0);

    _showUploadDialog(context, progressNotifier, selectedImageFile != null);

    try {

      var data = {
        "user_id": userId.toString(),
        "name":firstNameController.text.toString(),
        "lastName":lastNameController.text.toString(),
        "dob":dobController.text.toString(),
        "email":email,
        "mobileNo":phoneController.text.toString(),
        "address1":address1Controller.text.toString(),
        "address2":address2Controller.text.toString(),
        "city":cityController.text.toString(),
        "state":stateController.text.toString(),
        "zipcode":zipcodeController.text.toString(),
        "country":countryController.text.toString(),
        "gender":selectedGender=="Select"?"":selectedGender,
      };

      FormData formData = FormData.fromMap({
        "data": base64.encode(utf8.encode(json.encode(data))),
        if (selectedImageFile != null)
          "image": await MultipartFile.fromFile(
            selectedImageFile!.path,
            filename: selectedImageFile!.path.split('/').last,
          ),
      });

     final response= await dio.post(
        "${AppConstant.appBaseURL}users/updateProfile",
        data: formData,
        onSendProgress: (sent, total) {
          if (selectedImageFile != null) {
            progressNotifier.value = sent / total;
          }
        },
      );

     var responseJSON=jsonDecode(returnDioResponse(response, context));
     print(responseJSON);
     Navigator.pop(context);

     if(responseJSON['statusCode']==200 || responseJSON['statusCode']==201){
       Toast.show(responseJSON['message']?.toString()??"Profile Updated Successfully.",duration: Toast.lengthLong,backgroundColor: Colors.green);
       MyUtils.saveSharedPreferences('mobile', responseJSON['data']['mobileNo'].toString());
       MyUtils.saveSharedPreferences('address_1', responseJSON['data']['address1'].toString());
       MyUtils.saveSharedPreferences('address_2', responseJSON['data']['address2'].toString());
       MyUtils.saveSharedPreferences('city', responseJSON['data']['city'].toString());
       MyUtils.saveSharedPreferences('country', responseJSON['data']['country'].toString());
       MyUtils.saveSharedPreferences('dob', responseJSON['data']['dob'].toString());
       MyUtils.saveSharedPreferences('gender', responseJSON['data']['gender'].toString());
       MyUtils.saveSharedPreferences('image', responseJSON['data']['image'].toString());
       MyUtils.saveSharedPreferences('lastName', responseJSON['data']['lastName'].toString());
       MyUtils.saveSharedPreferences('firstName', responseJSON['data']['name'].toString());
       MyUtils.saveSharedPreferences('state', responseJSON['data']['state'].toString());
       MyUtils.saveSharedPreferences('zipcode', responseJSON['data']['zipcode'].toString());
       MyUtils.saveSharedPreferences('name', "${responseJSON['data']['name'].toString()} ${responseJSON['data']['lastName']?.toString()??""}");
       Navigator.of(context).pushAndRemoveUntil(
           MaterialPageRoute(builder: (context) => HomeScreen()),
               (Route<dynamic> route) => false);

     }else{
       Toast.show(responseJSON['message']?.toString()??"Something went wrong! Please try again later.",duration: Toast.lengthLong,backgroundColor: Colors.red);
     }

    } catch (e) {
      print(e);
      Navigator.pop(context);
      Toast.show("Something went wrong! Please try again later.",duration: Toast.lengthLong,backgroundColor: Colors.red);
    }
  }


  void _showUploadDialog(
      BuildContext context,
      ValueNotifier<double> progressNotifier,
      bool showProgress) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          content: ValueListenableBuilder<double>(
            valueListenable: progressNotifier,
            builder: (context, progress, _) {

              if (!showProgress) {
                return Row(
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(width: 15),
                    Text("Please wait...")
                  ],
                );
              }

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Uploading Image"),
                  const SizedBox(height: 15),
                  LinearProgressIndicator(value: progress),
                  const SizedBox(height: 10),
                  Text("${(progress * 100).toStringAsFixed(0)} %"),
                ],
              );
            },
          ),
        );
      },
    );
  }
  dynamic returnDioResponse(Response response, BuildContext context) {

    try {

      String base64Response = response.data.toString();

      String foo = base64Response.split('.')[0];

      List<int> res = base64.decode(base64.normalize(foo));

      String decodedResponse = utf8.decode(res);

      print(decodedResponse);
      print("${response.statusCode} Status Code*******");

      switch (response.statusCode) {

        case 200:
        case 201:
        case 302:
        case 400:
          log(decodedResponse);
          return decodedResponse;

        case 401:
          Toast.show(
            'Unauthorized User!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black,
          );
          throw BadRequestException(decodedResponse);

        case 403:
          Toast.show(
            'Internal server error !!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black,
          );
          throw UnauthorisedException(decodedResponse);

        case 500:
          Toast.show(
            'Internal server error!!',
            duration: Toast.lengthShort,
            gravity: Toast.bottom,
            backgroundColor: Colors.black,
          );
          break;

        default:
          throw FetchDataException(
            'Error occured while Communication with Server with StatusCode : ${response.statusCode}',
          );
      }

    } catch (e) {

      print("Response parsing error: $e");
      return response.data;
    }
  }
}
