import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final _searchCtrl = TextEditingController();
  String _query = '';
  String _activeCategory = 'All';

  static const _categories = [
    'All', 'Booking', 'Payments', 'Account', 'Listings',
  ];

  static const _faqs = [
    _FAQ(
      'How do I book a vehicle?',
      'Browse listings on the Home or Search screen, tap a vehicle, then tap "Book Now". Choose your dates, review the price breakdown, and confirm.',
      'Booking',
      Icons.calendar_month_outlined,
    ),
    _FAQ(
      'How long does booking approval take?',
      'Owners typically respond within 1–2 hours. You\'ll receive a notification as soon as your booking is confirmed or declined.',
      'Booking',
      Icons.access_time_outlined,
    ),
    _FAQ(
      'Can I cancel a booking?',
      'Yes. Go to Bookings → tap the booking → View Details → Cancel Booking. Cancellation fees may apply depending on how close to the pickup date you cancel.',
      'Booking',
      Icons.cancel_outlined,
    ),
    _FAQ(
      'What payment methods are accepted?',
      'We accept GCash, Maya, and major credit/debit cards. You can manage your payment methods in Profile → Payment Methods.',
      'Payments',
      Icons.credit_card_outlined,
    ),
    _FAQ(
      'When am I charged for a booking?',
      'Payment is held when a booking is confirmed by the owner. Funds are released to the owner after the rental period ends.',
      'Payments',
      Icons.payments_outlined,
    ),
    _FAQ(
      'How does the platform fee work?',
      'Movana charges a 5% platform fee on each transaction. This fee is shown transparently in the price breakdown before you confirm.',
      'Payments',
      Icons.percent_outlined,
    ),
    _FAQ(
      'How do I verify my identity?',
      'Go to Profile → Verify Now. You\'ll need to upload a government-issued ID and a selfie. Verification usually takes 24–48 hours.',
      'Account',
      Icons.verified_user_outlined,
    ),
    _FAQ(
      'How do I change my password?',
      'Go to Profile → Change Password. You\'ll be asked for your current password before setting a new one.',
      'Account',
      Icons.lock_outline,
    ),
    _FAQ(
      'How do I list my vehicle?',
      'Go to My Listings and tap "Add". Fill in your vehicle details across 3 steps: Basic Info, Vehicle Details, and Pricing. Your listing will be reviewed before going live.',
      'Listings',
      Icons.add_circle_outline,
    ),
    _FAQ(
      'How do I pause my listing?',
      'Go to My Listings → Edit → Pricing step. Toggle the "Listing is Live" switch to pause it. Renters won\'t be able to see or book it while paused.',
      'Listings',
      Icons.pause_circle_outlined,
    ),
  ];

  List<_FAQ> get _filtered {
    return _faqs.where((f) {
      final matchCat =
          _activeCategory == 'All' || f.category == _activeCategory;
      final matchQuery = _query.isEmpty ||
          f.question.toLowerCase().contains(_query.toLowerCase()) ||
          f.answer.toLowerCase().contains(_query.toLowerCase());
      return matchCat && matchQuery;
    }).toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Help Center', style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.page, Spacing.md, Spacing.page, 0),
            child: TextField(
              controller: _searchCtrl,
              onChanged: (v) => setState(() => _query = v),
              decoration: InputDecoration(
                hintText: 'Search help topics…',
                prefixIcon: const Icon(Icons.search,
                    size: 20, color: MovanaColors.inkLight),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchCtrl.clear();
                          setState(() => _query = '');
                        },
                      )
                    : null,
              ),
            ),
          ),
          const SizedBox(height: Spacing.md),

          // ── Category chips ─────────────────────────
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding:
                  const EdgeInsets.symmetric(horizontal: Spacing.page),
              itemCount: _categories.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: Spacing.sm),
              itemBuilder: (_, i) {
                final cat = _categories[i];
                final active = _activeCategory == cat;
                return GestureDetector(
                  onTap: () => setState(() => _activeCategory = cat),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: active
                          ? MovanaColors.primary
                          : MovanaColors.surface,
                      borderRadius:
                          BorderRadius.circular(Radii.pill),
                      border: Border.all(
                        color: active
                            ? MovanaColors.primary
                            : MovanaColors.border,
                      ),
                    ),
                    child: Text(
                      cat,
                      style: MovanaTextStyles.labelSM.copyWith(
                        color: active
                            ? Colors.white
                            : MovanaColors.inkMedium,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: Spacing.md),
          const Divider(height: 1),

          // ── FAQ list ───────────────────────────────
          Expanded(
            child: _filtered.isEmpty
                ? const EmptyState(
                    emoji: '🔍',
                    title: 'No results found',
                    subtitle:
                        'Try different keywords or browse a different category.',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(Spacing.page),
                    itemCount: _filtered.length + 1,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: Spacing.sm),
                    itemBuilder: (_, i) {
                      if (i == _filtered.length) {
                        return _ContactSupportCard();
                      }
                      return _FAQTile(faq: _filtered[i]);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _FAQ {
  final String question;
  final String answer;
  final String category;
  final IconData icon;
  const _FAQ(this.question, this.answer, this.category, this.icon);
}

class _FAQTile extends StatefulWidget {
  final _FAQ faq;
  const _FAQTile({required this.faq});

  @override
  State<_FAQTile> createState() => _FAQTileState();
}

class _FAQTileState extends State<_FAQTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: _expanded
            ? MovanaColors.primarySurface
            : MovanaColors.surface,
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(
          color: _expanded
              ? MovanaColors.primary.withValues(alpha: 0.3)
              : Colors.transparent,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(Radii.md),
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(widget.faq.icon,
                        size: 18, color: MovanaColors.primary),
                    const SizedBox(width: Spacing.md),
                    Expanded(
                      child: Text(widget.faq.question,
                          style: MovanaTextStyles.labelMD),
                    ),
                    Icon(
                      _expanded
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: MovanaColors.inkLight,
                    ),
                  ],
                ),
                if (_expanded) ...[
                  const SizedBox(height: Spacing.md),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Text(widget.faq.answer,
                        style: MovanaTextStyles.bodyMD),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ContactSupportCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: Spacing.lg),
      padding: const EdgeInsets.all(Spacing.xl),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [MovanaColors.primaryDark, MovanaColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(Radii.xl),
      ),
      child: Column(
        children: [
          const Icon(Icons.support_agent_rounded,
              size: 36, color: Colors.white),
          const SizedBox(height: Spacing.md),
          const Text(
            'Still need help?',
            style: TextStyle(
              fontFamily: 'Syne',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Our support team is available Mon–Fri, 9AM–6PM PHT.',
            style: TextStyle(
              fontFamily: 'Inter',
              color: Colors.white70,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xl),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.email_outlined, size: 16),
                  label: const Text('Email Us'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(
                        color: Colors.white54),
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Radii.md)),
                  ),
                ),
              ),
              const SizedBox(width: Spacing.md),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.chat_outlined, size: 16),
                  label: const Text('Live Chat'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: MovanaColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Radii.md)),
                    textStyle: MovanaTextStyles.labelSM,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
