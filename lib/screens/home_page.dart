import 'package:flutter/material.dart';
import 'package:groupe7/screens/add_post_screen.dart';
import 'package:groupe7/screens/create_post.dart';
import 'package:groupe7/screens/settings/settings.dart';

class ChatterBox extends StatefulWidget {
  const ChatterBox({super.key});

  @override
  _ChatterBoxState createState() => _ChatterBoxState();
}

class _ChatterBoxState extends State<ChatterBox> {
  int selectedIndex = 0;
  final pages =[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        title: _buildAppBarTitle(),
        //backgroundColor: Colors.black,
        actions: _buildAppBarActions(),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: Container(
        margin: EdgeInsets.only(top: 3.0),
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
        Navigator.push(context, MaterialPageRoute(builder: (context)=>CreatePostScreen()));
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
  
  
  BottomNavigationBar _buildBottomNavigationBar() {
  // Vérifiez si le mode sombre est activé
  bool isDarkMode = MediaQuery.of(context).platformBrightness == Brightness.dark;

  return BottomNavigationBar(
    backgroundColor: isDarkMode ? Colors.black : Colors.white, // Couleur de fond
    currentIndex: selectedIndex,
    onTap: (int index) {
      setState(() {
        selectedIndex = index;
      });
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_filled, color: isDarkMode ? Colors.white : Colors.black),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search, color: isDarkMode ? Colors.white : Colors.black),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.add_box_outlined, color: isDarkMode ? Colors.white : Colors.black),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.video_library_outlined, color: isDarkMode ? Colors.white : Colors.black),
        label: '',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline, color: isDarkMode ? Colors.white : Colors.black),
        label: '',
      ),
    ],
  );

  }
}
