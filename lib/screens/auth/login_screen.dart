import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';
import '../../models/models.dart';
import '../main_shell.dart';
import 'forgot_password_screen.dart';

// ──────────────────────────────────────────────
// Login Screen
// ──────────────────────────────────────────────
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  void _login() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.page, vertical: Spacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              const MovanaLogo(),
              const SizedBox(height: Spacing.xxxl),
              // Heading
              const Text('Welcome\nback 👋', style: MovanaTextStyles.displayLG),
              const SizedBox(height: Spacing.sm),
              const Text(
                'Sign in to continue to your account.',
                style: MovanaTextStyles.bodyLG,
              ),
              const SizedBox(height: Spacing.xxxl),
              // Email
              _Label('Email address'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'juan@email.com',
                  prefixIcon: Icon(Icons.email_outlined,
                      size: 20, color: MovanaColors.inkLight),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              // Password
              _Label('Password'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: '••••••••',
                  prefixIcon: const Icon(Icons.lock_outline,
                      size: 20, color: MovanaColors.inkLight),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                      size: 20,
                      color: MovanaColors.inkLight,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.md),
              // Forgot pass
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (_) => const ForgotPasswordScreen()),
                  ),
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: MovanaColors.primary,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              // Login btn
              MovanaButton(
                label: 'Sign In',
                onPressed: _login,
                isLoading: _loading,
              ),
              const SizedBox(height: Spacing.lg),
              // Divider
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('or', style: MovanaTextStyles.bodyMD),
                ),
                const Expanded(child: Divider()),
              ]),
              const SizedBox(height: Spacing.lg),
              // Google btn
              _SocialButton(
                label: 'Continue with Google',
                emoji: 'G',
                onTap: _login,
              ),
              const SizedBox(height: Spacing.xl),
              // Sign up
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  ),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Don\'t have an account? ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: MovanaColors.inkLight,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign up',
                          style: TextStyle(
                            color: MovanaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
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
// Register Screen
// ──────────────────────────────────────────────
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  UserRole _selectedRole = UserRole.renter;

  void _register() async {
    setState(() => _loading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const MainShell()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        title: const MovanaLogo(showText: false),
        centerTitle: false,
        leading: BackButton(color: MovanaColors.ink),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.page, vertical: Spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Create your\naccount ✨',
                  style: MovanaTextStyles.displayLG),
              const SizedBox(height: Spacing.sm),
              const Text(
                'Join thousands of Filipinos renting vehicles.',
                style: MovanaTextStyles.bodyLG,
              ),
              const SizedBox(height: Spacing.xxl),
              // Role selection
              _Label('I want to'),
              const SizedBox(height: Spacing.sm),
              Row(children: [
                _RoleChip(
                  label: '🔍  Find rentals',
                  selected: _selectedRole == UserRole.renter,
                  onTap: () => setState(() => _selectedRole = UserRole.renter),
                ),
                const SizedBox(width: Spacing.sm),
                _RoleChip(
                  label: '🏍️  List my vehicle',
                  selected: _selectedRole == UserRole.owner,
                  onTap: () => setState(() => _selectedRole = UserRole.owner),
                ),
              ]),
              const SizedBox(height: Spacing.lg),
              // Fields
              _Label('Full Name'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  hintText: 'Juan dela Cruz',
                  prefixIcon: Icon(Icons.person_outline,
                      size: 20, color: MovanaColors.inkLight),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              _Label('Email Address'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'juan@email.com',
                  prefixIcon: Icon(Icons.email_outlined,
                      size: 20, color: MovanaColors.inkLight),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              _Label('Phone Number'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: '+63 912 345 6789',
                  prefixIcon: Icon(Icons.phone_outlined,
                      size: 20, color: MovanaColors.inkLight),
                ),
              ),
              const SizedBox(height: Spacing.lg),
              _Label('Password'),
              const SizedBox(height: Spacing.sm),
              TextFormField(
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  hintText: 'At least 8 characters',
                  prefixIcon: const Icon(Icons.lock_outline,
                      size: 20, color: MovanaColors.inkLight),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscure
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      size: 20,
                      color: MovanaColors.inkLight,
                    ),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),
              // Terms
              Row(
                children: [
                  Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: MovanaColors.primary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Icon(Icons.check, size: 12, color: Colors.white),
                  ),
                  const SizedBox(width: Spacing.sm),
                  Expanded(
                    child: RichText(
                      text: const TextSpan(
                        text: 'I agree to the ',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            color: MovanaColors.inkMedium,
                            fontSize: 13),
                        children: [
                          TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                                color: MovanaColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                          TextSpan(text: ' and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                color: MovanaColors.primary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Spacing.xxl),
              MovanaButton(
                label: 'Create Account',
                onPressed: _register,
                isLoading: _loading,
              ),
              const SizedBox(height: Spacing.lg),
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: RichText(
                    text: const TextSpan(
                      text: 'Already have an account? ',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        color: MovanaColors.inkLight,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: 'Sign in',
                          style: TextStyle(
                            color: MovanaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Helpers ────────────────────────────────────
class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: MovanaTextStyles.labelMD,
      );
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback onTap;
  const _SocialButton(
      {required this.label, required this.emoji, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          border: Border.all(color: MovanaColors.border),
          borderRadius: BorderRadius.circular(Radii.md),
          color: MovanaColors.surface,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w900)),
            const SizedBox(width: Spacing.md),
            Text(label, style: MovanaTextStyles.labelMD),
          ],
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _RoleChip(
      {required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? MovanaColors.primarySurface : MovanaColors.surface,
            border: Border.all(
              color: selected ? MovanaColors.primary : MovanaColors.border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(Radii.md),
          ),
          child: Center(
            child: Text(
              label,
              style: MovanaTextStyles.labelMD.copyWith(
                color: selected ? MovanaColors.primary : MovanaColors.inkMedium,
              ),
            ),
          ),
        ),
      ),
    );
  }
}


