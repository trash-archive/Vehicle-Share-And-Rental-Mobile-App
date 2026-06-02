import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../listing/vehicle_detail_screen.dart';

// ─────────────────────────────────────────────────────────────
// SearchScreen — Map view by default, List toggle pill at bottom
// Filters and search query are shared between both views.
// ─────────────────────────────────────────────────────────────
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

  // true = map view (default), false = list view
  bool _mapMode = true;

  final _sortOptions = ['Nearest', 'Price: Low', 'Price: High', 'Rating'];

  // Simulated map pin positions
  static const _pins = [
    _MapPin(vehicleIndex: 0, x: 0.25, y: 0.35),
    _MapPin(vehicleIndex: 1, x: 0.55, y: 0.45),
    _MapPin(vehicleIndex: 2, x: 0.70, y: 0.30),
    _MapPin(vehicleIndex: 3, x: 0.40, y: 0.60),
    _MapPin(vehicleIndex: 4, x: 0.80, y: 0.65),
    _MapPin(vehicleIndex: 5, x: 0.15, y: 0.70),
  ];

  VehicleModel? _selectedMapVehicle;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery ?? '';
    _searchCtrl = TextEditingController(text: _query);
    _tabCtrl = TabController(length: 5, vsync: this);
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

  /// Dynamic title based on active query / filter.
  String get _dynamicTitle {
    if (_query.isNotEmpty) return 'Results for "$_query"';
    if (widget.initialFilter != null) {
      const icons = {
        'Motorcycle': '🏍️',
        'Sedan': '🚗',
        'Van': '🚐',
        'E-bike': '⚡',
        'Excavator': '🏗️',
        'Tractor': '🚜',
      };
      final icon = icons[widget.initialFilter] ?? '🔍';
      return '$icon ${widget.initialFilter}s';
    }
    return 'Discover';
  }

  /// Shared filtered + sorted results used by both map and list.
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
      results =
          results.where((v) => v.category == _selectedCategory).toList();
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

  /// Whether a vehicle should show as a pin given current filters.
  bool _vehicleMatchesFilters(VehicleModel v) => _results.contains(v);

  // ── Shared header (search bar + filters + category tabs) ────
  Widget _buildHeader() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
              Spacing.page, Spacing.lg, Spacing.page, Spacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  _dynamicTitle,
                  key: ValueKey(_dynamicTitle),
                  style: _mapMode
                      ? MovanaTextStyles.displayMD.copyWith(
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              color: Colors.black26,
                              blurRadius: 4,
                            ),
                          ],
                        )
                      : MovanaTextStyles.displayMD,
                ),
              ),
              const SizedBox(height: Spacing.md),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchCtrl,
                      onChanged: (v) => setState(() {
                        _query = v;
                        _selectedMapVehicle = null;
                      }),
                      decoration: InputDecoration(
                        hintText: 'Search vehicles, equipment...',
                        filled: true,
                        fillColor: MovanaColors.white,
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
                    onTap: () =>
                        setState(() => _showFilters = !_showFilters),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _showFilters
                            ? MovanaColors.primary
                            : MovanaColors.white,
                        borderRadius: BorderRadius.circular(Radii.md),
                        border: Border.all(
                          color: _showFilters
                              ? MovanaColors.primary
                              : MovanaColors.border,
                        ),
                        boxShadow: _mapMode
                            ? [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
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
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: _showFilters
              ? _FiltersPanel(
                  priceRange: _priceRange,
                  sortBy: _sortBy,
                  sortOptions: _sortOptions,
                  verifiedOnly: _verifiedOnly,
                  isOverMap: _mapMode,
                  onPriceChanged: (r) => setState(() => _priceRange = r),
                  onSortChanged: (s) => setState(() => _sortBy = s),
                  onVerifiedChanged: (b) =>
                      setState(() => _verifiedOnly = b),
                )
              : const SizedBox.shrink(),
        ),
        _CategoryTabBar(
          isOverMap: _mapMode,
          onCategoryChanged: (c) => setState(() {
            _selectedCategory = c;
            _selectedMapVehicle = null;
          }),
        ),
        if (!_mapMode) const Divider(height: 1),
      ],
    );
  }

  // ── Map view ────────────────────────────────────────────────
  Widget _buildMapView() {
    final results = _results;
    return Stack(
      children: [
        // Map background fills the whole screen
        Positioned.fill(
          child: _MockMapView(
            pins: _pins,
            vehicles: MockData.vehicles,
            selectedVehicle: _selectedMapVehicle,
            filterFn: _vehicleMatchesFilters,
            onPinTap: (v) =>
                setState(() => _selectedMapVehicle = v),
          ),
        ),

        // Header overlaid on top of the map
        SafeArea(
          child: Column(
            children: [
              _buildHeader(),
            ],
          ),
        ),

        // Results count chip
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: Spacing.page, top: 180),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: MovanaColors.ink.withOpacity(0.72),
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
                child: Text(
                  '${results.length} vehicle${results.length != 1 ? 's' : ''} nearby',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Selected vehicle card
        if (_selectedMapVehicle != null)
          Positioned(
            bottom: 90,
            left: Spacing.page,
            right: Spacing.page,
            child: _MapVehicleCard(
              vehicle: _selectedMapVehicle!,
              onClose: () =>
                  setState(() => _selectedMapVehicle = null),
              onView: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => VehicleDetailScreen(
                      vehicle: _selectedMapVehicle!),
                ),
              ),
            ),
          ),

        // List toggle pill
        Positioned(
          bottom: 24,
          left: 0,
          right: 0,
          child: Center(
            child: GestureDetector(
              onTap: () => setState(() {
                _mapMode = false;
                _selectedMapVehicle = null;
              }),
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
    );
  }

  // ── List view ────────────────────────────────────────────────
  Widget _buildListView() {
    final results = _results;
    return SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: results.isEmpty
                ? const EmptyState(
                    emoji: '🔍',
                    title: 'No results found',
                    subtitle:
                        'Try adjusting your search or filters.',
                  )
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(
                            Spacing.page, Spacing.md, Spacing.page, 0),
                        child: Row(
                          children: [
                            Text(
                              '${results.length} result${results.length != 1 ? 's' : ''}',
                              style: MovanaTextStyles.labelMD
                                  .copyWith(color: MovanaColors.inkLight),
                            ),
                            const Spacer(),
                            Text('Sorted by $_sortBy',
                                style: MovanaTextStyles.bodySM),
                          ],
                        ),
                      ),
                      Expanded(
                        child: RefreshIndicator(
                          color: MovanaColors.primary,
                          onRefresh: () async => await Future.delayed(
                              const Duration(milliseconds: 800)),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(Spacing.page),
                            itemCount: results.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: Spacing.lg),
                            itemBuilder: (ctx, i) => VehicleCard(
                              vehicle: results[i],
                              onTap: () => Navigator.of(ctx).push(
                                MaterialPageRoute(
                                  builder: (_) => VehicleDetailScreen(
                                      vehicle: results[i]),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
          // Map toggle pill at the bottom of list view
          Container(
            padding: EdgeInsets.fromLTRB(
              Spacing.page,
              Spacing.md,
              Spacing.page,
              Spacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: MovanaColors.white,
              border: Border(top: BorderSide(color: MovanaColors.border)),
            ),
            child: Center(
              child: GestureDetector(
                onTap: () => setState(() => _mapMode = true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: MovanaColors.primary,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.map_outlined,
                          color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Map View',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: _mapMode ? _buildMapView() : _buildListView(),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Category tab bar (transparent when over map)
// ─────────────────────────────────────────────────────────────
class _CategoryTabBar extends StatefulWidget {
  final ValueChanged<VehicleCategory?> onCategoryChanged;
  final bool isOverMap;
  const _CategoryTabBar(
      {required this.onCategoryChanged, this.isOverMap = false});

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
                    : widget.isOverMap
                        ? Colors.white.withOpacity(0.9)
                        : Colors.transparent,
                borderRadius: BorderRadius.circular(Radii.pill),
                border: Border.all(
                  color: selected
                      ? MovanaColors.primary
                      : widget.isOverMap
                          ? Colors.transparent
                          : MovanaColors.border,
                ),
                boxShadow: widget.isOverMap && !selected
                    ? [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        )
                      ]
                    : null,
              ),
              child: Center(
                child: Text(
                  label,
                  style: MovanaTextStyles.labelSM.copyWith(
                    color: selected
                        ? Colors.white
                        : widget.isOverMap
                            ? MovanaColors.ink
                            : MovanaColors.inkMedium,
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

// ─────────────────────────────────────────────────────────────
// Filters panel (semi-transparent when over map)
// ─────────────────────────────────────────────────────────────
class _FiltersPanel extends StatelessWidget {
  final RangeValues priceRange;
  final String sortBy;
  final List<String> sortOptions;
  final bool verifiedOnly;
  final bool isOverMap;
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
    this.isOverMap = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: isOverMap
          ? const EdgeInsets.symmetric(horizontal: Spacing.page)
          : EdgeInsets.zero,
      padding: const EdgeInsets.fromLTRB(
          Spacing.page, 0, Spacing.page, Spacing.lg),
      decoration: isOverMap
          ? BoxDecoration(
              color: MovanaColors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(Radii.lg),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Divider(),
          const SizedBox(height: Spacing.md),
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
                            borderRadius: BorderRadius.circular(Radii.pill),
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

// ─────────────────────────────────────────────────────────────
// Mock map view (visual placeholder for Google Maps)
// ─────────────────────────────────────────────────────────────
class _MockMapView extends StatelessWidget {
  final List<_MapPin> pins;
  final List<VehicleModel> vehicles;
  final VehicleModel? selectedVehicle;
  final bool Function(VehicleModel) filterFn;
  final ValueChanged<VehicleModel> onPinTap;

  const _MockMapView({
    required this.pins,
    required this.vehicles,
    required this.selectedVehicle,
    required this.filterFn,
    required this.onPinTap,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox.expand(
      child: Stack(
        children: [
          // Map background
          CustomPaint(
            size: Size(size.width, size.height),
            painter: _MapPainter(),
          ),
          // Placeholder label
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.map_outlined, size: 16, color: MovanaColors.primary),
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
          // Price pins — filtered
          ...pins.map((pin) {
            if (pin.vehicleIndex >= vehicles.length) return const SizedBox.shrink();
            final v = vehicles[pin.vehicleIndex];
            if (!filterFn(v)) return const SizedBox.shrink();
            final isSelected = selectedVehicle?.id == v.id;
            return Positioned(
              left: size.width * pin.x - 36,
              top: size.height * pin.y - 20,
              child: GestureDetector(
                onTap: () => onPinTap(v),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? MovanaColors.primary : MovanaColors.white,
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
                      color: isSelected ? Colors.white : MovanaColors.primary,
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

// ─────────────────────────────────────────────────────────────
// Map grid painter (same aesthetic as MapExploreScreen)
// ─────────────────────────────────────────────────────────────
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Paint()..color = const Color(0xFFE8EAD3),
    );
    final roadPaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 8;
    final minorPaint = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 3;
    for (var i = 0; i < 6; i++) {
      final y = size.height * (0.15 + i * 0.15);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), roadPaint);
    }
    for (var i = 0; i < 5; i++) {
      final x = size.width * (0.1 + i * 0.2);
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), roadPaint);
    }
    for (var i = 0; i < 12; i++) {
      final y = size.height * (0.08 + i * 0.08);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), minorPaint);
    }
    final blockPaint = Paint()..color = const Color(0xFFDDE0C8);
    final rects = [
      Rect.fromLTWH(size.width * 0.1, size.height * 0.15,
          size.width * 0.15, size.height * 0.12),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.30,
          size.width * 0.18, size.height * 0.10),
      Rect.fromLTWH(size.width * 0.60, size.height * 0.20,
          size.width * 0.20, size.height * 0.08),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.55,
          size.width * 0.22, size.height * 0.12),
    ];
    for (final r in rects) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(r, const Radius.circular(4)), blockPaint);
    }
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.40, size.height * 0.55,
            size.width * 0.25, size.height * 0.15),
        const Radius.circular(6),
      ),
      Paint()..color = const Color(0xFFC8DDB8),
    );
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─────────────────────────────────────────────────────────────
// Selected vehicle mini-card on map
// ─────────────────────────────────────────────────────────────
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
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Container(
            width: 36, height: 4,
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
                    width: 90, height: 80, fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 90, height: 80, color: MovanaColors.surface,
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
                            fontSize: 18,
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
                          size: 20, color: MovanaColors.inkLight),
                    ),
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: onView,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: MovanaColors.primary,
                          borderRadius: BorderRadius.circular(Radii.pill),
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

// ─────────────────────────────────────────────────────────────
// Map pin data
// ─────────────────────────────────────────────────────────────
class _MapPin {
  final int vehicleIndex;
  final double x;
  final double y;
  const _MapPin({required this.vehicleIndex, required this.x, required this.y});
}
