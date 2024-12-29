import 'package:flutter/material.dart';

void main() {
  runApp(const MyPage());
}

class MyPage extends StatelessWidget {
  const MyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: ChatterBox(),
    );
  }
}


class ChatterBox extends StatefulWidget {
  @override
  _ChatterBoxState createState() => _ChatterBoxState();
}

class _ChatterBoxState extends State<ChatterBox> {

  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: RichText(
          text: TextSpan(
            style: TextStyle(
              fontFamily: 'BlackOpsOne',
              fontSize: 20,
            ),
            children: [
              TextSpan(
                text: 'Chatter',
                style: TextStyle(color: Colors.pink),
              ),
              TextSpan(
                text: 'box',
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline, color: Colors.white),
            onPressed: () {
              // Action à effectuer lors du clic sur le bouton "Ajouter"
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite_border , color: Colors.white),
            onPressed: () {
              // Action à effectuer lors du clic sur le bouton "J'aime"
            },
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.messenger_outline, color: Colors.white),
                onPressed: () {
                  // Action à effectuer lors du clic sur le bouton "Messagerie"
                },
              ),
            ],
          ),
        ],
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        currentIndex: selectedIndex,
        onTap: (int index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled, color: Colors.white,), label: 'Inscription'),
          BottomNavigationBarItem(icon: Icon(Icons.search, color: Colors.white), label: 'Information'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined, color: Colors.white), label: 'Paramètres'),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined, color: Colors.white), // Icon for the video library tab
            label: 'Videos',
            // Label for the video library tab (optional)
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.white), // Icon for the profile tab
            label: 'Profile', // Label for the profile tab (optional)
          ),

        ],
      ),*/
    );
  }
}