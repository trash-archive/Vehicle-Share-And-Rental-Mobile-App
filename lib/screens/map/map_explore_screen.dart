import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../listing/vehicle_detail_screen.dart';
import '../search/search_screen.dart';

/// NOTE: This screen simulates the map UI using Flutter widgets.
/// In production, replace the _MockMapView with GoogleMap widget
/// from the google_maps_flutter package.
class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  VehicleModel? _selectedVehicle;
  String _selectedFilter = 'All';

  final _filters = ['All', 'Motorcycle', 'Car', 'Van', 'Equipment'];

  // Simulated pin positions (relative to mock map area)
  static const _pins = [
    _MapPin(vehicleIndex: 0, x: 0.25, y: 0.35),
    _MapPin(vehicleIndex: 1, x: 0.55, y: 0.45),
    _MapPin(vehicleIndex: 2, x: 0.70, y: 0.30),
    _MapPin(vehicleIndex: 3, x: 0.40, y: 0.60),
    _MapPin(vehicleIndex: 4, x: 0.80, y: 0.65),
    _MapPin(vehicleIndex: 5, x: 0.15, y: 0.70),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Mock Map Background ─────────────────────
          _MockMapView(
            pins: _pins,
            vehicles: MockData.vehicles,
            selectedVehicle: _selectedVehicle,
            onPinTap: (v) => setState(() => _selectedVehicle = v),
          ),

          // ── Top search bar overlay ──────────────────
          SafeArea(
            child: Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.all(Spacing.page),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => const SearchScreen()),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: Spacing.lg, vertical: 12),
                            decoration: BoxDecoration(
                              color: MovanaColors.white,
                              borderRadius:
                                  BorderRadius.circular(Radii.lg),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 16,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.search,
                                    color: MovanaColors.inkLight, size: 20),
                                const SizedBox(width: 8),
                                Text(
                                  'Search on map...',
                                  style: MovanaTextStyles.bodyMD
                                      .copyWith(color: MovanaColors.inkLight),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: MovanaColors.white,
                          borderRadius:
                              BorderRadius.circular(Radii.md),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.12),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.my_location_rounded,
                            size: 20, color: MovanaColors.primary),
                      ),
                    ],
                  ),
                ),
                // Filter chips
                SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.page),
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: Spacing.sm),
                    itemBuilder: (_, i) {
                      final f = _filters[i];
                      final selected = f == _selectedFilter;
                      return GestureDetector(
                        onTap: () =>
                            setState(() => _selectedFilter = f),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: selected
                                ? MovanaColors.primary
                                : MovanaColors.white,
                            borderRadius:
                                BorderRadius.circular(Radii.pill),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Text(
                            f,
                            style: MovanaTextStyles.labelSM.copyWith(
                              color: selected
                                  ? Colors.white
                                  : MovanaColors.inkMedium,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Results count badge ─────────────────────
          Positioned(
            top: 160,
            left: Spacing.page,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: MovanaColors.ink.withOpacity(0.75),
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              child: Text(
                '${MockData.vehicles.length} vehicles nearby',
                style: const TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),

          // ── Selected vehicle card ───────────────────
          if (_selectedVehicle != null)
            Positioned(
              bottom: 100,
              left: Spacing.page,
              right: Spacing.page,
              child: _MapVehicleCard(
                vehicle: _selectedVehicle!,
                onClose: () => setState(() => _selectedVehicle = null),
                onBook: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => VehicleDetailScreen(
                        vehicle: _selectedVehicle!),
                  ),
                ),
              ),
            ),

          // ── List toggle button ──────────────────────
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Center(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: MovanaColors.ink,
                    borderRadius: BorderRadius.circular(Radii.pill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.view_list_rounded,
                          color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'List View',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Mock Map View (visual placeholder for Google Maps)
// ──────────────────────────────────────────────
class _MockMapView extends StatelessWidget {
  final List<_MapPin> pins;
  final List<VehicleModel> vehicles;
  final VehicleModel? selectedVehicle;
  final ValueChanged<VehicleModel> onPinTap;

  const _MockMapView({
    required this.pins,
    required this.vehicles,
    required this.selectedVehicle,
    required this.onPinTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          // Map background with grid pattern
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _MapPainter(),
          ),
          // "Real map" placeholder label
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined,
                      size: 16, color: MovanaColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Google Maps integration here',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 12,
                      color: MovanaColors.inkMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Vehicle pins
          ...pins.map((pin) {
            if (pin.vehicleIndex >= vehicles.length) {
              return const SizedBox.shrink();
            }
            final v = vehicles[pin.vehicleIndex];
            final isSelected = selectedVehicle?.id == v.id;
            return Positioned(
              left: size.width * pin.x - 36,
              top: size.height * pin.y - 20,
              child: GestureDetector(
                onTap: () => onPinTap(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? MovanaColors.primary
                        : MovanaColors.white,
                    borderRadius: BorderRadius.circular(Radii.pill),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: isSelected ? 16 : 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                    border: Border.all(
                      color: isSelected
                          ? MovanaColors.primary
                          : MovanaColors.border,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Text(
                    '₱${v.pricePerDay.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? Colors.white
                          : MovanaColors.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Custom Painter for mock map grid
// ──────────────────────────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Base map color (light greenish gray like Google Maps)
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE8EAD3),
    );

    // Grid lines (streets)
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 3;

    // Major roads (horizontal)
    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.15 + i * 0.15);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    // Major roads (vertical)
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.2);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    // Minor roads
    for (var i = 0; i < 12; i++) {
      final y = size.height * (0.08 + i * 0.08);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }

    // "Blocks" (filled areas)
    final blockPaint = Paint()..color = const Color(0xFFDDE0C8);
    final rects = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.15, size.width * 0.15,
          size.height * 0.12),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.30, size.width * 0.18,
          size.height * 0.10),
      Rect.fromLTWH(size.width * 0.60, size.height * 0.20, size.width * 0.20,
          size.height * 0.08),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.55, size.width * 0.22,
          size.height * 0.12),
    ];
    for (final r in rects) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(4)),
          blockPaint);
    }

    // Park-like area (green)
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.40, size.height * 0.55, size.width * 0.25,
            size.height * 0.15),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFC8DDB8),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ──────────────────────────────────────────────
// Selected Vehicle Card on Map
// ──────────────────────────────────────────────
class _MapVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onClose;
  final VoidCallback onBook;

  const _MapVehicleCard({
    required this.vehicle,
    required this.onClose,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle
          const SizedBox(height: 8),
          Container(
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: MovanaColors.border,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Radii.md),
                  child: Image.network(
                    vehicle.imageUrls.first,
                    width: 90,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90,
                      height: 80,
                      color: MovanaColors.surface,
                    ),
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(vehicle.name,
                          style: MovanaTextStyles.headingSM,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.location_on_outlined,
                            size: 12, color: MovanaColors.inkLight),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            '${vehicle.distanceKm} km away',
                            style: MovanaTextStyles.bodySM,
                          ),
                        ),
                      ]),
                      const SizedBox(height: 6),
                      StarRating(
                          rating: vehicle.rating,
                          reviewCount: vehicle.reviewCount),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '₱${vehicle.pricePerDay.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: MovanaColors.primary,
                            ),
                          ),
                          Text('/day',
                              style: MovanaTextStyles.bodySM),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    GestureDetector(
                      onTap: onClose,
                      child: const Icon(Icons.close,
                          size: 20, color: MovanaColors.inkLight),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onBook,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: MovanaColors.primary,
                          borderRadius:
                              BorderRadius.circular(Radii.pill),
                        ),
                        child: const Text(
                          'View',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPin {
  final int vehicleIndex;
  final double x;
  final double y;
  const _MapPin(
      {required this.vehicleIndex, required this.x, required this.y});
}
