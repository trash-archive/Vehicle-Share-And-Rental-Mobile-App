import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

// ── Mock payment method model ──────────────────
class _PaymentMethod {
  final String id;
  final _PaymentType type;
  final String label;
  final String detail;
  final bool isDefault;

  const _PaymentMethod({
    required this.id,
    required this.type,
    required this.label,
    required this.detail,
    required this.isDefault,
  });
}

enum _PaymentType { gcash, maya, card, bank }

// ── Screen ────────────────────────────────────
class PaymentMethodsScreen extends StatefulWidget {
  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  late List<_PaymentMethod> _methods;

  @override
  void initState() {
    super.initState();
    _methods = [
      const _PaymentMethod(
        id: 'pm1',
        type: _PaymentType.gcash,
        label: 'GCash',
        detail: '+63 912 345 6789',
        isDefault: true,
      ),
      const _PaymentMethod(
        id: 'pm2',
        type: _PaymentType.card,
        label: 'Visa •••• 4242',
        detail: 'Expires 08/27',
        isDefault: false,
      ),
    ];
  }

  void _setDefault(String id) {
    setState(() {
      _methods = _methods
          .map((m) => _PaymentMethod(
                id: m.id,
                type: m.type,
                label: m.label,
                detail: m.detail,
                isDefault: m.id == id,
              ))
          .toList();
    });
  }

  void _remove(String id) {
    final removed = _methods.firstWhere((m) => m.id == id);
    setState(() => _methods.removeWhere((m) => m.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${removed.label} removed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => setState(() => _methods.insert(0, removed)),
        ),
      ),
    );
  }

  void _showAddSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddPaymentSheet(
        onAdd: (method) => setState(() => _methods.add(method)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Payment Methods', style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: _methods.isEmpty
          ? Column(
              children: [
                const Expanded(
                  child: EmptyState(
                    emoji: '💳',
                    title: 'No payment methods',
                    subtitle:
                        'Add GCash, Maya, or a card to pay for rentals quickly.',
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      Spacing.page,
                      0,
                      Spacing.page,
                      Spacing.page + MediaQuery.of(context).padding.bottom),
                  child: MovanaButton(
                    label: 'Add Payment Method',
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: _showAddSheet,
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.all(Spacing.page),
                    children: [
                      // Info banner
                      Container(
                        padding: const EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: MovanaColors.primarySurface,
                          borderRadius: BorderRadius.circular(Radii.md),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.lock_outline,
                                size: 16, color: MovanaColors.primary),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: Text(
                                'Your payment info is encrypted and secure.',
                                style: MovanaTextStyles.bodySM.copyWith(
                                    color: MovanaColors.primary),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),
                      const SectionHeader(title: 'Saved Methods'),
                      const SizedBox(height: Spacing.md),
                      ..._methods.map((m) => Padding(
                            padding:
                                const EdgeInsets.only(bottom: Spacing.md),
                            child: _MethodCard(
                              method: m,
                              onSetDefault: () => _setDefault(m.id),
                              onRemove: () => _remove(m.id),
                            ),
                          )),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(
                      Spacing.page,
                      Spacing.md,
                      Spacing.page,
                      Spacing.md + MediaQuery.of(context).padding.bottom),
                  decoration: const BoxDecoration(
                    color: MovanaColors.white,
                    border:
                        Border(top: BorderSide(color: MovanaColors.border)),
                  ),
                  child: MovanaButton(
                    label: 'Add Payment Method',
                    isOutlined: true,
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: _showAddSheet,
                  ),
                ),
              ],
            ),
    );
  }
}

// ── Method Card ───────────────────────────────
class _MethodCard extends StatelessWidget {
  final _PaymentMethod method;
  final VoidCallback onSetDefault;
  final VoidCallback onRemove;

  const _MethodCard({
    required this.method,
    required this.onSetDefault,
    required this.onRemove,
  });

  static const _typeIcon = {
    _PaymentType.gcash: Icons.account_balance_wallet_rounded,
    _PaymentType.maya: Icons.account_balance_wallet_rounded,
    _PaymentType.card: Icons.credit_card_rounded,
    _PaymentType.bank: Icons.account_balance_rounded,
  };

  static const _typeColor = {
    _PaymentType.gcash: Color(0xFF007AFF),
    _PaymentType.maya: Color(0xFF3BB54A),
    _PaymentType.card: MovanaColors.primary,
    _PaymentType.bank: MovanaColors.inkMedium,
  };

  @override
  Widget build(BuildContext context) {
    final color = _typeColor[method.type]!;
    final icon = _typeIcon[method.type]!;

    return Container(
      padding: const EdgeInsets.all(Spacing.lg),
      decoration: BoxDecoration(
        color: MovanaColors.white,
        borderRadius: BorderRadius.circular(Radii.lg),
        border: Border.all(
          color: method.isDefault
              ? MovanaColors.primary.withValues(alpha: 0.4)
              : MovanaColors.border,
          width: method.isDefault ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: MovanaColors.ink.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(Radii.md),
            ),
            child: Icon(icon, size: 24, color: color),
          ),
          const SizedBox(width: Spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(method.label, style: MovanaTextStyles.labelMD),
                    if (method.isDefault) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: MovanaColors.primarySurface,
                          borderRadius: BorderRadius.circular(Radii.pill),
                        ),
                        child: Text(
                          'Default',
                          style: MovanaTextStyles.bodySM.copyWith(
                            color: MovanaColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(method.detail, style: MovanaTextStyles.bodyMD),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert,
                size: 20, color: MovanaColors.inkLight),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Radii.md)),
            onSelected: (v) {
              if (v == 'default') onSetDefault();
              if (v == 'remove') onRemove();
            },
            itemBuilder: (_) => [
              if (!method.isDefault)
                const PopupMenuItem(
                  value: 'default',
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline,
                          size: 18, color: MovanaColors.primary),
                      SizedBox(width: 10),
                      Text('Set as default'),
                    ],
                  ),
                ),
              const PopupMenuItem(
                value: 'remove',
                child: Row(
                  children: [
                    Icon(Icons.delete_outline,
                        size: 18, color: MovanaColors.error),
                    SizedBox(width: 10),
                    Text('Remove',
                        style: TextStyle(color: MovanaColors.error)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Add Payment Bottom Sheet ──────────────────
class _AddPaymentSheet extends StatefulWidget {
  final void Function(_PaymentMethod) onAdd;
  const _AddPaymentSheet({required this.onAdd});

  @override
  State<_AddPaymentSheet> createState() => _AddPaymentSheetState();
}

class _AddPaymentSheetState extends State<_AddPaymentSheet> {
  _PaymentType? _selectedType;
  final _numberCtrl = TextEditingController();
  bool _loading = false;

  static const _options = [
    (_PaymentType.gcash, 'GCash', Icons.account_balance_wallet_rounded,
        Color(0xFF007AFF)),
    (_PaymentType.maya, 'Maya', Icons.account_balance_wallet_rounded,
        Color(0xFF3BB54A)),
    (_PaymentType.card, 'Credit / Debit Card',
        Icons.credit_card_rounded, MovanaColors.primary),
    (_PaymentType.bank, 'Bank Account',
        Icons.account_balance_rounded, MovanaColors.inkMedium),
  ];

  bool get _canSubmit =>
      _selectedType != null && _numberCtrl.text.trim().isNotEmpty;

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    final opt = _options.firstWhere((o) => o.$1 == _selectedType);
    widget.onAdd(_PaymentMethod(
      id: 'pm${DateTime.now().millisecondsSinceEpoch}',
      type: _selectedType!,
      label: opt.$2,
      detail: _numberCtrl.text.trim(),
      isDefault: false,
    ));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${opt.$2} added successfully!'),
        backgroundColor: MovanaColors.success,
      ),
    );
  }

  @override
  void dispose() {
    _numberCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        decoration: const BoxDecoration(
          color: MovanaColors.white,
          borderRadius:
              BorderRadius.vertical(top: Radius.circular(Radii.xxl)),
        ),
        padding: EdgeInsets.fromLTRB(
            Spacing.page,
            Spacing.page,
            Spacing.page,
            Spacing.page + MediaQuery.of(context).padding.bottom),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle + header
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
            Row(
              children: [
                const Text('Add Payment Method',
                    style: MovanaTextStyles.displayMD),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),

            // Type selection
            const Text('Select Type', style: MovanaTextStyles.labelMD),
            const SizedBox(height: Spacing.md),
            Wrap(
              spacing: Spacing.sm,
              runSpacing: Spacing.sm,
              children: _options.map((opt) {
                final selected = _selectedType == opt.$1;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedType = opt.$1),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: selected
                          ? opt.$4.withValues(alpha: 0.1)
                          : MovanaColors.surface,
                      borderRadius:
                          BorderRadius.circular(Radii.md),
                      border: Border.all(
                        color: selected
                            ? opt.$4
                            : MovanaColors.border,
                        width: selected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(opt.$3, size: 16, color: opt.$4),
                        const SizedBox(width: 6),
                        Text(opt.$2,
                            style: MovanaTextStyles.labelSM.copyWith(
                                color: selected
                                    ? opt.$4
                                    : MovanaColors.inkMedium)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: Spacing.xl),

            // Number / account field
            const Text('Account / Card Number',
                style: MovanaTextStyles.labelMD),
            const SizedBox(height: Spacing.sm),
            TextField(
              controller: _numberCtrl,
              keyboardType: TextInputType.phone,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                hintText: _selectedType == _PaymentType.card
                    ? '1234 5678 9012 3456'
                    : '+63 9XX XXX XXXX',
                prefixIcon: const Icon(Icons.dialpad_outlined,
                    size: 20, color: MovanaColors.inkLight),
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            MovanaButton(
              label: 'Add Method',
              isLoading: _loading,
              onPressed: _canSubmit ? _submit : null,
            ),
          ],
        ),
      ),
    );
  }
}
