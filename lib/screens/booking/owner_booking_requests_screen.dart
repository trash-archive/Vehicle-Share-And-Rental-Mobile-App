import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

class OwnerBookingRequestsScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const OwnerBookingRequestsScreen({super.key, required this.vehicle});

  @override
  State<OwnerBookingRequestsScreen> createState() =>
      _OwnerBookingRequestsScreenState();
}

class _OwnerBookingRequestsScreenState
    extends State<OwnerBookingRequestsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  late List<BookingModel> _requests;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _requests = List.of(
      MockData.ownerIncomingRequests
          .where((r) => r.vehicleId == widget.vehicle.id),
    );
  }

  List<BookingModel> get _pending =>
      _requests.where((r) => r.status == BookingStatus.pending).toList();

  List<BookingModel> get _handled => _requests
      .where((r) =>
          r.status == BookingStatus.confirmed ||
          r.status == BookingStatus.cancelled)
      .toList();

  void _onDecision(BookingModel booking, bool accepted) {
    setState(() {
      final idx = _requests.indexWhere((r) => r.id == booking.id);
      if (idx == -1) return;
      _requests[idx] = BookingModel(
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
        status: accepted ? BookingStatus.confirmed : BookingStatus.cancelled,
        notes: booking.notes,
      );
    });
    // Move to Handled tab
    _tabCtrl.animateTo(1);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          accepted
              ? '✅ Booking confirmed for ${booking.renterName}!'
              : '❌ Booking declined for ${booking.renterName}.',
        ),
        backgroundColor:
            accepted ? MovanaColors.success : MovanaColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Booking Requests', style: MovanaTextStyles.headingSM),
            Text(
              widget.vehicle.name,
              style: MovanaTextStyles.bodySM
                  .copyWith(color: MovanaColors.primary),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: MovanaColors.primary,
          unselectedLabelColor: MovanaColors.inkLight,
          indicatorColor: MovanaColors.primary,
          indicatorWeight: 2,
          labelStyle: MovanaTextStyles.labelMD,
          tabs: [
            Tab(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Pending'),
                  if (_pending.isNotEmpty) ...[
                    const SizedBox(width: 6),
                    _TabBadge(_pending.length),
                  ],
                ],
              ),
            ),
            const Tab(text: 'Handled'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _pending.isEmpty
              ? const EmptyState(
                  emoji: '📭',
                  title: 'No pending requests',
                  subtitle:
                      'New booking requests for this vehicle will appear here.',
                )
              : _RequestList(
                  requests: _pending,
                  onDecision: _onDecision,
                ),
          _handled.isEmpty
              ? const EmptyState(
                  emoji: '📋',
                  title: 'Nothing handled yet',
                  subtitle: 'Accepted and declined requests will appear here.',
                )
              : _RequestList(
                  requests: _handled,
                  onDecision: null,
                ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Request List
// ──────────────────────────────────────────────
class _RequestList extends StatelessWidget {
  final List<BookingModel> requests;
  final void Function(BookingModel, bool)? onDecision;

  const _RequestList({required this.requests, required this.onDecision});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(Spacing.page),
      itemCount: requests.length,
      separatorBuilder: (_, __) => const SizedBox(height: Spacing.lg),
      itemBuilder: (_, i) => _RequestCard(
        booking: requests[i],
        onDecision: onDecision,
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Request Card
// ──────────────────────────────────────────────
class _RequestCard extends StatelessWidget {
  final BookingModel booking;
  final void Function(BookingModel, bool)? onDecision;

  const _RequestCard({required this.booking, required this.onDecision});

  String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final avatar = MockData.renterAvatars[booking.renterId] ??
        'https://i.pravatar.cc/150?img=1';
    final isPending = booking.status == BookingStatus.pending;
    final isConfirmed = booking.status == BookingStatus.confirmed;

    return Container(
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: isPending
              ? MovanaColors.warning.withOpacity(0.4)
              : MovanaColors.border,
        ),
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
          // ── Header ─────────────────────────────
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(avatar),
                  backgroundColor: MovanaColors.surface,
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(booking.renterName,
                          style: MovanaTextStyles.labelLG),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time_rounded,
                              size: 12, color: MovanaColors.inkLight),
                          const SizedBox(width: 4),
                          Text(
                            'Requested just now',
                            style: MovanaTextStyles.bodySM,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                BookingStatusChip(booking.status),
              ],
            ),
          ),
          const Divider(height: 1),

          // ── Booking Details ─────────────────────
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              children: [
                _DetailRow(
                  icon: Icons.calendar_today_outlined,
                  label: 'Check-in',
                  value: _fmt(booking.startDate),
                ),
                const SizedBox(height: Spacing.sm),
                _DetailRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Check-out',
                  value: _fmt(booking.endDate),
                ),
                const SizedBox(height: Spacing.sm),
                _DetailRow(
                  icon: Icons.timelapse_rounded,
                  label: 'Duration',
                  value:
                      '${booking.durationDays} day${booking.durationDays != 1 ? 's' : ''}',
                ),
                const SizedBox(height: Spacing.sm),
                _DetailRow(
                  icon: Icons.payments_outlined,
                  label: 'Total',
                  value: '₱${booking.totalPrice.toStringAsFixed(0)}',
                  valueStyle: MovanaTextStyles.labelLG.copyWith(
                    color: MovanaColors.primary,
                    fontFamily: 'Syne',
                  ),
                ),
                if (booking.notes != null && booking.notes!.isNotEmpty) ...[
                  const SizedBox(height: Spacing.md),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(color: MovanaColors.border),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes_rounded,
                            size: 14, color: MovanaColors.inkLight),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            booking.notes!,
                            style: MovanaTextStyles.bodyMD,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Action Buttons (pending only) ───────
          if (isPending && onDecision != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(Spacing.lg),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showDeclineSheet(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: MovanaColors.error,
                        side: const BorderSide(color: MovanaColors.error),
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.md)),
                      ),
                      child: const Text('Decline'),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => _showAcceptSheet(context),
                      style: ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Radii.md)),
                        textStyle: MovanaTextStyles.labelMD,
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Confirmed indicator ─────────────────
          if (isConfirmed) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.lg, vertical: Spacing.md),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded,
                      size: 16, color: MovanaColors.success),
                  const SizedBox(width: Spacing.sm),
                  Text(
                    'You accepted this booking',
                    style: MovanaTextStyles.labelSM
                        .copyWith(color: MovanaColors.success),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showAcceptSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DecisionSheet(
        booking: booking,
        isAccept: true,
        onConfirm: () {
          Navigator.pop(context);
          onDecision!(booking, true);
        },
      ),
    );
  }

  void _showDeclineSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _DecisionSheet(
        booking: booking,
        isAccept: false,
        onConfirm: () {
          Navigator.pop(context);
          onDecision!(booking, false);
        },
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Accept / Decline Bottom Sheet
// ──────────────────────────────────────────────
class _DecisionSheet extends StatefulWidget {
  final BookingModel booking;
  final bool isAccept;
  final VoidCallback onConfirm;

  const _DecisionSheet({
    required this.booking,
    required this.isAccept,
    required this.onConfirm,
  });

  @override
  State<_DecisionSheet> createState() => _DecisionSheetState();
}

class _DecisionSheetState extends State<_DecisionSheet> {
  String? _selectedReason;

  static const _declineReasons = [
    'Vehicle not available on these dates',
    'Renter does not meet requirements',
    'Conflicting schedule',
    'Other reason',
  ];

  String _fmt(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final isAccept = widget.isAccept;
    final b = widget.booking;
    final color = isAccept ? MovanaColors.success : MovanaColors.error;

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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
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

          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isAccept
                  ? Icons.check_circle_rounded
                  : Icons.cancel_rounded,
              size: 32,
              color: color,
            ),
          ),
          const SizedBox(height: Spacing.lg),

          Text(
            isAccept ? 'Accept Booking?' : 'Decline Booking?',
            style: MovanaTextStyles.displayMD,
          ),
          const SizedBox(height: Spacing.sm),
          Text(
            isAccept
                ? 'You\'re confirming ${b.renterName}\'s booking request.'
                : 'Let ${b.renterName} know why you\'re declining.',
            style: MovanaTextStyles.bodyMD,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxl),

          // Booking summary
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(color: MovanaColors.border),
            ),
            child: Column(
              children: [
                InfoRow(label: 'Renter', value: b.renterName),
                const Divider(),
                InfoRow(
                    label: 'Dates',
                    value:
                        '${_fmt(b.startDate)} – ${_fmt(b.endDate)}'),
                const Divider(),
                InfoRow(
                  label: 'Total',
                  value: '',
                  trailing: Text(
                    '₱${b.totalPrice.toStringAsFixed(0)}',
                    style: MovanaTextStyles.labelLG.copyWith(
                      color: MovanaColors.primary,
                      fontFamily: 'Syne',
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.lg),

          // Decline reason picker
          if (!isAccept) ...[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('Reason', style: MovanaTextStyles.labelMD),
            ),
            const SizedBox(height: Spacing.sm),
            ...(_declineReasons.map((r) => GestureDetector(
                  onTap: () => setState(() => _selectedReason = r),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(bottom: Spacing.sm),
                    padding: const EdgeInsets.symmetric(
                        horizontal: Spacing.lg, vertical: Spacing.md),
                    decoration: BoxDecoration(
                      color: _selectedReason == r
                          ? MovanaColors.error.withOpacity(0.06)
                          : MovanaColors.surface,
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: _selectedReason == r
                            ? MovanaColors.error.withOpacity(0.4)
                            : MovanaColors.border,
                        width: _selectedReason == r ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(r,
                                style: MovanaTextStyles.bodyMD
                                    .copyWith(
                                        color: _selectedReason == r
                                            ? MovanaColors.error
                                            : MovanaColors.inkMedium))),
                        if (_selectedReason == r)
                          const Icon(Icons.check_circle_rounded,
                              size: 16,
                              color: MovanaColors.error),
                      ],
                    ),
                  ),
                ))),
            const SizedBox(height: Spacing.sm),
          ],

          const SizedBox(height: Spacing.md),

          // Confirm button
          MovanaButton(
            label: isAccept ? 'Confirm Acceptance' : 'Confirm Decline',
            color: color,
            onPressed: widget.onConfirm,
            icon: Icon(
              isAccept ? Icons.check_rounded : Icons.close_rounded,
              size: 18,
            ),
          ),
          const SizedBox(height: Spacing.sm),
          MovanaButton(
            label: 'Go Back',
            isOutlined: true,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Helpers
// ──────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final TextStyle? valueStyle;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14, color: MovanaColors.inkLight),
        const SizedBox(width: Spacing.sm),
        Text(label, style: MovanaTextStyles.bodyMD),
        const Spacer(),
        Text(
          value,
          style: valueStyle ??
              MovanaTextStyles.labelMD
                  .copyWith(color: MovanaColors.inkMedium),
        ),
      ],
    );
  }
}

class _TabBadge extends StatelessWidget {
  final int count;
  const _TabBadge(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: MovanaColors.warning,
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
    );
  }
}
