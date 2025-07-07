import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/property.dart';
import '../providers/profile_provider.dart';
import 'home_screen.dart';
import 'favorites_screen.dart';
import 'login_screen.dart';
import 'profile.dart';

class MainScreen extends StatefulWidget {
  final List<Property> properties;

  const MainScreen({super.key, required this.properties});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final profile = profileProvider.profile;
    final isLoggedIn = profile != null;
    final role = profile?.role ?? '';

    List<BottomNavigationBarItem> bottomNavItems = [];
    List<Widget> screens = [];

    if (!isLoggedIn) {
      // Not logged in: show Home, Favorites, Profile (Login)
      bottomNavItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      screens = [
        HomeScreen(properties: widget.properties),
        FavoritesScreen(),
        LoginScreen(onLoginSuccess: () async {
          // load profile after login
          await Provider.of<ProfileProvider>(context, listen: false).loadUserProfile();
          setState(() {}); // rebuild UI with logged in state
        }),
      ];
    } else if (role == 'Landlord') {
      // Landlord: show Home, Add, My Listings, Profile
      bottomNavItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Add'),
        BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'My Listings'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      screens = [
        HomeScreen(properties: widget.properties),
        const Center(child: Text('Add Listing')),   // TODO: replace with real Add Listing screen
        const Center(child: Text('My Listings')),   // TODO: replace with real My Listings screen
        ProfileScreen(
          ownerName: profile.fullName,
          ownerEmail: 'your-email@example.com',     // replace with real data
          avatarUrl: 'https://example.com/avatar.jpg',
          totalListings: 12,
          activeListings: 7,
        ),
      ];
    } else {
      // Tenant: show Home, Favorites, Profile
      bottomNavItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      screens = [
        HomeScreen(properties: widget.properties),
        FavoritesScreen(),
        ProfileScreen(
          ownerName: profile.fullName,
          ownerEmail: 'your-email@example.com',     // replace with real data
          avatarUrl: 'https://example.com/avatar.jpg',
          totalListings: 0,
          activeListings: 0,
        ),
      ];
    }

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
        selectedItemColor: const Color(0xff4facfe),
        unselectedItemColor: Colors.grey,
        items: bottomNavItems,
      ),
    );
  }
}
