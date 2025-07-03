import 'package:flutter/material.dart';
import './models/property.dart';
import './screens/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Property> properties = [
    Property(
      id: 'p1',
      title: 'Cozy Apartment',
      description: 'A cozy apartment in the city center.',
      price: 1200,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: 'Downtown',
    ),
    Property(
      id: 'p2',
      title: 'Modern Loft',
      description: 'Spacious modern loft with a great view.',
      price: 2000,
      imageUrl: 'https://via.placeholder.com/400x200',
      location: 'Uptown',
    ),
  ];

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      home: HomeScreen(properties: properties),
    );
  }
}
