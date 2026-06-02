import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

/// Full-screen booking confirmation shown after a booking request is sent.
/// Provides a reference number, booking summary, and CTA to view bookings.
class BookingConfirmationScreen extends StatelessWidget {
  final VehicleModel vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final double total;
  final String bookingRef;

  const BookingConfirmationScreen({
    super.key,
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.total,
    required this.bookingRef,
  });

  String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  int get _days => endDate.difference(startDate).inDays;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(Spacing.page),
                child: Column(
                  children: [
                    const SizedBox(height: Spacing.xxxl),

                    // ── Success animation ───────────────────
                    _SuccessBadge(),
                    const SizedBox(height: Spacing.xxl),

                    const Text(
                      'Booking Request Sent!',
                      style: MovanaTextStyles.displayMD,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      'Your request has been sent to the owner.\nThey usually respond within 1–2 hours.',
                      style: MovanaTextStyles.bodyMD
                          .copyWith(color: MovanaColors.inkMedium),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: Spacing.xxl),

                    // ── Reference number ────────────────────
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Spacing.xl, vertical: Spacing.md),
                      decoration: BoxDecoration(
                        color: MovanaColors.primarySurface,
                        borderRadius: BorderRadius.circular(Radii.md),
                        border: Border.all(
                            color: MovanaColors.primary.withOpacity(0.25)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Booking Reference',
                            style: MovanaTextStyles.bodySM
                                .copyWith(color: MovanaColors.inkLight),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            bookingRef.toUpperCase(),
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: MovanaColors.primary,
                              letterSpacing: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),

                    // ── Booking summary card ─────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: MovanaColors.surface,
                        borderRadius: BorderRadius.circular(Radii.lg),
                        border: Border.all(color: MovanaColors.border),
                      ),
                      child: Column(
                        children: [
                          // Vehicle header
                          Padding(
                            padding: const EdgeInsets.all(Spacing.lg),
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Radii.md),
                                  child: Image.network(
                                    vehicle.imageUrls.first,
                                    width: 64,
                                    height: 56,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => Container(
                                      width: 64,
                                      height: 56,
                                      color: MovanaColors.border,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: Spacing.md),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(vehicle.name,
                                          style: MovanaTextStyles.labelLG,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      const SizedBox(height: 2),
                                      Text(vehicle.location,
                                          style: MovanaTextStyles.bodyMD),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Divider(height: 1),
                          // Details rows
                          Padding(
                            padding: const EdgeInsets.all(Spacing.lg),
                            child: Column(
                              children: [
                                InfoRow(
                                  label: 'Check-in',
                                  value: _fmt(startDate),
                                ),
                                const SizedBox(height: Spacing.sm),
                                InfoRow(
                                  label: 'Check-out',
                                  value: _fmt(endDate),
                                ),
                                const SizedBox(height: Spacing.sm),
                                InfoRow(
                                  label: 'Duration',
                                  value:
                                      '$_days day${_days != 1 ? 's' : ''}',
                                ),
                                const Divider(height: Spacing.xxl),
                                InfoRow(
                                  label: 'Total Amount',
                                  value: '',
                                  trailing: Text(
                                    '₱${total.toStringAsFixed(0)}',
                                    style: MovanaTextStyles.labelLG.copyWith(
                                      color: MovanaColors.primary,
                                      fontFamily: 'Syne',
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: Spacing.xl),

                    // ── Pending info banner ──────────────────
                    Container(
                      padding: const EdgeInsets.all(Spacing.md),
                      decoration: BoxDecoration(
                        color: MovanaColors.warning.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(Radii.md),
                        border: Border.all(
                            color: MovanaColors.warning.withOpacity(0.25)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 16, color: MovanaColors.warning),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Awaiting owner approval',
                                  style: MovanaTextStyles.labelSM
                                      .copyWith(color: MovanaColors.warning),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'You won\'t be charged until the owner confirms your request. Check "My Bookings" for status updates.',
                                  style: MovanaTextStyles.bodySM.copyWith(
                                      color: MovanaColors.warning),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: Spacing.xxxl),
                  ],
                ),
              ),
            ),

            // ── Bottom actions ───────────────────────────
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
                  MovanaButton(
                    label: 'View in My Bookings',
                    icon: const Icon(Icons.calendar_today_rounded, size: 18),
                    onPressed: () {
                      // Pop all routes back to the shell and switch to
                      // Bookings tab (index 2). We pass a result so the
                      // shell knows to jump tabs.
                      Navigator.of(context).popUntil((r) => r.isFirst);
                    },
                  ),
                  const SizedBox(height: Spacing.sm),
                  MovanaButton(
                    label: 'Back to Home',
                    isOutlined: true,
                    onPressed: () =>
                        Navigator.of(context).popUntil((r) => r.isFirst),
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
// Animated success badge
// ──────────────────────────────────────────────
class _SuccessBadge extends StatefulWidget {
  @override
  State<_SuccessBadge> createState() => _SuccessBadgeState();
}

class _SuccessBadgeState extends State<_SuccessBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..forward();
    _scale = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _opacity = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: 96,
          height: 96,
          decoration: BoxDecoration(
            color: MovanaColors.success.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: MovanaColors.success.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                size: 40,
                color: MovanaColors.success,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
