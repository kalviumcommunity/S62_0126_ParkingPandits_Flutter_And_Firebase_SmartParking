class AppConstants {
  // App info
  static const String appName = 'Smart Parking';
  static const String appVersion = '1.0.0';

  // Default location
  static const String defaultLocation = 'Delhi, India';
  static const double defaultRadius = 5.0; // in kilometers

  // Parking spot types
  static const List<String> parkingTypes = [
    'All',
    'Street',
    'Mall',
    'Office',
    'Residential',
  ];

  // Mock parking spots data
  static const List<Map<String, dynamic>> mockParkingSpots = [
    {
      'id': '1',
      'name': 'Connaught Place Parking',
      'address': 'Connaught Place, New Delhi',
      'availableSpots': 12,
      'totalSpots': 50,
      'pricePerHour': 40.0,
      'distance': 0.8,
      'rating': 4.3,
      'isAvailable': true,
      'type': 'Mall',
    },
    {
      'id': '2',
      'name': 'MG Road Street Parking',
      'address': 'MG Road, Gurugram',
      'availableSpots': 5,
      'totalSpots': 20,
      'pricePerHour': 30.0,
      'distance': 1.2,
      'rating': 4.0,
      'isAvailable': true,
      'type': 'Street',
    },
    {
      'id': '3',
      'name': 'DLF Cyber City Parking',
      'address': 'Cyber City, Gurugram',
      'availableSpots': 0,
      'totalSpots': 100,
      'pricePerHour': 50.0,
      'distance': 2.5,
      'rating': 4.5,
      'isAvailable': false,
      'type': 'Office',
    },
    {
      'id': '4',
      'name': 'Select Citywalk Mall',
      'address': 'Saket, New Delhi',
      'availableSpots': 25,
      'totalSpots': 200,
      'pricePerHour': 60.0,
      'distance': 3.1,
      'rating': 4.2,
      'isAvailable': true,
      'type': 'Mall',
    },
  ];
}
