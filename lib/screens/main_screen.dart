import 'package:flutter/material.dart';
import 'package:my_first_app/screens/add_listing_screen.dart';
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
        LoginScreen(
          onLoginSuccess: () async {
            // load profile after login
            await Provider.of<ProfileProvider>(
              context,
              listen: false,
            ).loadUserProfile();
            setState(() {}); // rebuild UI with logged in state
          },
        ),
      ];
    } else if (role == 'Landlord') {
      // Landlord: show Home, Add, My Listings, Profile
      bottomNavItems = const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_rounded),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people_alt_rounded), // or Icons.group
          label: 'Tenants',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add_business_rounded), // or Icons.add_box
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt_rounded),
          label: 'My Listings',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_rounded),
          label: 'Profile',
        ),
      ];

      screens = [
        HomeScreen(properties: widget.properties),
        const Center(child: Text('Manage Tenants')),
        AddListingScreen(),
        const Center(
          child: Text('My Listings'),
        ), 
          profile != null
      ? ProfileScreen(profile: profile)
      : const Center(child: CircularProgressIndicator()),

      ];
    } else {
      // Tenant: show Home, Favorites, Profile
      bottomNavItems = const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
         BottomNavigationBarItem(icon: Icon(Icons.place_rounded), label: 'My Place'),
        BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ];
      screens = [
        HomeScreen(properties: widget.properties),
        const Center(child: Text('Manage My Place')),
        FavoritesScreen(),
        ProfileScreen(profile: profile)
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
