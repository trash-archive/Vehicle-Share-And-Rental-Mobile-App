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

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  List<BookingModel> _filter(List<BookingStatus> statuses) =>
      MockData.bookings.where((b) => statuses.contains(b.status)).toList();

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
          ),
          _BookingList(
            bookings: _filter([BookingStatus.confirmed]),
          ),
          _BookingList(
            bookings:
                _filter([BookingStatus.completed, BookingStatus.cancelled]),
          ),
        ],
      ),
    );
  }
}

class _BookingList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _BookingList({required this.bookings});

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
      itemBuilder: (_, i) => _BookingCard(booking: bookings[i]),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final BookingModel booking;
  const _BookingCard({required this.booking});

  String _fmt(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}';
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
                        onPressed: () {},
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
