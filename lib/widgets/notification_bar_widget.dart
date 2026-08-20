import 'package:flutter/cupertino.dart';

import '../utils/app_theme.dart';

class NotificationBarWidget extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Container(
      height: MediaQuery.of(context).padding.top,
      color: AppTheme.darkBrown,
    );
  }

}