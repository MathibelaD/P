import 'package:flutter/material.dart';
import '../models/property.dart';

class PropertyDetailScreen extends StatelessWidget {
  static const routeName = '/property-detail';

  const PropertyDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)!.settings.arguments as Property;

    return Scaffold(
      appBar: AppBar(title: Text(property.title)),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(property.imageUrl),
            SizedBox(height: 10),
            Text('\$${property.price}/month',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text(property.location, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(property.description),
            ),
          ],
        ),
      ),
    );
  }
}
