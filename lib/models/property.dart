class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String location;
  final String type;
  final int bedrooms;
  final int bathrooms;
  final double areaSqFt;
  final List<String> amenities;
  final String contactPhoneNumber;
  final String contactEmail;
  final double? averageRating;
  final int? numberOfReviews;
  final double? latitude;  // ✅ add
  final double? longitude; // ✅ add

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.type,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqFt,
    required this.amenities,
    required this.contactPhoneNumber,
    required this.contactEmail,
    this.averageRating,
    this.numberOfReviews,
    this.latitude,   // ✅ add
    this.longitude,  // ✅ add
  });

  // Make sure fromMap / toMap handle them too
  factory Property.fromMap(Map<String, dynamic> map) {
    return Property(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      imageUrl: map['image_url'] ?? '',
      location: map['location'] ?? '',
      type: map['type'] ?? '',
      bedrooms: map['bedrooms'] ?? 0,
      bathrooms: map['bathrooms'] ?? 0,
      areaSqFt: (map['area_sq_ft'] ?? 0).toDouble(),
      amenities: List<String>.from(map['amenities'] ?? []),
      contactPhoneNumber: map['contact_phone_number'] ?? '',
      contactEmail: map['contact_email'] ?? '',
      averageRating: map['average_rating'] != null ? (map['average_rating'] as num).toDouble() : null,
      numberOfReviews: map['number_of_reviews'],
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
    );
  }
}
