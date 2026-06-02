import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';

class EditVehicleScreen extends StatefulWidget {
  final VehicleModel vehicle;
  const EditVehicleScreen({super.key, required this.vehicle});

  @override
  State<EditVehicleScreen> createState() => _EditVehicleScreenState();
}

class _EditVehicleScreenState extends State<EditVehicleScreen> {
  final _formKey = GlobalKey<FormState>();
  int _step = 0;
  bool _hasChanges = false;
  bool _loading = false;

  late TextEditingController _nameCtrl;
  late TextEditingController _locationCtrl;
  String? _selectedCategory;

  late TextEditingController _typeCtrl;
  late TextEditingController _yearCtrl;
  late TextEditingController _colorCtrl;
  late TextEditingController _plateCtrl;
  late TextEditingController _descCtrl;

  late TextEditingController _dailyCtrl;
  late TextEditingController _hourlyCtrl;
  late bool _isAvailable;

  static const _steps = ['Basic Info', 'Vehicle Details', 'Pricing'];

  static const _categoryOptions = [
    ('personal', '🏍️ Personal Transport'),
    ('commercial', '🚐 Commercial Vehicles'),
    ('construction', '🏗️ Construction Equipment'),
    ('agricultural', '🚜 Agricultural Equipment'),
  ];

  @override
  void initState() {
    super.initState();
    final v = widget.vehicle;
    _nameCtrl = TextEditingController(text: v.name);
    _locationCtrl = TextEditingController(text: v.location);
    _selectedCategory = v.category.name;
    _typeCtrl = TextEditingController(text: v.type);
    _yearCtrl = TextEditingController(text: v.year.toString());
    _colorCtrl = TextEditingController(text: v.color);
    _plateCtrl = TextEditingController(text: v.plateNumber);
    _descCtrl = TextEditingController(text: v.description);
    _dailyCtrl = TextEditingController(text: v.pricePerDay.toStringAsFixed(0));
    _hourlyCtrl = TextEditingController(text: v.pricePerHour.toStringAsFixed(0));
    _isAvailable = v.isAvailable;

    for (final c in [_nameCtrl, _locationCtrl, _typeCtrl, _yearCtrl,
        _colorCtrl, _plateCtrl, _descCtrl, _dailyCtrl, _hourlyCtrl]) {
      c.addListener(() => setState(() => _hasChanges = true));
    }
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _locationCtrl, _typeCtrl, _yearCtrl,
        _colorCtrl, _plateCtrl, _descCtrl, _dailyCtrl, _hourlyCtrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.xl)),
        title: const Text('Discard changes?', style: MovanaTextStyles.headingSM),
        content: Text('You have unsaved changes. Leave anyway?',
            style: MovanaTextStyles.bodyMD),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Keep Editing')),
          TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Discard',
                  style: TextStyle(color: MovanaColors.error))),
        ],
      ),
    );
    return leave ?? false;
  }

  void _next() {
    if (_step < _steps.length - 1) {
      setState(() => _step++);
    } else {
      _save();
    }
  }

  void _save() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() => _loading = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Listing updated successfully!'),
        backgroundColor: MovanaColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_hasChanges,
      onPopInvokedWithResult: (didPop, _) async {
        if (didPop) return;
        final leave = await _onWillPop();
        if (leave && mounted) Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: MovanaColors.white,
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Listing', style: MovanaTextStyles.headingSM),
              Text(widget.vehicle.name,
                  style: MovanaTextStyles.bodySM
                      .copyWith(color: MovanaColors.primary)),
            ],
          ),
          leading: const BackButton(),
          actions: [
            if (_hasChanges)
              Padding(
                padding: const EdgeInsets.only(right: Spacing.md),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: MovanaColors.primarySurface,
                      borderRadius: BorderRadius.circular(Radii.pill),
                    ),
                    child: Text('Unsaved',
                        style: MovanaTextStyles.labelSM
                            .copyWith(color: MovanaColors.primary)),
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              // ── Step indicator ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    Spacing.page, Spacing.lg, Spacing.page, 0),
                child: Column(
                  children: [
                    Row(
                      children: List.generate(_steps.length * 2 - 1, (i) {
                        if (i.isOdd) {
                          return Expanded(
                            child: Container(
                              height: 2,
                              color: i ~/ 2 < _step
                                  ? MovanaColors.primary
                                  : MovanaColors.border,
                            ),
                          );
                        }
                        final idx = i ~/ 2;
                        final done = idx < _step;
                        final active = idx == _step;
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
                                ? const Icon(Icons.check,
                                    size: 14, color: Colors.white)
                                : Text('${idx + 1}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: active
                                          ? MovanaColors.primary
                                          : MovanaColors.inkLight,
                                    )),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: Spacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _steps.asMap().entries.map((e) {
                        return Text(e.value,
                            style: MovanaTextStyles.bodySM.copyWith(
                              color: e.key == _step
                                  ? MovanaColors.primary
                                  : MovanaColors.inkLight,
                              fontWeight: e.key == _step
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ));
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const Divider(height: Spacing.xxl),

              // ── Step content ────────────────────────────
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                      Spacing.page, 0, Spacing.page, Spacing.page),
                  child: _buildStep(),
                ),
              ),

              // ── Bottom nav ──────────────────────────────
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
                        label: _step < _steps.length - 1
                            ? 'Next'
                            : 'Save Changes',
                        isLoading: _loading,
                        onPressed: _next,
                        icon: _step == _steps.length - 1
                            ? const Icon(Icons.check_rounded, size: 18)
                            : null,
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

  Widget _buildStep() {
    switch (_step) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label('Vehicle Name'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _nameCtrl,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'e.g. Honda Click 125i',
                prefixIcon: Icon(Icons.directions_car_outlined,
                    size: 20, color: MovanaColors.inkLight),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.lg),
            _Label('Category'),
            const SizedBox(height: Spacing.sm),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: const InputDecoration(),
              hint: const Text('Select category'),
              items: _categoryOptions
                  .map((c) => DropdownMenuItem(
                        value: c.$1,
                        child: Text(c.$2),
                      ))
                  .toList(),
              onChanged: (v) => setState(() {
                _selectedCategory = v;
                _hasChanges = true;
              }),
            ),
            const SizedBox(height: Spacing.lg),
            _Label('Pick-up Location'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _locationCtrl,
              decoration: const InputDecoration(
                hintText: 'e.g. Lahug, Cebu City',
                prefixIcon: Icon(Icons.location_on_outlined,
                    size: 20, color: MovanaColors.inkLight),
              ),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Label('Vehicle Type'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _typeCtrl,
              decoration: const InputDecoration(
                  hintText: 'e.g. Scooter, Sedan, Excavator'),
            ),
            const SizedBox(height: Spacing.lg),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Year'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _yearCtrl,
                        keyboardType: TextInputType.number,
                        decoration:
                            const InputDecoration(hintText: 'e.g. 2022'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _Label('Color'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _colorCtrl,
                        decoration:
                            const InputDecoration(hintText: 'e.g. White'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.lg),
            _Label('Plate Number'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _plateCtrl,
              decoration:
                  const InputDecoration(hintText: 'e.g. ABC 1234'),
            ),
            const SizedBox(height: Spacing.lg),
            _Label('Description'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _descCtrl,
              maxLines: 5,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText:
                    'Describe your vehicle, condition, inclusions...',
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current photos
            _Label('Current Photos'),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 90,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.vehicle.imageUrls.length + 1,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: Spacing.sm),
                itemBuilder: (_, i) {
                  if (i == widget.vehicle.imageUrls.length) {
                    return GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          color: MovanaColors.surface,
                          borderRadius:
                              BorderRadius.circular(Radii.md),
                          border: Border.all(
                              color: MovanaColors.border,
                              style: BorderStyle.solid),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_rounded,
                                size: 24,
                                color: MovanaColors.inkLight),
                            SizedBox(height: 2),
                            Text('Add photo',
                                style: MovanaTextStyles.bodySM),
                          ],
                        ),
                      ),
                    );
                  }
                  return Stack(
                    children: [
                      ClipRRect(
                        borderRadius:
                            BorderRadius.circular(Radii.md),
                        child: Image.network(
                          widget.vehicle.imageUrls[i],
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 90,
                            height: 90,
                            color: MovanaColors.surface,
                          ),
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close,
                              size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: Spacing.xxl),

            // Pricing
            _Label('Daily Rate (₱)'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _dailyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  prefixText: '₱ ', hintText: '0.00'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Required' : null,
            ),
            const SizedBox(height: Spacing.lg),
            _Label('Hourly Rate (₱)'),
            const SizedBox(height: Spacing.sm),
            TextFormField(
              controller: _hourlyCtrl,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  prefixText: '₱ ', hintText: '0.00'),
            ),
            const SizedBox(height: Spacing.xxl),

            // Availability toggle
            Container(
              padding: const EdgeInsets.all(Spacing.lg),
              decoration: BoxDecoration(
                color: _isAvailable
                    ? MovanaColors.success.withOpacity(0.06)
                    : MovanaColors.surface,
                borderRadius: BorderRadius.circular(Radii.lg),
                border: Border.all(
                  color: _isAvailable
                      ? MovanaColors.success.withOpacity(0.3)
                      : MovanaColors.border,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: _isAvailable
                          ? MovanaColors.success.withOpacity(0.12)
                          : MovanaColors.border.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isAvailable
                          ? Icons.check_circle_rounded
                          : Icons.pause_circle_rounded,
                      size: 20,
                      color: _isAvailable
                          ? MovanaColors.success
                          : MovanaColors.inkLight,
                    ),
                  ),
                  const SizedBox(width: Spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isAvailable
                              ? 'Listing is Live'
                              : 'Listing is Paused',
                          style: MovanaTextStyles.labelMD,
                        ),
                        Text(
                          _isAvailable
                              ? 'Renters can discover and book this vehicle.'
                              : 'Hidden from search results.',
                          style: MovanaTextStyles.bodyMD,
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _isAvailable,
                    onChanged: (v) => setState(() {
                      _isAvailable = v;
                      _hasChanges = true;
                    }),
                    activeColor: MovanaColors.success,
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.xxxl),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: MovanaTextStyles.labelMD);
}
