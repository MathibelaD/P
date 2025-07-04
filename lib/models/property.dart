class Property1 {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  final String location;
  final String type;

  Property1({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.type,
  });
}

class Property {
  final String id;
  final String title;
  final String description;
  final double price;
  final String type;
  final String imageUrl;
  final String location;
  final int bedrooms; // New: Number of bedrooms
  final int bathrooms; // New: Number of bathrooms
  final double areaSqFt; // New: Area in square feet/meters
  final List<String> amenities; // New: List of amenities (e.g., "Pool", "Gym")
  final double latitude; // New: For map integration
  final double longitude; // New: For map integration
  final String contactPhoneNumber; // New: Landlord's phone number
  final String contactEmail; // New: Landlord's email
  final int? numberOfReviews;
  final double? averageRating;

  Property({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.location,
    required this.bedrooms,
    required this.bathrooms,
    required this.areaSqFt,
    required this.amenities,
    required this.latitude,
    required this.longitude,
    required this.type,
    required this.contactPhoneNumber,
    required this.contactEmail,
    this.numberOfReviews,
    this.averageRating,
  });
}
