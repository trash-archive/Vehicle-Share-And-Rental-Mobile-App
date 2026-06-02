import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../../data/mock_data.dart';

class RentalHistoryScreen extends StatefulWidget {
  const RentalHistoryScreen({super.key});

  @override
  State<RentalHistoryScreen> createState() => _RentalHistoryScreenState();
}

class _RentalHistoryScreenState extends State<RentalHistoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  // All bookings as history (completed + cancelled)
  static final _all = MockData.bookings;
  static final _completed =
      _all.where((b) => b.status == BookingStatus.completed).toList();
  static final _cancelled =
      _all.where((b) => b.status == BookingStatus.cancelled).toList();

  double get _totalSpent => _completed.fold(0, (s, b) => s + b.totalPrice);
  int get _totalRentals => _completed.length;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Rental History', style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: MovanaColors.primary,
          unselectedLabelColor: MovanaColors.inkLight,
          indicatorColor: MovanaColors.primary,
          indicatorWeight: 2,
          labelStyle: MovanaTextStyles.labelMD,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Completed'),
            Tab(text: 'Cancelled'),
          ],
        ),
      ),
      body: Column(
        children: [
          // ── Summary banner ──────────────────────────
          Container(
            margin: const EdgeInsets.all(Spacing.page),
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MovanaColors.primaryDark, MovanaColors.primary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Radii.lg),
            ),
            child: Row(
              children: [
                _SummaryItem(
                  value: '$_totalRentals',
                  label: 'Total Rentals',
                ),
                Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withOpacity(0.3)),
                _SummaryItem(
                  value: '₱${_totalSpent.toStringAsFixed(0)}',
                  label: 'Total Spent',
                ),
                Container(
                    width: 1,
                    height: 36,
                    color: Colors.white.withOpacity(0.3)),
                _SummaryItem(
                  value: _completed.isEmpty
                      ? 'N/A'
                      : '${(_completed.map((b) => b.durationDays).reduce((a, b) => a + b))} days',
                  label: 'Days Rented',
                ),
              ],
            ),
          ),

          // ── Tab content ─────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _HistoryList(bookings: _all),
                _HistoryList(bookings: _completed),
                _HistoryList(bookings: _cancelled),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HistoryList extends StatelessWidget {
  final List<BookingModel> bookings;
  const _HistoryList({required this.bookings});

  @override
  Widget build(BuildContext context) {
    if (bookings.isEmpty) {
      return const EmptyState(
        emoji: '📋',
        title: 'No rentals here',
        subtitle: 'Your rental records will appear here.',
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
          Spacing.page, 0, Spacing.page, Spacing.page),
      itemCount: bookings.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.md),
      itemBuilder: (_, i) => _HistoryCard(booking: bookings[i]),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final BookingModel booking;
  const _HistoryCard({required this.booking});

  String _fmt(DateTime dt) {
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
            color: MovanaColors.ink.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(Radii.lg)),
            child: Image.network(
              booking.vehicleImage,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 100,
                height: 100,
                color: MovanaColors.surface,
              ),
            ),
          ),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(booking.vehicleName,
                            style: MovanaTextStyles.labelLG,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                      BookingStatusChip(booking.status),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text('Owner: ${booking.ownerName}',
                      style: MovanaTextStyles.bodyMD),
                  const SizedBox(height: Spacing.sm),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          size: 12, color: MovanaColors.inkLight),
                      const SizedBox(width: 4),
                      Text(
                        '${_fmt(booking.startDate)} – ${_fmt(booking.endDate)}',
                        style: MovanaTextStyles.bodySM,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        '₱${booking.totalPrice.toStringAsFixed(0)}',
                        style: MovanaTextStyles.labelMD.copyWith(
                          color: MovanaColors.primary,
                          fontFamily: 'Syne',
                        ),
                      ),
                      Text(
                        ' • ${booking.durationDays} day${booking.durationDays != 1 ? 's' : ''}',
                        style: MovanaTextStyles.bodySM,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String value;
  final String label;
  const _SummaryItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Syne',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
