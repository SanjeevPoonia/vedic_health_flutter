import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vedic_health/utils/app_modal.dart';
import 'package:vedic_health/views/home_screen.dart';
import 'package:vedic_health/views/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp],
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token=prefs.getString('access_token')??'';
  print(token);
  if(token!='')
  {
    AppModel.setTokenValue(token.toString());
    AppModel.setLoginToken(true);
  }
  runApp(MyApp(token));
}

class MyApp extends StatelessWidget {
   final String token;
   MyApp(this.token);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vedic Health',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        primarySwatch: Colors.green,
        fontFamily: 'Montserrat',
        useMaterial3: true,
      ),
      home:  SplashScreen(token),
    );
  }
}


