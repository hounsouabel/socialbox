import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:groupe7/about.dart';
import 'package:groupe7/responsive/responsive_layout_screen.dart';
import 'package:groupe7/screens/login_screen.dart';
import 'package:groupe7/utilities/colors.dart';
import 'firebase_options.dart';
import 'package:groupe7/responsive/mobile_screen_layout.dart';
import 'package:groupe7/responsive/web_screen_layout.dart';


Future<void> main () async {
  //Ajout pour initilaliser Firebase dans le projet | voir la vidéo tuto
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
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
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: mobileBackgroundColor ),
     // home: const MyHomePage(title: 'Groupe 7'),
      home: const ResponsiveLayout(mobileScreenLayout:MobileScreenLayout() ,webScreenLayout: WebScreenLayout(),),
    );
  }
}
/*
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Text("Social Hub")),
            ListTile(
              title: Text("A propos"),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutPage()),
                );
              },
            )
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            const Text("Point de départ",style: TextStyle(fontSize: 25),)
          ],
        ),
      ),
    );
  }
} */
