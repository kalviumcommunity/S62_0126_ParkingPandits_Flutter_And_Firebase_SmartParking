class ParkingSpot {
  final String id;
  final String name;
  final String address;
  final int availableSpots;
  final int totalSpots;
  final double pricePerHour;
  final double distance; // in km
  final double rating;
  final bool isAvailable;
  final String type;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.address,
    required this.availableSpots,
    required this.totalSpots,
    required this.pricePerHour,
    required this.distance,
    required this.rating,
    required this.isAvailable,
    required this.type,
  });

  // Factory constructor for mock data
  factory ParkingSpot.fromJson(Map<String, dynamic> json) {
    return ParkingSpot(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      availableSpots: json['availableSpots'] ?? 0,
      totalSpots: json['totalSpots'] ?? 0,
      pricePerHour: (json['pricePerHour'] ?? 0).toDouble(),
      distance: (json['distance'] ?? 0).toDouble(),
      rating: (json['rating'] ?? 0).toDouble(),
      isAvailable: json['isAvailable'] ?? false,
      type: json['type'] ?? '',
    );
  }

  // Helper methods
  String get formattedPrice => '₹${pricePerHour.toInt()}/hr';
  String get formattedDistance => '${distance.toStringAsFixed(1)} km';
}
