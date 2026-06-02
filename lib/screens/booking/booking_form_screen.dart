import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import 'booking_confirmation_screen.dart';

class BookingFormScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const BookingFormScreen({super.key, required this.vehicle});

  @override
  State<BookingFormScreen> createState() => _BookingFormScreenState();
}

class _BookingFormScreenState extends State<BookingFormScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final _notesCtrl = TextEditingController();
  bool _loading = false;

  VehicleModel get v => widget.vehicle;

  int get _days {
    if (_startDate == null || _endDate == null) return 0;
    return _endDate!.difference(_startDate!).inDays;
  }

  double get _subtotal => _days * v.pricePerDay;
  double get _fee => _subtotal * 0.05;
  double get _total => _subtotal + _fee;

  void _pickDate(bool isStart) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: isStart
          ? (now)
          : (_startDate?.add(const Duration(days: 1)) ?? now),
      firstDate: now,
      lastDate: now.add(const Duration(days: 90)),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: MovanaColors.primary,
            onPrimary: Colors.white,
          ),
        ),
        child: child!,
      ),
    );
    if (date == null) return;
    setState(() {
      if (isStart) {
        _startDate = date;
        if (_endDate != null && _endDate!.isBefore(date)) {
          _endDate = date.add(const Duration(days: 1));
        }
      } else {
        _endDate = date;
      }
    });
  }

  void _confirmBooking() async {
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select rental dates')),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _loading = false);
      _showConfirmationSheet();
    }
  }

  /// Generates a short booking reference like "MOV-B3F2A"
  String _generateRef() {
    final chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final buf = StringBuffer('MOV-');
    final now = DateTime.now().millisecondsSinceEpoch;
    for (var i = 0; i < 5; i++) {
      buf.write(chars[(now >> (i * 4)) % chars.length]);
    }
    return buf.toString();
  }

  void _showConfirmationSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _BookingConfirmationSheet(
        vehicle: v,
        startDate: _startDate!,
        endDate: _endDate!,
        total: _total,
        onConfirm: () {
          Navigator.pop(context); // close sheet
          // Navigate to the full confirmation screen, replacing booking form
          // and detail so the back stack lands on the shell.
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => BookingConfirmationScreen(
                vehicle: v,
                startDate: _startDate!,
                endDate: _endDate!,
                total: _total,
                bookingRef: _generateRef(),
              ),
            ),
          );
        },
      ),
    );
  }

  String _fmt(DateTime? dt) {
    if (dt == null) return 'Select date';
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Book Vehicle'),
        leading: const BackButton(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Spacing.page),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Vehicle mini card
            Container(
              padding: const EdgeInsets.all(Spacing.md),
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
                      v.imageUrls.first,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 72,
                        height: 72,
                        color: MovanaColors.border,
                      ),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(v.name, style: MovanaTextStyles.labelLG),
                        Text(v.location, style: MovanaTextStyles.bodyMD),
                        const SizedBox(height: 4),
                        Text(
                          '₱${v.pricePerDay.toStringAsFixed(0)}/day',
                          style: MovanaTextStyles.labelMD.copyWith(
                              color: MovanaColors.primary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // Date selection
            const Text('Select Rental Dates', style: MovanaTextStyles.headingSM),
            const SizedBox(height: Spacing.md),
            Row(
              children: [
                Expanded(
                  child: _DatePickerCard(
                    label: 'Start Date',
                    date: _fmt(_startDate),
                    icon: Icons.flight_takeoff_rounded,
                    hasValue: _startDate != null,
                    onTap: () => _pickDate(true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    width: 32,
                    height: 1,
                    color: MovanaColors.border,
                  ),
                ),
                Expanded(
                  child: _DatePickerCard(
                    label: 'End Date',
                    date: _fmt(_endDate),
                    icon: Icons.flight_land_rounded,
                    hasValue: _endDate != null,
                    onTap: () => _pickDate(false),
                  ),
                ),
              ],
            ),
            if (_days > 0) ...[
              const SizedBox(height: Spacing.sm),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: MovanaColors.primarySurface,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                  child: Text(
                    '$_days day${_days != 1 ? 's' : ''} rental',
                    style: MovanaTextStyles.labelSM
                        .copyWith(color: MovanaColors.primary),
                  ),
                ),
              ),
            ],
            const SizedBox(height: Spacing.xxl),

            // Notes
            const Text('Notes to Owner', style: MovanaTextStyles.headingSM),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _notesCtrl,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Any special requests or notes for the owner...',
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // Price breakdown
            if (_days > 0) ...[
              const Text('Price Breakdown', style: MovanaTextStyles.headingSM),
              const SizedBox(height: Spacing.md),
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: MovanaColors.surface,
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(color: MovanaColors.border),
                ),
                child: Column(
                  children: [
                    InfoRow(
                      label: '₱${v.pricePerDay.toStringAsFixed(0)} × $_days day${_days != 1 ? 's' : ''}',
                      value: '₱${_subtotal.toStringAsFixed(0)}',
                    ),
                    const Divider(),
                    InfoRow(
                      label: 'Platform fee (5%)',
                      value: '₱${_fee.toStringAsFixed(0)}',
                    ),
                    const Divider(),
                    InfoRow(
                      label: 'Total',
                      value: '₱${_total.toStringAsFixed(0)}',
                      trailing: Text(
                        '₱${_total.toStringAsFixed(0)}',
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
              const SizedBox(height: Spacing.lg),
              // Info note
              Container(
                padding: const EdgeInsets.all(Spacing.md),
                decoration: BoxDecoration(
                  color: MovanaColors.info.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(Radii.md),
                  border: Border.all(
                      color: MovanaColors.info.withOpacity(0.2)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline,
                        size: 16, color: MovanaColors.info),
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: Text(
                        'Booking is subject to owner approval. You won\'t be charged until confirmed.',
                        style: MovanaTextStyles.bodySM.copyWith(
                            color: MovanaColors.info),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: Spacing.xxxl),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(Spacing.page, Spacing.md, Spacing.page,
            Spacing.md + MediaQuery.of(context).padding.bottom),
        decoration: const BoxDecoration(
          color: MovanaColors.white,
          border: Border(top: BorderSide(color: MovanaColors.border)),
        ),
        child: MovanaButton(
          label: 'Send Booking Request',
          onPressed: _confirmBooking,
          isLoading: _loading,
          icon: const Icon(Icons.send_rounded, size: 18),
        ),
      ),
    );
  }
}

class _DatePickerCard extends StatelessWidget {
  final String label;
  final String date;
  final IconData icon;
  final bool hasValue;
  final VoidCallback onTap;

  const _DatePickerCard({
    required this.label,
    required this.date,
    required this.icon,
    required this.hasValue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: hasValue ? MovanaColors.primarySurface : MovanaColors.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(
            color: hasValue ? MovanaColors.primary : MovanaColors.border,
            width: hasValue ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: hasValue
                      ? MovanaColors.primary
                      : MovanaColors.inkLight,
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: MovanaTextStyles.bodySM.copyWith(
                    color: hasValue
                        ? MovanaColors.primary
                        : MovanaColors.inkLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              date,
              style: MovanaTextStyles.labelMD.copyWith(
                color: hasValue
                    ? MovanaColors.primary
                    : MovanaColors.inkLight,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Booking Confirmation Sheet
// ──────────────────────────────────────────────
class _BookingConfirmationSheet extends StatelessWidget {
  final VehicleModel vehicle;
  final DateTime startDate;
  final DateTime endDate;
  final double total;
  final VoidCallback onConfirm;

  const _BookingConfirmationSheet({
    required this.vehicle,
    required this.startDate,
    required this.endDate,
    required this.total,
    required this.onConfirm,
  });

  String _fmt(DateTime dt) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dt.month - 1]} ${dt.day}, ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xxl)),
      ),
      padding: const EdgeInsets.all(Spacing.page),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: MovanaColors.border,
              borderRadius: BorderRadius.circular(Radii.pill),
            ),
          ),
          const SizedBox(height: Spacing.xl),
          // Checkmark
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: MovanaColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 36,
              color: MovanaColors.primary,
            ),
          ),
          const SizedBox(height: Spacing.lg),
          const Text('Confirm Booking', style: MovanaTextStyles.displayMD),
          const SizedBox(height: Spacing.sm),
          Text(
            'Review your booking details before submitting.',
            style: MovanaTextStyles.bodyMD,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxl),
          // Summary
          Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(color: MovanaColors.border),
            ),
            child: Column(
              children: [
                InfoRow(label: 'Vehicle', value: vehicle.name),
                const Divider(),
                InfoRow(label: 'Start', value: _fmt(startDate)),
                const Divider(),
                InfoRow(label: 'End', value: _fmt(endDate)),
                const Divider(),
                InfoRow(
                  label: 'Total',
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
          const SizedBox(height: Spacing.xxl),
          MovanaButton(
            label: 'Confirm & Send Request',
            onPressed: onConfirm,
            icon: const Icon(Icons.check_rounded, size: 18),
          ),
          const SizedBox(height: Spacing.md),
          MovanaButton(
            label: 'Cancel',
            isOutlined: true,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(height: Spacing.lg),
        ],
      ),
    );
  }
}
