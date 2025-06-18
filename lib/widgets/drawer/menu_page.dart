
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vedic_health/widgets/drawer/zoom_scaffold.dart'  as MEN;




class MenuScreen extends StatelessWidget {
  final String name;
  final int index;

  MenuScreen(this.name,this.index);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MEN.MenuController>(context, listen: true).toggle();
        }
      },
      child: Container(
        padding: EdgeInsets.only(
          left: 15,
          bottom: 8,
          right: 20,),
        color: Color(0xff000204),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            SizedBox(height: 36),

            SizedBox(height: 12),

            Padding(
              padding: EdgeInsets.only(left: 5),
              child:     Text(
                name,
                style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato',
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: EdgeInsets.only(left: 5),
              // child:     Text(
              //   email,
              //   style: TextStyle(
              //       fontSize: 15.5,
              //       fontFamily: 'Lato',
              //       fontWeight: FontWeight.w400,
              //       color: Color.fromRGBO(138,138,140,1)),
              // ),
            ),

            SizedBox(height: 70),



            InkWell(
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyRidesScreen()));
              },
              child:   NavigationItems('assets/nav_home.png','My Rides',true),
            ),



            InkWell(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context)=>WalletScreen()));
              },
              child:    NavigationItems('assets/nav_home.png','Account Settlement',false),
            ),




            InkWell(
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>SettingsScreen(true)));
              },
              child:    NavigationItems('assets/nav_home.png','Account Settings',false),
            ),









            InkWell(
              onTap: (){
              //  Navigator.push(context, MaterialPageRoute(builder: (context)=>HelpCenterScreen()));
              },
              child:  NavigationItems('assets/nav_home.png','Help Center',false),
            ),

            InkWell(
              onTap: (){
               // Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUsScreen()));
              },
              child:  NavigationItems('assets/nav_home.png','About & Legal',false),
            ),




            Spacer(),


             InkWell(
               onTap: (){
                 showLogOutDialog(context);
               },
               child:   Container(

                   width: 150,
                   height: 47,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(25),
                       border: Border.all(width: 2,color: Color.fromRGBO(255,255,255,0.1))
                   ),


                   child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: <Widget>[

                       Image.asset('assets/nav_home.png',width: 20,height: 20,),

                       SizedBox(width: 10),


                       Text(
                         'Logout',
                         style: TextStyle(
                             fontSize: 19,
                             fontFamily: 'Lato',
                             fontWeight: FontWeight.w700,
                             color: Color.fromRGBO(239,122,70,1)),
                       ),



                     ],
                   )
               ),
             ),
            SizedBox(height: 50,)




            /*    NavigationItems(),
            NavigationItems()*/

            /*   ListTile(
              onTap: () {},
              leading: Icon(
                Icons.settings,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Settings',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),*/

            /*  ListTile(
              onTap: () {},
              leading: Icon(
                Icons.headset_mic,
                color: Colors.white,
                size: 20,
              ),
              title: Text('Support',
                  style: TextStyle(fontSize: 14, color: Colors.white)),
            ),*/



          ],
        ),
      ),
    );
  }
  showLogOutDialog(BuildContext context) {
    Widget cancelButton = GestureDetector(
        onTap: (){
          Navigator.pop(context);
        },
        child: Text("Cancel"));
    Widget continueButton = GestureDetector(
        onTap: (){
          Navigator.pop(context);

        },

        child: Text("Logout",style: TextStyle(
          color: Colors.red
        ),));

    AlertDialog alert = AlertDialog(
      title: Text("Log Out"),
      content: Text("Are you sure you want to Log out ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }







}

class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}
class NavigationItems extends StatelessWidget
{
  final String iconURI,title;
  bool textColorOrange;
  NavigationItems(this.iconURI,this.title,this.textColorOrange);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      child: Row(
        children: <Widget>[
          Image.asset(iconURI,width: 25,height: 25,),

          SizedBox(width: 15),


          Text(
            title,
            style: TextStyle(
                fontSize: 16,
                fontFamily: 'Lato',
                fontWeight: FontWeight.w600,
                color: textColorOrange==true?Color.fromRGBO(239,122,70,1):Color.fromRGBO(185,185,186,1)),
          ),




        ],
      ),
    );
  }

}

