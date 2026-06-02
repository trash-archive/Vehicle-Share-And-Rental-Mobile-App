import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';
import '../booking/owner_booking_requests_screen.dart';
import 'edit_vehicle_screen.dart';
import 'vehicle_verification_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('My Listings', style: MovanaTextStyles.displayMD),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Spacing.page),
            child: ElevatedButton.icon(
              onPressed: _showAddVehicleSheet,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.lg, vertical: Spacing.sm),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Radii.pill)),
                textStyle: MovanaTextStyles.labelSM,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: MovanaColors.primary,
          unselectedLabelColor: MovanaColors.inkLight,
          indicatorColor: MovanaColors.primary,
          indicatorWeight: 2,
          labelStyle: MovanaTextStyles.labelMD,
          tabs: const [
            Tab(text: 'Listings'),
            Tab(text: 'Earnings'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _ListingsTab(),
          _EarningsTab(),
        ],
      ),
    );
  }

  void _showAddVehicleSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddVehicleSheet(),
    );
  }
}

// ──────────────────────────────────────────────
// Listings Tab
// ──────────────────────────────────────────────
class _ListingsTab extends StatelessWidget {
  // Use first 2 vehicles as "owner's listings"
  final _myVehicles = [MockData.vehicles[0], MockData.vehicles[1]];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.page),
      children: [
        // Summary cards
        Row(
          children: [
            _SummaryCard(
              label: 'Active',
              value: '${MockData.ownerStats['activeListings']}',
              icon: Icons.check_circle_outline,
              color: MovanaColors.success,
            ),
            const SizedBox(width: Spacing.md),
            _SummaryCard(
              label: 'Pending',
              value: '${MockData.ownerStats['pendingApprovals']}',
              icon: Icons.pending_outlined,
              color: MovanaColors.warning,
            ),
            const SizedBox(width: Spacing.md),
            _SummaryCard(
              label: 'Avg Rating',
              value: '${MockData.ownerStats['avgRating']}★',
              icon: Icons.star_outline,
              color: MovanaColors.accent,
            ),
          ],
        ),
        const SizedBox(height: Spacing.xxl),
        const SectionHeader(title: 'Your Vehicles'),
        const SizedBox(height: Spacing.md),
        ..._myVehicles.map((v) => Padding(
          padding: const EdgeInsets.only(bottom: Spacing.lg),
          child: _OwnerVehicleCard(vehicle: v),
        )),
      ],
    );
  }
}

class _OwnerVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;
  const _OwnerVehicleCard({required this.vehicle});

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
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(Radii.lg)),
                child: Image.network(
                  vehicle.imageUrls.first,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 160,
                    color: MovanaColors.surface,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Row(
                  children: [
                    if (vehicle.isVerified)
                      _SmallBadge(
                        label: 'Verified',
                        color: MovanaColors.success,
                        icon: Icons.verified,
                      ),
                    const SizedBox(width: 6),
                    _SmallBadge(
                      label: vehicle.isAvailable ? 'Live' : 'Paused',
                      color: vehicle.isAvailable
                          ? MovanaColors.primary
                          : MovanaColors.inkLight,
                      icon: vehicle.isAvailable
                          ? Icons.circle
                          : Icons.pause_circle_outline,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(vehicle.name, style: MovanaTextStyles.headingSM),
                    ),
                    Text(
                      '₱${vehicle.pricePerDay.toStringAsFixed(0)}/day',
                      style: MovanaTextStyles.labelLG.copyWith(
                        color: MovanaColors.primary,
                        fontFamily: 'Syne',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(vehicle.location, style: MovanaTextStyles.bodyMD),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    _StatPill(
                      icon: Icons.star_rounded,
                      value: '${vehicle.rating}',
                      color: MovanaColors.warning,
                    ),
                    const SizedBox(width: Spacing.sm),
                    _StatPill(
                      icon: Icons.people_outline,
                      value: '${vehicle.reviewCount} rentals',
                      color: MovanaColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: Spacing.md),
                const Divider(),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                EditVehicleScreen(vehicle: vehicle),
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: MovanaColors.inkMedium,
                          side: const BorderSide(color: MovanaColors.border),
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.md)),
                        ),
                        child: const Text('Edit'),
                      ),
                    ),
                    if (!vehicle.isVerified) ...[
                      const SizedBox(width: Spacing.sm),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VehicleVerificationScreen(),
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: MovanaColors.warning,
                            side: const BorderSide(
                                color: MovanaColors.warning),
                            minimumSize: Size.zero,
                            padding:
                                const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(Radii.md)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.verified_outlined, size: 14),
                              SizedBox(width: 4),
                              Text('Verify',
                                  style: TextStyle(fontSize: 13)),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(width: Spacing.sm),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OwnerBookingRequestsScreen(
                              vehicle: vehicle,
                            ),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Radii.md)),
                          textStyle: MovanaTextStyles.labelSM,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text('View Requests'),
                            const SizedBox(width: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.25),
                                borderRadius:
                                    BorderRadius.circular(Radii.pill),
                              ),
                              child: Text(
                                '${MockData.ownerIncomingRequests.where((r) => r.vehicleId == vehicle.id && r.status == BookingStatus.pending).length}',
                                style: const TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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
// Earnings Tab
// ──────────────────────────────────────────────
class _EarningsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stats = MockData.ownerStats;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(Spacing.page),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total earnings hero
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(Spacing.xxl),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [MovanaColors.primaryDark, MovanaColors.primaryLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(Radii.xl),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Earnings',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  '₱${(stats['totalEarnings'] as double).toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: Spacing.md),
                Row(
                  children: [
                    _EarningPill('${stats['totalRentals']} rentals'),
                    const SizedBox(width: Spacing.sm),
                    _EarningPill('This month: ₱${(stats['thisMonth'] as double).toStringAsFixed(0)}'),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Spacing.xxl),
          // Recent transactions
          const SectionHeader(title: 'Recent Transactions'),
          const SizedBox(height: Spacing.md),
          if (_mockTransactions.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: Spacing.xxxl),
              child: EmptyState(
                emoji: '💸',
                title: 'No transactions yet',
                subtitle:
                    'Earnings from completed rentals will appear here.',
              ),
            )
          else
            ..._mockTransactions.map((t) => _TransactionTile(tx: t)),
        ],
      ),
    );
  }

  static const _mockTransactions = [
    _Transaction('Toyota Vios Rental', 'Maria Santos', 1800, '2 days ago', true),
    _Transaction('Honda Click Rental', 'Pedro Reyes', 500, '5 days ago', true),
    _Transaction('Platform Fee Deduction', 'Movana', -90, '5 days ago', false),
    _Transaction('Toyota Vios Rental', 'Ana Flores', 3600, '2 weeks ago', true),
  ];
}

class _Transaction {
  final String title;
  final String party;
  final double amount;
  final String date;
  final bool isCredit;
  const _Transaction(
      this.title, this.party, this.amount, this.date, this.isCredit);
}

class _TransactionTile extends StatelessWidget {
  final _Transaction tx;
  const _TransactionTile({required this.tx});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: tx.isCredit
                  ? MovanaColors.success.withOpacity(0.1)
                  : MovanaColors.error.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              tx.isCredit ? Icons.arrow_downward : Icons.arrow_upward,
              size: 20,
              color: tx.isCredit ? MovanaColors.success : MovanaColors.error,
            ),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(tx.title, style: MovanaTextStyles.labelMD),
                Text('${tx.party} • ${tx.date}',
                    style: MovanaTextStyles.bodySM),
              ],
            ),
          ),
          Text(
            '${tx.isCredit ? '+' : '-'}₱${tx.amount.abs().toStringAsFixed(0)}',
            style: MovanaTextStyles.labelLG.copyWith(
              color: tx.isCredit ? MovanaColors.success : MovanaColors.error,
              fontFamily: 'Syne',
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Add Vehicle Bottom Sheet (simplified form)
// ──────────────────────────────────────────────
class _AddVehicleSheet extends StatefulWidget {
  @override
  State<_AddVehicleSheet> createState() => _AddVehicleSheetState();
}

class _AddVehicleSheetState extends State<_AddVehicleSheet> {
  int _step = 0;

  final _steps = [
    'Basic Info',
    'Vehicle Details',
    'Photos & Pricing',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(Radii.xxl)),
      ),
      child: Column(
        children: [
          // Handle + Header
          Padding(
            padding: const EdgeInsets.all(Spacing.page),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MovanaColors.border,
                    borderRadius: BorderRadius.circular(Radii.pill),
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                Row(
                  children: [
                    const Text('List a Vehicle',
                        style: MovanaTextStyles.displayMD),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Step indicator
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Row(
              children: List.generate(_steps.length * 2 - 1, (i) {
                if (i.isOdd) {
                  return Expanded(
                    child: Container(
                      height: 2,
                      color: i ~/ 2 < _step
                          ? MovanaColors.primary
                          : MovanaColors.border,
                    ),
                  );
                }
                final idx = i ~/ 2;
                final done = idx < _step;
                final active = idx == _step;
                return Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: done
                        ? MovanaColors.primary
                        : active
                            ? MovanaColors.primarySurface
                            : MovanaColors.surface,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: active || done
                          ? MovanaColors.primary
                          : MovanaColors.border,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: done
                        ? const Icon(Icons.check, size: 14, color: Colors.white)
                        : Text(
                            '${idx + 1}',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: active
                                  ? MovanaColors.primary
                                  : MovanaColors.inkLight,
                            ),
                          ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: Spacing.lg),
          // Step labels
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Spacing.page),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _steps.asMap().entries.map((e) {
                return Text(
                  e.value,
                  style: MovanaTextStyles.bodySM.copyWith(
                    color: e.key == _step
                        ? MovanaColors.primary
                        : MovanaColors.inkLight,
                    fontWeight: e.key == _step
                        ? FontWeight.w600
                        : FontWeight.w400,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: Spacing.xxl),
          // Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.page),
              child: _StepContent(step: _step),
            ),
          ),
          // Bottom buttons
          Padding(
            padding: EdgeInsets.fromLTRB(Spacing.page, 0, Spacing.page,
                Spacing.page + MediaQuery.of(context).padding.bottom),
            child: Row(
              children: [
                if (_step > 0) ...[
                  Expanded(
                    child: MovanaButton(
                      label: 'Back',
                      isOutlined: true,
                      onPressed: () => setState(() => _step--),
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                ],
                Expanded(
                  child: MovanaButton(
                    label: _step < _steps.length - 1 ? 'Next' : 'Submit',
                    onPressed: () {
                      if (_step < _steps.length - 1) {
                        setState(() => _step++);
                      } else {
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepContent extends StatelessWidget {
  final int step;
  const _StepContent({required this.step});

  @override
  Widget build(BuildContext context) {
    if (step == 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vehicle Name', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(decoration: InputDecoration(hintText: 'e.g. Honda Click 125i')),
          const SizedBox(height: Spacing.lg),
          const Text('Category', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(),
            hint: const Text('Select category'),
            items: const [
              DropdownMenuItem(value: 'personal', child: Text('🏍️ Personal Transport')),
              DropdownMenuItem(value: 'commercial', child: Text('🚐 Commercial Vehicles')),
              DropdownMenuItem(value: 'construction', child: Text('🏗️ Construction Equipment')),
              DropdownMenuItem(value: 'agricultural', child: Text('🚜 Agricultural Equipment')),
            ],
            onChanged: (_) {},
          ),
          const SizedBox(height: Spacing.lg),
          const Text('Location', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(
            decoration: InputDecoration(
              hintText: 'Enter pick-up location',
              prefixIcon: Icon(Icons.location_on_outlined, size: 20),
            ),
          ),
        ],
      );
    }
    if (step == 1) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Vehicle Type', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(decoration: InputDecoration(hintText: 'e.g. Scooter, Sedan, Excavator')),
          const SizedBox(height: Spacing.lg),
          const Text('Year', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(
            keyboardType: TextInputType.number,
            decoration: InputDecoration(hintText: 'e.g. 2022'),
          ),
          const SizedBox(height: Spacing.lg),
          const Text('Color', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(decoration: InputDecoration(hintText: 'e.g. White')),
          const SizedBox(height: Spacing.lg),
          const Text('Plate Number', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          const TextField(decoration: InputDecoration(hintText: 'e.g. ABC 1234')),
          const SizedBox(height: Spacing.lg),
          const Text('Description', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          TextField(
            maxLines: 4,
            decoration: const InputDecoration(
              hintText: 'Describe your vehicle, condition, inclusions...',
            ),
          ),
        ],
      );
    }
    // Step 2: Photos & Pricing
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Vehicle Photos', style: MovanaTextStyles.labelMD),
        const SizedBox(height: Spacing.sm),
        Container(
          height: 120,
          decoration: BoxDecoration(
            color: MovanaColors.surface,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(
              color: MovanaColors.border,
              style: BorderStyle.solid,
            ),
          ),
          child: const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_photo_alternate_outlined,
                    size: 36, color: MovanaColors.inkLight),
                SizedBox(height: Spacing.sm),
                Text('Tap to upload photos',
                    style: MovanaTextStyles.bodyMD),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.xxl),
        const Text('Daily Rate (₱)', style: MovanaTextStyles.labelMD),
        const SizedBox(height: Spacing.sm),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '₱ ',
          ),
        ),
        const SizedBox(height: Spacing.lg),
        const Text('Hourly Rate (₱)', style: MovanaTextStyles.labelMD),
        const SizedBox(height: Spacing.sm),
        const TextField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: '0.00',
            prefixText: '₱ ',
          ),
        ),
      ],
    );
  }
}

// ── Helpers ────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _SummaryCard(
      {required this.label,
      required this.value,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(Spacing.md),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 6),
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Syne',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(label, style: MovanaTextStyles.bodySM),
          ],
        ),
      ),
    );
  }
}

class _SmallBadge extends StatelessWidget {
  final String label;
  final Color color;
  final IconData icon;
  const _SmallBadge(
      {required this.label, required this.color, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.9),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: Colors.white),
          const SizedBox(width: 3),
          Text(
            label,
            style: MovanaTextStyles.bodySM.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  final IconData icon;
  final String value;
  final Color color;
  const _StatPill(
      {required this.icon, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            value,
            style: MovanaTextStyles.bodySM.copyWith(color: color,
                fontWeight: FontWeight.w600, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

class _EarningPill extends StatelessWidget {
  final String label;
  const _EarningPill(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontFamily: 'Inter',
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
