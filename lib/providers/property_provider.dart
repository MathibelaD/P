import 'package:flutter/material.dart';
import '../models/property.dart';

class PropertyProvider with ChangeNotifier {
  final List<Property> _properties = [
   Property(
      id: 'p1',
    title: 'Spacious Family Home',
    description:
        'A beautiful and spacious family home located in a quiet neighborhood. Features a large garden, modern kitchen, and plenty of natural light. Perfect for families looking for comfort and convenience.',
    price: 15000.00,
    imageUrl: 'assets/images/image1.jpg', // Make sure you have this in your assets folder
    location: 'Sandton, Johannesburg',
    bedrooms: 4,
    bathrooms: 3,
    areaSqFt: 250.0,
    type:'studio',
    amenities: ['Garden', 'Double Garage', 'Pet Friendly', 'Swimming Pool'],
    latitude: -26.1075, // Example: Sandton latitude
    longitude: 28.0566, // Example: Sandton longitude
    contactPhoneNumber: '+27821234567',
    contactEmail: 'landlord.sandton@example.com',
     ),
          Property(
    id: 'p2',
    title: 'Modern Apartment with City Views',
    description:
        'Stunning modern apartment with breathtaking city views. Ideal for young professionals. Close to public transport, restaurants, and entertainment.',
    price: 9500.00,
    imageUrl: 'assets/images/image3.jpg', // Make sure you have this in your assets folder
    location: 'Cape Town City Centre',
    bedrooms: 2,
    bathrooms: 2,
    type: 'studio',
    areaSqFt: 110.0,
    amenities: ['Gym', '24/7 Security', 'Balcony', 'En-suite Bathroom'],
    latitude: -33.9249, // Example: Cape Town latitude
    longitude: 18.4241, // Example: Cape Town longitude
    contactPhoneNumber: '+27719876543',
    contactEmail: 'landlord.capetown@example.com',
  ),
  ];

  List<Property> get properties => [..._properties];

  Property findById(String id) =>
      _properties.firstWhere((prop) => prop.id == id);
}
