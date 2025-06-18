


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../utils/app_theme.dart';
import '../../views/cart_screen.dart';
import '../../views/profile_screen.dart';
// import 'package:qaviews/view/requirement_slip_screen.dart';
// import 'package:qaviews/view/search_image_screen.dart';


// import '../view/new_arrivals_screen.dart';
// import '../view/product_search_screen.dart';


class ZoomScaffold extends StatefulWidget {
  final Widget menuScreen;
  final Layout contentScreen;
  final String pageTitle;
  final bool orangeTheme;
  final bool showBoxes;

  ZoomScaffold({
    required this.menuScreen,
    required this.contentScreen,
    required this.pageTitle,
    required this.orangeTheme,
    required this.showBoxes
  });

  @override
  _ZoomScaffoldState createState() => _ZoomScaffoldState();
}

class _ZoomScaffoldState extends State<ZoomScaffold>
    with TickerProviderStateMixin {
  var searchController=TextEditingController();
  int _selectedIndex = 0;

 /* List<Widget> _widgetOptions = <Widget>[
    DriverDashboardScreen(),
    LoginScreen()
  ];*/
  Curve scaleDownCurve =  Interval(0.0, 0.3, curve: Curves.easeOut);
  Curve scaleUpCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideOutCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);
  Curve slideInCurve =  Interval(0.0, 1.0, curve: Curves.easeOut);

  createContentDisplay() {
    return zoomAndSlideContent(Container(
      child:  GestureDetector(
        onTap: (){
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Card(
              elevation: 2,
              margin: EdgeInsets.zero,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight: Radius.circular(15))
              ),
              child: Container(
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                 /*   borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20), // Adjust the radius as needed
                      bottomRight: Radius.circular(20), // Adjust the radius as needed
                    ),*/
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [


              GestureDetector(
              onTap: () {
    Provider.of<MenuController>(context, listen: false).toggle();

        },
            child:

            Image.asset('assets/ham3.png',width: 22,height: 22,
            )),


        Text("Home",
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            )),

                        GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartScreen()));


                            },
                            child: Image.asset("assets/cart_bag.png",width: 39,height: 39)
                        )




                      ]))),

              //Container(height: 1,color: Colors.grey.withOpacity(0.3),width: double.infinity),


              //_widgetOptions.elementAt(_selectedIndex),
             widget.contentScreen.contentBuilder(context),
            ],
          ),
         /* bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.orangeAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2
                ),
              ],
            ),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: MyColor.themeColor,
              unselectedItemColor: Color.fromRGBO(155,153,152,1),
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/home_bt.png")),
                  ),
                  title: Text(
                    'Home',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/settings_bt.png")),
                  ),
                  title: Text(
                    'Setting',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/notification_bt.png")),
                  ),
                  title: Text(
                    'Notifications',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/filter_bt.png")),
                  ),
                  title: Text(
                    'Filter',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),


                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 5,top: 6),
                    child: ImageIcon(AssetImage("images/profile_bt.png")),
                  ),
                  title: Text(
                    'My Account',
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(79,79,79, 0.5)
                    ),
                  ),
                ),
              ],
              onTap: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          )*/
        ),
      ),
    ));
  }

  zoomAndSlideContent(Widget content) {
    var slidePercent, scalePercent;

    switch (Provider.of<MenuController>(context, listen: true).state) {
      case MenuState.closed:
        slidePercent = 0.0;
        scalePercent = 0.0;
        break;
      case MenuState.open:
        slidePercent = 1.0;
        scalePercent = 1.0;
        break;
      case MenuState.opening:
        slidePercent = slideOutCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleDownCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
      case MenuState.closing:
        slidePercent = slideInCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        scalePercent = scaleUpCurve.transform(
            Provider.of<MenuController>(context, listen: true).percentOpen);
        break;
    }

    final slideAmount = 235.0 * slidePercent;
    final contentScale = 1.0 - (0.30 * scalePercent);
    final cornerRadius =
        30.0 * Provider.of<MenuController>(context, listen: true).percentOpen;

    return new Transform(
      transform: new Matrix4.translationValues(slideAmount, 0.0, 0.0)
        ..scale(contentScale, contentScale),
      alignment: Alignment.centerLeft,
      child: new Container(
        decoration: new BoxDecoration(
          boxShadow: [
            new BoxShadow(
              color: Colors.black12,
              offset: const Offset(0.0, 5.0),
              blurRadius: 15.0,
              spreadRadius: 10.0,
            ),
          ],
        ),
        child: new ClipRRect(
            borderRadius: new BorderRadius.circular(cornerRadius),
            child: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Scaffold(
            body: widget.menuScreen,
          ),
        ),
        createContentDisplay()
      ],
    );
  }
}

class ZoomScaffoldMenuController extends StatefulWidget {
  final ZoomScaffoldBuilder builder;

  ZoomScaffoldMenuController({
    required this.builder,
  });

  @override
  ZoomScaffoldMenuControllerState createState() {
    return new ZoomScaffoldMenuControllerState();
  }
}

class ZoomScaffoldMenuControllerState
    extends State<ZoomScaffoldMenuController> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(
        context, Provider.of<MenuController>(context, listen: true));
  }
}

typedef Widget ZoomScaffoldBuilder(
    BuildContext context, MenuController menuController);

class Layout {
  final WidgetBuilder contentBuilder;

  Layout({
   required this.contentBuilder,
  });
}

class MenuController extends ChangeNotifier {
  final TickerProvider vsync;
  final AnimationController _animationController;
  MenuState state = MenuState.closed;

  MenuController({
   required this.vsync,
  }) : _animationController = new AnimationController(vsync: vsync) {
    _animationController
      ..duration = const Duration(milliseconds: 250)
      ..addListener(() {
        notifyListeners();
      })
      ..addStatusListener((AnimationStatus status) {
        switch (status) {
          case AnimationStatus.forward:
            state = MenuState.opening;
            break;
          case AnimationStatus.reverse:
            state = MenuState.closing;
            break;
          case AnimationStatus.completed:
            state = MenuState.open;
            break;
          case AnimationStatus.dismissed:
            state = MenuState.closed;
            break;
        }
        notifyListeners();
      });
  }

  @override
  dispose() {
    _animationController.dispose();
    super.dispose();
  }

  get percentOpen {
    return _animationController.value;
  }

  open() {
    _animationController.forward();
  }

  close() {
    _animationController.reverse();
  }

  toggle() {
    if (state == MenuState.open) {
      close();
    } else if (state == MenuState.closed) {
      open();
    }
  }
}

enum MenuState {
  closed,
  opening,
  open,
  closing,
}