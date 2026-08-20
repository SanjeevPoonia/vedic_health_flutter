import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vedic_health/utils/name_avatar.dart';
import '../utils/app_theme.dart';
class PractCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onBack;
  final String iconStr;
  final String actionIconStr;
  final VoidCallback onAction;
  final bool isOnlineImage;
  final String empName;

  const PractCustomAppBar({
    Key? key,
    required this.title,
    required this.onBack,
    required this.iconStr,
    required this.actionIconStr,
    required this.onAction,
    required this.isOnlineImage,
    required this.empName
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
            GestureDetector(
              onTap: onAction,
              child: isOnlineImage?
              ClipRRect(
                borderRadius: BorderRadius.circular(25), // rounded corners
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl: actionIconStr,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (context, url, error) =>
                  NameAvatar(fullName: empName,size: 50,),
                ),
              ):Image.asset(actionIconStr,width: 50,height: 50,),
            )
          ],
        ),
      ),
    ));
  }


}