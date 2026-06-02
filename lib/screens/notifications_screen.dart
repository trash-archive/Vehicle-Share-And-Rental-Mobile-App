import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/shared_widgets.dart';
import '../models/models.dart';
import '../data/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationItem> _items;

  @override
  void initState() {
    super.initState();
    _items = List.of(MockData.notifications);
  }

  int get _unreadCount => _items.where((n) => !n.isRead).length;

  void _markAllRead() =>
      setState(() => _items.forEach((n) => n.isRead = true));

  void _dismiss(NotificationItem item) {
    setState(() => _items.removeWhere((n) => n.id == item.id));
  }

  void _markRead(NotificationItem item) =>
      setState(() => item.isRead = true);

  // Split into Today vs Earlier
  List<NotificationItem> get _today {
    final now = DateTime.now();
    return _items
        .where((n) =>
            now.difference(n.time).inHours < 24 &&
            n.time.day == now.day)
        .toList();
  }

  List<NotificationItem> get _earlier {
    final now = DateTime.now();
    return _items
        .where((n) =>
            !(now.difference(n.time).inHours < 24 &&
                n.time.day == now.day))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Notifications', style: MovanaTextStyles.headingSM),
            if (_unreadCount > 0)
              Text(
                '$_unreadCount unread',
                style: MovanaTextStyles.bodySM
                    .copyWith(color: MovanaColors.primary),
              ),
          ],
        ),
        leading: const BackButton(),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllRead,
              child: Text(
                'Mark all read',
                style: MovanaTextStyles.labelSM
                    .copyWith(color: MovanaColors.primary),
              ),
            ),
        ],
      ),
      body: _items.isEmpty
          ? const EmptyState(
              emoji: '🔔',
              title: 'No notifications',
              subtitle:
                  'You\'re all caught up! Booking updates and messages will appear here.',
            )
          : ListView(
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              children: [
                if (_today.isNotEmpty) ...[
                  _GroupLabel('Today'),
                  ..._today.map((n) => _NotificationTile(
                        item: n,
                        onDismiss: () => _dismiss(n),
                        onTap: () => _markRead(n),
                      )),
                ],
                if (_earlier.isNotEmpty) ...[
                  _GroupLabel('Earlier'),
                  ..._earlier.map((n) => _NotificationTile(
                        item: n,
                        onDismiss: () => _dismiss(n),
                        onTap: () => _markRead(n),
                      )),
                ],
                const SizedBox(height: Spacing.xxxl),
              ],
            ),
    );
  }
}

// ──────────────────────────────────────────────
// Notification Tile
// ──────────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final NotificationItem item;
  final VoidCallback onDismiss;
  final VoidCallback onTap;

  const _NotificationTile({
    required this.item,
    required this.onDismiss,
    required this.onTap,
  });

  static const _typeConfig = {
    NotificationType.bookingConfirmed: (
      Icons.check_circle_rounded,
      MovanaColors.success,
    ),
    NotificationType.bookingRequest: (
      Icons.pending_rounded,
      MovanaColors.warning,
    ),
    NotificationType.bookingCancelled: (
      Icons.cancel_rounded,
      MovanaColors.error,
    ),
    NotificationType.newMessage: (
      Icons.chat_bubble_rounded,
      MovanaColors.info,
    ),
    NotificationType.reviewReceived: (
      Icons.star_rounded,
      MovanaColors.warning,
    ),
    NotificationType.system: (
      Icons.info_rounded,
      MovanaColors.inkLight,
    ),
  };

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final config = _typeConfig[item.type]!;
    final icon = config.$1;
    final color = config.$2;

    return Dismissible(
      key: ValueKey(item.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: Spacing.xl),
        color: MovanaColors.error.withOpacity(0.08),
        child: const Icon(Icons.delete_outline_rounded,
            color: MovanaColors.error, size: 24),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: item.isRead
              ? MovanaColors.white
              : MovanaColors.primarySurface.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.page,
            vertical: Spacing.md,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon circle
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 22, color: color),
              ),
              const SizedBox(width: Spacing.md),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            style: item.isRead
                                ? MovanaTextStyles.labelMD
                                : MovanaTextStyles.labelMD.copyWith(
                                    color: MovanaColors.ink),
                          ),
                        ),
                        if (!item.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: MovanaColors.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      item.body,
                      style: MovanaTextStyles.bodyMD.copyWith(
                        color: item.isRead
                            ? MovanaColors.inkLight
                            : MovanaColors.inkMedium,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _timeAgo(item.time),
                      style: MovanaTextStyles.bodySM.copyWith(
                        color: color,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Group label
// ──────────────────────────────────────────────
class _GroupLabel extends StatelessWidget {
  final String label;
  const _GroupLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
          Spacing.page, Spacing.md, Spacing.page, Spacing.sm),
      child: Text(
        label,
        style: MovanaTextStyles.bodySM.copyWith(
          fontWeight: FontWeight.w700,
          color: MovanaColors.inkLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
