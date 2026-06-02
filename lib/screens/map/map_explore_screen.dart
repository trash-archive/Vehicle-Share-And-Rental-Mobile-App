import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../listing/vehicle_detail_screen.dart';
import '../search/search_screen.dart';

// Cebu City centre
const _cebu = LatLng(10.3157, 123.8854);

// Fixed lat/lng offsets for each mock vehicle pin
const _pinCoords = [
  LatLng(10.3180, 123.8820),
  LatLng(10.3140, 123.8900),
  LatLng(10.3200, 123.8960),
  LatLng(10.3100, 123.8840),
  LatLng(10.3220, 123.8780),
  LatLng(10.3070, 123.8910),
];

class MapExploreScreen extends StatefulWidget {
  const MapExploreScreen({super.key});

  @override
  State<MapExploreScreen> createState() => _MapExploreScreenState();
}

class _MapExploreScreenState extends State<MapExploreScreen> {
  VehicleModel? _selectedVehicle;
  String _selectedFilter = 'All';
  bool _showList = false;
  final _mapController = MapController();
  final _filters = ['All', 'Motorcycle', 'Car', 'Van', 'Equipment'];

  bool _matches(VehicleModel v) {
    switch (_selectedFilter) {
      case 'Motorcycle':
        return v.type == 'Scooter' || v.type == 'Motorcycle';
      case 'Car':
        return v.type == 'Sedan' || v.type == 'SUV' || v.type == 'Pickup';
      case 'Van':
        return v.category == VehicleCategory.commercial;
      case 'Equipment':
        return v.category == VehicleCategory.construction ||
            v.category == VehicleCategory.agricultural;
      default:
        return true;
    }
  }

  List<VehicleModel> get _filtered =>
      MockData.vehicles.where(_matches).toList();

  void _openDetail(VehicleModel v) => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: v)),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showList ? _buildListView() : _buildMapView(),
    );
  }

  // ── Map View ────────────────────────────────────────────
  Widget _buildMapView() {
    final vehicles = MockData.vehicles;
    final markers = <Marker>[];

    for (var i = 0; i < vehicles.length && i < _pinCoords.length; i++) {
      final v = vehicles[i];
      if (!_matches(v)) continue;
      final isSelected = _selectedVehicle?.id == v.id;
      markers.add(Marker(
        point: _pinCoords[i],
        width: 72,
        height: 34,
        child: GestureDetector(
          onTap: () => setState(() => _selectedVehicle = v),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected ? MovanaColors.primary : Colors.white,
              borderRadius: BorderRadius.circular(Radii.pill),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: isSelected ? 12 : 6,
                  offset: const Offset(0, 3),
                ),
              ],
              border: Border.all(
                color: isSelected ? MovanaColors.primary : MovanaColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Text(
              '₱${v.pricePerDay.toStringAsFixed(0)}',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : MovanaColors.primary,
              ),
            ),
          ),
        ),
      ));
    }

    return Stack(
      children: [
        // ── Real Map ──────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: _cebu,
            initialZoom: 14.5,
            onTap: (_, __) => setState(() => _selectedVehicle = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.movana.app',
            ),
            MarkerLayer(markers: markers),
          ],
        ),

        // ── Top overlay: search + filters ────────────────
        SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Spacing.page, Spacing.md, Spacing.page, 0),
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
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Radii.lg),
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
                                  color: MovanaColors.inkLight, size: 18),
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
                    GestureDetector(
                      onTap: () => _mapController.move(_cebu, 14.5),
                      child: Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Radii.md),
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
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.sm),
              SizedBox(
                height: 34,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: Spacing.page),
                  itemCount: _filters.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(width: Spacing.sm),
                  itemBuilder: (_, i) {
                    final f = _filters[i];
                    final sel = f == _selectedFilter;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedFilter = f),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: sel ? MovanaColors.primary : Colors.white,
                          borderRadius: BorderRadius.circular(Radii.pill),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 6),
                          ],
                        ),
                        child: Text(f,
                            style: MovanaTextStyles.labelSM.copyWith(
                              color: sel
                                  ? Colors.white
                                  : MovanaColors.inkMedium,
                            )),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        // ── Selected vehicle card ─────────────────────────
        if (_selectedVehicle != null)
          Positioned(
            bottom: 80,
            left: Spacing.page,
            right: Spacing.page,
            child: _MapVehicleCard(
              vehicle: _selectedVehicle!,
              onClose: () => setState(() => _selectedVehicle = null),
              onView: () => _openDetail(_selectedVehicle!),
            ),
          ),

        // ── List toggle pill ──────────────────────────────
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() => _showList = true),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                decoration: BoxDecoration(
                  color: MovanaColors.ink,
                  borderRadius: BorderRadius.circular(Radii.pill),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 12,
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
                    Text('List View',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        )),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── List View ───────────────────────────────────────────
  Widget _buildListView() {
    final items = _filtered;
    return SafeArea(
      child: Column(
        children: [
          // Header row
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.page, Spacing.md, Spacing.page, 0),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Nearby Listings',
                    style: TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: MovanaColors.ink,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => _showList = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: MovanaColors.primary,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.map_outlined,
                            color: Colors.white, size: 16),
                        SizedBox(width: 6),
                        Text('Map View',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Filter chips
          const SizedBox(height: Spacing.sm),
          SizedBox(
            height: 34,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: Spacing.page),
              itemCount: _filters.length,
              separatorBuilder: (_, __) => const SizedBox(width: Spacing.sm),
              itemBuilder: (_, i) {
                final f = _filters[i];
                final sel = f == _selectedFilter;
                return GestureDetector(
                  onTap: () => setState(() => _selectedFilter = f),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 7),
                    decoration: BoxDecoration(
                      color:
                          sel ? MovanaColors.primary : MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.pill),
                      border: Border.all(
                        color: sel
                            ? MovanaColors.primary
                            : MovanaColors.border,
                      ),
                    ),
                    child: Text(f,
                        style: MovanaTextStyles.labelSM.copyWith(
                          color: sel
                              ? Colors.white
                              : MovanaColors.inkMedium,
                        )),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Spacing.md),
          // Count
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${items.length} vehicle${items.length != 1 ? 's' : ''} found',
                style: MovanaTextStyles.bodySM
                    .copyWith(color: MovanaColors.inkLight),
              ),
            ),
          ),
          const SizedBox(height: Spacing.sm),
          // List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.page, vertical: 4),
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: Spacing.md),
              itemBuilder: (_, i) => VehicleCard(
                vehicle: items[i],
                onTap: () => _openDetail(items[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Selected Vehicle Card on Map ───────────────────────────
class _MapVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onClose;
  final VoidCallback onView;

  const _MapVehicleCard({
    required this.vehicle,
    required this.onClose,
    required this.onView,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Radii.xl),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.all(Spacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(Radii.md),
            child: Image.network(
              vehicle.imageUrls.first,
              width: 80,
              height: 72,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 80,
                height: 72,
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
                  Text('${vehicle.distanceKm} km away',
                      style: MovanaTextStyles.bodySM),
                ]),
                const SizedBox(height: 4),
                StarRating(
                    rating: vehicle.rating,
                    reviewCount: vehicle.reviewCount),
                const SizedBox(height: 4),
                Row(children: [
                  Text(
                    '₱${vehicle.pricePerDay.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontFamily: 'Syne',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: MovanaColors.primary,
                    ),
                  ),
                  Text('/day', style: MovanaTextStyles.bodySM),
                ]),
              ],
            ),
          ),
          Column(
            children: [
              GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close,
                    size: 18, color: MovanaColors.inkLight),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onView,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: MovanaColors.primary,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: const Text('View',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      )),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
