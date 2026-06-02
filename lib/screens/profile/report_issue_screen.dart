import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  String? _selectedCategory;
  final _descCtrl = TextEditingController();
  bool _loading = false;
  bool _submitted = false;

  static const _categories = [
    _IssueCategory(
      'Fake or misleading listing',
      Icons.warning_amber_rounded,
      MovanaColors.warning,
    ),
    _IssueCategory(
      'Vehicle condition misrepresented',
      Icons.car_repair,
      MovanaColors.error,
    ),
    _IssueCategory(
      'Inappropriate behavior from user',
      Icons.person_off_outlined,
      MovanaColors.error,
    ),
    _IssueCategory(
      'Payment or billing issue',
      Icons.credit_card_off_outlined,
      MovanaColors.warning,
    ),
    _IssueCategory(
      'Scam or fraud attempt',
      Icons.gpp_bad_outlined,
      MovanaColors.error,
    ),
    _IssueCategory(
      'Other',
      Icons.help_outline,
      MovanaColors.inkLight,
    ),
  ];

  bool get _canSubmit =>
      _selectedCategory != null && _descCtrl.text.trim().length >= 20;

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  @override
  void dispose() {
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
      return Scaffold(
        backgroundColor: MovanaColors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(Spacing.page),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: MovanaColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_rounded,
                      size: 48, color: MovanaColors.success),
                ),
                const SizedBox(height: Spacing.xl),
                const Text(
                  'Report Submitted',
                  style: MovanaTextStyles.displayLG,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.md),
                const Text(
                  'Thank you for keeping Movana safe. Our team will review your report within 24–48 hours.',
                  style: MovanaTextStyles.bodyLG,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: Spacing.xxxl),
                MovanaButton(
                  label: 'Back to Profile',
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Report an Issue',
            style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.page),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(Spacing.md),
                    decoration: BoxDecoration(
                      color: MovanaColors.error.withValues(alpha: 0.06),
                      borderRadius: BorderRadius.circular(Radii.md),
                      border: Border.all(
                          color: MovanaColors.error.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.shield_outlined,
                            size: 18, color: MovanaColors.error),
                        const SizedBox(width: Spacing.sm),
                        Expanded(
                          child: Text(
                            'All reports are confidential. False reports may result in account suspension.',
                            style: MovanaTextStyles.bodySM
                                .copyWith(color: MovanaColors.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: Spacing.xxl),

                  const Text('What are you reporting?',
                      style: MovanaTextStyles.labelLG),
                  const SizedBox(height: Spacing.md),
                  ..._categories.map((cat) {
                    final selected = _selectedCategory == cat.label;
                    return GestureDetector(
                      onTap: () =>
                          setState(() => _selectedCategory = cat.label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        margin:
                            const EdgeInsets.only(bottom: Spacing.sm),
                        padding: const EdgeInsets.all(Spacing.md),
                        decoration: BoxDecoration(
                          color: selected
                              ? cat.color.withValues(alpha: 0.06)
                              : MovanaColors.surface,
                          borderRadius: BorderRadius.circular(Radii.md),
                          border: Border.all(
                            color: selected
                                ? cat.color.withValues(alpha: 0.4)
                                : Colors.transparent,
                            width: selected ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: cat.color.withValues(alpha: 0.1),
                                borderRadius:
                                    BorderRadius.circular(Radii.sm),
                              ),
                              child: Icon(cat.icon,
                                  size: 18, color: cat.color),
                            ),
                            const SizedBox(width: Spacing.md),
                            Expanded(
                              child: Text(cat.label,
                                  style: MovanaTextStyles.labelMD),
                            ),
                            if (selected)
                              Icon(Icons.check_circle_rounded,
                                  size: 18, color: cat.color),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: Spacing.xxl),

                  const Text('Describe the issue',
                      style: MovanaTextStyles.labelLG),
                  const SizedBox(height: Spacing.sm),
                  TextFormField(
                    controller: _descCtrl,
                    maxLines: 6,
                    maxLength: 1000,
                    onChanged: (_) => setState(() {}),
                    decoration: const InputDecoration(
                      hintText:
                          'Please provide as much detail as possible (min. 20 characters)…',
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Submit button
          Container(
            padding: EdgeInsets.fromLTRB(
                Spacing.page,
                Spacing.md,
                Spacing.page,
                Spacing.md + MediaQuery.of(context).padding.bottom),
            decoration: const BoxDecoration(
              color: MovanaColors.white,
              border: Border(top: BorderSide(color: MovanaColors.border)),
            ),
            child: MovanaButton(
              label: 'Submit Report',
              isLoading: _loading,
              onPressed: _canSubmit ? _submit : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _IssueCategory {
  final String label;
  final IconData icon;
  final Color color;
  const _IssueCategory(this.label, this.icon, this.color);
}
