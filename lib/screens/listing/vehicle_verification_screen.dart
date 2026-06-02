import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class VehicleVerificationScreen extends StatefulWidget {
  const VehicleVerificationScreen({super.key});

  @override
  State<VehicleVerificationScreen> createState() =>
      _VehicleVerificationScreenState();
}

class _VehicleVerificationScreenState
    extends State<VehicleVerificationScreen> {
  int _step = 0;
  bool _loading = false;
  bool _submitted = false;

  // Step 0 — OR/CR
  bool _orUploaded = false;
  bool _crUploaded = false;

  // Step 1 — Vehicle Photos
  final List<bool> _vehiclePhotos = [false, false, false, false];

  // Step 2 — Plate + Confirm
  final _plateCtrl = TextEditingController();
  bool _plateConfirmed = false;

  @override
  void dispose() {
    _plateCtrl.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_step) {
      case 0: return _orUploaded && _crUploaded;
      case 1: return _vehiclePhotos.where((v) => v).length >= 2;
      case 2: return _plateCtrl.text.trim().isNotEmpty && _plateConfirmed;
    }
    return false;
  }

  void _next() {
    if (_step < 2) {
      setState(() => _step++);
    } else {
      _submit();
    }
  }

  void _submit() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _submitted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) return _SubmittedView();

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const Text('Vehicle Verification',
            style: MovanaTextStyles.headingSM),
        leading: const BackButton(),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
                Spacing.page, Spacing.md, Spacing.page, 0),
            child: _StepIndicator(step: _step, labels: const [
              'OR / CR',
              'Vehicle Photos',
              'Plate & Confirm',
            ]),
          ),
          const SizedBox(height: Spacing.lg),
          const Divider(height: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(Spacing.page),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildStep(),
              ),
            ),
          ),
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
                    label: _step < 2 ? 'Continue' : 'Submit for Review',
                    isLoading: _loading,
                    onPressed: _canProceed ? _next : null,
                    icon: _step == 2
                        ? const Icon(Icons.verified_outlined, size: 18)
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
        return _Step0OrCr(
          key: const ValueKey(0),
          orUploaded: _orUploaded,
          crUploaded: _crUploaded,
          onOrTap: () => setState(() => _orUploaded = true),
          onCrTap: () => setState(() => _crUploaded = true),
        );
      case 1:
        return _Step1VehiclePhotos(
          key: const ValueKey(1),
          photos: _vehiclePhotos,
          onPhotoTap: (i) =>
              setState(() => _vehiclePhotos[i] = !_vehiclePhotos[i]),
        );
      case 2:
        return _Step2PlateConfirm(
          key: const ValueKey(2),
          plateCtrl: _plateCtrl,
          confirmed: _plateConfirmed,
          onConfirmChanged: (v) => setState(() => _plateConfirmed = v),
          onPlateChanged: () => setState(() {}),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Step 0: OR/CR Upload ──────────────────────
class _Step0OrCr extends StatelessWidget {
  final bool orUploaded;
  final bool crUploaded;
  final VoidCallback onOrTap;
  final VoidCallback onCrTap;

  const _Step0OrCr({
    super.key,
    required this.orUploaded,
    required this.crUploaded,
    required this.onOrTap,
    required this.onCrTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Upload OR / CR', style: MovanaTextStyles.headingSM),
        const SizedBox(height: Spacing.sm),
        const Text(
          'Upload your vehicle\'s Official Receipt (OR) and Certificate of Registration (CR) to verify ownership.',
          style: MovanaTextStyles.bodyMD,
        ),
        const SizedBox(height: Spacing.xxl),
        _DocUploadCard(
          title: 'Official Receipt (OR)',
          subtitle: 'Latest payment receipt from LTO',
          icon: Icons.receipt_long_outlined,
          uploaded: orUploaded,
          onTap: onOrTap,
        ),
        const SizedBox(height: Spacing.lg),
        _DocUploadCard(
          title: 'Certificate of Registration (CR)',
          subtitle: 'Latest CR from LTO',
          icon: Icons.description_outlined,
          uploaded: crUploaded,
          onTap: onCrTap,
        ),
        const SizedBox(height: Spacing.xl),
        _InfoCard(
          icon: Icons.info_outline,
          color: MovanaColors.info,
          text: 'Make sure the documents are current and clearly photographed. Expired OR/CR will not be accepted.',
        ),
      ],
    );
  }
}

// ── Step 1: Vehicle Photos ────────────────────
class _Step1VehiclePhotos extends StatelessWidget {
  final List<bool> photos;
  final ValueChanged<int> onPhotoTap;

  const _Step1VehiclePhotos({
    super.key,
    required this.photos,
    required this.onPhotoTap,
  });

  static const _angles = [
    ('Front view', Icons.directions_car_outlined),
    ('Rear view', Icons.directions_car_outlined),
    ('Driver side', Icons.transfer_within_a_station),
    ('Interior', Icons.airline_seat_recline_normal_outlined),
  ];

  int get _uploadedCount => photos.where((v) => v).length;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Vehicle Photos', style: MovanaTextStyles.headingSM),
                  SizedBox(height: Spacing.xs),
                  Text('Upload at least 2 photos of your vehicle.',
                      style: MovanaTextStyles.bodyMD),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: _uploadedCount >= 2
                    ? MovanaColors.success.withOpacity(0.1)
                    : MovanaColors.surface,
                borderRadius: BorderRadius.circular(Radii.pill),
              ),
              child: Text(
                '$_uploadedCount / ${photos.length}',
                style: MovanaTextStyles.labelSM.copyWith(
                  color: _uploadedCount >= 2
                      ? MovanaColors.success
                      : MovanaColors.inkLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: Spacing.xxl),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: Spacing.md,
            crossAxisSpacing: Spacing.md,
            childAspectRatio: 1.1,
          ),
          itemCount: photos.length,
          itemBuilder: (_, i) {
            final uploaded = photos[i];
            final (label, icon) = _angles[i];
            return GestureDetector(
              onTap: () => onPhotoTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: uploaded
                      ? MovanaColors.success.withOpacity(0.08)
                      : MovanaColors.surface,
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(
                    color:
                        uploaded ? MovanaColors.success : MovanaColors.border,
                    width: uploaded ? 1.5 : 1,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      uploaded
                          ? Icons.check_circle_rounded
                          : Icons.add_photo_alternate_outlined,
                      size: 36,
                      color: uploaded
                          ? MovanaColors.success
                          : MovanaColors.inkLight,
                    ),
                    const SizedBox(height: Spacing.sm),
                    Text(
                      label,
                      style: MovanaTextStyles.labelSM.copyWith(
                        color: uploaded
                            ? MovanaColors.success
                            : MovanaColors.inkMedium,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: Spacing.xl),
        _InfoCard(
          icon: Icons.wb_sunny_outlined,
          color: MovanaColors.warning,
          text: 'Take photos in daylight. All photos must show the actual vehicle, not from the internet.',
        ),
      ],
    );
  }
}

// ── Step 2: Plate & Confirm ───────────────────
class _Step2PlateConfirm extends StatelessWidget {
  final TextEditingController plateCtrl;
  final bool confirmed;
  final ValueChanged<bool> onConfirmChanged;
  final VoidCallback onPlateChanged;

  const _Step2PlateConfirm({
    super.key,
    required this.plateCtrl,
    required this.confirmed,
    required this.onConfirmChanged,
    required this.onPlateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Plate & Confirmation', style: MovanaTextStyles.headingSM),
        const SizedBox(height: Spacing.sm),
        const Text(
          'Enter your vehicle\'s plate number and confirm that all submitted information is accurate.',
          style: MovanaTextStyles.bodyMD,
        ),
        const SizedBox(height: Spacing.xxl),
        Text('Plate Number', style: MovanaTextStyles.labelMD),
        const SizedBox(height: Spacing.sm),
        TextField(
          controller: plateCtrl,
          textCapitalization: TextCapitalization.characters,
          onChanged: (_) => onPlateChanged(),
          decoration: const InputDecoration(
            hintText: 'e.g. ABC 1234',
            prefixIcon:
                Icon(Icons.badge_outlined, size: 20, color: MovanaColors.inkLight),
          ),
        ),
        const SizedBox(height: Spacing.xxl),
        // Declaration checkbox
        GestureDetector(
          onTap: () => onConfirmChanged(!confirmed),
          child: Container(
            padding: const EdgeInsets.all(Spacing.lg),
            decoration: BoxDecoration(
              color: confirmed
                  ? MovanaColors.primarySurface
                  : MovanaColors.surface,
              borderRadius: BorderRadius.circular(Radii.lg),
              border: Border.all(
                color: confirmed ? MovanaColors.primary : MovanaColors.border,
                width: confirmed ? 1.5 : 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(
                    color: confirmed
                        ? MovanaColors.primary
                        : MovanaColors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: confirmed
                          ? MovanaColors.primary
                          : MovanaColors.border,
                    ),
                  ),
                  child: confirmed
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: Spacing.md),
                const Expanded(
                  child: Text(
                    'I declare that all documents submitted are authentic, the vehicle is properly registered with the LTO, and the information provided is accurate to the best of my knowledge.',
                    style: MovanaTextStyles.bodyMD,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: Spacing.xl),
        _InfoCard(
          icon: Icons.gavel_outlined,
          color: MovanaColors.error,
          text: 'Submitting false documents may result in permanent account suspension and legal action.',
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
                child: const Icon(Icons.directions_car_rounded,
                    size: 50, color: MovanaColors.primary),
              ),
              const SizedBox(height: Spacing.xl),
              const Text('Submitted for Review!',
                  style: MovanaTextStyles.displayMD,
                  textAlign: TextAlign.center),
              const SizedBox(height: Spacing.md),
              const Text(
                'Your vehicle documents are under review.\nYou\'ll be notified once verification is complete.',
                style: MovanaTextStyles.bodyLG,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xxxl),
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
                          Text('Pending Verification',
                              style: MovanaTextStyles.labelMD),
                          Text(
                              'Review takes up to 48 hours on business days.',
                              style: MovanaTextStyles.bodyMD),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxl),
              MovanaButton(
                label: 'Back to My Listings',
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Shared Widgets ────────────────────────────
class _DocUploadCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool uploaded;
  final VoidCallback onTap;

  const _DocUploadCard({
    required this.title,
    required this.subtitle,
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
        padding: const EdgeInsets.all(Spacing.lg),
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
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: uploaded
                    ? MovanaColors.success.withOpacity(0.12)
                    : MovanaColors.border.withOpacity(0.4),
                borderRadius: BorderRadius.circular(Radii.sm),
              ),
              child: Icon(
                uploaded ? Icons.check_rounded : icon,
                size: 22,
                color:
                    uploaded ? MovanaColors.success : MovanaColors.inkLight,
              ),
            ),
            const SizedBox(width: Spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: MovanaTextStyles.labelMD.copyWith(
                        color:
                            uploaded ? MovanaColors.success : MovanaColors.ink,
                      )),
                  Text(
                    uploaded ? 'Uploaded successfully ✓' : subtitle,
                    style: MovanaTextStyles.bodyMD,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.add_photo_alternate_outlined,
              size: 22,
              color: MovanaColors.inkLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _InfoCard(
      {required this.icon, required this.color, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.06),
        borderRadius: BorderRadius.circular(Radii.md),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: Spacing.sm),
          Expanded(
            child: Text(text,
                style:
                    MovanaTextStyles.bodySM.copyWith(color: color)),
          ),
        ],
      ),
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
                color:
                    e.key == step ? MovanaColors.primary : MovanaColors.inkLight,
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
