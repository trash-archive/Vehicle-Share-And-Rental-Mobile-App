import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

// ── Mock: reviews written BY the current user ──
class _UserReview {
  final String vehicleId;
  final String vehicleName;
  final String vehicleImage;
  final double vehicleRating;
  final double ownerRating;
  final String comment;
  final List<String> tags;
  final DateTime createdAt;

  const _UserReview({
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.vehicleRating,
    required this.ownerRating,
    required this.comment,
    required this.tags,
    required this.createdAt,
  });
}

final _myReviews = [
  _UserReview(
    vehicleId: 'v001',
    vehicleName: 'Honda Click 125i',
    vehicleImage:
        'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=800',
    vehicleRating: 5.0,
    ownerRating: 5.0,
    comment:
        'Excellent vehicle! Very clean and well-maintained. Owner was very responsive and accommodating. Highly recommend!',
    tags: ['Clean & tidy', 'Well-maintained', 'As described'],
    createdAt: DateTime(2024, 3, 15),
  ),
];

class MyReviewsScreen extends StatelessWidget {
  const MyReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('My Reviews', style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: _myReviews.isEmpty
          ? const EmptyState(
              emoji: '⭐',
              title: 'No reviews yet',
              subtitle:
                  'After completing a rental, you can leave a review for the vehicle and owner.',
            )
          : ListView(
              padding: const EdgeInsets.all(Spacing.page),
              children: [
                // Summary bar
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        MovanaColors.primaryDark,
                        MovanaColors.primaryLight
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(Radii.lg),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.rate_review_rounded,
                          color: Colors.white, size: 28),
                      const SizedBox(width: Spacing.md),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${_myReviews.length} review${_myReviews.length == 1 ? '' : 's'} written',
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Text(
                            'Your contribution helps the community',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xxl),
                ..._myReviews.map((r) => Padding(
                      padding:
                          const EdgeInsets.only(bottom: Spacing.lg),
                      child: _MyReviewCard(review: r),
                    )),
              ],
            ),
    );
  }
}

class _MyReviewCard extends StatelessWidget {
  final _UserReview review;
  const _MyReviewCard({required this.review});

  String _formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: MovanaColors.border),
        boxShadow: [
          BoxShadow(
            color: MovanaColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle header
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(top: Radius.circular(Radii.lg)),
            child: Stack(
              children: [
                Image.network(
                  review.vehicleImage,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 120,
                    color: MovanaColors.surface,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      review.vehicleName,
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Ratings row
                Row(
                  children: [
                    _RatingPill(
                        label: 'Vehicle',
                        rating: review.vehicleRating),
                    const SizedBox(width: Spacing.sm),
                    _RatingPill(
                        label: 'Owner', rating: review.ownerRating),
                    const Spacer(),
                    Text(
                      _formatDate(review.createdAt),
                      style: MovanaTextStyles.bodySM,
                    ),
                  ],
                ),
                if (review.tags.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  Wrap(
                    spacing: Spacing.sm,
                    runSpacing: Spacing.sm,
                    children: review.tags
                        .map((t) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: MovanaColors.primarySurface,
                                borderRadius:
                                    BorderRadius.circular(Radii.pill),
                              ),
                              child: Text(
                                t,
                                style: MovanaTextStyles.bodySM.copyWith(
                                    color: MovanaColors.primary,
                                    fontWeight: FontWeight.w500),
                              ),
                            ))
                        .toList(),
                  ),
                ],
                const SizedBox(height: Spacing.md),
                Text(review.comment, style: MovanaTextStyles.bodyMD),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RatingPill extends StatelessWidget {
  final String label;
  final double rating;
  const _RatingPill({required this.label, required this.rating});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: MovanaColors.warning.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded,
              size: 12, color: MovanaColors.warning),
          const SizedBox(width: 3),
          Text(
            '$label ${rating.toStringAsFixed(1)}',
            style: MovanaTextStyles.bodySM.copyWith(
              color: MovanaColors.warning,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
