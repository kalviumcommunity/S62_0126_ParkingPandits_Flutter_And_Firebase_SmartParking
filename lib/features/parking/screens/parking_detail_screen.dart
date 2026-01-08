import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/models/parking_spot.dart';

class ParkingDetailScreen extends StatelessWidget {
  final ParkingSpot spot;
  
  const ParkingDetailScreen({
    super.key,
    required this.spot,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Details'),
      ),
      body: Column(
        children: [
          // Header Image/Map
          Container(
            height: 200,
            color: Colors.blue.shade50,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_parking,
                    size: 80,
                    color: Colors.blue.shade700,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    spot.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Availability Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: spot.isAvailable
                            ? Colors.green.shade50
                            : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: spot.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                      child: Text(
                        spot.isAvailable ? '✅ Available' : '❌ Full',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: spot.isAvailable
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Address
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            spot.address,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Information Grid
                    const Text(
                      'Parking Information',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      childAspectRatio: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildInfoTile(
                          icon: Icons.local_parking,
                          title: 'Available Spots',
                          value: '${spot.availableSpots}/${spot.totalSpots}',
                          color: Colors.blue,
                        ),
                        _buildInfoTile(
                          icon: Icons.currency_rupee,
                          title: 'Price per hour',
                          value: spot.formattedPrice,
                          color: Colors.green,
                        ),
                        _buildInfoTile(
                          icon: Icons.star,
                          title: 'Rating',
                          value: spot.rating.toStringAsFixed(1),
                          color: Colors.amber,
                        ),
                        _buildInfoTile(
                          icon: Icons.directions_car,
                          title: 'Distance',
                          value: spot.formattedDistance,
                          color: Colors.purple,
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Description
                    const Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'This parking facility offers secure parking with CCTV surveillance, '
                      '24/7 security, and good lighting. Perfect for both short-term and '
                      'long-term parking needs.',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        height: 1.5,
                      ),
                    ),
                    
                    const SizedBox(height: 30),
                    
                    // Features
                    const Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: const [
                        FeatureChip(text: '24/7 Security'),
                        FeatureChip(text: 'CCTV'),
                        FeatureChip(text: 'Well Lit'),
                        FeatureChip(text: 'Covered'),
                        FeatureChip(text: 'EV Charging'),
                        FeatureChip(text: 'Wheelchair Access'),
                      ],
                    ),
                    
                    const SizedBox(height: 40), // Extra space at bottom
                  ],
                ),
              ),
            ),
          ),
          
          // Bottom Booking Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                top: BorderSide(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Price Info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Price per hour',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      spot.formattedPrice,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                
                const Spacer(),
                
                // Book Button
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    onPressed: spot.isAvailable
                        ? () {
                            _showBookingDialog(context);
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: spot.isAvailable
                          ? Colors.blue.shade700
                          : Colors.grey,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      spot.isAvailable ? 'Book Now' : 'Not Available',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showBookingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                'Book ${spot.name}?',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Duration: 2 hours\nTotal: ₹80',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showSuccessDialog(context);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }
  
  void _showSuccessDialog(BuildContext context) {
    final bookingId = 'SPB${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.celebration,
                size: 60,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              const Text(
                'You booked:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                spot.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                'Booking ID: $bookingId',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to home
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }
}

class FeatureChip extends StatelessWidget {
  final String text;
  
  const FeatureChip({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.blue.shade100,
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blue.shade800,
          fontSize: 14,
        ),
      ),
    );
  }
}
