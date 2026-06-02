import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';
import '../booking/booking_form_screen.dart';
import '../messages/messages_screen.dart';
import 'owner_profile_screen.dart';
import 'all_reviews_screen.dart';

class VehicleDetailScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const VehicleDetailScreen({super.key, required this.vehicle});

  @override
  State<VehicleDetailScreen> createState() => _VehicleDetailScreenState();
}

class _VehicleDetailScreenState extends State<VehicleDetailScreen> {
  int _currentImage = 0;
  bool _isFavorited = false;

  VehicleModel get v => widget.vehicle;

  void _openGallery(BuildContext context, int initialIndex) {
    Navigator.of(context).push(
      PageRouteBuilder(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullScreenGallery(
          imageUrls: v.imageUrls,
          initialIndex: initialIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: CustomScrollView(
        slivers: [
          // ── Image Gallery Header ──────────────────────
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: MovanaColors.white,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _isFavorited = !_isFavorited),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        _isFavorited
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        key: ValueKey(_isFavorited),
                        color: _isFavorited
                            ? MovanaColors.error
                            : Colors.white,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child:
                        Icon(Icons.share_outlined, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  PageView.builder(
                    itemCount: v.imageUrls.length,
                    onPageChanged: (i) =>
                        setState(() => _currentImage = i),
                    itemBuilder: (_, i) => GestureDetector(
                      onTap: () => _openGallery(context, i),
                      child: Image.network(
                        v.imageUrls[i],
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: MovanaColors.surface,
                          child: const Icon(Icons.directions_car,
                              size: 64, color: MovanaColors.border),
                        ),
                      ),
                    ),
                  ),
                  // Image dots
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(v.imageUrls.length, (i) {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          width: i == _currentImage ? 20 : 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                i == _currentImage ? 1 : 0.5),
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                        );
                      }),
                    ),
                  ),
                  // Image count badge
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Text(
                        '${_currentImage + 1}/${v.imageUrls.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Content ───────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(v.name, style: MovanaTextStyles.displayMD),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on_outlined,
                                    size: 14, color: MovanaColors.inkLight),
                                const SizedBox(width: 2),
                                Text(
                                  v.location,
                                  style: MovanaTextStyles.bodyMD,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₱${v.pricePerDay.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontFamily: 'Syne',
                                    fontSize: 24,
                                    fontWeight: FontWeight.w800,
                                    color: MovanaColors.primary,
                                  ),
                                ),
                                TextSpan(
                                  text: '/day',
                                  style: MovanaTextStyles.bodySM,
                                ),
                              ],
                            ),
                          ),
                          Text('₱${v.pricePerHour.toStringAsFixed(0)}/hr',
                              style: MovanaTextStyles.bodySM),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  // Badges row
                  Row(
                    children: [
                      StarRating(rating: v.rating, reviewCount: v.reviewCount),
                      const SizedBox(width: Spacing.md),
                      if (v.isVerified)
                        _Badge(
                          icon: Icons.verified,
                          label: 'Verified',
                          color: MovanaColors.success,
                        ),
                      const SizedBox(width: Spacing.sm),
                      _Badge(
                        icon: Icons.circle,
                        label: v.isAvailable ? 'Available' : 'Unavailable',
                        color: v.isAvailable
                            ? MovanaColors.success
                            : MovanaColors.error,
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.lg),

                  // ── Owner Card ──────────────────────────
                  _OwnerCard(vehicle: v),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.lg),

                  // ── Vehicle Details ─────────────────────
                  const Text('Vehicle Details',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.md),
                  _DetailGrid(v),
                  const SizedBox(height: Spacing.xxl),

                  // ── Features ────────────────────────────
                  const Text('Features & Inclusions',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.md),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: v.features
                        .map((f) => _FeatureChip(f))
                        .toList(),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.lg),

                  // ── Description ─────────────────────────
                  const Text('About this listing',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.md),
                  Text(v.description, style: MovanaTextStyles.bodyMD),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.lg),

                  // ── Reviews ─────────────────────────────
                  SectionHeader(
                    title: 'Reviews (${MockData.sampleReviews.length})',
                    actionLabel: 'See all',
                    onAction: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => AllReviewsScreen(
                          vehicleName: v.name,
                          averageRating: v.rating,
                          reviews: MockData.sampleReviews,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.md),
                  ...MockData.sampleReviews.take(2).map(
                        (r) => _ReviewTile(review: r),
                      ),
                  const SizedBox(height: Spacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BookingBar(vehicle: v),
    );
  }
}

// ──────────────────────────────────────────────
// Owner Card
// ──────────────────────────────────────────────
class _OwnerCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _OwnerCard({required this.vehicle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => OwnerProfileScreen(
            ownerId: vehicle.ownerId,
            ownerName: vehicle.ownerName,
            ownerAvatar: vehicle.ownerAvatar,
            ownerRating: vehicle.ownerRating,
            ownerVerified: vehicle.ownerVerified,
          ),
        ),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(vehicle.ownerAvatar),
                backgroundColor: MovanaColors.surface,
              ),
              if (vehicle.ownerVerified)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: MovanaColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.verified,
                      size: 14,
                      color: MovanaColors.primaryLight,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(vehicle.ownerName,
                    style: MovanaTextStyles.labelLG),
                Text('Vehicle Owner • ⭐ ${vehicle.ownerRating}',
                    style: MovanaTextStyles.bodyMD),
              ],
            ),
          ),
          Row(
            children: [
              _IconBtn(icon: Icons.chat_bubble_outline, onTap: () {}),
              const SizedBox(width: Spacing.sm),
              _IconBtn(icon: Icons.phone_outlined, onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Detail Grid
// ──────────────────────────────────────────────
class _DetailGrid extends StatelessWidget {
  final VehicleModel v;
  const _DetailGrid(this.v);

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Type', v.type),
      ('Year', v.year.toString()),
      ('Color', v.color),
      ('Plate No.', v.plateNumber),
      ('Distance', '${v.distanceKm} km'),
      ('Category', v.category.name.toUpperCase()),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 72,
        mainAxisSpacing: Spacing.sm,
        crossAxisSpacing: Spacing.sm,
      ),
      itemCount: items.length,
      itemBuilder: (_, i) {
        final (label, value) = items[i];
        return Container(
          padding: const EdgeInsets.all(Spacing.md),
          decoration: BoxDecoration(
            color: MovanaColors.surface,
            borderRadius: BorderRadius.circular(Radii.md),
            border: Border.all(color: MovanaColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(label, style: MovanaTextStyles.bodySM),
              const SizedBox(height: 2),
              Text(value,
                  style: MovanaTextStyles.labelMD,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ),
        );
      },
    );
  }
}

class _FeatureChip extends StatelessWidget {
  final String label;
  const _FeatureChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: MovanaColors.primarySurface,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: MovanaColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.check_circle_rounded,
              size: 13, color: MovanaColors.primary),
          const SizedBox(width: 4),
          Text(label,
              style: MovanaTextStyles.labelSM
                  .copyWith(color: MovanaColors.primary)),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _Badge({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: MovanaTextStyles.labelSM
                  .copyWith(color: color, fontSize: 11)),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                  backgroundImage: NetworkImage(review.reviewerAvatar),
                  backgroundColor: MovanaColors.border,
                ),
                const SizedBox(width: Spacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.reviewerName,
                          style: MovanaTextStyles.labelMD),
                      Text(
                        '${review.createdAt.day}/${review.createdAt.month}/${review.createdAt.year}',
                        style: MovanaTextStyles.bodySM,
                      ),
                    ],
                  ),
                ),
                StarRating(rating: review.rating, showCount: false),
              ],
            ),
            const SizedBox(height: Spacing.sm),
            Text(review.comment, style: MovanaTextStyles.bodyMD),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: MovanaColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: MovanaColors.border),
        ),
        child: Icon(icon, size: 18, color: MovanaColors.inkMedium),
      ),
    );
  }
}

class _BookingBar extends StatelessWidget {
  final VehicleModel vehicle;
  const _BookingBar({required this.vehicle});

  void _openChat(BuildContext context) {
    // Find existing convo or create a mock one from vehicle owner data
    final existing = MockData.conversations
        .where((c) => c.otherUserId == vehicle.ownerId)
        .toList();

    final convo = existing.isNotEmpty
        ? existing.first
        : ConversationModel(
            id: 'new_${vehicle.ownerId}',
            otherUserId: vehicle.ownerId,
            otherUserName: vehicle.ownerName,
            otherUserAvatar: vehicle.ownerAvatar,
            vehicleName: vehicle.name,
            lastMessage: '',
            lastMessageTime: DateTime.now(),
            unreadCount: 0,
          );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ChatScreen(convo: convo)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(Spacing.page, Spacing.md, Spacing.page,
          Spacing.md + MediaQuery.of(context).padding.bottom),
      decoration: const BoxDecoration(
        color: MovanaColors.white,
        border: Border(top: BorderSide(color: MovanaColors.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: MovanaButton(
              label: 'Message Owner',
              isOutlined: true,
              icon: const Icon(Icons.chat_bubble_outline, size: 18),
              onPressed: () => _openChat(context),
              width: null,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: MovanaButton(
              label: 'Book Now',
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              onPressed: vehicle.isAvailable
                  ? () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) =>
                            BookingFormScreen(vehicle: vehicle),
                      ))
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Full-Screen Image Gallery
// ──────────────────────────────────────────────
class _FullScreenGallery extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const _FullScreenGallery({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  State<_FullScreenGallery> createState() => _FullScreenGalleryState();
}

class _FullScreenGalleryState extends State<_FullScreenGallery> {
  late PageController _pageCtrl;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Swipeable pages
          PageView.builder(
            controller: _pageCtrl,
            itemCount: widget.imageUrls.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.network(
                  widget.imageUrls[i],
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.broken_image_outlined,
                    color: Colors.white38,
                    size: 64,
                  ),
                ),
              ),
            ),
          ),

          // Top bar
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md, vertical: Spacing.sm),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.close,
                          color: Colors.white, size: 20),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: Text(
                      '${_current + 1} / ${widget.imageUrls.length}',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom dot indicators
          Positioned(
            bottom: 32,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(widget.imageUrls.length, (i) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: i == _current ? 20 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Colors.white
                        .withOpacity(i == _current ? 1.0 : 0.4),
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
