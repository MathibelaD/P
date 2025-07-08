import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen> {
  final SupabaseClient supabase = Supabase.instance.client;

  List<Map<String, dynamic>> _listings = [];
  bool _isLoading = true;
  String? _error;

Future<void> _fetchListings() async {
  setState(() {
    _isLoading = true;
    _error = null;
  });

  try {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final data = await supabase
        .from('listings')
        .select()
        .eq('owner_id', userId)
        .order('created_at', ascending: false);

    setState(() {
      _listings = data;
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


  @override
  void initState() {
    super.initState();
    _fetchListings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        backgroundColor: const Color(0xff4facfe),
      ),
      body: RefreshIndicator(
        onRefresh: _fetchListings,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(
                    child: Text(
                      'Error: $_error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _listings.isEmpty
                    ? const Center(
                        child: Text('No listings found. Add one!'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: _listings.length,
                        itemBuilder: (context, index) {
                          final listing = _listings[index];
                          return _buildListingCard(listing);
                        },
                      ),
      ),
    );
  }

  Widget _buildListingCard(Map<String, dynamic> listing) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to listing detail/edit page if you want
        },
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(15)),
              child: listing['image_url'] != null
                  ? Image.network(
                      listing['image_url'],
                      width: 120,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 120,
                      height: 90,
                      color: Colors.grey[300],
                      child: const Icon(Icons.home, size: 40, color: Colors.white54),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing['title'] ?? 'Untitled',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      listing['location'] ?? '',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '\$${listing['price'].toString()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.green[700],
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        if (listing['bedrooms'] != null)
                          Row(
                            children: [
                              const Icon(Icons.bed, size: 16),
                              const SizedBox(width: 4),
                              Text('${listing['bedrooms']}'),
                            ],
                          ),
                        const SizedBox(width: 12),
                        if (listing['bathrooms'] != null)
                          Row(
                            children: [
                              const Icon(Icons.bathtub, size: 16),
                              const SizedBox(width: 4),
                              Text('${listing['bathrooms']}'),
                            ],
                          ),
                        const SizedBox(width: 12),
                        if (listing['area_sq_ft'] != null)
                          Row(
                            children: [
                              const Icon(Icons.square_foot, size: 16),
                              const SizedBox(width: 4),
                              Text('${listing['area_sq_ft']} sq ft'),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
