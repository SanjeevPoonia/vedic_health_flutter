import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_theme.dart';

class CustomCardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final String iconStr;

  const CustomCardAppBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.iconStr,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(74);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.brown,             // Notification bar bg color
        statusBarIconBrightness: Brightness.light, // For black icons
      ),
    );
    return SafeArea(child: Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Container(
        height: 74,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: onBack,
              child:  Image.asset(iconStr,width: 22,height: 22,),
            ),

            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),

            const SizedBox(
              width: 25,
              height: 25,
            ),
          ],
        ),
      ),
    ));
  }


}