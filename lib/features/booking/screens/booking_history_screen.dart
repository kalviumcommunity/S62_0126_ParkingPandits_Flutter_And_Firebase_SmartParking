import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';

class BookingHistoryScreen extends StatefulWidget {
  const BookingHistoryScreen({super.key});

  @override
  State<BookingHistoryScreen> createState() => _BookingHistoryScreenState();
}

class _BookingHistoryScreenState extends State<BookingHistoryScreen> {
  String _selectedFilter = 'all'; // 'all', 'upcoming', 'past', 'cancelled'
  
  final List<Map<String, dynamic>> _bookings = [
    {
      'id': 'B001',
      'parkingName': 'Connaught Place Parking',
      'address': 'Connaught Place, New Delhi',
      'date': 'Today, 10:30 AM',
      'duration': '2 hours',
      'price': '₹80',
      'status': 'active',
      'statusColor': Colors.green,
      'vehicle': 'DL 1AB 2345',
      'spotNumber': 'A-12',
      'bookingId': 'SPB123456',
    },
    {
      'id': 'B002',
      'parkingName': 'MG Road Street Parking',
      'address': 'MG Road, Gurugram',
      'date': 'Yesterday, 3:45 PM',
      'duration': '1 hour',
      'price': '₹30',
      'status': 'completed',
      'statusColor': Colors.blue,
      'vehicle': 'DL 1AB 2345',
      'spotNumber': 'B-07',
      'bookingId': 'SPB123457',
    },
    {
      'id': 'B003',
      'parkingName': 'Select Citywalk Mall',
      'address': 'Saket, New Delhi',
      'date': 'Dec 28, 2:15 PM',
      'duration': '3 hours',
      'price': '₹180',
      'status': 'completed',
      'statusColor': Colors.blue,
      'vehicle': 'HR 26 AB 1234',
      'spotNumber': 'P-45',
      'bookingId': 'SPB123458',
    },
    {
      'id': 'B004',
      'parkingName': 'DLF Cyber City Parking',
      'address': 'Cyber City, Gurugram',
      'date': 'Dec 25, 11:00 AM',
      'duration': '4 hours',
      'price': '₹200',
      'status': 'cancelled',
      'statusColor': Colors.red,
      'vehicle': 'DL 1AB 2345',
      'spotNumber': 'C-22',
      'bookingId': 'SPB123459',
    },
    {
      'id': 'B005',
      'parkingName': 'Ambience Mall Parking',
      'address': 'Vasant Kunj, Delhi',
      'date': 'Dec 20, 5:30 PM',
      'duration': '2 hours',
      'price': '₹100',
      'status': 'completed',
      'statusColor': Colors.blue,
      'vehicle': 'DL 1AB 2345',
      'spotNumber': 'D-18',
      'bookingId': 'SPB123460',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBookings = _filterBookings();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking History'),
      ),
      body: Column(
        children: [
          // Filter Chips
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', 'all'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', 'active'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Completed', 'completed'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Cancelled', 'cancelled'),
                ],
              ),
            ),
          ),
          
          // Statistics Summary
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.1)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Total', '${_bookings.length}', Icons.receipt),
                _buildStatItem('Active', '1', Icons.timer),
                _buildStatItem('Spent', '₹590', Icons.currency_rupee),
              ],
            ),
          ),
          
          // Bookings List
          Expanded(
            child: filteredBookings.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      return _buildBookingCard(booking);
                    },
                  ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = selected ? value : 'all';
        });
      },
      selectedColor: AppTheme.primaryColor.withOpacity(0.2),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isSelected ? AppTheme.primaryColor : Colors.grey.shade300,
        ),
      ),
      labelStyle: TextStyle(
        color: isSelected ? AppTheme.primaryColor : AppTheme.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(icon, color: AppTheme.primaryColor),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
  
  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking['parkingName'],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['address'],
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: booking['statusColor'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    _capitalize(booking['status']),
                    style: TextStyle(
                      color: booking['statusColor'],
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Booking Details
            Row(
              children: [
                _buildDetailItem(
                  icon: Icons.calendar_today,
                  label: 'Date & Time',
                  value: booking['date'],
                ),
                const SizedBox(width: 20),
                _buildDetailItem(
                  icon: Icons.timer,
                  label: 'Duration',
                  value: booking['duration'],
                ),
                const SizedBox(width: 20),
                _buildDetailItem(
                  icon: Icons.currency_rupee,
                  label: 'Amount',
                  value: booking['price'],
                ),
              ],
            ),
            
            const SizedBox(height: 12),
            
            // Additional Details
            Row(
              children: [
                _buildDetailItem(
                  icon: Icons.directions_car,
                  label: 'Vehicle',
                  value: booking['vehicle'],
                ),
                const SizedBox(width: 20),
                _buildDetailItem(
                  icon: Icons.local_parking,
                  label: 'Spot',
                  value: booking['spotNumber'],
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Action Buttons
            if (booking['status'] == 'active')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showExtendBookingDialog(context, booking);
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('Extend Time'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showCancelBookingDialog(context, booking);
                      },
                      icon: const Icon(Icons.close, size: 18),
                      label: const Text('Cancel'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            
            if (booking['status'] == 'completed')
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showInvoice(context, booking);
                      },
                      icon: const Icon(Icons.receipt, size: 18),
                      label: const Text('View Invoice'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _showRateDialog(context, booking);
                      },
                      icon: const Icon(Icons.star, size: 18),
                      label: const Text('Rate Parking'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
            
            if (booking['status'] == 'cancelled')
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    _showBookAgainDialog(context, booking);
                  },
                  icon: const Icon(Icons.replay, size: 18),
                  label: const Text('Book Again'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'No bookings found',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.grey.shade400,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You don\'t have any ${_selectedFilter == 'all' ? '' : _selectedFilter} bookings',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Navigate to home to book parking
              Navigator.pop(context);
            },
            child: const Text('Find Parking'),
          ),
        ],
      ),
    );
  }
  
  List<Map<String, dynamic>> _filterBookings() {
    if (_selectedFilter == 'all') return _bookings;
    return _bookings.where((booking) => booking['status'] == _selectedFilter).toList();
  }
  
  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  void _showExtendBookingDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Extend Booking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Select additional time:'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [1, 2, 3].map((hours) {
                  return Column(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: hours == 1 ? AppTheme.primaryColor : AppTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                          child: Text(
                            '$hours',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: hours == 1 ? Colors.white : AppTheme.textColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$hours ${hours == 1 ? 'hour' : 'hours'}',
                        style: TextStyle(
                          color: hours == 1 ? AppTheme.primaryColor : AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Additional amount: ₹40'),
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
                _showExtensionConfirmation(context, booking);
              },
              child: const Text('Extend'),
            ),
          ],
        );
      },
    );
  }
  
  void _showExtensionConfirmation(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Extended!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle, size: 60, color: Colors.green),
              const SizedBox(height: 20),
              Text(
                '${booking['parkingName']}',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                'Extended by 1 hour\nNew total: ₹120',
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void _showCancelBookingDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Cancel Booking'),
          content: const Text('Are you sure you want to cancel this booking?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showCancellationConfirmation(context, booking);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Yes, Cancel'),
            ),
          ],
        );
      },
    );
  }
  
  void _showCancellationConfirmation(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Booking Cancelled'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.info, size: 60, color: Colors.orange),
              const SizedBox(height: 20),
              const Text(
                'Your booking has been cancelled.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Refund of ₹80 will be processed within 5-7 business days.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void _showInvoice(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'INVOICE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                _buildInvoiceRow('Booking ID', booking['bookingId']),
                _buildInvoiceRow('Parking', booking['parkingName']),
                _buildInvoiceRow('Date', booking['date']),
                _buildInvoiceRow('Duration', booking['duration']),
                _buildInvoiceRow('Spot', booking['spotNumber']),
                _buildInvoiceRow('Vehicle', booking['vehicle']),
                const Divider(height: 30),
                _buildInvoiceRow('Amount', booking['price'], isBold: true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Close'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget _buildInvoiceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
  
  void _showRateDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Rate Parking'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(booking['parkingName']),
              const SizedBox(height: 20),
              const Text('How was your experience?'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.star,
                      size: 30,
                      color: index < 4 ? Colors.amber : Colors.grey.shade300,
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),
              TextFormField(
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Add a review (optional)',
                  border: OutlineInputBorder(),
                ),
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
                _showRatingConfirmation(context);
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
  
  void _showRatingConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Thank You!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.thumb_up, size: 60, color: Colors.green),
              const SizedBox(height: 20),
              const Text(
                'Your rating has been submitted.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'You earned 5 points for your review!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.green),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
  
  void _showBookAgainDialog(BuildContext context, Map<String, dynamic> booking) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Book Again'),
          content: Text('Book ${booking['parkingName']} again?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); // Go back to home
                // In a real app, this would navigate to booking flow
              },
              child: const Text('Book Now'),
            ),
          ],
        );
      },
    );
  }
}
