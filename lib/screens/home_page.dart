import 'package:flutter/material.dart';
import 'package:groupe7/screens/settings.dart';

class ChatterBox extends StatefulWidget {
  const ChatterBox({super.key});

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
        title: _buildAppBarTitle(),
        //backgroundColor: Colors.black,
        actions: _buildAppBarActions(),
      ),
      // Uncomment the bottom navigation bar if needed
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Container(
        margin: EdgeInsets.only(top: 3.0),
        //color: Colors.black,
        child: ListView(
          children: [
            const Text(
              "",
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'BlackOpsOne',
          fontSize: 20,
        ),
        children: [
          const TextSpan(
            text: 'Chatter',
            style: TextStyle(color: Colors.pink),
          ),
          const TextSpan(
            text: 'box',
            style: TextStyle(color: Colors.blue),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAppBarActions() {
    return [
      _buildStyledIconButton(Icons.add_sharp, () {
        // Action à effectuer lors du clic sur le bouton "Ajouter"
      }),
      _buildStyledIconButton(Icons.search, () {
        // Action à effectuer lors du clic sur le bouton "J'aime"
      }),
      _buildStyledIconButton(Icons.menu, () {
        
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SettingsPage()),
        );
      }),
    ];
  }

  Widget _buildStyledIconButton(IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      height: 40,
      decoration: BoxDecoration(
        color: Colors.grey[500],
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        //padding: const EdgeInsets.all(16.0),
      ),
    );
  }
  // Uncomment this method if you want to use the bottom navigation bar

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: Colors.black,
      currentIndex: selectedIndex,
      onTap: (int index) {
        setState(() {
          selectedIndex = index;
        });
      },
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, color: Colors.white),
            label: 'Inscription'),
        BottomNavigationBarItem(
            icon: Icon(Icons.search, color: Colors.white),
            label: 'Information'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_box_outlined, color: Colors.white),
            label: 'Paramètres'),
        BottomNavigationBarItem(
            icon: Icon(Icons.video_library_outlined, color: Colors.white),
            label: 'Videos'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.white),
            label: 'Profile'),
      ],
    );
  }
}
