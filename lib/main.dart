import 'package:flutter/material.dart';
import './models/property.dart';
import './screens/main_screen.dart';

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
      imageUrl: 'assets/images/image1.jpg',
      location: 'Cape Town',
      type: "Apartment"
    ),
    Property(
      id: 'p2',
      title: 'Ikhaya Lethu',
      description: 'Spacious modern loft with a great view.',
      price: 2000,
      imageUrl: 'assets/images/image2.jpg',
      location: 'Pretoria',
      type: "Apartment"
    ),
    Property(
      id: 'p3',
      title: 'Modern Loft',
      description: 'Spacious modern loft with a great view.',
      price: 2000,
      imageUrl: 'assets/images/image3.jpg',
      location: 'Johhanesburg',
      type: "Studio"
    ),
    Property(
      id: 'p4',
      title: 'Modern Loft',
      description: 'Spacious modern loft with a great view.',
      price: 2000,
      imageUrl: 'assets/images/image4.jpg',
      location: 'soshanguve',
      type: "House"
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      // home: HomeScreen(properties: properties),
     home: MainScreen(properties: properties),
    );
  }
}
