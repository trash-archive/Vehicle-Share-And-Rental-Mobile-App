import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import 'booking_detail_screen.dart';
import 'leave_review_screen.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  // Local mutable copy so cancellations reflect immediately
  late List<BookingModel> _bookings;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _bookings = List<BookingModel>.from(MockData.bookings);
  }

  List<BookingModel> _filter(List<BookingStatus> statuses) =>
      _bookings.where((b) => statuses.contains(b.status)).toList();

  void _cancelBooking(BookingModel booking) {
    setState(() {
      final idx = _bookings.indexWhere((b) => b.id == booking.id);
      if (idx != -1) {
        _bookings[idx] = BookingModel(
          id: booking.id,
          vehicleId: booking.vehicleId,
          vehicleName: booking.vehicleName,
          vehicleImage: booking.vehicleImage,
          renterId: booking.renterId,
          renterName: booking.renterName,
          ownerId: booking.ownerId,
          ownerName: booking.ownerName,
          startDate: booking.startDate,
          endDate: booking.endDate,
          totalPrice: booking.totalPrice,
          status: BookingStatus.cancelled,
          notes: booking.notes,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('My Bookings',
            style: MovanaTextStyles.displayMD),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: MovanaColors.primary,
          unselectedLabelColor: MovanaColors.inkLight,
          indicatorColor: MovanaColors.primary,
          indicatorWeight: 2,
          labelStyle: MovanaTextStyles.labelMD,
          unselectedLabelStyle: MovanaTextStyles.bodyMD,
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Upcoming'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _BookingList(
            bookings: _filter([BookingStatus.ongoing, BookingStatus.pending]),
            onCancel: _cancelBooking,
          ),
          _BookingList(
            bookings: _filter([BookingStatus.confirmed]),
            onCancel: _cancelBooking,
          ),
          _BookingList(
            bookings:
                _filter([BookingStatus.completed, BookingStatus.cancelled]),
            onCancel: _cancelBooking,
          ),
        ],
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  final ValueChanged<BookingModel> onCancel;
  const _BookingList({required this.bookings, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(
        emoji: '📋',
        title: 'No bookings here',
        subtitle: 'Your bookings will appear here once you rent a vehicle.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.page),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.lg),
      itemBuilder: (_, i) =>
          _BookingCard(booking: bookings[i], onCancel: onCancel),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  final ValueChanged<BookingModel> onCancel;
  const _BookingCard({required this.booking, required this.onCancel});

  String _fmt(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
  }

  void _showCancelSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _QuickCancelSheet(
        booking: booking,
        onConfirm: () {
          Navigator.pop(context);
          onCancel(booking);
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
    return Container(
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
          // Image + overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Radii.lg)),
                child: Image.network(
                  booking.vehicleImage,
                  height: 140,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 140,
                    color: MovanaColors.surface,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: BookingStatusChip(booking.status),
              ),
              // Pending label overlay
              if (booking.status == BookingStatus.pending)
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 12, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Awaiting owner approval',
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 11,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(booking.vehicleName, style: MovanaTextStyles.headingSM),
                const SizedBox(height: 4),
                Text('Owner: ${booking.ownerName}',
                    style: MovanaTextStyles.bodyMD),
                const SizedBox(height: Spacing.md),
                // Date row
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined,
                        size: 14, color: MovanaColors.inkLight),
                    const SizedBox(width: 4),
                    Text(
                      '${_fmt(booking.startDate)} – ${_fmt(booking.endDate)}, ${booking.endDate.year}',
                      style: MovanaTextStyles.labelMD
                          .copyWith(color: MovanaColors.inkMedium),
                    ),
                    const Spacer(),
                    Text(
                      '${booking.durationDays} days',
                      style: MovanaTextStyles.bodySM,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.sm),
                const Divider(),
                const SizedBox(height: Spacing.sm),
                Row(
                  children: [
                    Text(
                      '₱${booking.totalPrice.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: MovanaColors.primary,
                      ),
                    ),
                    Text(' total', style: MovanaTextStyles.bodyMD),
                    const Spacer(),
                    // Action buttons
                    if (booking.status == BookingStatus.pending)
                      TextButton(
                        onPressed: () => _showCancelSheet(context),
                        child: const Text('Cancel',
                            style: TextStyle(color: MovanaColors.error)),
                      ),
                    if (booking.status == BookingStatus.confirmed)
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                BookingDetailScreen(booking: booking),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MovanaColors.primary,
                          side: const BorderSide(color: MovanaColors.primary),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.pill)),
                        ),
                        child: const Text('View Details'),
                      ),
                    if (booking.status == BookingStatus.completed)
                      OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                LeaveReviewScreen(booking: booking),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MovanaColors.warning,
                          side: const BorderSide(color: MovanaColors.warning),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 8),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.pill)),
                        ),
                        child: const Text('Leave Review'),
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

// ──────────────────────────────────────────────
// Quick cancel bottom sheet (from list)
// ──────────────────────────────────────────────
class _QuickCancelSheet extends StatefulWidget {
  final BookingModel booking;
  final VoidCallback onConfirm;
  const _QuickCancelSheet({required this.booking, required this.onConfirm});

  @override
  State<_QuickCancelSheet> createState() => _QuickCancelSheetState();
}

class _QuickCancelSheetState extends State<_QuickCancelSheet> {
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
              child: Text('Cancel Booking?', style: MovanaTextStyles.displayMD),
            ),
            const SizedBox(height: Spacing.sm),
            Center(
              child: Text(
                widget.booking.vehicleName,
                style: MovanaTextStyles.bodyMD
                    .copyWith(color: MovanaColors.inkLight),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: Spacing.xxl),
            Text('Reason for cancellation', style: MovanaTextStyles.labelMD),
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
