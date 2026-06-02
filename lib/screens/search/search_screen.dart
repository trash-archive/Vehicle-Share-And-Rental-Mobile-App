import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../listing/vehicle_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;
  final String? initialFilter;

  const SearchScreen({super.key, this.initialQuery, this.initialFilter});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with SingleTickerProviderStateMixin {
  late TextEditingController _searchCtrl;
  late TabController _tabCtrl;
  late String _query;
  VehicleCategory? _selectedCategory;
  RangeValues _priceRange = const RangeValues(0, 20000);
  String _sortBy = 'Nearest';
  bool _verifiedOnly = false;
  bool _showFilters = false;

  final _sortOptions = ['Nearest', 'Price: Low', 'Price: High', 'Rating'];

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _searchCtrl = TextEditingController(text: _query);
    _tabCtrl = TabController(length: 5, vsync: this);
    // Apply initial category filter if provided
    if (widget.initialFilter != null) {
      _selectedCategory = _filterToCategory(widget.initialFilter!);
    }
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    _tabCtrl.dispose();
    super.dispose();
  }

  VehicleCategory? _filterToCategory(String filter) {
    switch (filter) {
      case 'Motorcycle':
      case 'Car':
      case 'E-bike':
        return VehicleCategory.personal;
      case 'Van':
        return VehicleCategory.commercial;
      case 'Equipment':
        return VehicleCategory.construction;
      default:
        return null;
    }
  }

  List<VehicleModel> get _results {
    var results = MockData.vehicles;
    if (_query.isNotEmpty) {
      results = results
          .where((v) =>
              v.name.toLowerCase().contains(_query.toLowerCase()) ||
              v.location.toLowerCase().contains(_query.toLowerCase()) ||
              v.type.toLowerCase().contains(_query.toLowerCase()))
          .toList();
    }
    if (_selectedCategory != null) {
      results = results.where((v) => v.category == _selectedCategory).toList();
    }
    if (_verifiedOnly) {
      results = results.where((v) => v.isVerified).toList();
    }
    results = results
        .where((v) =>
            v.pricePerDay >= _priceRange.start &&
            v.pricePerDay <= _priceRange.end)
        .toList();
    switch (_sortBy) {
      case 'Nearest':
        results.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
        break;
      case 'Price: Low':
        results.sort((a, b) => a.pricePerDay.compareTo(b.pricePerDay));
        break;
      case 'Price: High':
        results.sort((a, b) => b.pricePerDay.compareTo(a.pricePerDay));
        break;
      case 'Rating':
        results.sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                  Spacing.page, Spacing.lg, Spacing.page, Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Discover', style: MovanaTextStyles.displayMD),
                  const SizedBox(height: Spacing.md),
                  // Search bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          onChanged: (v) => setState(() => _query = v),
                          decoration: InputDecoration(
                            hintText: 'Search vehicles, equipment...',
                            prefixIcon: const Icon(Icons.search,
                                color: MovanaColors.inkLight, size: 20),
                            suffixIcon: _query.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.close, size: 18),
                                    onPressed: () {
                                      _searchCtrl.clear();
                                      setState(() => _query = '');
                                    },
                                  )
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.sm),
                      GestureDetector(
                        onTap: () => setState(() => _showFilters = !_showFilters),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: _showFilters
                                ? MovanaColors.primary
                                : MovanaColors.surface,
                            borderRadius: BorderRadius.circular(Radii.md),
                            border: Border.all(
                              color: _showFilters
                                  ? MovanaColors.primary
                                  : MovanaColors.border,
                            ),
                          ),
                          child: Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: _showFilters
                                ? Colors.white
                                : MovanaColors.inkMedium,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ── Filters Panel ─────────────────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _showFilters ? _FiltersPanel(
                priceRange: _priceRange,
                sortBy: _sortBy,
                sortOptions: _sortOptions,
                verifiedOnly: _verifiedOnly,
                onPriceChanged: (r) => setState(() => _priceRange = r),
                onSortChanged: (s) => setState(() => _sortBy = s),
                onVerifiedChanged: (b) => setState(() => _verifiedOnly = b),
              ) : const SizedBox.shrink(),
            ),

            // ── Category tabs ─────────────────────────
            _CategoryTabBar(
              onCategoryChanged: (c) => setState(() => _selectedCategory = c),
            ),
            const Divider(height: 1),

            // ── Results ───────────────────────────────
            Expanded(
              child: _results.isEmpty
                  ? const EmptyState(
                      emoji: '🔍',
                      title: 'No results found',
                      subtitle:
                          'Try adjusting your search or filters to find more options.',
                    )
                  : Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                              Spacing.page, Spacing.md, Spacing.page, 0),
                          child: Row(
                            children: [
                              Text(
                                '${_results.length} result${_results.length != 1 ? 's' : ''}',
                                style: MovanaTextStyles.labelMD.copyWith(
                                  color: MovanaColors.inkLight,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                'Sorted by $_sortBy',
                                style: MovanaTextStyles.bodySM,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(Spacing.page),
                            itemCount: _results.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: Spacing.lg),
                            itemBuilder: (ctx, i) => VehicleCard(
                              vehicle: _results[i],
                              onTap: () => Navigator.of(ctx).push(
                                MaterialPageRoute(
                                  builder: (_) => VehicleDetailScreen(
                                      vehicle: _results[i]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTabBar extends StatefulWidget {
  final ValueChanged<VehicleCategory?> onCategoryChanged;
  const _CategoryTabBar({required this.onCategoryChanged});

  @override
  State<_CategoryTabBar> createState() => _CategoryTabBarState();
}

class _CategoryTabBarState extends State<_CategoryTabBar> {
  int _selected = 0;

  static const _tabs = [
    ('All', null),
    ('Personal', VehicleCategory.personal),
    ('Commercial', VehicleCategory.commercial),
    ('Construction', VehicleCategory.construction),
    ('Agricultural', VehicleCategory.agricultural),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.page, vertical: 6),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 6),
        itemBuilder: (_, i) {
          final (label, cat) = _tabs[i];
          final selected = i == _selected;
          return GestureDetector(
            onTap: () {
              setState(() => _selected = i);
              widget.onCategoryChanged(cat);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: selected
                    ? MovanaColors.primary
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(
                  color: selected ? MovanaColors.primary : MovanaColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: MovanaTextStyles.labelSM.copyWith(
                    color: selected ? Colors.white : MovanaColors.inkMedium,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _FiltersPanel extends StatelessWidget {
  final RangeValues priceRange;
  final String sortBy;
  final List<String> sortOptions;
  final bool verifiedOnly;
  final ValueChanged<RangeValues> onPriceChanged;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<bool> onVerifiedChanged;

  const _FiltersPanel({
    required this.priceRange,
    required this.sortBy,
    required this.sortOptions,
    required this.verifiedOnly,
    required this.onPriceChanged,
    required this.onSortChanged,
    required this.onVerifiedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
          Spacing.page, 0, Spacing.page, Spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: Spacing.md),
          // Price range
          Row(
            children: [
              Text('Price Range', style: MovanaTextStyles.labelMD),
              const Spacer(),
              Text(
                '₱${priceRange.start.toInt()} – ₱${priceRange.end.toInt()}',
                style: MovanaTextStyles.labelSM
                    .copyWith(color: MovanaColors.primary),
              ),
            ],
          ),
          RangeSlider(
            values: priceRange,
            min: 0,
            max: 20000,
            divisions: 40,
            activeColor: MovanaColors.primary,
            inactiveColor: MovanaColors.border,
            onChanged: onPriceChanged,
          ),
          // Sort
          Row(
            children: [
              Text('Sort By', style: MovanaTextStyles.labelMD),
              const SizedBox(width: Spacing.lg),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: sortOptions.map((s) {
                      final selected = s == sortBy;
                      return GestureDetector(
                        onTap: () => onSortChanged(s),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 180),
                          margin: const EdgeInsets.only(right: 6),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: selected
                                ? MovanaColors.primarySurface
                                : MovanaColors.surface,
                            border: Border.all(
                              color: selected
                                  ? MovanaColors.primary
                                  : MovanaColors.border,
                            ),
                            borderRadius:
                                BorderRadius.circular(Radii.pill),
                          ),
                          child: Text(
                            s,
                            style: MovanaTextStyles.bodySM.copyWith(
                              color: selected
                                  ? MovanaColors.primary
                                  : MovanaColors.inkMedium,
                              fontWeight: selected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.sm),
          // Verified only toggle
          Row(
            children: [
              Text('Verified listings only',
                  style: MovanaTextStyles.labelMD),
              const Spacer(),
              Switch(
                value: verifiedOnly,
                onChanged: onVerifiedChanged,
                activeColor: MovanaColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
