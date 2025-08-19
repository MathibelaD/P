import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/property.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_bar.dart';
import '../providers/profile_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required List<Property> properties});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  List<Property> _allProperties = [];
  String selectedFilter = 'All';
  String searchQuery = '';
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchProperties();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchProperties() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final data = await Supabase.instance.client
          .from('listings')
          .select();

      final fetched = data.map<Property>((item) => Property.fromMap(item)).toList();

      setState(() {
        _allProperties = fetched;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 18) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    final filteredProperties = _allProperties.where((p) {
      final matchesFilter = selectedFilter == 'All' ||
          p.type.toLowerCase() == selectedFilter.toLowerCase();
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
          Consumer<ProfileProvider>(
            builder: (context, profileProvider, _) {
              if (profileProvider.profile != null) {
                return IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    await Supabase.instance.client.auth.signOut();
                    Provider.of<ProfileProvider>(context, listen: false).clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed out')),
                    );
                  },
                );
              } else {
                return IconButton(
                  icon: const Icon(Icons.login, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                );
              }
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text('Error: $_error', style: const TextStyle(color: Colors.red)))
              : RefreshIndicator(
                  onRefresh: _fetchProperties,
                  child: Column(
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
                        child: filteredProperties.isEmpty
                            ? const Center(child: Text('No properties found'))
                            : ListView.builder(
                                itemCount: filteredProperties.length,
                                itemBuilder: (ctx, i) => PropertyCard(property: filteredProperties[i]),
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
