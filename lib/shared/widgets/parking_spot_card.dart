import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/models/parking_spot.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';

class ParkingSpotCard extends StatelessWidget {
  final ParkingSpot spot;
  final VoidCallback? onTap;

  const ParkingSpotCard({
    super.key,
    required this.spot,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      spot.name,
                      style: AppTheme.headlineMedium.copyWith(
                        fontSize: 18,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: spot.isAvailable 
                          ? AppTheme.secondaryColor.withOpacity(0.1)
                          : AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      spot.isAvailable ? 'Available' : 'Full',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: spot.isAvailable 
                            ? AppTheme.secondaryColor 
                            : AppTheme.errorColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Address
              Text(
                spot.address,
                style: AppTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 16),

              // Details row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildDetailItem(
                    icon: Icons.local_parking,
                    label: 'Spots',
                    value: '${spot.availableSpots}/${spot.totalSpots}',
                  ),
                  _buildDetailItem(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: spot.formattedPrice,
                  ),
                  _buildDetailItem(
                    icon: Icons.place,
                    label: 'Distance',
                    value: spot.formattedDistance,
                  ),
                  _buildDetailItem(
                    icon: Icons.star,
                    label: 'Rating',
                    value: spot.rating.toStringAsFixed(1),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Book button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: spot.isAvailable ? onTap : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: spot.isAvailable 
                        ? AppTheme.primaryColor 
                        : Colors.grey[300],
                    foregroundColor: spot.isAvailable 
                        ? Colors.white 
                        : Colors.grey[600],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    spot.isAvailable ? 'Book Now' : 'No Spots Available',
                    style: AppTheme.buttonText.copyWith(
                      fontSize: 14,
                      color: spot.isAvailable 
                          ? Colors.white 
                          : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
