

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppBarWidget extends StatelessWidget
{
  final String title;
  AppBarWidget(this.title);
  @override
  Widget build(BuildContext context) {

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 10),
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))
      ),
      child: Container(
        height: 74,
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
                onTap: () {
                  Navigator.pop(context);

                },
                child:Icon(Icons.arrow_back_ios_new_sharp,size: 17)),


            Text(title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                )),

            Padding(
              padding: const EdgeInsets.only(right: 5),
              child:  Container(
                width: 25,
                height: 25,
              )
            ),




          ],
        ),
      ),
    );
  }

}
