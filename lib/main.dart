import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
//import 'package:groupe7/about.dart';
//import 'package:groupe7/responsive/responsive_layout_screen.dart';
//import 'package:groupe7/screens/login_screen.dart';
//import 'package:groupe7/utilities/colors.dart';
import 'firebase_options.dart';
//import 'package:groupe7/responsive/mobile_screen_layout.dart';
//import 'package:groupe7/responsive/web_screen_layout.dart';
import 'package:firebase_app_check/firebase_app_check.dart';

import 'home.dart';


Future<void> main () async {
  //Ajout pour initilaliser Firebase dans le projet | voir la vidéo tuto
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.playIntegrity,
);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Social Hub',
      debugShowCheckedModeBanner: false,
      //theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor ),
      

     // home: const MyHomePage(title: 'Groupe 7'),
      //home: const ResponsiveLayout(mobileScreenLayout:MobileScreenLayout() ,webScreenLayout: WebScreenLayout(),),
      home: MyHomePage(),
    );
  }
}
