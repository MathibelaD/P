import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  // For now, we'll use mock favorite properties
  final List<Map<String, dynamic>> favoriteProperties = [
    {
      'title': 'Modern Loft Apartment',
      'location': 'Cape Town, South Africa',
      'price': 850,
      'imageUrl': 'assets/images/image1.jpg',
    },
    {
      'title': 'Cozy Beach House',
      'location': 'Durban, South Africa',
      'price': 1200,
      'imageUrl': 'assets/images/image4.jpg',
    },
    {
      'title': 'Luxury Villa',
      'location': 'Johannesburg, South Africa',
      'price': 2500,
      'imageUrl': 'assets/images/image2.jpg',
    },
  ];

  FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool hasFavorites = favoriteProperties.isNotEmpty;

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
        title: const Text(
          'My Favorites',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: hasFavorites
          ? ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: favoriteProperties.length,
              itemBuilder: (ctx, index) {
                final property = favoriteProperties[index];
                return _buildFavoriteCard(property);
              },
            )
          : _buildEmptyState(),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> property) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          // TODO: Navigate to property detail screen
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Property image
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.asset(
               property['imageUrl'],
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property['title'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property['location'],
                    style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.attach_money,
                        color: Colors.teal,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${property['price']}/mo',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          // TODO: Remove from favorites
                        },
                        icon: const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 16),
            const Text(
              'No favorites yet!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Browse properties and tap the heart icon to save your favorite homes.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
