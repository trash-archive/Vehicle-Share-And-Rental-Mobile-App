import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';

class LeaveReviewScreen extends StatefulWidget {
  final BookingModel booking;
  const LeaveReviewScreen({super.key, required this.booking});

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen>
    with SingleTickerProviderStateMixin {
  double _vehicleRating = 0;
  double _ownerRating = 0;
  final _commentCtrl = TextEditingController();
  final Set<String> _selectedTags = {};
  bool _submitted = false;
  bool _loading = false;

  late AnimationController _successCtrl;
  late Animation<double> _successScale;
  late Animation<double> _successFade;

  // Quick-tag options
  static const _vehicleTags = [
    'Clean & tidy', 'Well-maintained', 'As described',
    'Fuel efficient', 'Easy to drive', 'Great condition',
  ];
  static const _ownerTags = [
    'Very responsive', 'On time', 'Helpful',
    'Friendly', 'Professional', 'Trustworthy',
  ];

  String get _ownerAvatar {
    try {
      return MockData.vehicles
          .firstWhere((v) => v.ownerId == widget.booking.ownerId)
          .ownerAvatar;
    } catch (_) {
      return 'https://i.pravatar.cc/150?img=1';
    }
  }

  @override
  void initState() {
    super.initState();
    _successCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _successScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _successCtrl, curve: Curves.elasticOut),
    );
    _successFade = CurvedAnimation(parent: _successCtrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _successCtrl.dispose();
    _commentCtrl.dispose();
    super.dispose();
  }

  bool get _canSubmit => _vehicleRating > 0 && _ownerRating > 0;

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    setState(() {
      _loading = false;
      _submitted = true;
    });
    _successCtrl.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: _submitted
          ? null
          : AppBar(
              title: const Text('Leave a Review',
                  style: MovanaTextStyles.headingSM),
              leading: const BackButton(),
            ),
      body: _submitted ? _SuccessView(ctrl: _successCtrl, scale: _successScale, fade: _successFade) : _FormView(
        booking: widget.booking,
        ownerAvatar: _ownerAvatar,
        vehicleRating: _vehicleRating,
        ownerRating: _ownerRating,
        selectedTags: _selectedTags,
        commentCtrl: _commentCtrl,
        vehicleTags: _vehicleTags,
        ownerTags: _ownerTags,
        canSubmit: _canSubmit,
        loading: _loading,
        onVehicleRating: (r) => setState(() => _vehicleRating = r),
        onOwnerRating: (r) => setState(() => _ownerRating = r),
        onTagToggle: (t) => setState(() {
          _selectedTags.contains(t)
              ? _selectedTags.remove(t)
              : _selectedTags.add(t);
        }),
        onSubmit: _submit,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Form View
// ──────────────────────────────────────────────
class _FormView extends StatelessWidget {
  final BookingModel booking;
  final String ownerAvatar;
  final double vehicleRating;
  final double ownerRating;
  final Set<String> selectedTags;
  final TextEditingController commentCtrl;
  final List<String> vehicleTags;
  final List<String> ownerTags;
  final bool canSubmit;
  final bool loading;
  final ValueChanged<double> onVehicleRating;
  final ValueChanged<double> onOwnerRating;
  final ValueChanged<String> onTagToggle;
  final VoidCallback onSubmit;

  const _FormView({
    required this.booking,
    required this.ownerAvatar,
    required this.vehicleRating,
    required this.ownerRating,
    required this.selectedTags,
    required this.commentCtrl,
    required this.vehicleTags,
    required this.ownerTags,
    required this.canSubmit,
    required this.loading,
    required this.onVehicleRating,
    required this.onOwnerRating,
    required this.onTagToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(Spacing.page),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Rental summary card ─────────────────
                Container(
                  padding: const EdgeInsets.all(Spacing.lg),
                  decoration: BoxDecoration(
                    color: MovanaColors.surface,
                    borderRadius: BorderRadius.circular(Radii.lg),
                    border: Border.all(color: MovanaColors.border),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(Radii.md),
                        child: Image.network(
                          booking.vehicleImage,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 64,
                            height: 64,
                            color: MovanaColors.border,
                          ),
                        ),
                      ),
                      const SizedBox(width: Spacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(booking.vehicleName,
                                style: MovanaTextStyles.labelLG,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Owner: ${booking.ownerName}',
                                style: MovanaTextStyles.bodyMD),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: MovanaColors.success.withOpacity(0.1),
                                borderRadius:
                                    BorderRadius.circular(Radii.pill),
                              ),
                              child: Text(
                                'Completed rental',
                                style: MovanaTextStyles.bodySM.copyWith(
                                  color: MovanaColors.success,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: Spacing.xxl),

                // ── Vehicle Rating ──────────────────────
                const Text('Rate the Vehicle',
                    style: MovanaTextStyles.headingSM),
                const SizedBox(height: Spacing.sm),
                Text(
                  'How was the vehicle\'s condition and quality?',
                  style: MovanaTextStyles.bodyMD,
                ),
                const SizedBox(height: Spacing.lg),
                _StarPicker(
                  rating: vehicleRating,
                  onChanged: onVehicleRating,
                ),
                if (vehicleRating > 0) ...[
                  const SizedBox(height: Spacing.sm),
                  Center(
                    child: Text(
                      _ratingLabel(vehicleRating),
                      style: MovanaTextStyles.labelMD
                          .copyWith(color: MovanaColors.warning),
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.lg),
                // Vehicle quick tags
                Wrap(
                  spacing: Spacing.sm,
                  runSpacing: Spacing.sm,
                  children: vehicleTags
                      .map((t) => _QuickTag(
                            label: t,
                            selected: selectedTags.contains(t),
                            onTap: () => onTagToggle(t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: Spacing.xxl),
                const Divider(),
                const SizedBox(height: Spacing.xxl),

                // ── Owner Rating ────────────────────────
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(ownerAvatar),
                      backgroundColor: MovanaColors.border,
                    ),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rate the Owner',
                              style: MovanaTextStyles.headingSM),
                          Text(booking.ownerName,
                              style: MovanaTextStyles.bodyMD),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  'How was the owner\'s responsiveness and service?',
                  style: MovanaTextStyles.bodyMD,
                ),
                const SizedBox(height: Spacing.lg),
                _StarPicker(
                  rating: ownerRating,
                  onChanged: onOwnerRating,
                ),
                if (ownerRating > 0) ...[
                  const SizedBox(height: Spacing.sm),
                  Center(
                    child: Text(
                      _ratingLabel(ownerRating),
                      style: MovanaTextStyles.labelMD
                          .copyWith(color: MovanaColors.warning),
                    ),
                  ),
                ],
                const SizedBox(height: Spacing.lg),
                // Owner quick tags
                Wrap(
                  spacing: Spacing.sm,
                  runSpacing: Spacing.sm,
                  children: ownerTags
                      .map((t) => _QuickTag(
                            label: t,
                            selected: selectedTags.contains(t),
                            onTap: () => onTagToggle(t),
                          ))
                      .toList(),
                ),
                const SizedBox(height: Spacing.xxl),
                const Divider(),
                const SizedBox(height: Spacing.xxl),

                // ── Written review ──────────────────────
                const Text('Write a Review',
                    style: MovanaTextStyles.headingSM),
                const SizedBox(height: Spacing.sm),
                Text(
                  'Share your experience to help other renters.',
                  style: MovanaTextStyles.bodyMD,
                ),
                const SizedBox(height: Spacing.md),
                TextField(
                  controller: commentCtrl,
                  maxLines: 5,
                  maxLength: 500,
                  decoration: const InputDecoration(
                    hintText:
                        'Tell others about your rental experience...',
                  ),
                ),
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
          ),
        ),

        // ── Submit bar ──────────────────────────────
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!canSubmit)
                Padding(
                  padding: const EdgeInsets.only(bottom: Spacing.sm),
                  child: Text(
                    'Please rate both the vehicle and owner to continue.',
                    style: MovanaTextStyles.bodySM
                        .copyWith(color: MovanaColors.inkLight),
                    textAlign: TextAlign.center,
                  ),
                ),
              MovanaButton(
                label: 'Submit Review',
                isLoading: loading,
                onPressed: canSubmit ? onSubmit : null,
                icon: const Icon(Icons.star_rounded, size: 18),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _ratingLabel(double r) {
    if (r == 5) return '⭐ Excellent!';
    if (r == 4) return '😊 Good';
    if (r == 3) return '😐 Average';
    if (r == 2) return '😕 Below Average';
    return '😞 Poor';
  }
}

// ──────────────────────────────────────────────
// Success View
// ──────────────────────────────────────────────
class _SuccessView extends StatelessWidget {
  final AnimationController ctrl;
  final Animation<double> scale;
  final Animation<double> fade;

  const _SuccessView(
      {required this.ctrl, required this.scale, required this.fade});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: FadeTransition(
          opacity: fade,
          child: ScaleTransition(
            scale: scale,
            child: Padding(
              padding: const EdgeInsets.all(Spacing.xxxl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: const BoxDecoration(
                      color: MovanaColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle_rounded,
                      size: 52,
                      color: MovanaColors.primary,
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  const Text('Review Submitted!',
                      style: MovanaTextStyles.displayMD,
                      textAlign: TextAlign.center),
                  const SizedBox(height: Spacing.md),
                  Text(
                    'Thank you for sharing your experience.\nYour feedback helps the Movana community.',
                    style: MovanaTextStyles.bodyLG,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: Spacing.xxxl),
                  MovanaButton(
                    label: 'Back to Bookings',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Interactive Star Picker
// ──────────────────────────────────────────────
class _StarPicker extends StatelessWidget {
  final double rating;
  final ValueChanged<double> onChanged;

  const _StarPicker({required this.rating, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final filled = i < rating;
        return GestureDetector(
          onTap: () => onChanged((i + 1).toDouble()),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Icon(
              filled ? Icons.star_rounded : Icons.star_border_rounded,
              size: 44,
              color: filled ? MovanaColors.warning : MovanaColors.border,
            ),
          ),
        );
      }),
    );
  }
}

// ──────────────────────────────────────────────
// Quick Tag Chip
// ──────────────────────────────────────────────
class _QuickTag extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickTag(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: selected
              ? MovanaColors.primarySurface
              : MovanaColors.surface,
          borderRadius: BorderRadius.circular(Radii.pill),
          border: Border.all(
            color: selected
                ? MovanaColors.primary
                : MovanaColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check_rounded,
                  size: 13, color: MovanaColors.primary),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: MovanaTextStyles.labelSM.copyWith(
                color: selected
                    ? MovanaColors.primary
                    : MovanaColors.inkMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
