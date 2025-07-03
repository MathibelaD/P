import 'package:flutter/material.dart';
import '../models/property.dart';
import '../widgets/property_card.dart';

class HomeScreen extends StatelessWidget {
  final List<Property> properties;

  const HomeScreen({super.key, required this.properties});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xff4facfe), Color(0xff00f2fe)], begin: Alignment.topLeft,end: Alignment.bottomRight)
          ),
        ),
        title: Row(
          children: [
            const Icon(
              Icons.home_rounded,
              color:Colors.white,
              size:28
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Property Rentals',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white
                ),),
                Text("Find Your Perfect Home",
                style: TextStyle(fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white70),)
              ],
            )
          ],
        ),
      ),
      body: ListView.builder(
      itemCount: properties.length,
      itemBuilder: (ctx, i) => PropertyCard(property: properties[i]),
      ),
    );
  }
}
