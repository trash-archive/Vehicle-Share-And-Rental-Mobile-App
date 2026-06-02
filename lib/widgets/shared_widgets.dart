import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

// ──────────────────────────────────────────────
// Movana Logo Widget
// ──────────────────────────────────────────────
class MovanaLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const MovanaLogo({
    super.key,
    this.size = 32,
    this.showText = true,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? MovanaColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(size * 0.25),
          ),
          child: Center(
            child: Text(
              'M',
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: size * 0.6,
                fontWeight: FontWeight.w800,
                color: MovanaColors.white,
                height: 1,
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 8),
          Text(
            'Movana',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: size * 0.65,
              fontWeight: FontWeight.w800,
              color: c,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Shimmer Skeleton
// ──────────────────────────────────────────────
class ShimmerBox extends StatefulWidget {
  final double width;
  final double height;
  final double radius;
  const ShimmerBox(
      {super.key, required this.width, required this.height, this.radius = 8});

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.3, end: 0.7)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: Color.lerp(MovanaColors.border, MovanaColors.surface, _anim.value),
        ),
      ),
    );
  }
}

class VehicleCardSkeleton extends StatelessWidget {
  const VehicleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: MovanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ShimmerBox(width: double.infinity, height: 180, radius: Radii.lg),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ShimmerBox(width: 200, height: 18, radius: 4),
                const SizedBox(height: Spacing.sm),
                const ShimmerBox(width: 140, height: 13, radius: 4),
                const SizedBox(height: Spacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    ShimmerBox(width: 100, height: 13, radius: 4),
                    ShimmerBox(width: 70, height: 20, radius: 4),
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

// ──────────────────────────────────────────────
// Vehicle Card (Full)
// ──────────────────────────────────────────────
class VehicleCard extends StatefulWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const VehicleCard({super.key, required this.vehicle, required this.onTap});

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    final vehicle = widget.vehicle;
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: MovanaColors.white,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: MovanaColors.border),
          boxShadow: [
            BoxShadow(
              color: MovanaColors.ink.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Radii.lg),
                  ),
                  child: Image.network(
                    vehicle.imageUrls.first,
                    height: 180,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (_, child, progress) => progress == null
                        ? child
                        : const ShimmerBox(
                            width: double.infinity, height: 180, radius: 0),
                    errorBuilder: (_, __, ___) => Container(
                      height: 180,
                      color: MovanaColors.surface,
                      child: const Icon(Icons.directions_car,
                          size: 48, color: MovanaColors.border),
                    ),
                  ),
                ),
                // Category chip
                Positioned(
                  top: 12,
                  left: 12,
                  child: _CategoryBadge(vehicle.category),
                ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => setState(() => _favorited = !_favorited),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _favorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(_favorited),
                          color: _favorited ? MovanaColors.error : Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ),
                // Verified badge
                if (vehicle.isVerified)
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: MovanaColors.success.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(Radii.pill),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified,
                              size: 12, color: Colors.white),
                          const SizedBox(width: 3),
                          Text(
                            'Verified',
                            style: MovanaTextStyles.bodySM.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            // Info
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          vehicle.name,
                          style: MovanaTextStyles.headingSM,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      StarRating(rating: vehicle.rating, reviewCount: vehicle.reviewCount),
                    ],
                  ),
                  const SizedBox(height: Spacing.xs),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined,
                          size: 14, color: MovanaColors.inkLight),
                      const SizedBox(width: 2),
                      Expanded(
                        child: Text(
                          '${vehicle.location} • ${vehicle.distanceKm.toStringAsFixed(1)} km',
                          style: MovanaTextStyles.bodySM,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.md),
                  Row(
                    children: [
                      _OwnerAvatar(vehicle),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: '₱${vehicle.pricePerDay.toStringAsFixed(0)}',
                                  style: MovanaTextStyles.labelLG.copyWith(
                                    color: MovanaColors.primary,
                                    fontSize: 18,
                                    fontFamily: 'Syne',
                                  ),
                                ),
                                TextSpan(
                                  text: '/day',
                                  style: MovanaTextStyles.bodySM,
                                ),
                              ],
                            ),
                          ),
                          Text(
                            '₱${vehicle.pricePerHour.toStringAsFixed(0)}/hr',
                            style: MovanaTextStyles.bodySM,
                          ),
                        ],
                      ),
                    ],
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

// ──────────────────────────────────────────────
// Vehicle Card (Compact / Horizontal)
// ──────────────────────────────────────────────
class VehicleCardCompact extends StatefulWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const VehicleCardCompact({super.key, required this.vehicle, required this.onTap});

  @override
  State<VehicleCardCompact> createState() => _VehicleCardCompactState();
}

class _VehicleCardCompactState extends State<VehicleCardCompact> {
  bool _favorited = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        width: 220,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
                  child: Image.network(
                    widget.vehicle.imageUrls.first,
                    height: 130,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 130,
                      color: MovanaColors.surface,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: _CategoryBadge(widget.vehicle.category),
                ),
                // Heart button
                Positioned(
                  top: 6,
                  right: 6,
                  child: GestureDetector(
                    onTap: () => setState(() => _favorited = !_favorited),
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.35),
                        shape: BoxShape.circle,
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          _favorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(_favorited),
                          color: _favorited ? MovanaColors.error : Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.vehicle.name,
                    style: MovanaTextStyles.labelMD,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.vehicle.location,
                    style: MovanaTextStyles.bodySM,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      Text(
                        '₱${widget.vehicle.pricePerDay.toStringAsFixed(0)}',
                        style: MovanaTextStyles.labelMD.copyWith(
                          color: MovanaColors.primary,
                          fontFamily: 'Syne',
                        ),
                      ),
                      Text('/day', style: MovanaTextStyles.bodySM),
                      const Spacer(),
                      StarRating(rating: widget.vehicle.rating, showCount: false),
                    ],
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

// ──────────────────────────────────────────────
// Star Rating Widget
// ──────────────────────────────────────────────
class StarRating extends StatelessWidget {
  final double rating;
  final int? reviewCount;
  final bool showCount;
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.reviewCount,
    this.showCount = true,
    this.size = 13,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: size, color: MovanaColors.warning),
        const SizedBox(width: 2),
        Text(
          rating.toStringAsFixed(1),
          style: MovanaTextStyles.labelSM.copyWith(fontSize: size - 1),
        ),
        if (showCount && reviewCount != null) ...[
          Text(
            ' ($reviewCount)',
            style: MovanaTextStyles.bodySM.copyWith(fontSize: size - 1),
          ),
        ],
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Category Badge
// ──────────────────────────────────────────────
class _CategoryBadge extends StatelessWidget {
  final VehicleCategory category;
  const _CategoryBadge(this.category);

  static const _icons = {
    VehicleCategory.personal: '🏍️',
    VehicleCategory.commercial: '🚐',
    VehicleCategory.construction: '🏗️',
    VehicleCategory.agricultural: '🚜',
    VehicleCategory.water: '⛵',
  };

  static const _labels = {
    VehicleCategory.personal: 'Personal',
    VehicleCategory.commercial: 'Commercial',
    VehicleCategory.construction: 'Construction',
    VehicleCategory.agricultural: 'Agricultural',
    VehicleCategory.water: 'Water',
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.55),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_icons[category] ?? '🚗', style: const TextStyle(fontSize: 10)),
          const SizedBox(width: 4),
          Text(
            _labels[category] ?? '',
            style: MovanaTextStyles.bodySM.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Owner Avatar Row
// ──────────────────────────────────────────────
class _OwnerAvatar extends StatelessWidget {
  final VehicleModel vehicle;
  const _OwnerAvatar(this.vehicle);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(vehicle.ownerAvatar),
          onBackgroundImageError: (_, __) {},
          backgroundColor: MovanaColors.surface,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  vehicle.ownerName,
                  style: MovanaTextStyles.labelSM.copyWith(fontSize: 11),
                ),
                if (vehicle.ownerVerified) ...[
                  const SizedBox(width: 2),
                  const Icon(Icons.verified,
                      size: 11, color: MovanaColors.primaryLight),
                ],
              ],
            ),
            Text(
              '⭐ ${vehicle.ownerRating}',
              style: MovanaTextStyles.bodySM.copyWith(fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Section Header
// ──────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: MovanaTextStyles.headingSM),
        const Spacer(),
        if (actionLabel != null)
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionLabel!,
              style: MovanaTextStyles.labelSM.copyWith(
                color: MovanaColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

// ──────────────────────────────────────────────
// Status Chip for Bookings
// ──────────────────────────────────────────────
class BookingStatusChip extends StatelessWidget {
  final BookingStatus status;
  const BookingStatusChip(this.status, {super.key});

  static const _labels = {
    BookingStatus.pending: 'Pending',
    BookingStatus.confirmed: 'Confirmed',
    BookingStatus.ongoing: 'Ongoing',
    BookingStatus.completed: 'Completed',
    BookingStatus.cancelled: 'Cancelled',
  };

  static const _colors = {
    BookingStatus.pending: MovanaColors.warning,
    BookingStatus.confirmed: MovanaColors.info,
    BookingStatus.ongoing: MovanaColors.primary,
    BookingStatus.completed: MovanaColors.success,
    BookingStatus.cancelled: MovanaColors.error,
  };

  @override
  Widget build(BuildContext context) {
    final color = _colors[status] ?? MovanaColors.inkLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        _labels[status] ?? '',
        style: MovanaTextStyles.labelSM.copyWith(color: color, fontSize: 11),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Empty State Widget
// ──────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;
  final Widget? action;

  const EmptyState({
    super.key,
    required this.emoji,
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Spacing.xxxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 56)),
            const SizedBox(height: Spacing.lg),
            Text(title,
                style: MovanaTextStyles.headingSM,
                textAlign: TextAlign.center),
            const SizedBox(height: Spacing.sm),
            Text(subtitle,
                style: MovanaTextStyles.bodyMD,
                textAlign: TextAlign.center),
            if (action != null) ...[
              const SizedBox(height: Spacing.xxl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Movana Primary Button
// ──────────────────────────────────────────────
class MovanaButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Widget? icon;
  final bool isOutlined;
  final Color? color;
  final double? width;

  const MovanaButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.isOutlined = false,
    this.color,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final bg = color ?? MovanaColors.primary;
    return SizedBox(
      width: width ?? double.infinity,
      height: 52,
      child: isOutlined
          ? OutlinedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: icon ?? const SizedBox.shrink(),
              label: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(label),
              style: OutlinedButton.styleFrom(
                foregroundColor: bg,
                side: BorderSide(color: bg),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.md)),
              ),
            )
          : ElevatedButton.icon(
              onPressed: isLoading ? null : onPressed,
              icon: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white),
                    )
                  : (icon ?? const SizedBox.shrink()),
              label: Text(label),
              style: ElevatedButton.styleFrom(
                backgroundColor: bg,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.md)),
                textStyle: MovanaTextStyles.labelLG,
              ),
            ),
    );
  }
}

// ──────────────────────────────────────────────
// Info Row (label: value)
// ──────────────────────────────────────────────
class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final Widget? trailing;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: Spacing.sm),
      child: Row(
        children: [
          Text(label, style: MovanaTextStyles.bodyMD),
          const Spacer(),
          trailing ??
              Text(value,
                  style: MovanaTextStyles.labelMD.copyWith(
                    color: MovanaColors.inkMedium,
                  )),
        ],
      ),
    );
  }
}
