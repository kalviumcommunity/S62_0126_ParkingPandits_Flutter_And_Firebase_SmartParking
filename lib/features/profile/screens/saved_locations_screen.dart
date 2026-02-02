import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';

class SavedLocationsScreen extends StatefulWidget {
  const SavedLocationsScreen({super.key});

  @override
  State<SavedLocationsScreen> createState() => _SavedLocationsScreenState();
}

class _SavedLocationsScreenState extends State<SavedLocationsScreen> {
  final List<Map<String, dynamic>> _savedLocations = [
    {
      'id': '1',
      'name': 'Home',
      'address': '123 MG Road, Gurugram',
      'type': 'home',
      'isDefault': true,
      'lat': 28.4595,
      'lng': 77.0266,
    },
    {
      'id': '2',
      'name': 'Office',
      'address': 'DLF Cyber City, Gurugram',
      'type': 'work',
      'isDefault': false,
      'lat': 28.4967,
      'lng': 77.0888,
    },
    {
      'id': '3',
      'name': 'Gym',
      'address': 'Connaught Place, Delhi',
      'type': 'gym',
      'isDefault': false,
      'lat': 28.6315,
      'lng': 77.2167,
    },
    {
      'id': '4',
      'name': 'Mom\'s House',
      'address': 'Karol Bagh, Delhi',
      'type': 'home',
      'isDefault': false,
      'lat': 28.6517,
      'lng': 77.1907,
    },
    {
      'id': '5',
      'name': 'Shopping Mall',
      'address': 'Select Citywalk, Saket',
      'type': 'shopping',
      'isDefault': false,
      'lat': 28.5275,
      'lng': 77.2190,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Locations'),
        actions: [
          IconButton(
            onPressed: _addNewLocation,
            icon: const Icon(Icons.add_location),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Add Card
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Add Current Location',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Save your current parking spot',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _addCurrentLocation,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ],
            ),
          ),
          
          // Saved Locations List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _savedLocations.length,
              itemBuilder: (context, index) {
                final location = _savedLocations[index];
                return _buildLocationCard(location);
              },
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildLocationCard(Map<String, dynamic> location) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getLocationColor(location['type']),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(
                _getLocationIcon(location['type']),
                color: Colors.white,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        location['name'],
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (location['isDefault'])
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'DEFAULT',
                            style: TextStyle(
                              fontSize: 10,
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    location['address'],
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${location['lat'].toStringAsFixed(4)}, ${location['lng'].toStringAsFixed(4)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Actions
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.edit, size: 20),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                  onTap: () => _editLocation(location),
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 20,
                        color: location['isDefault'] ? Colors.amber : Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Text(location['isDefault'] ? 'Remove Default' : 'Set as Default'),
                    ],
                  ),
                  onTap: () => _toggleDefault(location['id']),
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(Icons.delete, size: 20, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                  onTap: () => _deleteLocation(location['id']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getLocationColor(String type) {
    switch (type) {
      case 'home':
        return Colors.blue;
      case 'work':
        return Colors.green;
      case 'gym':
        return Colors.orange;
      case 'shopping':
        return Colors.purple;
      default:
        return AppTheme.primaryColor;
    }
  }
  
  IconData _getLocationIcon(String type) {
    switch (type) {
      case 'home':
        return Icons.home;
      case 'work':
        return Icons.work;
      case 'gym':
        return Icons.fitness_center;
      case 'shopping':
        return Icons.shopping_cart;
      default:
        return Icons.place;
    }
  }
  
  void _addNewLocation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Location'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Location Name',
                  hintText: 'e.g., Office, Gym, Mom\'s House',
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Address',
                  hintText: 'Enter full address',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField(
                decoration: const InputDecoration(labelText: 'Type'),
                items: const [
                  DropdownMenuItem(value: 'home', child: Text('Home')),
                  DropdownMenuItem(value: 'work', child: Text('Work')),
                  DropdownMenuItem(value: 'gym', child: Text('Gym')),
                  DropdownMenuItem(value: 'shopping', child: Text('Shopping')),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {},
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
                _showAddSuccess();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
  
  void _addCurrentLocation() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Current Location'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on, size: 60, color: Colors.green),
              SizedBox(height: 20),
              Text(
                'Getting your current location...',
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
    
    // Simulate location fetching
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showAddSuccess();
    });
  }
  
  void _showAddSuccess() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Location saved successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _editLocation(Map<String, dynamic> location) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Location'),
          content: const Text('Edit location functionality would be implemented here.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
  
  void _toggleDefault(String locationId) {
    setState(() {
      for (var location in _savedLocations) {
        location['isDefault'] = location['id'] == locationId;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Default location updated!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  void _deleteLocation(String locationId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Location'),
          content: const Text('Are you sure you want to delete this saved location?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _savedLocations.removeWhere((loc) => loc['id'] == locationId);
                });
                Navigator.pop(context);
                
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Location deleted'),
                    backgroundColor: Colors.red,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
