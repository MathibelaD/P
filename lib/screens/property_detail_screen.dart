import 'package:flutter/material.dart';
import '../models/property.dart';
import 'package:url_launcher/url_launcher.dart'; // Keep this import for phone/email calls
// import 'package:Maps_flutter/Maps_flutter.dart'; // Uncomment if you fix map setup

class PropertyDetailScreen extends StatefulWidget {
  static const routeName = '/property-detail';

  const PropertyDetailScreen({super.key});

  @override
  State<PropertyDetailScreen> createState() => _PropertyDetailScreenState();
}

class _PropertyDetailScreenState extends State<PropertyDetailScreen> {
  // Define initial camera position for the map (can be changed based on property)
  // Uncomment this if you decide to re-enable Google Maps
  // static const CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(-26.2041, 28.0473), // Default to Johannesburg, SA
  //   zoom: 14.0,
  // );

  @override
  Widget build(BuildContext context) {
    final property = ModalRoute.of(context)!.settings.arguments as Property;

    return Scaffold(
      appBar: AppBar(
        title: Text(property.title),
        backgroundColor: Colors.teal, // A pleasant color
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- Single Image (Replaced Carousel) ---
            Hero(
              tag: property.id, // For smooth transition from list
              child: property.imageUrl.contains('assets/')
                  ? Image.asset(
                      property.imageUrl,
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      property.imageUrl, // If you're using network images
                      width: double.infinity,
                      height: 250,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 250,
                        color: Colors.grey[300],
                        child: const Center(child: Text('Image not available')),
                      ),
                    ),
            ),
            const SizedBox(height: 16),

            // --- Property Title and Price ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    property.title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'R${property.price.toStringAsFixed(2)} / month', // Format price
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.location_on, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          property.location,
                          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),

            // --- Key Features (Bedrooms, Bathrooms, Area) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Key Features',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildFeatureIcon(Icons.bed, '${property.bedrooms} Bed', context),
                      _buildFeatureIcon(Icons.bathtub, '${property.bathrooms} Bath', context),
                      _buildFeatureIcon(Icons.square_foot, '${property.areaSqFt} m²', context),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),

            // --- Description ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    property.description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),

            // --- Amenities ---
            if (property.amenities.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amenities',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8.0, // Space between chips
                      runSpacing: 8.0, // Space between rows of chips
                      children: property.amenities
                          .map((amenity) => Chip(
                                label: Text(amenity),
                                backgroundColor: Colors.teal[50],
                                labelStyle: const TextStyle(color: Colors.teal),
                                side: const BorderSide(color: Colors.teal),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),
            if (property.amenities.isNotEmpty) const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),

            // --- Location Map (Commented out) ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Location on Map',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: const Center(
                      child: Text(
                        'Map functionality is currently disabled.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    // Removed ClipRRect and GoogleMap widget
                  ),
                ],
              ),
            ),
            const Divider(height: 30, thickness: 1, indent: 16, endIndent: 16),

            // --- Contact Information ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Landlord',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          ListTile(
                            leading: const Icon(Icons.phone, color: Colors.blue),
                            title: const Text('Call Landlord'),
                            subtitle: Text(property.contactPhoneNumber),
                            onTap: () => _makePhoneCall(property.contactPhoneNumber),
                          ),
                          ListTile(
                            leading: const Icon(Icons.email, color: Colors.red),
                            title: const Text('Email Landlord'),
                            subtitle: Text(property.contactEmail),
                            onTap: () => _sendEmail(property.contactEmail, property.title, property.location), // Fixed here
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30), // Extra space at the bottom
          ],
        ),
      ),
    );
  }

  // Helper function to build feature icons
  Widget _buildFeatureIcon(IconData icon, String text, BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 30, color: Colors.teal),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    // Re-enabled url_launcher
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch phone dialer.')),
      );
    }
  }

  // Function to send an email - Corrected signature and usage
  Future<void> _sendEmail(String emailAddress, String propertyTitle, String propertyLocation) async {
    final Uri launchUri = Uri(
      scheme: 'mailto',
      path: emailAddress,
      queryParameters: {
        'subject': 'Inquiry about Property: $propertyTitle',
        'body': 'Dear Landlord, I am interested in your property located at $propertyLocation. Could you please provide more details or arrange a viewing?\n\nMy name is [Your Name].\nMy phone number is [Your Phone Number].',
      },
    );
    // Re-enabled url_launcher
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch email app.')),
      );
    }
  }
}