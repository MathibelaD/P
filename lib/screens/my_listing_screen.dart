import 'package:flutter/material.dart';

class MyListingsScreen extends StatelessWidget {
  const MyListingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // For now, a simple placeholder page
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Listings'),
        backgroundColor: const Color(0xff4facfe),
      ),
      body: const Center(
        child: Text('Here will be your listings!'),
      ),
    );
  }
}
