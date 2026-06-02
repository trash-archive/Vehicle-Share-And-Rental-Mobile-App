import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import 'vehicle_detail_screen.dart';

class OwnerProfileScreen extends StatefulWidget {
  final String ownerId;
  final String ownerName;
  final String ownerAvatar;
  final double ownerRating;
  final bool ownerVerified;

  const OwnerProfileScreen({
    super.key,
    required this.ownerId,
    required this.ownerName,
    required this.ownerAvatar,
    required this.ownerRating,
    required this.ownerVerified,
  });

  @override
  State<OwnerProfileScreen> createState() => _OwnerProfileScreenState();
}

class _OwnerProfileScreenState extends State<OwnerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // Owner's listings — vehicles whose ownerId matches
  List<VehicleModel> get _listings => MockData.vehicles
      .where((v) => v.ownerId == widget.ownerId)
      .toList();

  // Total review count across all listings
  int get _totalRentals => _listings.fold(0, (s, v) => s + v.reviewCount);

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: NestedScrollView(
        headerSliverBuilder: (_, __) => [
          SliverToBoxAdapter(child: _Header(widget: widget, listings: _listings, totalRentals: _totalRentals)),
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              TabBar(
                controller: _tabCtrl,
                labelColor: MovanaColors.primary,
                unselectedLabelColor: MovanaColors.inkLight,
                indicatorColor: MovanaColors.primary,
                indicatorWeight: 2,
                labelStyle: MovanaTextStyles.labelMD,
                tabs: const [
                  Tab(text: 'Listings'),
                  Tab(text: 'Reviews'),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabCtrl,
          children: [
            _ListingsTab(listings: _listings),
            _ReviewsTab(),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Header
// ──────────────────────────────────────────────
class _Header extends StatelessWidget {
  final OwnerProfileScreen widget;
  final List<VehicleModel> listings;
  final int totalRentals;

  const _Header({
    required this.widget,
    required this.listings,
    required this.totalRentals,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [MovanaColors.primaryDark, MovanaColors.primary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(Spacing.page),
          child: Column(
            children: [
              // Back button row
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.more_horiz,
                        color: Colors.white, size: 20),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xl),

              // Avatar
              Stack(
                children: [
                  CircleAvatar(
                    radius: 44,
                    backgroundImage: NetworkImage(widget.ownerAvatar),
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                  if (widget.ownerVerified)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: MovanaColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.verified,
                            size: 16, color: MovanaColors.primary),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: Spacing.md),

              // Name + verified
              Text(
                widget.ownerName,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
                child: Text(
                  widget.ownerVerified
                      ? '✅ Verified Owner'
                      : '⏳ Unverified',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),

              // Stats row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _StatItem(
                      '${widget.ownerRating}★', 'Rating'),
                  _Divider(),
                  _StatItem('${listings.length}', 'Listings'),
                  _Divider(),
                  _StatItem('$totalRentals', 'Rentals'),
                ],
              ),
              const SizedBox(height: Spacing.xl),

              // Contact buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.chat_bubble_outline,
                          size: 16),
                      label: const Text('Message'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.white,
                        side: BorderSide(
                            color: Colors.white.withOpacity(0.6)),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Radii.md)),
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.phone_outlined, size: 16),
                      label: const Text('Call'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: MovanaColors.primary,
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(Radii.md)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.md),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Listings Tab
// ──────────────────────────────────────────────
class _ListingsTab extends StatelessWidget {
  final List<VehicleModel> listings;
  const _ListingsTab({required this.listings});

  @override
  Widget build(BuildContext context) {
    if (listings.isEmpty) {
      return const EmptyState(
        emoji: '🚗',
        title: 'No listings yet',
        subtitle: 'This owner has no active vehicles listed.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.page),
      itemCount: listings.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.lg),
      itemBuilder: (_, i) => VehicleCard(
        vehicle: listings[i],
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => VehicleDetailScreen(vehicle: listings[i]),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Reviews Tab
// ──────────────────────────────────────────────
class _ReviewsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final reviews = MockData.sampleReviews;
    // Rating breakdown counts
    final counts = List.generate(
        5,
        (i) => reviews
            .where((r) => r.rating.round() == 5 - i)
            .length);
    final avg = reviews.isEmpty
        ? 0.0
        : reviews.map((r) => r.rating).reduce((a, b) => a + b) /
            reviews.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Rating summary card
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(color: MovanaColors.border),
            ),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      avg.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: MovanaColors.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: List.generate(
                          5,
                          (i) => Icon(
                                i < avg.round()
                                    ? Icons.star_rounded
                                    : Icons.star_border_rounded,
                                size: 16,
                                color: MovanaColors.warning,
                              )),
                    ),
                    const SizedBox(height: 4),
                    Text('${reviews.length} reviews',
                        style: MovanaTextStyles.bodySM),
                  ],
                ),
                const SizedBox(width: Spacing.xl),
                Expanded(
                  child: Column(
                    children: List.generate(5, (i) {
                      final star = 5 - i;
                      final count = counts[i];
                      final pct = reviews.isEmpty
                          ? 0.0
                          : count / reviews.length;
                      return Padding(
                        padding: const EdgeInsets.only(
                            bottom: Spacing.xs),
                        child: Row(
                          children: [
                            Text('$star',
                                style: MovanaTextStyles.bodySM),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                size: 11,
                                color: MovanaColors.warning),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                    Radii.pill),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 6,
                                  backgroundColor: MovanaColors.border,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          MovanaColors.warning),
                                ),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            SizedBox(
                              width: 20,
                              child: Text('$count',
                                  style: MovanaTextStyles.bodySM),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxl),
          const Text('Recent Reviews',
              style: MovanaTextStyles.headingSM),
          const SizedBox(height: Spacing.md),
          ...reviews.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.md),
                child: Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    color: MovanaColors.surface,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    border: Border.all(color: MovanaColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundImage:
                                NetworkImage(r.reviewerAvatar),
                            backgroundColor: MovanaColors.border,
                          ),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(r.reviewerName,
                                    style: MovanaTextStyles.labelMD),
                                Text(
                                  '${r.createdAt.day}/${r.createdAt.month}/${r.createdAt.year}',
                                  style: MovanaTextStyles.bodySM,
                                ),
                              ],
                            ),
                          ),
                          StarRating(
                              rating: r.rating, showCount: false),
                        ],
                      ),
                      const SizedBox(height: Spacing.sm),
                      Text(r.comment,
                          style: MovanaTextStyles.bodyMD),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Pinned TabBar delegate
// ──────────────────────────────────────────────
class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  const _TabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height + 1;
  @override
  double get maxExtent => tabBar.preferredSize.height + 1;

  @override
  Widget build(_, __, ___) => Container(
        color: MovanaColors.white,
        child: Column(
          children: [tabBar, const Divider(height: 1)],
        ),
      );

  @override
  bool shouldRebuild(_) => false;
}

// ── Helpers ──────────────────────────────────────
class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      );
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 32,
        color: Colors.white.withOpacity(0.3),
      );
}
