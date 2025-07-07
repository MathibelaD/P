import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/property.dart';
import './screens/main_screen.dart';
import './screens/property_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import './screens/supabase_test_screen.dart';
import './providers/profile_provider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );


runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final List<Property> properties = [
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rental App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      // home: HomeScreen(properties: properties),
     home: MainScreen(properties: properties),
     routes: {
      // register your named routes here
      PropertyDetailScreen.routeName: (ctx) => const PropertyDetailScreen(),
      '/supabase-test': (ctx) => const SupabaseTestScreen(),
    },
    );
  }
}
