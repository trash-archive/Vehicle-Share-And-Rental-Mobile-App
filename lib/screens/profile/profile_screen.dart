import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../data/mock_data.dart';
import '../notifications_screen.dart';
import '../auth/identity_verification_screen.dart';
import '../auth/phone_verification_screen.dart';
import '../listing/my_listings_screen.dart';
import 'edit_profile_screen.dart';
import 'saved_listings_screen.dart';
import 'payment_methods_screen.dart';
import 'rental_history_screen.dart';
import 'my_reviews_screen.dart';
import 'help_center_screen.dart';
import 'report_issue_screen.dart';
import 'terms_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;

    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: CustomScrollView(
        slivers: [
          // ── Profile Header ────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [MovanaColors.primaryDark, MovanaColors.primary],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(Spacing.page),
                  child: Column(
                    children: [
                      // Top row
                      Row(
                        children: [
                          const Text(
                            'Profile',
                            style: TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen()),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(Radii.md),
                                  ),
                                  child: const Icon(Icons.notifications_outlined,
                                      size: 20, color: Colors.white),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: Container(
                                    width: 10,
                                    height: 10,
                                    decoration: BoxDecoration(
                                      color: MovanaColors.error,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          color: MovanaColors.primary, width: 1.5),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: Spacing.sm),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (_) => const SettingsScreen()),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius:
                                    BorderRadius.circular(Radii.md),
                              ),
                              child: const Icon(Icons.settings_outlined,
                                  size: 20, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.xxl),
                      // Avatar + info
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: 44,
                            backgroundImage:
                                NetworkImage(user.avatarUrl),
                            backgroundColor:
                                Colors.white.withOpacity(0.2),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: MovanaColors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: MovanaColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.camera_alt,
                                    size: 12, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: Spacing.md),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontFamily: 'Syne',
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          if (user.isVerified) ...[
                            const SizedBox(width: 6),
                            const Icon(Icons.verified,
                                size: 18,
                                color: Colors.white),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        user.email,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: Spacing.md),
                      // Stats row
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                        children: [
                          _ProfileStat('${user.rating}★', 'Rating'),
                          _VerticalDivider(),
                          _ProfileStat(
                              '${user.reviewCount}', 'Reviews'),
                          _VerticalDivider(),
                          _ProfileStat(user.location, 'Location'),
                        ],
                      ),
                      const SizedBox(height: Spacing.xl),
                    ],
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(Spacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verification Status
                  _VerificationCard(user.isVerified),
                  const SizedBox(height: Spacing.xxl),

                  // Account section
                  _SectionLabel('Account'),
                  const SizedBox(height: Spacing.md),
                  _MenuTile(
                    icon: Icons.person_outline,
                    label: 'Personal Information',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const EditProfileScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.phone_outlined,
                    label: 'Phone Verification',
                    trailing: _VerifiedBadge(),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PhoneVerificationScreen(
                            phone: MockData.currentUser.phone),
                      ),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.lock_outline,
                    label: 'Change Password',
                    onTap: () {},
                  ),
                  _MenuTile(
                    icon: Icons.credit_card_outlined,
                    label: 'Payment Methods',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const PaymentMethodsScreen()),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Rental activity
                  _SectionLabel('Rental Activity'),
                  const SizedBox(height: Spacing.md),
                  _MenuTile(
                    icon: Icons.directions_car_outlined,
                    label: 'My Listings',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const MyListingsScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.history_rounded,
                    label: 'Rental History',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const RentalHistoryScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.favorite_outline,
                    label: 'Saved Listings',
                    trailing: _CountBadge('${MockData.savedVehicleIds.length}'),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const SavedListingsScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.star_outline,
                    label: 'My Reviews',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const MyReviewsScreen()),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Support
                  _SectionLabel('Support'),
                  const SizedBox(height: Spacing.md),
                  _MenuTile(
                    icon: Icons.help_outline,
                    label: 'Help Center',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const HelpCenterScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.flag_outlined,
                    label: 'Report an Issue',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const ReportIssueScreen()),
                    ),
                  ),
                  _MenuTile(
                    icon: Icons.description_outlined,
                    label: 'Terms & Privacy Policy',
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => const TermsScreen()),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),

                  // Logout
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.all(Spacing.lg),
                      decoration: BoxDecoration(
                        color: MovanaColors.error.withOpacity(0.06),
                        borderRadius:
                            BorderRadius.circular(Radii.md),
                        border: Border.all(
                            color: MovanaColors.error.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.logout,
                              size: 20, color: MovanaColors.error),
                          const SizedBox(width: Spacing.sm),
                          Text(
                            'Log Out',
                            style: MovanaTextStyles.labelLG
                                .copyWith(color: MovanaColors.error),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: Spacing.xl),
                  Center(
                    child: Text(
                      'Movana v1.0.0 • Made with ❤️ for PH',
                      style: MovanaTextStyles.bodySM,
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerificationCard extends StatelessWidget {
  final bool isVerified;
  const _VerificationCard(this.isVerified);

  @override
  Widget build(BuildContext context) {
    if (isVerified) {
      return Container(
        padding: const EdgeInsets.all(Spacing.lg),
        decoration: BoxDecoration(
          color: MovanaColors.success.withOpacity(0.08),
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(color: MovanaColors.success.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: MovanaColors.success.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.verified_user,
                  size: 22, color: MovanaColors.success),
            ),
            const SizedBox(width: Spacing.md),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Identity Verified', style: MovanaTextStyles.labelLG),
                  Text('Your account is fully verified.',
                      style: MovanaTextStyles.bodyMD),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: MovanaColors.warning.withOpacity(0.08),
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(color: MovanaColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: MovanaColors.warning.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.warning_amber_rounded,
                size: 22, color: MovanaColors.warning),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Verify Your Identity',
                    style: MovanaTextStyles.labelLG),
                const Text('Upload a valid ID to unlock all features.',
                    style: MovanaTextStyles.bodyMD),
                const SizedBox(height: Spacing.sm),
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const IdentityVerificationScreen()),
                  ),
                  child: Text(
                    'Verify Now →',
                    style: MovanaTextStyles.labelSM
                        .copyWith(color: MovanaColors.warning),
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

class _MenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.label,
    this.trailing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: Spacing.md, horizontal: Spacing.md),
        margin: const EdgeInsets.only(bottom: 2),
        decoration: BoxDecoration(
          color: MovanaColors.white,
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: MovanaColors.surface,
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child:
                  Icon(icon, size: 18, color: MovanaColors.inkMedium),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Text(label, style: MovanaTextStyles.labelMD),
            ),
            trailing ??
                const Icon(Icons.chevron_right,
                    size: 20, color: MovanaColors.inkLight),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: MovanaTextStyles.bodySM.copyWith(
          fontWeight: FontWeight.w700,
          color: MovanaColors.inkLight,
          letterSpacing: 0.5,
        ),
      );
}

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  const _ProfileStat(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
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
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            color: Colors.white.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
        width: 1,
        height: 32,
        color: Colors.white.withOpacity(0.3),
      );
}

class _VerifiedBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: MovanaColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Text(
        'Verified',
        style: MovanaTextStyles.bodySM.copyWith(
          color: MovanaColors.success,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _CountBadge extends StatelessWidget {
  final String count;
  const _CountBadge(this.count);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: const BoxDecoration(
        color: MovanaColors.primary,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          count,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
