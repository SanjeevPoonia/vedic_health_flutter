import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedic_health/views/appointments/appointment_home.dart';
import 'package:vedic_health/views/appointments/my_appointment_screen.dart';
import 'package:vedic_health/views/appointments/my_appointment_waitlist_screen.dart';
import 'package:vedic_health/views/authentication/login_screen.dart';
import 'package:vedic_health/views/change_password_screen.dart';
import 'package:vedic_health/views/membership/membership_user_screen.dart';
import 'package:vedic_health/views/my_orders.dart';
import 'package:vedic_health/views/profile_screen.dart';
import 'package:vedic_health/views/yoga_classes/schedule_yoga_class_screen.dart';
import 'package:vedic_health/views/yoga_classes/yoga_classes_screen.dart';
import 'package:vedic_health/views/yoga_courses/yoga_courses_screen.dart';
import '../network/constants.dart';
import '../utils/name_avatar.dart';
import '../widgets/drawer/zoom_scaffold.dart' as MEN;
import 'package:toast/toast.dart';
import '../network/Utils.dart';
import '../utils/app_theme.dart';
import '../widgets/sidebar_widget.dart';
import 'category_wise_products.dart';
import 'events/event_home_screen.dart';
import 'my_reviews_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MenuScreen extends StatefulWidget {
  @override
  MenuState createState() => MenuState();
}

class MenuState extends State<MenuScreen> {
  String emailID = '';
  String userName = '';
  String id = '';
  String? profileImageUrl;
  @override
  Widget build(BuildContext context) {
    ToastContext().init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF9CFA5),
      body: Container(
          // color: const Color(0xFFF9CFA5),
          width: MediaQuery.of(context).size.width,
          height: double.infinity,
          child: Stack(
            children: [
              Container(
                // margin: EdgeInsets.only(left: 20,right: 20,top: 40),
                height: double.infinity,
                width: double.infinity,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/backimage.jpeg'),
                    colorFilter: new ColorFilter.mode(
                        Colors.black.withOpacity(0.05), BlendMode.dstATop),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Column(
                  children: [
                    const SizedBox(height: 23),
                    Row(
                      children: [
                        Spacer(),
                        InkWell(
                          onTap: () {
                            Provider.of<MEN.MenuController>(context,
                                    listen: false)
                                .toggle();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Image.asset("assets/ham_drawer.png",
                                width: 24,
                                height: 24,
                                color: Colors.black),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Row(
                        children: [
                          const SizedBox(width: 12),

                          profileImageUrl == null || profileImageUrl!.isEmpty
                              ? NameAvatar(fullName: userName,size: 50,)
                              : ClipRRect(
                            borderRadius: BorderRadius.circular(25), // rounded corners
                            child: CachedNetworkImage(
                              height: 50,
                              width: 50,
                              imageUrl: profileImageUrl??"",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: Colors.grey[200],
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                              errorWidget: (context, url, error) => NameAvatar(fullName: userName,size: 50,),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(userName,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),

                              //   const SizedBox(height: 4),

                              Text(emailID,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black)),
                              const SizedBox(height: 4),
                            ],
                          )),
                          const SizedBox(width: 10),
                          //  const Spacer(),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      margin: EdgeInsets.only(left: 15, right: 110),
                      child: Divider(
                        color: Colors.white.withOpacity(0.50),
                      ),
                    ),
                    Expanded(
                        child: ListView(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            children: [
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfileScreen()));
                                },
                                // child: SideBarWidget('My Profile ', 'assets/nav_profile.png'),
                                child: SideBarWidget('My Profile ', 'assets/ic_menu_profile.svg'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryWiseProducts("","")));
                                  // Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
                                },
                               // child: SideBarWidget('Shop ', 'assets/nav_profile.png'),
                                child: SideBarWidget('Shop ', 'assets/ic_menu_shops.svg'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                          const MyOrdersScreen()));
                                },
                                child: SideBarWidget('My Orders', 'assets/ic_menu_myorders.svg'),
                                //child: SideBarWidget('My Orders', 'assets/checkout.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YogaClassesScreen()));
                                },
                                //child: SideBarWidget('Yoga Classes', 'assets/review.png'),
                                child: SideBarWidget('Yoga Classes', 'assets/ic_menu_yogaclasses.svg'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ScheduleClassesScreen()));
                                },
                                child: SideBarWidget('Schedule Classes', 'assets/ic_menu_yogaclasses.svg'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppointmentHomeScreen()));
                                },
                                child: SideBarWidget('Book Appointments', 'assets/ic_menu_appoint.svg'),
                                //child: SideBarWidget('Book Appointments', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyAppointmentScreen(
                                            id: id,
                                          )));
                                },
                                child: SideBarWidget('My Appointments', 'assets/ic_menu_myappoint.svg'),
                                //child: SideBarWidget('My Appointments', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyAppointmentWaitlistScreen()));
                                },
                                child: SideBarWidget('My Waitlist', 'assets/ic_menu_waitlist.svg'),
                               // child: SideBarWidget('My Waitlist', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MembershipUserScreen()));
                                },
                                child: SideBarWidget('Membership', 'assets/ic_menu_membership.svg'),
                                //child: SideBarWidget('Membership', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => YogaCoursesScreen()));
                                },
                                child: SideBarWidget('Courses', 'assets/ic_menu_couses.svg'),
                                //child: SideBarWidget('Courses', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventHomeScreen()));
                                },
                                child: SideBarWidget('Events', 'assets/ic_menu_events.svg'),
                               // child: SideBarWidget('Events', 'assets/review.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyReviewScreen()));
                                },
                                child:
                                SideBarWidget('Reviews', 'assets/ic_menu_review.svg'),
                              ),
                              InkWell(
                                onTap: () {
                                  Provider.of<MEN.MenuController>(context,
                                      listen: false)
                                      .toggle();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ChangePasswordScreen()));

                                  //  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: SubmitAuditListScreen()));
                                },
                                child: SideBarWidget('Change Password', 'assets/ic_menu_changepass.svg'),
                                //child: SideBarWidget('Change Password', 'assets/password.png'),
                              ),
                              InkWell(
                                onTap: () {
                                  _modalBottomLogout();

                                  /*   Provider.of<MEN.MenuController>(context,
                                          listen: false)
                                          .toggle();*/
                                  //  Navigator.push(context, PageTransition(type: PageTransitionType.leftToRight, child: ChangePasswordScreen()));

                                  //Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: AssignedTab(true)));
                                },
                                child: SideBarWidget('Logout', 'assets/ic_menu_logout.svg'),
                              ),








                        ])),

                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          )),
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
  void initState() {
    super.initState();
    getValue();
  }
  Future<void> getValue() async {
    String? email = await MyUtils.getSharedPreferences("email");
    String? name = await MyUtils.getSharedPreferences("name");
    String? id = await MyUtils.getSharedPreferences("user_id");

    emailID = email ?? "";
    userName = name ?? "NA";
    id = id ?? "NA";
    String? image = await MyUtils.getSharedPreferences("image");
    if(image!=null && image.isNotEmpty){
      profileImageUrl=AppConstant.appBaseURL+image;
    }
    print(email);
    print(name);
  }
  _showAlertDialog() {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text(
                "Logout",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                    fontSize: 18),
              ),
              content: const Text(
                "Are you sure you want to Logout ?",
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 16,
                    color: Colors.black),
              ),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                      _logOut(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppTheme.themeColor,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Text(
                          "Logout",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.grey,
                      ),
                      height: 45,
                      padding: const EdgeInsets.all(10),
                      child: const Center(
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 14,
                              color: Colors.white),
                        ),
                      ),
                    ))
              ],
            ));
  }
  _logOut(BuildContext context) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove("user_id");
    await preferences.remove("email");
    await preferences.remove("auth_key");
    await preferences.remove("token");
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => VedicHealthLoginScreen()), (Route<dynamic> route) => false);
    //Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false);
  }
}
