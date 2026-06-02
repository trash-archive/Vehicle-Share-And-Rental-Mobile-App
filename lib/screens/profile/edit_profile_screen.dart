import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../data/mock_data.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _bioCtrl;
  String? _selectedGender;
  bool _loading = false;
  bool _hasChanges = false;

  static const _genders = ['Male', 'Female', 'Prefer not to say'];

  @override
  void initState() {
    super.initState();
    final user = MockData.currentUser;
    _nameCtrl = TextEditingController(text: user.name);
    _emailCtrl = TextEditingController(text: user.email);
    _phoneCtrl = TextEditingController(text: user.phone);
    _locationCtrl = TextEditingController(text: user.location);
    _bioCtrl = TextEditingController(
      text: 'Vehicle enthusiast and frequent traveler around Cebu.',
    );
    _selectedGender = 'Male';

    // Track changes
    for (final c in [_nameCtrl, _emailCtrl, _phoneCtrl, _locationCtrl, _bioCtrl]) {
      c.addListener(() => setState(() => _hasChanges = true));
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _locationCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    if (!_hasChanges) return true;
    final leave = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Radii.xl)),
        title: const Text('Discard changes?',
            style: MovanaTextStyles.headingSM),
        content: Text(
          'You have unsaved changes. Are you sure you want to leave?',
          style: MovanaTextStyles.bodyMD,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Keep Editing'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Discard',
                style: TextStyle(color: MovanaColors.error)),
          ),
        ],
      ),
    );
    return leave ?? false;
  }

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _hasChanges = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Profile updated successfully!'),
        backgroundColor: MovanaColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = MockData.currentUser;
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
          title: const Text('Personal Information',
              style: MovanaTextStyles.headingSM),
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
                    child: Text(
                      'Unsaved',
                      style: MovanaTextStyles.labelSM
                          .copyWith(color: MovanaColors.primary),
                    ),
                  ),
                ),
              ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(Spacing.page),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Avatar section ────────────────────
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundImage:
                                  NetworkImage(user.avatarUrl),
                              backgroundColor: MovanaColors.surface,
                            ),
                            Positioned(
                              bottom: 2,
                              right: 2,
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: MovanaColors.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.camera_alt,
                                      size: 16, color: Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.sm),
                      Center(
                        child: TextButton(
                          onPressed: () {},
                          child: Text(
                            'Change Photo',
                            style: MovanaTextStyles.labelMD
                                .copyWith(color: MovanaColors.primary),
                          ),
                        ),
                      ),
                      const SizedBox(height: Spacing.xl),

                      // ── Basic info ────────────────────────
                      _SectionHeader('Basic Information'),
                      const SizedBox(height: Spacing.md),

                      _FieldLabel('Full Name'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _nameCtrl,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'Juan dela Cruz',
                          prefixIcon: Icon(Icons.person_outline,
                              size: 20, color: MovanaColors.inkLight),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Name is required'
                            : null,
                      ),
                      const SizedBox(height: Spacing.lg),

                      _FieldLabel('Email Address'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'juan@email.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              size: 20, color: MovanaColors.inkLight),
                          suffixIcon: Padding(
                            padding: EdgeInsets.all(12),
                            child: Icon(Icons.lock_outline,
                                size: 16, color: MovanaColors.inkLight),
                          ),
                        ),
                        // Email is read-only — requires re-verification to change
                        readOnly: true,
                        style: TextStyle(color: MovanaColors.inkLight),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: Spacing.xs, left: 4),
                        child: Text(
                          'Email changes require re-verification.',
                          style: MovanaTextStyles.bodySM,
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),

                      _FieldLabel('Phone Number'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          hintText: '+63 912 345 6789',
                          prefixIcon: Icon(Icons.phone_outlined,
                              size: 20, color: MovanaColors.inkLight),
                        ),
                        validator: (v) => v == null || v.trim().isEmpty
                            ? 'Phone number is required'
                            : null,
                      ),
                      const SizedBox(height: Spacing.lg),

                      _FieldLabel('Gender'),
                      const SizedBox(height: Spacing.sm),
                      Row(
                        children: _genders.map((g) {
                          final selected = _selectedGender == g;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() {
                                _selectedGender = g;
                                _hasChanges = true;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: EdgeInsets.only(
                                    right: g != _genders.last
                                        ? Spacing.sm
                                        : 0),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12),
                                decoration: BoxDecoration(
                                  color: selected
                                      ? MovanaColors.primarySurface
                                      : MovanaColors.surface,
                                  borderRadius:
                                      BorderRadius.circular(Radii.md),
                                  border: Border.all(
                                    color: selected
                                        ? MovanaColors.primary
                                        : MovanaColors.border,
                                    width: selected ? 1.5 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    g,
                                    style: MovanaTextStyles.labelSM
                                        .copyWith(
                                      color: selected
                                          ? MovanaColors.primary
                                          : MovanaColors.inkMedium,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: Spacing.xxl),

                      // ── Location & Bio ────────────────────
                      _SectionHeader('Location & Bio'),
                      const SizedBox(height: Spacing.md),

                      _FieldLabel('City / Location'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _locationCtrl,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Cebu City',
                          prefixIcon: Icon(Icons.location_on_outlined,
                              size: 20, color: MovanaColors.inkLight),
                        ),
                      ),
                      const SizedBox(height: Spacing.lg),

                      _FieldLabel('Bio'),
                      const SizedBox(height: Spacing.sm),
                      TextFormField(
                        controller: _bioCtrl,
                        maxLines: 4,
                        maxLength: 200,
                        decoration: const InputDecoration(
                          hintText:
                              'Tell others a bit about yourself...',
                        ),
                      ),
                      const SizedBox(height: Spacing.xxl),

                      // ── Member since (read-only) ──────────
                      Container(
                        padding: const EdgeInsets.all(Spacing.lg),
                        decoration: BoxDecoration(
                          color: MovanaColors.surface,
                          borderRadius: BorderRadius.circular(Radii.lg),
                          border: Border.all(color: MovanaColors.border),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: MovanaColors.primarySurface,
                                borderRadius:
                                    BorderRadius.circular(Radii.sm),
                              ),
                              child: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 16,
                                  color: MovanaColors.primary),
                            ),
                            const SizedBox(width: Spacing.md),
                            Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text('Member Since',
                                    style: MovanaTextStyles.bodySM),
                                Text(
                                  'June 2023',
                                  style: MovanaTextStyles.labelMD,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: Spacing.xxxl),
                    ],
                  ),
                ),
              ),

              // ── Save bar ──────────────────────────────────
              Container(
                padding: EdgeInsets.fromLTRB(
                  Spacing.page,
                  Spacing.md,
                  Spacing.page,
                  Spacing.md + MediaQuery.of(context).padding.bottom,
                ),
                decoration: const BoxDecoration(
                  color: MovanaColors.white,
                  border:
                      Border(top: BorderSide(color: MovanaColors.border)),
                ),
                child: MovanaButton(
                  label: 'Save Changes',
                  isLoading: _loading,
                  onPressed: _hasChanges ? _save : null,
                  icon: const Icon(Icons.check_rounded, size: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ──────────────────────────────────────
class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

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

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) =>
      Text(text, style: MovanaTextStyles.labelMD);
}
