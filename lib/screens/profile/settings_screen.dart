import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Notification prefs
  bool _bookingUpdates = true;
  bool _messages = true;
  bool _promotions = false;
  bool _systemAlerts = true;

  // Preferences
  bool _darkMode = false;
  String _language = 'English';
  String _currency = 'PHP (₱)';
  bool _locationServices = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title:
            const Text('Settings', style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: ListView(
        padding: const EdgeInsets.all(Spacing.page),
        children: [
          // ── Notifications ──────────────────────────
          _SectionLabel('Notifications'),
          const SizedBox(height: Spacing.md),
          _ToggleTile(
            icon: Icons.calendar_today_outlined,
            label: 'Booking Updates',
            subtitle: 'Confirmations, cancellations, and reminders',
            value: _bookingUpdates,
            onChanged: (v) => setState(() => _bookingUpdates = v),
          ),
          _ToggleTile(
            icon: Icons.chat_bubble_outline,
            label: 'Messages',
            subtitle: 'New messages from owners and renters',
            value: _messages,
            onChanged: (v) => setState(() => _messages = v),
          ),
          _ToggleTile(
            icon: Icons.local_offer_outlined,
            label: 'Promotions & Offers',
            subtitle: 'Deals, discounts, and platform announcements',
            value: _promotions,
            onChanged: (v) => setState(() => _promotions = v),
          ),
          _ToggleTile(
            icon: Icons.info_outline,
            label: 'System Alerts',
            subtitle: 'Security and account activity alerts',
            value: _systemAlerts,
            onChanged: (v) => setState(() => _systemAlerts = v),
          ),
          const SizedBox(height: Spacing.xl),

          // ── Appearance ─────────────────────────────
          _SectionLabel('Appearance'),
          const SizedBox(height: Spacing.md),
          _ToggleTile(
            icon: Icons.dark_mode_outlined,
            label: 'Dark Mode',
            subtitle: 'Switch to dark theme',
            value: _darkMode,
            onChanged: (v) => setState(() => _darkMode = v),
          ),
          const SizedBox(height: Spacing.xl),

          // ── Preferences ───────────────────────────
          _SectionLabel('Preferences'),
          const SizedBox(height: Spacing.md),
          _SelectTile(
            icon: Icons.language,
            label: 'Language',
            value: _language,
            options: const ['English', 'Filipino'],
            onChanged: (v) => setState(() => _language = v),
          ),
          _SelectTile(
            icon: Icons.currency_exchange,
            label: 'Currency',
            value: _currency,
            options: const ['PHP (\u20B1)', 'USD (\$)'],
            onChanged: (v) => setState(() => _currency = v),
          ),
          _ToggleTile(
            icon: Icons.location_on_outlined,
            label: 'Location Services',
            subtitle: 'Used for nearby vehicle search',
            value: _locationServices,
            onChanged: (v) => setState(() => _locationServices = v),
          ),
          const SizedBox(height: Spacing.xl),

          // ── Account Actions ────────────────────────
          _SectionLabel('Account'),
          const SizedBox(height: Spacing.md),
          _ActionTile(
            icon: Icons.download_outlined,
            label: 'Download My Data',
            color: MovanaColors.primary,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Your data export will be emailed within 24 hours.')),
            ),
          ),
          _ActionTile(
            icon: Icons.delete_forever_outlined,
            label: 'Delete Account',
            color: MovanaColors.error,
            onTap: () => _showDeleteConfirm(context),
          ),
          const SizedBox(height: Spacing.xxxl),
        ],
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.xl)),
        title: const Text('Delete Account?',
            style: MovanaTextStyles.headingSM),
        content: const Text(
          'This action is permanent and cannot be undone. All your data, bookings, and listings will be permanently removed.',
          style: MovanaTextStyles.bodyMD,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: MovanaColors.error,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Radii.md)),
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ── Reusable Tile Widgets ─────────────────────

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

class _ToggleTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final void Function(bool) onChanged;

  const _ToggleTile({
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.sm, horizontal: Spacing.sm),
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
            child: Icon(icon, size: 18, color: MovanaColors.inkMedium),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: MovanaTextStyles.labelMD),
                if (subtitle != null)
                  Text(subtitle!, style: MovanaTextStyles.bodySM),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: MovanaColors.primary,
          ),
        ],
      ),
    );
  }
}

class _SelectTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final List<String> options;
  final void Function(String) onChanged;

  const _SelectTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(
          vertical: Spacing.sm, horizontal: Spacing.sm),
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
            child: Icon(icon, size: 18, color: MovanaColors.inkMedium),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Text(label, style: MovanaTextStyles.labelMD),
          ),
          GestureDetector(
            onTap: () => _showPicker(context),
            child: Row(
              children: [
                Text(value,
                    style: MovanaTextStyles.bodyMD.copyWith(
                        color: MovanaColors.primary)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right,
                    size: 18, color: MovanaColors.inkLight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(Radii.xxl)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(Spacing.page),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: MovanaTextStyles.displayMD),
            const SizedBox(height: Spacing.lg),
            ...options.map((opt) => ListTile(
                  title: Text(opt),
                  trailing: opt == value
                      ? const Icon(Icons.check_rounded,
                          color: MovanaColors.primary)
                      : null,
                  onTap: () {
                    onChanged(opt);
                    Navigator.pop(context);
                  },
                )),
            SizedBox(
                height: MediaQuery.of(context).padding.bottom +
                    Spacing.md),
          ],
        ),
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 2),
        padding: const EdgeInsets.symmetric(
            vertical: Spacing.md, horizontal: Spacing.sm),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(Radii.md),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: Spacing.md),
            Text(label,
                style: MovanaTextStyles.labelMD
                    .copyWith(color: color)),
            const Spacer(),
            Icon(Icons.chevron_right,
                size: 18, color: color.withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }
}
