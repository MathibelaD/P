import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/property.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_bar.dart';
import '../providers/profile_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  final List<Property> properties;

  const HomeScreen({super.key, required this.properties});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFilter = 'All';
  String searchQuery = '';
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  /// Helper: get "Good morning / afternoon / evening"
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties = widget.properties.where((p) {
      final matchesFilter = selectedFilter == 'All' ||
          (p.type.toLowerCase() == selectedFilter.toLowerCase());
      final matchesSearch = p.title.toLowerCase().contains(searchQuery) ||
          p.location.toLowerCase().contains(searchQuery);
      return matchesFilter && matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4facfe), Color(0xff00f2fe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Consumer<ProfileProvider>(
          builder: (context, profileProvider, _) {
            final profile = profileProvider.profile;

            if (profileProvider.isLoading) {
              return const Text('Loading...');
            }
            print("=======================================");
print(profile);
            if (profile != null) {
              return Row(
                children: [
                  const Icon(Icons.home_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${getGreeting()}, ${profile.fullName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        "Find Your Perfect Home",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return Row(
                children: const [
                  Icon(Icons.home_rounded, color: Colors.white, size: 28),
                  SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Property Rentals',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Find Your Perfect Home",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            }
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              Provider.of<ProfileProvider>(context, listen: false).clear();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Signed out')),
              );
              // Optionally navigate to login screen
              // Navigator.of(context).pushReplacementNamed('/login');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: TextField(
              controller: searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search by title or location',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          FilterBar(
            selectedFilter: selectedFilter,
            onFilterSelected: (filter) {
              setState(() {
                selectedFilter = filter;
              });
            },
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProperties.length,
              itemBuilder: (ctx, i) => PropertyCard(property: filteredProperties[i]),
            ),
          ),
        ],
      ),
    );
  }
}
