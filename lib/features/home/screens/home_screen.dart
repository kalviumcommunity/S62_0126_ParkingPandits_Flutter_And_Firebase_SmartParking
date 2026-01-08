import 'package:flutter/material.dart';
import 'package:smart_parking_assistant/core/constants/app_constants.dart';
import 'package:smart_parking_assistant/core/models/parking_spot.dart';
import 'package:smart_parking_assistant/core/theme/app_theme.dart';
import 'package:smart_parking_assistant/features/parking/screens/parking_detail_screen.dart';
import 'package:smart_parking_assistant/features/profile/screens/profile_screen.dart';
import 'package:smart_parking_assistant/shared/widgets/parking_spot_card.dart';
import 'package:smart_parking_assistant/shared/widgets/search_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';
  List<ParkingSpot> _parkingSpots = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadParkingSpots();
  }

  Future<void> _loadParkingSpots() async {
    setState(() => _isLoading = true);
    
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Convert mock data to ParkingSpot objects
    final spots = AppConstants.mockParkingSpots
        .map((json) => ParkingSpot.fromJson(json))
        .toList();
    
    setState(() {
      _parkingSpots = spots;
      _isLoading = false;
    });
  }

  void _onSearch() {
    // Search functionality to be implemented
  }

  void _onFilterTap() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return FilterBottomSheet(
          selectedFilter: _selectedFilter,
          onFilterSelected: (filter) {
            setState(() => _selectedFilter = filter);
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _onParkingSpotTap(ParkingSpot spot) {
    // Navigate to detail screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ParkingDetailScreen(spot: spot),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Find Parking',
              style: AppTheme.headlineMedium,
            ),
            Text(
              AppConstants.defaultLocation,
              style: AppTheme.bodyMedium.copyWith(fontSize: 12),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              // Navigate to profile screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProfileScreen(),
                ),
              );
            },
            icon: const CircleAvatar(
              backgroundColor: AppTheme.primaryColor,
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          SearchBarWidget(
            controller: _searchController,
            onSearch: _onSearch,
            onFilterTap: _onFilterTap,
          ),

          // Filter chips
          _buildFilterChips(),

          // Parking spots list
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _parkingSpots.isEmpty
                    ? _buildEmptyState()
                    : _buildParkingList(),
          ),
        ],
      ),

      // Floating Action Button for quick reporting
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to report screen
        },
        backgroundColor: AppTheme.secondaryColor,
        icon: const Icon(Icons.add_location_alt),
        label: const Text('Report Spot'),
      ),
    );
  }

  Widget _buildFilterChips() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: AppConstants.parkingTypes.map((type) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(type),
                selected: _selectedFilter == type,
                selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                onSelected: (selected) {
                  setState(() => _selectedFilter = selected ? type : 'All');
                },
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: _selectedFilter == type
                        ? AppTheme.primaryColor
                        : Colors.grey[300]!,
                  ),
                ),
                labelStyle: TextStyle(
                  color: _selectedFilter == type
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary,
                  fontWeight: _selectedFilter == type
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildParkingList() {
    // Filter spots based on selected filter
    List<ParkingSpot> filteredSpots = _parkingSpots
        .where((spot) =>
            _selectedFilter == 'All' || spot.type == _selectedFilter)
        .toList();

    return RefreshIndicator(
      onRefresh: _loadParkingSpots,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filteredSpots.length,
        itemBuilder: (context, index) {
          final spot = filteredSpots[index];
          return ParkingSpotCard(
            spot: spot,
            onTap: () => _onParkingSpotTap(spot),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.local_parking,
            size: 80,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 20),
          Text(
            'No parking spots found',
            style: AppTheme.headlineMedium.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try changing your filters or location',
            style: AppTheme.bodyMedium.copyWith(
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _loadParkingSpots,
            child: const Text('Refresh'),
          ),
        ],
      ),
    );
  }
}

// Filter Bottom Sheet
class FilterBottomSheet extends StatefulWidget {
  final String selectedFilter;
  final Function(String) onFilterSelected;

  const FilterBottomSheet({
    super.key,
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late String _tempSelectedFilter;

  @override
  void initState() {
    super.initState();
    _tempSelectedFilter = widget.selectedFilter;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Filter Parking Spots',
            style: AppTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AppConstants.parkingTypes.map((type) {
              return ChoiceChip(
                label: Text(type),
                selected: _tempSelectedFilter == type,
                onSelected: (selected) {
                  setState(() {
                    _tempSelectedFilter = selected ? type : 'All';
                  });
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _tempSelectedFilter = 'All');
                  },
                  child: const Text('Reset'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.onFilterSelected(_tempSelectedFilter);
                  },
                  child: const Text('Apply'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
