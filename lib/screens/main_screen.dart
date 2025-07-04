import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../models/property.dart';
import 'login_screen.dart';
import 'profile.dart';
import 'favorites_screen.dart';

// import your other screens when you add them

class MainScreen extends StatefulWidget {
  final List<Property> properties;

  const MainScreen({super.key, required this.properties});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  bool isLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    // List of widgets for each tab
    final screens = [
      HomeScreen(properties: widget.properties),
      // Placeholder widgets for now; replace with real screens
     FavoritesScreen(),
      const Center(child: Text('Add Listing')),
      const Center(child: Text('My Listings')),
    isLoggedIn
      ? ProfileScreen(
          ownerName: 'Jane Doe',
          ownerEmail: 'jane.doe@example.com',
          avatarUrl: 'https://example.com/avatar.jpg',
          totalListings: 12,
          activeListings: 7,
        )
      : LoginScreen(onLoginSuccess: () {
          setState(() {
            isLoggedIn = true;
          });
        }),
    ];

    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xff4facfe),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'My Listings',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
