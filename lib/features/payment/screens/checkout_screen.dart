import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';

class CheckoutScreen extends StatefulWidget {
  final Map<String, dynamic> bookingDetails;
  
  const CheckoutScreen({
    super.key,
    required this.bookingDetails,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'upi';
  final List<Map<String, dynamic>> _paymentMethods = [
    {
      'id': 'upi',
      'name': 'UPI',
      'icon': Icons.payment,
      'color': Colors.blue,
      'description': 'Google Pay, PhonePe, Paytm',
    },
    {
      'id': 'card',
      'name': 'Credit/Debit Card',
      'icon': Icons.credit_card,
      'color': Colors.purple,
      'description': 'Visa, Mastercard, RuPay',
    },
    {
      'id': 'wallet',
      'name': 'Wallet',
      'icon': Icons.wallet,
      'color': Colors.green,
      'description': 'Paytm Wallet, Amazon Pay',
    },
    {
      'id': 'netbanking',
      'name': 'Net Banking',
      'icon': Icons.account_balance,
      'color': Colors.orange,
      'description': 'All major banks',
    },
  ];
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Booking Summary
              const Text(
                'Booking Summary',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildSummaryRow('Parking', widget.bookingDetails['parkingName']),
                    _buildSummaryRow('Duration', '${widget.bookingDetails['duration']} hours'),
                    _buildSummaryRow('Spot', widget.bookingDetails['spotNumber']),
                    _buildSummaryRow('Date & Time', widget.bookingDetails['dateTime']),
                    const Divider(height: 20),
                    _buildSummaryRow('Base Price', '₹${widget.bookingDetails['basePrice']}'),
                    _buildSummaryRow('GST (18%)', '₹${widget.bookingDetails['gst']}'),
                    _buildSummaryRow('Platform Fee', '₹${widget.bookingDetails['platformFee']}'),
                    const Divider(height: 20),
                    _buildSummaryRow(
                      'Total Amount',
                      '₹${widget.bookingDetails['totalAmount']}',
                      isTotal: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 30),
              
              // Payment Methods
              const Text(
                'Select Payment Method',
                style: AppTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              
              Column(
                children: _paymentMethods.map((method) {
                  return _buildPaymentMethodCard(method);
                }).toList(),
              ),
              
              const SizedBox(height: 30),
              
              // Promo Code
              const Text(
                'Promo Code',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        hintText: 'Enter promo code',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Apply'),
                  ),
                ],
              ),
              
              const SizedBox(height: 30),
              
              // Terms & Conditions
              Row(
                children: [
                  Checkbox(
                    value: true,
                    onChanged: (value) {},
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                        children: [
                          TextSpan(text: 'I agree to the '),
                          TextSpan(
                            text: 'Terms & Conditions',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Cancellation Policy',
                            style: TextStyle(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      
      // Bottom Payment Button
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(color: Colors.grey.shade300),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total Payable',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  '₹${widget.bookingDetails['totalAmount']}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _processPayment();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed to Pay',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal ? AppTheme.primaryColor : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildPaymentMethodCard(Map<String, dynamic> method) {
    final isSelected = _selectedPaymentMethod == method['id'];
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method['id'];
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? method['color'].withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? method['color'] : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: method['color'].withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: method['color'].withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
              child: Icon(method['icon'], color: method['color']),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    method['name'],
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? method['color'] : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    method['description'],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: method['color'],
              ),
          ],
        ),
      ),
    );
  }
  
  void _processPayment() {
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const Dialog(
          child: Padding(
            padding: EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 20),
                Text('Processing payment...'),
              ],
            ),
          ),
        );
      },
    );
    
    // Simulate payment processing
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context); // Remove loading dialog
      _showPaymentSuccess();
    });
  }
  
  void _showPaymentSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Payment Successful!'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.check_circle,
                size: 80,
                color: Colors.green,
              ),
              const SizedBox(height: 20),
              Text(
                '₹${widget.bookingDetails['totalAmount']}',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Payment completed successfully',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.workspace_premium, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text(
                      'You earned 20 points!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close success dialog
                Navigator.pop(context); // Go back to booking/history
              },
              child: const Text('View Booking'),
            ),
          ],
        );
      },
    );
  }
}
