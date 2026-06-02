import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../listing/vehicle_detail_screen.dart';
import '../notifications_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedFilter = 'All';
  final _filters = ['All', 'Motorcycle', 'Car', 'Van', 'E-bike', 'Equipment'];

  List<VehicleModel> get _filteredVehicles {
    if (_selectedFilter == 'All') return MockData.vehicles;
    return MockData.vehicles.where((v) {
      switch (_selectedFilter) {
        case 'Motorcycle':
          return v.category == VehicleCategory.personal &&
              (v.type == 'Scooter' || v.type == 'Motorcycle');
        case 'Car':
          return v.type == 'Sedan' || v.type == 'SUV' || v.type == 'Pickup';
        case 'Van':
          return v.category == VehicleCategory.commercial;
        case 'E-bike':
          return v.type == 'E-bike';
        case 'Equipment':
          return v.category == VehicleCategory.construction ||
              v.category == VehicleCategory.agricultural;
        default:
          return true;
      }
    }).toList();
  }

  void _openDetail(VehicleModel v) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => VehicleDetailScreen(vehicle: v)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredVehicles;
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: SafeArea(
        child: ListView(
          children: [
            // ── App Bar ──────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.page, vertical: Spacing.md),
              child: Row(
                children: [
                  const MovanaLogo(),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const NotificationsScreen()),
                    ),
                    child: Stack(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: MovanaColors.surface,
                            borderRadius: BorderRadius.circular(Radii.md),
                            border: Border.all(color: MovanaColors.border),
                          ),
                          child: const Icon(Icons.notifications_outlined,
                              size: 20, color: MovanaColors.inkMedium),
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: MovanaColors.accent,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Hero Banner ───────────────────────────────
            _HeroBanner(),
            const SizedBox(height: Spacing.xxl),

            // ── Categories ────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Spacing.page),
              child: const SectionHeader(title: 'Browse by Category'),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                itemCount: MockData.categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: Spacing.md),
                itemBuilder: (_, i) {
                  final cat = MockData.categories[i];
                  return _CategoryTile(
                    label: cat['label'] as String,
                    emoji: cat['icon'] as String,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => SearchScreen(
                          initialFilter: cat['filter'] as String,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // ── Near You ──────────────────────────────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Spacing.page),
              child: SectionHeader(
                title: 'Near You',
                actionLabel: 'See all',
                onAction: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SearchScreen()),
                ),
              ),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 270,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                itemCount: MockData.nearbyVehicles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: Spacing.md),
                itemBuilder: (_, i) {
                  final v = MockData.nearbyVehicles[i];
                  return VehicleCardCompact(
                    vehicle: v,
                    onTap: () => _openDetail(v),
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // ── Stats Banner ──────────────────────────────
            _StatsBanner(),
            const SizedBox(height: Spacing.xxl),

            // ── All Listings header + filter chips ────────
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: Spacing.page),
              child: const SectionHeader(title: 'All Listings'),
            ),
            const SizedBox(height: Spacing.md),
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
                itemCount: _filters.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: Spacing.sm),
                itemBuilder: (_, i) {
                  final f = _filters[i];
                  final selected = f == _selectedFilter;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedFilter = f),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 180),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: selected
                            ? MovanaColors.primary
                            : MovanaColors.surface,
                        borderRadius: BorderRadius.circular(Radii.pill),
                        border: Border.all(
                          color: selected
                              ? MovanaColors.primary
                              : MovanaColors.border,
                        ),
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
            const SizedBox(height: Spacing.lg),

            // ── Vehicle List ──────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
              child: Column(
                children: filtered
                    .map((v) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: Spacing.lg),
                          child: VehicleCard(
                            vehicle: v,
                            onTap: () => _openDetail(v),
                          ),
                        ))
                    .toList(),
              ),
            ),

            const SizedBox(height: Spacing.xxxl),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Hero Banner
// ──────────────────────────────────────────────
class _HeroBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.page),
      padding: const EdgeInsets.all(Spacing.xxl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MovanaColors.primaryDark, MovanaColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
            child: const Text(
              '📍 Cebu City',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),
          const Text(
            'Find your perfect\nride nearby',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: Spacing.md),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg, vertical: Spacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Radii.md),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search,
                      color: MovanaColors.inkLight, size: 20),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'Search vehicles & equipment...',
                    style: MovanaTextStyles.bodyMD
                        .copyWith(color: MovanaColors.inkLight),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: MovanaColors.primary,
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: const Icon(Icons.tune,
                        color: Colors.white, size: 16),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Category Tile
// ──────────────────────────────────────────────
class _CategoryTile extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;

  const _CategoryTile(
      {required this.label, required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: MovanaColors.primarySurface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(
                  color: MovanaColors.primary.withOpacity(0.15)),
            ),
            child: Center(
              child: Text(emoji,
                  style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: MovanaTextStyles.bodySM.copyWith(
              color: MovanaColors.inkMedium,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Stats Banner
// ──────────────────────────────────────────────
class _StatsBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: Spacing.page),
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        color: MovanaColors.accentSurface,
        borderRadius: BorderRadius.circular(Radii.xl),
        border:
            Border.all(color: MovanaColors.accent.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _StatItem('500+', 'Listings'),
          _divider(),
          _StatItem('1.2K+', 'Renters'),
          _divider(),
          _StatItem('4.8★', 'Avg Rating'),
        ],
      ),
    );
  }

  Widget _divider() => Container(
        width: 1,
        height: 36,
        color: MovanaColors.accent.withOpacity(0.3),
      );
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: MovanaColors.accent,
            ),
          ),
          Text(label, style: MovanaTextStyles.bodySM),
        ],
      ),
    );
  }
}
