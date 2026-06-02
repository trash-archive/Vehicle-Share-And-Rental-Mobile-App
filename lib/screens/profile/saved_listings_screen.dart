import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../listing/vehicle_detail_screen.dart';

class SavedListingsScreen extends StatefulWidget {
  const SavedListingsScreen({super.key});

  @override
  State<SavedListingsScreen> createState() => _SavedListingsScreenState();
}

class _SavedListingsScreenState extends State<SavedListingsScreen> {
  late List<VehicleModel> _saved;
  String _sortBy = 'Recently Saved';

  static const _sortOptions = [
    'Recently Saved',
    'Price: Low',
    'Price: High',
    'Rating',
  ];

  @override
  void initState() {
    super.initState();
    _saved = List.of(MockData.savedVehicles);
  }

  List<VehicleModel> get _sorted {
    final list = List.of(_saved);
    switch (_sortBy) {
      case 'Price: Low':
        list.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
      case 'Price: High':
        list.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
      case 'Rating':
        list.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return list;
  }

  void _remove(VehicleModel vehicle) {
    setState(() => _saved.removeWhere((v) => v.id == vehicle.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${vehicle.name} removed from saved listings.'),
        action: SnackBarAction(
          label: 'Undo',
          textColor: MovanaColors.primaryLight,
          onPressed: () => setState(() => _saved.add(vehicle)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sorted = _sorted;
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Saved Listings', style: MovanaTextStyles.headingSM),
            Text(
              '${_saved.length} vehicle${_saved.length != 1 ? 's' : ''}',
              style: MovanaTextStyles.bodySM
                  .copyWith(color: MovanaColors.primary),
            ),
          ],
        ),
        leading: const BackButton(),
        actions: [
          if (_saved.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: Spacing.md),
              child: _SortButton(
                current: _sortBy,
                options: _sortOptions,
                onSelected: (s) => setState(() => _sortBy = s),
              ),
            ),
        ],
      ),
      body: _saved.isEmpty
          ? const EmptyState(
              emoji: '❤️',
              title: 'No saved listings',
              subtitle:
                  'Tap the heart icon on any listing to save it here for later.',
            )
          : ListView.separated(
              padding: const EdgeInsets.all(Spacing.page),
              itemCount: sorted.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: Spacing.lg),
              itemBuilder: (_, i) => _SavedVehicleCard(
                vehicle: sorted[i],
                onRemove: () => _remove(sorted[i]),
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        VehicleDetailScreen(vehicle: sorted[i]),
                  ),
                ),
              ),
            ),
    );
  }
}

// ──────────────────────────────────────────────
// Saved Vehicle Card
// ──────────────────────────────────────────────
class _SavedVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onRemove;
  final VoidCallback onTap;

  const _SavedVehicleCard({
    required this.vehicle,
    required this.onRemove,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(vehicle.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.xl),
        decoration: BoxDecoration(
          color: MovanaColors.error.withOpacity(0.1),
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: MovanaColors.error.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.favorite_border_rounded,
                color: MovanaColors.error, size: 24),
            const SizedBox(height: 4),
            Text(
              'Remove',
              style: MovanaTextStyles.labelSM
                  .copyWith(color: MovanaColors.error),
            ),
          ],
        ),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: MovanaColors.white,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: MovanaColors.border),
            boxShadow: [
              BoxShadow(
                color: MovanaColors.ink.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // ── Thumbnail ──────────────────────────
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                    left: Radius.circular(Radii.lg)),
                child: Image.network(
                  vehicle.imageUrls.first,
                  width: 110,
                  height: 110,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 110,
                    height: 110,
                    color: MovanaColors.surface,
                    child: const Icon(Icons.directions_car,
                        color: MovanaColors.border, size: 32),
                  ),
                ),
              ),

              // ── Info ───────────────────────────────
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              vehicle.name,
                              style: MovanaTextStyles.labelLG,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          // Remove heart button
                          GestureDetector(
                            onTap: onRemove,
                            child: const Icon(
                              Icons.favorite_rounded,
                              color: MovanaColors.error,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 12, color: MovanaColors.inkLight),
                          const SizedBox(width: 2),
                          Expanded(
                            child: Text(
                              vehicle.location,
                              style: MovanaTextStyles.bodySM,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      StarRating(
                          rating: vehicle.rating,
                          reviewCount: vehicle.reviewCount),
                      const SizedBox(height: Spacing.sm),
                      Row(
                        children: [
                          Text(
                            '₱${vehicle.pricePerDay.toStringAsFixed(0)}',
                            style: MovanaTextStyles.labelLG.copyWith(
                              color: MovanaColors.primary,
                              fontFamily: 'Syne',
                              fontSize: 16,
                            ),
                          ),
                          Text('/day',
                              style: MovanaTextStyles.bodySM),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: vehicle.isAvailable
                                  ? MovanaColors.success.withOpacity(0.1)
                                  : MovanaColors.error.withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(Radii.pill),
                            ),
                            child: Text(
                              vehicle.isAvailable
                                  ? 'Available'
                                  : 'Unavailable',
                              style: MovanaTextStyles.bodySM.copyWith(
                                color: vehicle.isAvailable
                                    ? MovanaColors.success
                                    : MovanaColors.error,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Sort Button
// ──────────────────────────────────────────────
class _SortButton extends StatelessWidget {
  final String current;
  final List<String> options;
  final ValueChanged<String> onSelected;

  const _SortButton({
    required this.current,
    required this.options,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selected = await showModalBottomSheet<String>(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (_) => _SortSheet(current: current, options: options),
        );
        if (selected != null) onSelected(selected);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md, vertical: Spacing.sm),
        decoration: BoxDecoration(
          color: MovanaColors.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(color: MovanaColors.border),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sort_rounded,
                size: 16, color: MovanaColors.inkMedium),
            const SizedBox(width: 4),
            Text('Sort', style: MovanaTextStyles.labelSM),
          ],
        ),
      ),
    );
  }
}

class _SortSheet extends StatelessWidget {
  final String current;
  final List<String> options;

  const _SortSheet({required this.current, required this.options});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        Spacing.page,
        Spacing.page,
        Spacing.page,
        Spacing.page + MediaQuery.of(context).padding.bottom,
      ),
      decoration: const BoxDecoration(
        color: MovanaColors.white,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Radii.xxl)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: MovanaColors.border,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const Text('Sort by', style: MovanaTextStyles.headingSM),
          const SizedBox(height: Spacing.lg),
          ...options.map((o) {
            final selected = o == current;
            return GestureDetector(
              onTap: () => Navigator.pop(context, o),
              child: Container(
                margin: const EdgeInsets.only(bottom: Spacing.sm),
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg, vertical: Spacing.md),
                decoration: BoxDecoration(
                  color: selected
                      ? MovanaColors.primarySurface
                      : MovanaColors.surface,
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: Border.all(
                    color: selected
                        ? MovanaColors.primary
                        : MovanaColors.border,
                    width: selected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        o,
                        style: MovanaTextStyles.labelMD.copyWith(
                          color: selected
                              ? MovanaColors.primary
                              : MovanaColors.ink,
                        ),
                      ),
                    ),
                    if (selected)
                      const Icon(Icons.check_rounded,
                          size: 18, color: MovanaColors.primary),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
