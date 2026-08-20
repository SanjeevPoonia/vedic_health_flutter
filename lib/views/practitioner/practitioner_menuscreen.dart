import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:toast/toast.dart';
import 'package:flutter/material.dart';
import 'package:vedic_health/views/practitioner/practitioner_appointment_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_earning_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_homescreen.dart';
import 'package:vedic_health/views/practitioner/practitioner_product_screen.dart';
import 'package:vedic_health/views/practitioner/practitioner_services_screen.dart';
import 'package:vedic_health/views/practitioner/prectitioner_personaltask_screen.dart';
import '../../network/Utils.dart';
import '../../utils/app_theme.dart';
import '../authentication/login_screen.dart';
import '../home_screen.dart';

class PractitionerMenuScreen extends StatefulWidget{
  _practionerState createState()=>_practionerState();
}
class _practionerState extends State<PractitionerMenuScreen>{

  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor:AppTheme.darkBrown,
      body: Transform.translate(
        offset: const Offset(0, 40),   // <-- Move UP by 20 px
        child: Container(
          color: Colors.white,
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerHomeScreen()),
                    );
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_home_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Home",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerAppointmentScreen()),
                    );

                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_app_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Appointments",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerServiceScreen()),
                    );
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_service_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Services",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerPersonalTask()),
                    );
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_app_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Personal Task",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerEarningScreen()),
                    );
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_earning_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Earnings",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => PractitionerProductScreen()),
                    );
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_prec_service_menu.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Product",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),
                  InkWell(onTap: (){
                    _modalBottomLogout();
                  }, child:Row(
                    children: [
                      Padding(padding: EdgeInsets.all(5),
                        child:
                        SvgPicture.asset("assets/ic_menu_logout.svg",height: 40,width: 40,),
                      ),
                      const SizedBox(width: 5,),
                      const Expanded(flex:1,child: Text("Logout",style: TextStyle(fontSize: 14,fontWeight: FontWeight.w500,color: Colors.black),)),
                      const Padding(padding: EdgeInsets.all(5),
                        child: Icon(Icons.chevron_right_outlined,size: 22,color: Colors.black,),)
                    ],
                  ) ,),
                  SizedBox(height: 10,),
                  Divider(height: 1,color: Colors.grey,),
                  SizedBox(height: 10,),



                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _modalBottomLogout() {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      context: context,
      builder: (ctx) => StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(15)),
                color: Colors.white,
              ),
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      const Spacer(),
                      GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Image.asset(
                            'assets/close_icc.png',
                            width: 14,
                            height: 14,
                          )),
                      const SizedBox(width: 20)
                    ],
                  ),
                  const SizedBox(height: 20),
                  Column(
                    children: [
                      Lottie.asset('assets/yoga.json', height: 120, width: 120),
                      const SizedBox(height: 5),
                      Text(
                        "Logout Account !",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.w600,
                            fontSize: 24),
                      ),
                      SizedBox(
                        height: 18,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Are you sure you want to logout? Once you logout you need to login again.",
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.w500,
                              fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 35,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.of(ctx).pop();
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(left: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFFE3E3E3)),
                            child: Center(
                              child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () async {
                            ToastContext().init(context);
                            Navigator.of(ctx).pop();

                            await MyUtils.removePrefs("user_id");
                            await MyUtils.removePrefs("email");
                            await MyUtils.removePrefs("auth_key");
                            await MyUtils.removePrefs("token");
                            await MyUtils.removePrefs("access_token");
                            await MyUtils.removePrefs("role");

                            //Route route = MaterialPageRoute(builder: (context) => LoginScreen());
                            Route route = MaterialPageRoute(builder: (context) => VedicHealthLoginScreen());

                            Navigator.pushAndRemoveUntil(
                                context, route, (Route<dynamic> route) => false);
                            Toast.show("Logged out successfully!",
                                duration: Toast.lengthLong,
                                gravity: Toast.bottom,
                                backgroundColor: Colors.greenAccent);
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(right: 16),
                            padding: const EdgeInsets.only(left: 4, right: 4),
                            decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.darkBrown),
                            child: Center(
                              child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }),
    );
  }

}