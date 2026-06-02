import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class IdentityVerificationScreen extends StatefulWidget {
  const IdentityVerificationScreen({super.key});

  @override
  State<IdentityVerificationScreen> createState() =>
      _IdentityVerificationScreenState();
}

class _IdentityVerificationScreenState
    extends State<IdentityVerificationScreen> {
  int _step = 0;
  String? _selectedIdType;
  bool _idFrontUploaded = false;
  bool _idBackUploaded = false;
  bool _selfieUploaded = false;
  bool _loading = false;
  bool _submitted = false;

  static const _idTypes = [
    _IdType("Passport", Icons.book_outlined),
    _IdType("Driver's License", Icons.badge_outlined),
    _IdType("National ID (PhilSys)", Icons.credit_card_outlined),
    _IdType("SSS / GSIS ID", Icons.account_balance_outlined),
    _IdType("Voter's ID", Icons.how_to_vote_outlined),
    _IdType("Postal ID", Icons.local_post_office_outlined),
  ];

  bool get _canProceedStep0 => _selectedIdType != null;
  bool get _canProceedStep1 => _idFrontUploaded && _idBackUploaded;
  bool get _canProceedStep2 => _selfieUploaded;

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  bool get _canProceed {
    switch (_step) {
      case 0: return _canProceedStep0;
      case 1: return _canProceedStep1;
      case 2: return _canProceedStep2;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _SubmittedView();

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Identity Verification',
            style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          // ── Progress bar ─────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.page, Spacing.md, Spacing.page, 0),
            child: _StepIndicator(step: _step, labels: const [
              'ID Type',
              'Upload ID',
              'Selfie',
            ]),
          ),
          const SizedBox(height: Spacing.lg),
          const Divider(height: 1),

          // ── Step content ─────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.page),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStep(),
              ),
            ),
          ),

          // ── Bottom bar ───────────────────────────────
          Container(
            padding: EdgeInsets.fromLTRB(
              Spacing.page, Spacing.md, Spacing.page,
              Spacing.md + MediaQuery.of(context).padding.bottom,
            ),
            decoration: const BoxDecoration(
              color: MovanaColors.white,
              border: Border(top: BorderSide(color: MovanaColors.border)),
            ),
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
                    label: _step < 2 ? 'Continue' : 'Submit',
                    isLoading: _loading,
                    onPressed: _canProceed ? _next : null,
                    icon: _step == 2
                        ? const Icon(Icons.check_rounded, size: 18)
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return _Step0IdType(
          key: const ValueKey(0),
          selected: _selectedIdType,
          idTypes: _idTypes,
          onSelect: (t) => setState(() => _selectedIdType = t),
        );
      case 1:
        return _Step1UploadId(
          key: const ValueKey(1),
          idType: _selectedIdType!,
          frontUploaded: _idFrontUploaded,
          backUploaded: _idBackUploaded,
          onFrontTap: () => setState(() => _idFrontUploaded = true),
          onBackTap: () => setState(() => _idBackUploaded = true),
        );
      case 2:
        return _Step2Selfie(
          key: const ValueKey(2),
          uploaded: _selfieUploaded,
          onTap: () => setState(() => _selfieUploaded = true),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Step 0: ID Type Selection ─────────────────
class _Step0IdType extends StatelessWidget {
  final String? selected;
  final List<_IdType> idTypes;
  final ValueChanged<String> onSelect;

  const _Step0IdType({
    super.key,
    required this.selected,
    required this.idTypes,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Select ID Type', style: MovanaTextStyles.headingSM),
        const SizedBox(height: Spacing.sm),
        const Text(
          'Choose a valid government-issued ID that you\'ll upload in the next step.',
          style: MovanaTextStyles.bodyMD,
        ),
        const SizedBox(height: Spacing.xxl),
        ...idTypes.map((id) {
          final isSelected = selected == id.label;
          return GestureDetector(
            onTap: () => onSelect(id.label),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              margin: const EdgeInsets.only(bottom: Spacing.sm),
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: isSelected
                    ? MovanaColors.primarySurface
                    : MovanaColors.surface,
                borderRadius: BorderRadius.circular(Radii.md),
                border: Border.all(
                  color: isSelected
                      ? MovanaColors.primary
                      : Colors.transparent,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MovanaColors.primary.withOpacity(0.12)
                          : MovanaColors.border.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(Radii.sm),
                    ),
                    child: Icon(id.icon,
                        size: 20,
                        color: isSelected
                            ? MovanaColors.primary
                            : MovanaColors.inkLight),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Text(id.label,
                        style: MovanaTextStyles.labelMD.copyWith(
                          color: isSelected
                              ? MovanaColors.primary
                              : MovanaColors.ink,
                        )),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle_rounded,
                        size: 20, color: MovanaColors.primary),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

// ── Step 1: Upload ID Photos ──────────────────
class _Step1UploadId extends StatelessWidget {
  final String idType;
  final bool frontUploaded;
  final bool backUploaded;
  final VoidCallback onFrontTap;
  final VoidCallback onBackTap;

  const _Step1UploadId({
    super.key,
    required this.idType,
    required this.frontUploaded,
    required this.backUploaded,
    required this.onFrontTap,
    required this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload your ID', style: MovanaTextStyles.headingSM),
        const SizedBox(height: Spacing.sm),
        Text(
          'Take a clear photo of both sides of your $idType. Make sure all details are visible and not blurry.',
          style: MovanaTextStyles.bodyMD,
        ),
        const SizedBox(height: Spacing.xxl),
        _UploadBox(
          label: 'Front Side',
          hint: 'Your name, photo, and ID number',
          icon: Icons.portrait_outlined,
          uploaded: frontUploaded,
          onTap: onFrontTap,
        ),
        const SizedBox(height: Spacing.lg),
        _UploadBox(
          label: 'Back Side',
          hint: 'Barcode, signature, or expiry',
          icon: Icons.flip_to_back_outlined,
          uploaded: backUploaded,
          onTap: onBackTap,
        ),
        const SizedBox(height: Spacing.xl),
        _TipBanner(
          icon: Icons.lightbulb_outline,
          text: 'Ensure good lighting and place the ID on a flat surface. Avoid glare.',
        ),
      ],
    );
  }
}

// ── Step 2: Selfie ────────────────────────────
class _Step2Selfie extends StatelessWidget {
  final bool uploaded;
  final VoidCallback onTap;

  const _Step2Selfie({super.key, required this.uploaded, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Take a Selfie', style: MovanaTextStyles.headingSM),
        const SizedBox(height: Spacing.sm),
        const Text(
          'We need to verify that you\'re the person on the ID. Take a clear selfie in good lighting.',
          style: MovanaTextStyles.bodyMD,
        ),
        const SizedBox(height: Spacing.xxl),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: uploaded
                  ? MovanaColors.success.withOpacity(0.08)
                  : MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.xl),
              border: Border.all(
                color: uploaded
                    ? MovanaColors.success
                    : MovanaColors.border,
                width: uploaded ? 1.5 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  uploaded
                      ? Icons.check_circle_rounded
                      : Icons.face_retouching_natural,
                  size: 56,
                  color: uploaded
                      ? MovanaColors.success
                      : MovanaColors.inkLight,
                ),
                const SizedBox(height: Spacing.md),
                Text(
                  uploaded ? 'Selfie captured ✓' : 'Tap to take a selfie',
                  style: MovanaTextStyles.labelMD.copyWith(
                    color: uploaded
                        ? MovanaColors.success
                        : MovanaColors.inkMedium,
                  ),
                ),
                if (!uploaded) ...[
                  const SizedBox(height: Spacing.xs),
                  Text(
                    'Camera will open',
                    style: MovanaTextStyles.bodySM,
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.xl),
        _TipBanner(
          icon: Icons.face_outlined,
          text: 'Look directly at the camera, remove sunglasses or hat, and ensure your face is fully visible.',
        ),
        const SizedBox(height: Spacing.lg),
        // Review info
        Container(
          padding: const EdgeInsets.all(Spacing.lg),
          decoration: BoxDecoration(
            color: MovanaColors.surface,
            borderRadius: BorderRadius.circular(Radii.lg),
            border: Border.all(color: MovanaColors.border),
          ),
          child: Column(
            children: [
              _InfoLine(Icons.access_time_outlined,
                  'Verification takes 24–48 hours'),
              const SizedBox(height: Spacing.sm),
              _InfoLine(Icons.lock_outline,
                  'Your data is encrypted and never shared'),
              const SizedBox(height: Spacing.sm),
              _InfoLine(Icons.check_circle_outline,
                  'Verified users unlock all platform features'),
            ],
          ),
        ),
      ],
    );
  }
}

// ── Submitted View ────────────────────────────
class _SubmittedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.page),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: MovanaColors.primarySurface,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user_rounded,
                    size: 52, color: MovanaColors.primary),
              ),
              const SizedBox(height: Spacing.xl),
              const Text('Verification Submitted!',
                  style: MovanaTextStyles.displayMD,
                  textAlign: TextAlign.center),
              const SizedBox(height: Spacing.md),
              const Text(
                'Your documents are under review.\nYou\'ll be notified within 24–48 hours.',
                style: MovanaTextStyles.bodyLG,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xxxl),
              // Status card
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: MovanaColors.warning.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(
                      color: MovanaColors.warning.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_empty_rounded,
                        size: 22, color: MovanaColors.warning),
                    const SizedBox(width: Spacing.md),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Pending Review',
                              style: MovanaTextStyles.labelMD),
                          Text('Our team is reviewing your documents.',
                              style: MovanaTextStyles.bodyMD),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxl),
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
}

// ── Shared helpers ────────────────────────────
class _UploadBox extends StatelessWidget {
  final String label;
  final String hint;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;

  const _UploadBox({
    required this.label,
    required this.hint,
    required this.icon,
    required this.uploaded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        decoration: BoxDecoration(
          color: uploaded
              ? MovanaColors.success.withOpacity(0.07)
              : MovanaColors.surface,
          borderRadius: BorderRadius.circular(Radii.lg),
          border: Border.all(
            color: uploaded ? MovanaColors.success : MovanaColors.border,
            width: uploaded ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            const SizedBox(width: Spacing.xl),
            Icon(
              uploaded ? Icons.check_circle_rounded : icon,
              size: 36,
              color:
                  uploaded ? MovanaColors.success : MovanaColors.inkLight,
            ),
            const SizedBox(width: Spacing.lg),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label,
                      style: MovanaTextStyles.labelMD.copyWith(
                        color: uploaded
                            ? MovanaColors.success
                            : MovanaColors.ink,
                      )),
                  const SizedBox(height: 2),
                  Text(
                    uploaded ? 'Photo uploaded ✓' : hint,
                    style: MovanaTextStyles.bodyMD,
                  ),
                ],
              ),
            ),
            Icon(
              uploaded
                  ? Icons.edit_outlined
                  : Icons.add_photo_alternate_outlined,
              size: 22,
              color: MovanaColors.inkLight,
            ),
            const SizedBox(width: Spacing.lg),
          ],
        ),
      ),
    );
  }
}

class _TipBanner extends StatelessWidget {
  final IconData icon;
  final String text;

  const _TipBanner({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: MovanaColors.primarySurface,
        borderRadius: BorderRadius.circular(Radii.md),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: MovanaColors.primary),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(text,
                style: MovanaTextStyles.bodySM
                    .copyWith(color: MovanaColors.primary)),
          ),
        ],
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoLine(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: MovanaColors.inkLight),
        const SizedBox(width: Spacing.sm),
        Text(text, style: MovanaTextStyles.bodySM),
      ],
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int step;
  final List<String> labels;

  const _StepIndicator({required this.step, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(labels.length * 2 - 1, (i) {
            if (i.isOdd) {
              return Expanded(
                child: Container(
                  height: 2,
                  color: i ~/ 2 < step
                      ? MovanaColors.primary
                      : MovanaColors.border,
                ),
              );
            }
            final idx = i ~/ 2;
            final done = idx < step;
            final active = idx == step;
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
        const SizedBox(height: Spacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.asMap().entries.map((e) {
            return Text(
              e.value,
              style: MovanaTextStyles.bodySM.copyWith(
                color: e.key == step
                    ? MovanaColors.primary
                    : MovanaColors.inkLight,
                fontWeight:
                    e.key == step ? FontWeight.w600 : FontWeight.w400,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _IdType {
  final String label;
  final IconData icon;
  const _IdType(this.label, this.icon);
}
