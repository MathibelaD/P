// Remove 'package:cloud_firestore/cloud_firestore.dart';
// We don't need it if we're not directly interacting with Firestore's Timestamp type.

import 'package:flutter/material.dart'; // Or just dart:core, depending on what else is in this file

class Review {
  final String id;
  final String propertyId;
  final String userId; // Or userName for display
  final double rating; // e.g., 1.0 to 5.0
  final String? comment; // Optional text review
  final DateTime date; // Using standard Dart DateTime
  final List<String>? images; // Optional: users can add photos to their review

  Review({
    required this.id,
    required this.propertyId,
    required this.userId,
    required this.rating,
    required this.date,
    this.comment,
    this.images,
  });

  // If you later use a local database that stores dates as strings or integers,
  // you'll modify these fromMap/toMap methods accordingly.

  // Example: Factory constructor for converting from a generic Map (e.g., from a local JSON file or a simple API)
  // This assumes the date is stored as an ISO 8601 string.
  factory Review.fromMap(Map<String, dynamic> map, String id) {
    return Review(
      id: id,
      propertyId: map['propertyId'],
      userId: map['userId'],
      rating: map['rating'].toDouble(),
      comment: map['comment'],
      date: DateTime.parse(map['date']), // Parse date string into DateTime
      images: map['images'] != null ? List<String>.from(map['images']) : null,
    );
  }

  // ToMap method for saving to a generic Map (e.g., for local storage or sending to a simple API)
  // This converts DateTime to an ISO 8601 string.
  Map<String, dynamic> toMap() {
    return {
      'propertyId': propertyId,
      'userId': userId,
      'rating': rating,
      'comment': comment,
      'date': date.toIso8601String(), // Convert DateTime to a string for storage
      'images': images,
    };
  }
}