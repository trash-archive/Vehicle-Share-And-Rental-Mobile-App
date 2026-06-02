import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';
import '../../models/models.dart';

// ──────────────────────────────────────────────
// Messages List Screen
// ──────────────────────────────────────────────
class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final convos = MockData.conversations;

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Messages', style: MovanaTextStyles.displayMD),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: convos.isEmpty
          ? const EmptyState(
              emoji: '💬',
              title: 'No messages yet',
              subtitle:
                  'When you message a vehicle owner or renter, your conversations will appear here.',
            )
          : ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: Spacing.md),
              itemCount: convos.length,
              separatorBuilder: (_, __) =>
                  const Divider(indent: 72, height: 1),
              itemBuilder: (ctx, i) =>
                  _ConversationTile(convo: convos[i]),
            ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  final ConversationModel convo;
  const _ConversationTile({required this.convo});

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => ChatScreen(convo: convo)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Spacing.page, vertical: Spacing.md),
        child: Row(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundImage: NetworkImage(convo.otherUserAvatar),
                  backgroundColor: MovanaColors.surface,
                ),
                if (convo.unreadCount > 0)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: MovanaColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: MovanaColors.white, width: 2),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          convo.otherUserName,
                          style: convo.unreadCount > 0
                              ? MovanaTextStyles.labelLG
                              : MovanaTextStyles.labelMD,
                        ),
                      ),
                      Text(
                        _timeAgo(convo.lastMessageTime),
                        style: MovanaTextStyles.bodySM,
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    convo.vehicleName,
                    style: MovanaTextStyles.bodySM
                        .copyWith(color: MovanaColors.primary),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          convo.lastMessage,
                          style: convo.unreadCount > 0
                              ? MovanaTextStyles.bodyMD
                                  .copyWith(color: MovanaColors.inkMedium)
                              : MovanaTextStyles.bodyMD,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (convo.unreadCount > 0)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: MovanaColors.primary,
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                          child: Text(
                            '${convo.unreadCount}',
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
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
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Chat Screen (individual conversation)
// ──────────────────────────────────────────────
class ChatScreen extends StatefulWidget {
  final ConversationModel convo;
  const ChatScreen({super.key, required this.convo});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();

  final List<_ChatMsg> _messages = [
    _ChatMsg(
      text: 'Hi! Is the Toyota Vios still available on June 10-12?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 15)),
    ),
    _ChatMsg(
      text: 'Hello! Yes, it\'s available on those dates. 😊',
      isMe: false,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 10)),
    ),
    _ChatMsg(
      text: 'Great! What\'s the pick-up location exactly?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
    ),
    _ChatMsg(
      text:
          'You can pick it up at SM City Cebu, near the main entrance. I\'ll be there by 9AM.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
    ),
    _ChatMsg(
      text: 'Perfect! What documents do I need to bring?',
      isMe: true,
      time: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
    ),
    _ChatMsg(
      text:
          'Just bring your valid ID and driver\'s license. We\'ll also do a quick vehicle walk-around before you drive off.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    _ChatMsg(
      text: 'Sure! You can pick it up at 9AM. I\'ll be there.',
      isMe: false,
      time: DateTime.now().subtract(const Duration(minutes: 60)),
    ),
  ];

  void _send() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_ChatMsg(
        text: text,
        isMe: true,
        time: DateTime.now(),
      ));
      _msgCtrl.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final convo = widget.convo;

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: NetworkImage(convo.otherUserAvatar),
              backgroundColor: MovanaColors.surface,
            ),
            const SizedBox(width: Spacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(convo.otherUserName,
                    style: MovanaTextStyles.labelMD),
                Text(convo.vehicleName,
                    style: MovanaTextStyles.bodySM
                        .copyWith(color: MovanaColors.primary)),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.phone_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Vehicle context banner
          Container(
            padding: const EdgeInsets.symmetric(
                horizontal: Spacing.page, vertical: Spacing.md),
            decoration: BoxDecoration(
              color: MovanaColors.primarySurface,
              border: const Border(
                  bottom: BorderSide(color: MovanaColors.border)),
            ),
            child: Row(
              children: [
                const Icon(Icons.directions_car_outlined,
                    size: 16, color: MovanaColors.primary),
                const SizedBox(width: Spacing.sm),
                Text(
                  'Re: ${convo.vehicleName}',
                  style: MovanaTextStyles.labelSM
                      .copyWith(color: MovanaColors.primary),
                ),
                const Spacer(),
                Text('View listing →',
                    style: MovanaTextStyles.labelSM
                        .copyWith(color: MovanaColors.primary)),
              ],
            ),
          ),
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(Spacing.page),
              itemCount: _messages.length,
              itemBuilder: (_, i) => _MessageBubble(msg: _messages[i]),
            ),
          ),
          // Input
          Container(
            padding: EdgeInsets.fromLTRB(
              Spacing.md,
              Spacing.md,
              Spacing.md,
              Spacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: MovanaColors.white,
              border:
                  Border(top: BorderSide(color: MovanaColors.border)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.attach_file_rounded,
                      color: MovanaColors.inkLight),
                  onPressed: () {},
                ),
                Expanded(
                  child: TextField(
                    controller: _msgCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Radii.pill)),
                        borderSide: BorderSide(color: MovanaColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Radii.pill)),
                        borderSide: BorderSide(color: MovanaColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                            Radius.circular(Radii.pill)),
                        borderSide: BorderSide(color: MovanaColors.primary),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                    ),
                    onSubmitted: (_) => _send(),
                  ),
                ),
                const SizedBox(width: Spacing.sm),
                GestureDetector(
                  onTap: _send,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: MovanaColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.send_rounded,
                        color: Colors.white, size: 20),
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

class _ChatMsg {
  final String text;
  final bool isMe;
  final DateTime time;
  const _ChatMsg({required this.text, required this.isMe, required this.time});
}

class _MessageBubble extends StatelessWidget {
  final _ChatMsg msg;
  const _MessageBubble({required this.msg});

  String _fmt(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Spacing.md),
      child: Row(
        mainAxisAlignment:
            msg.isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!msg.isMe) ...[
            CircleAvatar(
              radius: 14,
              backgroundImage:
                  const NetworkImage('https://i.pravatar.cc/150?img=5'),
              backgroundColor: MovanaColors.surface,
            ),
            const SizedBox(width: Spacing.sm),
          ],
          Column(
            crossAxisAlignment: msg.isMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: msg.isMe
                      ? MovanaColors.primary
                      : MovanaColors.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(Radii.lg),
                    topRight: const Radius.circular(Radii.lg),
                    bottomLeft: Radius.circular(msg.isMe ? Radii.lg : 4),
                    bottomRight: Radius.circular(msg.isMe ? 4 : Radii.lg),
                  ),
                  border: msg.isMe
                      ? null
                      : Border.all(color: MovanaColors.border),
                ),
                child: Text(
                  msg.text,
                  style: MovanaTextStyles.bodyMD.copyWith(
                    color: msg.isMe ? Colors.white : MovanaColors.ink,
                  ),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                _fmt(msg.time),
                style: MovanaTextStyles.bodySM
                    .copyWith(fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
