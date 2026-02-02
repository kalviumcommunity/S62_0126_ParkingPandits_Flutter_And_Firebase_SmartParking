import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/constants/app_constants.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  String _selectedFilter = 'All';
  Map<String, dynamic>? _selectedSpot;

  @override
  Widget build(BuildContext context) {
    final availableSpots = AppConstants.mockParkingSpots
        .where((spot) => _selectedFilter == 'All' || spot['type'] == _selectedFilter)
        .toList();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Parking Map'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Colors.grey),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search parking by area...',
                            border: InputBorder.none,
                          ),
                          onTap: () {
                            // Open search
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: AppConstants.parkingTypes.map((type) {
                      final isSelected = _selectedFilter == type;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(type),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              _selectedFilter = type;
                              _selectedSpot = null;
                            });
                          },
                          selectedColor: AppTheme.primaryColor,
                          labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Map Area
          Expanded(
            child: Stack(
              children: [
                // Map Background
                Container(
                  color: AppTheme.backgroundColor,
                  child: CustomPaint(
                    painter: MapBackgroundPainter(),
                    size: Size.infinite,
                  ),
                ),

                // Parking Spots
                ...availableSpots.asMap().entries.map((entry) {
                  final index = entry.key;
                  final spot = entry.value;
                  final distance = spot['distance'] as double;
                  final isAvailable = spot['isAvailable'] as bool;
                  
                  // Position based on distance and index
                  final left = 50.0 + (distance * 80.0);
                  final top = 100.0 + (index * 60.0);
                  
                  return Positioned(
                    left: left,
                    top: top,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSpot = spot;
                        });
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isAvailable ? AppTheme.primaryColor : Colors.grey,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border: _selectedSpot?['id'] == spot['id']
                              ? Border.all(color: Colors.white, width: 3)
                              : null,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.local_parking,
                                color: Colors.white,
                                size: 20,
                              ),
                              Text(
                                'P',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),

                // Location Indicator (Your current location)
                const Positioned(
                  left: 50,
                  top: 100,
                  child: Icon(
                    Icons.location_on,
                    color: Colors.red,
                    size: 40,
                  ),
                ),
              ],
            ),
          ),

          // Details Panel
          if (_selectedSpot != null)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 1,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedSpot!['name'],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _selectedSpot!['address'],
                              style: TextStyle(
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            _selectedSpot = null;
                          });
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Spot Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildInfoItem(
                        icon: Icons.local_parking,
                        value: '${_selectedSpot!['availableSpots']}/${_selectedSpot!['totalSpots']}',
                        label: 'Spots',
                      ),
                      _buildInfoItem(
                        icon: Icons.currency_rupee,
                        value: '₹${_selectedSpot!['pricePerHour'].toInt()}/hr',
                        label: 'Price',
                      ),
                      _buildInfoItem(
                        icon: Icons.directions_walk,
                        value: '${_selectedSpot!['distance']} km',
                        label: 'Distance',
                      ),
                      _buildInfoItem(
                        icon: Icons.star,
                        value: _selectedSpot!['rating'].toString(),
                        label: 'Rating',
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Action Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _selectedSpot!['isAvailable']
                          ? () {
                              // Navigate to booking
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedSpot!['isAvailable']
                            ? AppTheme.primaryColor
                            : Colors.grey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        _selectedSpot!['isAvailable'] ? 'Book Now' : 'Full',
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
      
      // Floating Action Button for My Location
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _selectedSpot = null;
          });
        },
        backgroundColor: Colors.white,
        child: Icon(Icons.my_location, color: AppTheme.primaryColor),
      ),
    );
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw roads
    final roadPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    // Main horizontal road
    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      roadPaint,
    );

    // Main vertical road
    canvas.drawLine(
      Offset(size.width * 0.5, 0),
      Offset(size.width * 0.5, size.height),
      roadPaint,
    );

    // Draw diagonal roads
    canvas.drawLine(
      Offset(0, 0),
      Offset(size.width, size.height),
      roadPaint,
    );
    canvas.drawLine(
      Offset(size.width, 0),
      Offset(0, size.height),
      roadPaint,
    );

    // Draw some buildings/landmarks
    final buildingPaint = Paint()
      ..color = Colors.blueGrey.shade100
      ..style = PaintingStyle.fill;

    // Draw some rectangles as buildings
    canvas.drawRect(Rect.fromLTWH(100, 150, 40, 60), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(200, 250, 50, 80), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(300, 100, 60, 70), buildingPaint);
    canvas.drawRect(Rect.fromLTWH(400, 300, 40, 90), buildingPaint);
    
    // Draw park areas
    final parkPaint = Paint()
      ..color = Colors.green.shade100
      ..style = PaintingStyle.fill;
    
    canvas.drawRect(Rect.fromLTWH(150, 350, 80, 50), parkPaint);
    canvas.drawRect(Rect.fromLTWH(350, 50, 60, 40), parkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
