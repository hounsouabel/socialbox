import 'package:flutter/material.dart';
import 'package:groupe7/screens/post_screen.dart';
import 'package:groupe7/screens/profile_screen.dart';
import 'package:groupe7/screens/requests_screen.dart';
import 'package:groupe7/screens/search_screen.dart';
import 'package:groupe7/screens/create_post.dart';
import 'package:groupe7/screens/settings/settings.dart';
import 'package:groupe7/screens/video_screen/home_page.dart';
import '../services/auth_service.dart';
import 'chats_screen.dart';

class ChatterBox extends StatefulWidget {
  const ChatterBox({super.key});

  @override
  _ChatterBoxState createState() => _ChatterBoxState();
}

class _ChatterBoxState extends State<ChatterBox> {
  int _selectedIndex = 0;
  final List<Widget> _screens = [
    PostsSection(),
    SearchScreen(),
    CreatePostScreen(),
    HomePage(),
    ProfileScreen(),
  ];

  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _selectedIndex != 3 && _selectedIndex != 1
          ? AppBar(
              toolbarHeight: 80,
              title: _buildAppBarTitle(),
              actions: _buildAppBarActions(),
            )
          : null,
      bottomNavigationBar: _buildBottomNavigationBar(),
      body: _screens[_selectedIndex],
    );
  }

  Widget _buildAppBarTitle() {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'BlackOpsOne',
          fontSize: 23,
        ),
        children: [
          const TextSpan(
            text: 'Social',
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
      _buildStyledIconButton(Icons.notifications_rounded, () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => FriendRequestsScreen()),
        );
      }),
      _buildStyledIconButton(Icons.message, () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ChatsScreen()));
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
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6.0),
      height: 40,
      child: IconButton(
        icon: Icon(icon, color: isDarkMode ? Colors.white : Colors.black),
        onPressed: onPressed,
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    bool isDarkMode =
        MediaQuery.of(context).platformBrightness == Brightness.dark;

    return BottomNavigationBar(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      currentIndex: _selectedIndex,
      onTap: (int index) {
        setState(() {
          _selectedIndex = index;
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled,
              color: isDarkMode ? Colors.white : Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search,
              color: isDarkMode ? Colors.white : Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_box_outlined,
              color: isDarkMode ? Colors.white : Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.video_library_outlined,
              color: isDarkMode ? Colors.white : Colors.black),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: FutureBuilder<Map<String, dynamic>?>(
            future: _authService.getUserData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError ||
                  !snapshot.hasData ||
                  snapshot.data == null) {
                return const Icon(Icons.person_outline, size: 24);
              } else {
                final userData = snapshot.data!;
                final String profileImage = userData["profil"] ?? '';
                return profileImage.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          profileImage,
                          height: 24,
                          width: 24,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.person_outline, size: 24);
                          },
                        ),
                      )
                    : const Icon(Icons.person_outline, size: 24);
              }
            },
          ),
          label: '',
        ),
      ],
    );
  }
}
