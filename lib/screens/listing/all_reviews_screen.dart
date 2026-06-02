import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../models/models.dart';

class AllReviewsScreen extends StatefulWidget {
  final String vehicleName;
  final double averageRating;
  final List<ReviewModel> reviews;

  const AllReviewsScreen({
    super.key,
    required this.vehicleName,
    required this.averageRating,
    required this.reviews,
  });

  @override
  State<AllReviewsScreen> createState() => _AllReviewsScreenState();
}

class _AllReviewsScreenState extends State<AllReviewsScreen> {
  String _sortBy = 'newest';

  List<ReviewModel> get _sorted {
    final list = List<ReviewModel>.from(widget.reviews);
    switch (_sortBy) {
      case 'highest':
        list.sort((a, b) => b.rating.compareTo(a.rating));
      case 'lowest':
        list.sort((a, b) => a.rating.compareTo(b.rating));
      case 'newest':
      default:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    return list;
  }

  // Build star breakdown counts
  Map<int, int> get _breakdown {
    final map = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    for (final r in widget.reviews) {
      final star = r.rating.round().clamp(1, 5);
      map[star] = (map[star] ?? 0) + 1;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.reviews.length;

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Reviews', style: MovanaTextStyles.headingSM),
            Text(widget.vehicleName,
                style: MovanaTextStyles.bodySM
                    .copyWith(color: MovanaColors.primary)),
          ],
        ),
        leading: const BackButton(),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.md),
            child: PopupMenuButton<String>(
              icon: const Icon(Icons.sort, color: MovanaColors.inkMedium),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.md)),
              onSelected: (v) => setState(() => _sortBy = v),
              itemBuilder: (_) => [
                _sortItem('newest', 'Newest First'),
                _sortItem('highest', 'Highest Rating'),
                _sortItem('lowest', 'Lowest Rating'),
              ],
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.page),
        children: [
          // ── Rating Summary Card ──────────────────────
          Container(
            padding: const EdgeInsets.all(Spacing.xl),
            decoration: BoxDecoration(
              color: MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.xl),
            ),
            child: Row(
              children: [
                // Big score
                Column(
                  children: [
                    Text(
                      widget.averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: MovanaColors.ink,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < widget.averageRating.round()
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 16,
                          color: MovanaColors.warning,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$total review${total == 1 ? '' : 's'}',
                      style: MovanaTextStyles.bodySM,
                    ),
                  ],
                ),
                const SizedBox(width: Spacing.xl),
                // Breakdown bars
                Expanded(
                  child: Column(
                    children: [5, 4, 3, 2, 1].map((star) {
                      final count = _breakdown[star] ?? 0;
                      final pct = total > 0 ? count / total : 0.0;
                      return Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            Text('$star',
                                style: MovanaTextStyles.bodySM),
                            const SizedBox(width: 4),
                            const Icon(Icons.star_rounded,
                                size: 10, color: MovanaColors.warning),
                            const SizedBox(width: 6),
                            Expanded(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Radii.pill),
                                child: LinearProgressIndicator(
                                  value: pct,
                                  backgroundColor: MovanaColors.border,
                                  valueColor:
                                      const AlwaysStoppedAnimation(
                                          MovanaColors.warning),
                                  minHeight: 6,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            SizedBox(
                              width: 20,
                              child: Text(
                                '$count',
                                style: MovanaTextStyles.bodySM,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxl),

          // ── Sort label ─────────────────────────────
          Row(
            children: [
              Text(
                'All Reviews',
                style: MovanaTextStyles.labelLG,
              ),
              const Spacer(),
              Text(
                _sortLabel,
                style: MovanaTextStyles.bodySM
                    .copyWith(color: MovanaColors.primary),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),

          // ── Review tiles ────────────────────────────
          ..._sorted.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: Spacing.lg),
                child: _ReviewTile(review: r),
              )),

          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }

  String get _sortLabel {
    switch (_sortBy) {
      case 'highest':
        return 'Highest Rating';
      case 'lowest':
        return 'Lowest Rating';
      default:
        return 'Newest First';
    }
  }

  PopupMenuItem<String> _sortItem(String value, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            _sortBy == value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            size: 16,
            color: MovanaColors.primary,
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}

class _ReviewTile extends StatelessWidget {
  final ReviewModel review;
  const _ReviewTile({required this.review});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays < 30) return '${diff.inDays}d ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: MovanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(review.reviewerAvatar),
                backgroundColor: MovanaColors.surface,
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName,
                        style: MovanaTextStyles.labelMD),
                    Text(_timeAgo(review.createdAt),
                        style: MovanaTextStyles.bodySM),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating.round()
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 14,
                    color: MovanaColors.warning,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: Spacing.md),
          Text(review.comment, style: MovanaTextStyles.bodyMD),
        ],
      ),
    );
  }
}
