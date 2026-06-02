import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';

class BookingDetailScreen extends StatefulWidget {
  final BookingModel booking;
  const BookingDetailScreen({super.key, required this.booking});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late BookingModel _booking;

  @override
  void initState() {
    super.initState();
    _booking = widget.booking;
  }

  String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  // Resolve owner avatar from vehicles list
  String get _ownerAvatar {
    try {
      return MockData.vehicles
          .firstWhere((v) => v.ownerId == _booking.ownerId)
          .ownerAvatar;
    } catch (_) {
      return 'https://i.pravatar.cc/150?img=1';
    }
  }

  void _showCancelSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _CancelBookingSheet(
        booking: _booking,
        onConfirm: () {
          Navigator.pop(context); // close sheet
          Navigator.pop(context); // close detail
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Booking cancelled successfully.'),
              backgroundColor: MovanaColors.error,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isPending = _booking.status == BookingStatus.pending;
    final isConfirmed = _booking.status == BookingStatus.confirmed;
    final isOngoing = _booking.status == BookingStatus.ongoing;
    final canCancel = isPending || isConfirmed;

    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: CustomScrollView(
        slivers: [
          // ── Hero image app bar ──────────────────────
          SliverAppBar(
            expandedHeight: 220,
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
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _booking.vehicleImage,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: MovanaColors.surface,
                    ),
                  ),
                  // Gradient overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.5),
                        ],
                      ),
                    ),
                  ),
                  // Booking ID + status chip
                  Positioned(
                    bottom: 16,
                    left: Spacing.page,
                    right: Spacing.page,
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _booking.vehicleName,
                                style: const TextStyle(
                                  fontFamily: 'Syne',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                'Booking #${_booking.id.toUpperCase()}',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.75),
                                ),
                              ),
                            ],
                          ),
                        ),
                        BookingStatusChip(_booking.status),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status Timeline ───────────────────────
                  _StatusTimeline(status: _booking.status),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.xxl),

                  // ── Rental Dates ──────────────────────────
                  const Text('Rental Period',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _DateCard(
                          label: 'Check-in',
                          date: _fmt(_booking.startDate),
                          icon: Icons.flight_takeoff_rounded,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: Spacing.md),
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_forward_rounded,
                                size: 18, color: MovanaColors.inkLight),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: MovanaColors.primarySurface,
                                borderRadius:
                                    BorderRadius.circular(Radii.pill),
                              ),
                              child: Text(
                                '${_booking.durationDays}d',
                                style: MovanaTextStyles.labelSM
                                    .copyWith(color: MovanaColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: _DateCard(
                          label: 'Check-out',
                          date: _fmt(_booking.endDate),
                          icon: Icons.flight_land_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.xxl),

                  // ── Owner Info ────────────────────────────
                  const Text('Vehicle Owner',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.lg),
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.lg),
                      border: Border.all(color: MovanaColors.border),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 26,
                          backgroundImage: NetworkImage(_ownerAvatar),
                          backgroundColor: MovanaColors.border,
                        ),
                        const SizedBox(width: Spacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_booking.ownerName,
                                  style: MovanaTextStyles.labelLG),
                              const SizedBox(height: 2),
                              Text('Vehicle Owner',
                                  style: MovanaTextStyles.bodyMD),
                            ],
                          ),
                        ),
                        _ContactBtn(
                          icon: Icons.chat_bubble_outline_rounded,
                          onTap: () {},
                        ),
                        const SizedBox(width: Spacing.sm),
                        _ContactBtn(
                          icon: Icons.phone_outlined,
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.xxl),

                  // ── Price Breakdown ───────────────────────
                  const Text('Price Breakdown',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.lg),
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.lg),
                      border: Border.all(color: MovanaColors.border),
                    ),
                    child: Column(
                      children: [
                        _PriceRow(
                          label:
                              'Rental (${_booking.durationDays} day${_booking.durationDays != 1 ? 's' : ''})',
                          value:
                              '₱${(_booking.totalPrice / 1.05).toStringAsFixed(0)}',
                        ),
                        const Divider(height: Spacing.xl),
                        _PriceRow(
                          label: 'Platform fee (5%)',
                          value:
                              '₱${(_booking.totalPrice - _booking.totalPrice / 1.05).toStringAsFixed(0)}',
                        ),
                        const Divider(height: Spacing.xl),
                        _PriceRow(
                          label: 'Total Paid',
                          value:
                              '₱${_booking.totalPrice.toStringAsFixed(0)}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),

                  // ── Renter Notes ──────────────────────────
                  if (_booking.notes != null &&
                      _booking.notes!.isNotEmpty) ...[
                    const SizedBox(height: Spacing.xxl),
                    const Divider(),
                    const SizedBox(height: Spacing.xxl),
                    const Text('Your Notes',
                        style: MovanaTextStyles.headingSM),
                    const SizedBox(height: Spacing.md),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: MovanaColors.primarySurface,
                        borderRadius: BorderRadius.circular(Radii.lg),
                        border: Border.all(
                            color: MovanaColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.notes_rounded,
                              size: 16, color: MovanaColors.primary),
                          const SizedBox(width: Spacing.sm),
                          Expanded(
                            child: Text(_booking.notes!,
                                style: MovanaTextStyles.bodyMD.copyWith(
                                    color: MovanaColors.inkMedium)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Cancellation Policy ───────────────────
                  const SizedBox(height: Spacing.xxl),
                  const Divider(),
                  const SizedBox(height: Spacing.xxl),
                  const Text('Cancellation Policy',
                      style: MovanaTextStyles.headingSM),
                  const SizedBox(height: Spacing.md),
                  Container(
                    padding: const EdgeInsets.all(Spacing.lg),
                    decoration: BoxDecoration(
                      color: MovanaColors.warning.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(Radii.lg),
                      border: Border.all(
                          color: MovanaColors.warning.withOpacity(0.25)),
                    ),
                    child: Column(
                      children: [
                        _PolicyRow(
                          icon: Icons.check_circle_outline,
                          color: MovanaColors.success,
                          text:
                              'Free cancellation up to 24 hours before check-in.',
                        ),
                        const SizedBox(height: Spacing.sm),
                        _PolicyRow(
                          icon: Icons.info_outline,
                          color: MovanaColors.warning,
                          text:
                              'Cancellations within 24 hours may incur a 50% fee.',
                        ),
                        const SizedBox(height: Spacing.sm),
                        _PolicyRow(
                          icon: Icons.cancel_outlined,
                          color: MovanaColors.error,
                          text:
                              'No refund for cancellations after check-in.',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xxxl),
                ],
              ),
            ),
          ),
        ],
      ),

      // ── Bottom Action Bar ───────────────────────────
      bottomNavigationBar: canCancel
          ? Container(
              padding: EdgeInsets.fromLTRB(
                Spacing.page,
                Spacing.md,
                Spacing.page,
                Spacing.md + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(
                color: MovanaColors.white,
                border:
                    Border(top: BorderSide(color: MovanaColors.border)),
              ),
              child: MovanaButton(
                label: 'Cancel Booking',
                isOutlined: true,
                color: MovanaColors.error,
                icon: const Icon(Icons.cancel_outlined, size: 18),
                onPressed: _showCancelSheet,
              ),
            )
          : isOngoing
              ? Container(
                  padding: EdgeInsets.fromLTRB(
                    Spacing.page,
                    Spacing.md,
                    Spacing.page,
                    Spacing.md + MediaQuery.of(context).padding.bottom,
                  ),
                  decoration: const BoxDecoration(
                    color: MovanaColors.white,
                    border: Border(
                        top: BorderSide(color: MovanaColors.border)),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: MovanaColors.primarySurface,
                      borderRadius: BorderRadius.circular(Radii.md),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_car_rounded,
                            size: 18, color: MovanaColors.primary),
                        SizedBox(width: Spacing.sm),
                        Text(
                          'Rental is currently ongoing',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: MovanaColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : null,
    );
  }
}

// ──────────────────────────────────────────────
// Status Timeline
// ──────────────────────────────────────────────
class _StatusTimeline extends StatelessWidget {
  final BookingStatus status;
  const _StatusTimeline({required this.status});

  static const _steps = [
    (BookingStatus.pending, Icons.pending_outlined, 'Requested'),
    (BookingStatus.confirmed, Icons.check_circle_outline, 'Confirmed'),
    (BookingStatus.ongoing, Icons.directions_car_outlined, 'Ongoing'),
    (BookingStatus.completed, Icons.verified_outlined, 'Completed'),
  ];

  int get _currentStep {
    switch (status) {
      case BookingStatus.pending:
        return 0;
      case BookingStatus.confirmed:
        return 1;
      case BookingStatus.ongoing:
        return 2;
      case BookingStatus.completed:
        return 3;
      case BookingStatus.cancelled:
        return -1;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (status == BookingStatus.cancelled) {
      return Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: MovanaColors.error.withOpacity(0.06),
          borderRadius: BorderRadius.circular(Radii.lg),
          border:
              Border.all(color: MovanaColors.error.withOpacity(0.25)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_rounded,
                size: 20, color: MovanaColors.error),
            SizedBox(width: Spacing.sm),
            Text(
              'This booking was cancelled',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: MovanaColors.error,
              ),
            ),
          ],
        ),
      );
    }

    final step = _currentStep;

    return Row(
      children: List.generate(_steps.length * 2 - 1, (i) {
        if (i.isOdd) {
          final lineIdx = i ~/ 2;
          final filled = lineIdx < step;
          return Expanded(
            child: Container(
              height: 2,
              color: filled ? MovanaColors.primary : MovanaColors.border,
            ),
          );
        }
        final idx = i ~/ 2;
        final done = idx < step;
        final active = idx == step;
        final color = done || active
            ? MovanaColors.primary
            : MovanaColors.border;

        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: done
                    ? MovanaColors.primary
                    : active
                        ? MovanaColors.primarySurface
                        : MovanaColors.surface,
                shape: BoxShape.circle,
                border: Border.all(color: color, width: 1.5),
              ),
              child: Icon(
                done ? Icons.check_rounded : _steps[idx].$2,
                size: 16,
                color: done
                    ? Colors.white
                    : active
                        ? MovanaColors.primary
                        : MovanaColors.inkLight,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _steps[idx].$3,
              style: MovanaTextStyles.bodySM.copyWith(
                color: active || done
                    ? MovanaColors.primary
                    : MovanaColors.inkLight,
                fontWeight:
                    active ? FontWeight.w700 : FontWeight.w400,
                fontSize: 10,
              ),
            ),
          ],
        );
      }),
    );
  }
}

// ──────────────────────────────────────────────
// Cancel Booking Bottom Sheet
// ──────────────────────────────────────────────
class _CancelBookingSheet extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback onConfirm;
  const _CancelBookingSheet(
      {required this.booking, required this.onConfirm});

  @override
  State<_CancelBookingSheet> createState() => _CancelBookingSheetState();
}

class _CancelBookingSheetState extends State<_CancelBookingSheet> {
  String? _reason;

  static const _reasons = [
    'Change of plans',
    'Found a better option',
    'Vehicle no longer needed',
    'Pricing concern',
    'Other',
  ];

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
      child: SingleChildScrollView(
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
            const SizedBox(height: Spacing.xl),
            Center(
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: MovanaColors.error.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.cancel_rounded,
                    size: 30, color: MovanaColors.error),
              ),
            ),
            const SizedBox(height: Spacing.lg),
            const Center(
              child: Text('Cancel Booking?',
                  style: MovanaTextStyles.displayMD),
            ),
            const SizedBox(height: Spacing.sm),
            Center(
              child: Text(
                'Please select a reason for cancellation.',
                style: MovanaTextStyles.bodyMD,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xxl),
            Text('Reason for cancellation',
                style: MovanaTextStyles.labelMD),
            const SizedBox(height: Spacing.md),
            ..._reasons.map((r) => GestureDetector(
                  onTap: () => setState(() => _reason = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: Spacing.sm),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg, vertical: Spacing.md),
                    decoration: BoxDecoration(
                      color: _reason == r
                          ? MovanaColors.error.withOpacity(0.06)
                          : MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: _reason == r
                            ? MovanaColors.error.withOpacity(0.4)
                            : MovanaColors.border,
                        width: _reason == r ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            r,
                            style: MovanaTextStyles.bodyMD.copyWith(
                              color: _reason == r
                                  ? MovanaColors.error
                                  : MovanaColors.inkMedium,
                            ),
                          ),
                        ),
                        if (_reason == r)
                          const Icon(Icons.check_circle_rounded,
                              size: 16, color: MovanaColors.error),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: Spacing.lg),
            MovanaButton(
              label: 'Confirm Cancellation',
              color: MovanaColors.error,
              onPressed: _reason != null ? widget.onConfirm : null,
              icon: const Icon(Icons.cancel_outlined, size: 18),
            ),
            const SizedBox(height: Spacing.sm),
            MovanaButton(
              label: 'Keep Booking',
              isOutlined: true,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────────
class _DateCard extends StatelessWidget {
  final String label;
  final String date;
  final IconData icon;
  const _DateCard(
      {required this.label, required this.date, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: MovanaColors.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: MovanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: MovanaColors.inkLight),
              const SizedBox(width: 4),
              Text(label, style: MovanaTextStyles.bodySM),
            ],
          ),
          const SizedBox(height: 4),
          Text(date,
              style: MovanaTextStyles.labelMD,
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isTotal;
  const _PriceRow(
      {required this.label, required this.value, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: isTotal
                ? MovanaTextStyles.labelLG
                : MovanaTextStyles.bodyMD,
          ),
        ),
        Text(
          value,
          style: isTotal
              ? MovanaTextStyles.labelLG.copyWith(
                  color: MovanaColors.primary,
                  fontFamily: 'Syne',
                  fontSize: 18,
                )
              : MovanaTextStyles.labelMD
                  .copyWith(color: MovanaColors.inkMedium),
        ),
      ],
    );
  }
}

class _PolicyRow extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;
  const _PolicyRow(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: Spacing.sm),
        Expanded(
          child: Text(text,
              style:
                  MovanaTextStyles.bodyMD.copyWith(color: color)),
        ),
      ],
    );
  }
}

class _ContactBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ContactBtn({required this.icon, required this.onTap});

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
