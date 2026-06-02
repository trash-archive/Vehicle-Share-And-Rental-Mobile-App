import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Terms & Privacy Policy',
            style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: MovanaColors.primary,
          unselectedLabelColor: MovanaColors.inkLight,
          indicatorColor: MovanaColors.primary,
          indicatorWeight: 2,
          labelStyle: MovanaTextStyles.labelMD,
          tabs: const [
            Tab(text: 'Terms of Use'),
            Tab(text: 'Privacy Policy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabCtrl,
        children: [
          _TermsContent(sections: _termsSections),
          _TermsContent(sections: _privacySections),
        ],
      ),
    );
  }
}

class _TermsContent extends StatelessWidget {
  final List<_Section> sections;
  const _TermsContent({required this.sections});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(Spacing.page),
      children: [
        // Last updated badge
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: MovanaColors.surface,
            borderRadius: BorderRadius.circular(Radii.pill),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.history, size: 14, color: MovanaColors.inkLight),
              const SizedBox(width: 6),
              Text(
                'Last updated: January 1, 2025',
                style: MovanaTextStyles.bodySM,
              ),
            ],
          ),
        ),
        const SizedBox(height: Spacing.xl),
        ...sections.expand((s) => [
              _SectionBlock(section: s),
              const SizedBox(height: Spacing.xl),
            ]),
        const SizedBox(height: Spacing.xxxl),
      ],
    );
  }
}

class _SectionBlock extends StatelessWidget {
  final _Section section;
  const _SectionBlock({required this.section});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: MovanaColors.primarySurface,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(section.icon,
                  size: 16, color: MovanaColors.primary),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                section.title,
                style: MovanaTextStyles.labelLG,
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.md),
        Text(section.body, style: MovanaTextStyles.bodyMD),
      ],
    );
  }
}

class _Section {
  final String title;
  final String body;
  final IconData icon;
  const _Section(this.title, this.body, this.icon);
}

const _termsSections = [
  _Section(
    '1. Acceptance of Terms',
    'By accessing or using the Movana platform, you agree to be bound by these Terms of Use and our Privacy Policy. If you do not agree, please do not use our services.',
    Icons.gavel_outlined,
  ),
  _Section(
    '2. Eligibility',
    'You must be at least 18 years old and possess a valid government-issued ID to use Movana. Renters must hold a valid driver\'s license appropriate for the vehicle category they wish to rent.',
    Icons.person_outline,
  ),
  _Section(
    '3. Booking and Payments',
    'Bookings are confirmed upon owner approval and payment authorization. The platform fee of 5% is non-refundable. Payments are processed securely through our payment partners.',
    Icons.payment_outlined,
  ),
  _Section(
    '4. Cancellation Policy',
    'Cancellations made more than 48 hours before pickup are fully refunded. Cancellations within 24–48 hours incur a 50% fee. Cancellations within 24 hours are non-refundable.',
    Icons.cancel_outlined,
  ),
  _Section(
    '5. Owner Responsibilities',
    'Owners are responsible for ensuring their vehicles are roadworthy, properly insured, and accurately described on the platform. Misrepresentation may result in account suspension.',
    Icons.directions_car_outlined,
  ),
  _Section(
    '6. Renter Responsibilities',
    'Renters must treat vehicles with care and return them in the same condition as received. Any damage, traffic violations, or fuel costs incurred during the rental period are the renter\'s responsibility.',
    Icons.assignment_ind_outlined,
  ),
  _Section(
    '7. Prohibited Activities',
    'The platform must not be used for illegal activities, subleasing vehicles, transporting prohibited goods, or any activity that endangers others. Violations may result in immediate account termination.',
    Icons.block_outlined,
  ),
  _Section(
    '8. Dispute Resolution',
    'In the event of a dispute, both parties should first attempt resolution through the in-app messaging system. Unresolved disputes may be escalated to Movana support for mediation.',
    Icons.handshake_outlined,
  ),
];

const _privacySections = [
  _Section(
    'Information We Collect',
    'We collect information you provide when creating an account (name, email, phone, government ID for verification), information about your vehicle listings, booking history, and usage data to improve our service.',
    Icons.info_outline,
  ),
  _Section(
    'How We Use Your Data',
    'Your data is used to facilitate bookings, verify identities, process payments, send notifications, provide customer support, and improve platform safety and quality.',
    Icons.data_usage_outlined,
  ),
  _Section(
    'Data Sharing',
    'We share limited data with other users as needed to complete transactions (e.g., your name and rating are shown to owners). We do not sell your personal data to third parties.',
    Icons.share_outlined,
  ),
  _Section(
    'Data Security',
    'We use industry-standard encryption and security measures to protect your personal information. Payment data is handled by PCI-compliant processors and is never stored on our servers.',
    Icons.security_outlined,
  ),
  _Section(
    'Cookies and Tracking',
    'We use cookies and similar technologies to improve your experience, remember preferences, and analyze app usage patterns. You can control cookie preferences through your device settings.',
    Icons.cookie_outlined,
  ),
  _Section(
    'Your Rights',
    'You have the right to access, correct, or delete your personal data. To submit a data request, contact our privacy team at privacy@movana.ph. We will respond within 30 days.',
    Icons.verified_user_outlined,
  ),
  _Section(
    'Contact Us',
    'For privacy-related inquiries, contact our Data Protection Officer at privacy@movana.ph or write to us at Movana Technologies, Cebu IT Park, Cebu City, Philippines 6000.',
    Icons.mail_outline,
  ),
];
