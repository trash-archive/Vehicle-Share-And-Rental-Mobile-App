import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  bool _loading = false;
  bool _sent = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_emailCtrl.text.trim().isEmpty) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() {
      _loading = false;
      _sent = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(
        leading: const BackButton(),
        title: const MovanaLogo(showText: false),
        centerTitle: false,
      ),
      body: SafeArea(
        child: _sent ? _SuccessView(email: _emailCtrl.text.trim()) : _FormView(
          emailCtrl: _emailCtrl,
          loading: _loading,
          onSubmit: _submit,
        ),
      ),
    );
  }
}

// ── Form View ─────────────────────────────────
class _FormView extends StatelessWidget {
  final TextEditingController emailCtrl;
  final bool loading;
  final VoidCallback onSubmit;

  const _FormView({
    required this.emailCtrl,
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: Spacing.page, vertical: Spacing.xxl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: MovanaColors.primarySurface,
              borderRadius: BorderRadius.circular(Radii.lg),
            ),
            child: const Icon(Icons.lock_reset_rounded,
                size: 32, color: MovanaColors.primary),
          ),
          const SizedBox(height: Spacing.xl),
          const Text('Forgot\nPassword?', style: MovanaTextStyles.displayLG),
          const SizedBox(height: Spacing.sm),
          const Text(
            'Enter the email address linked to your account and we\'ll send you a reset link.',
            style: MovanaTextStyles.bodyLG,
          ),
          const SizedBox(height: Spacing.xxxl),
          Text('Email Address', style: MovanaTextStyles.labelMD),
          const SizedBox(height: Spacing.sm),
          TextFormField(
            controller: emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'juan@email.com',
              prefixIcon: Icon(Icons.email_outlined,
                  size: 20, color: MovanaColors.inkLight),
            ),
          ),
          const SizedBox(height: Spacing.xxl),
          MovanaButton(
            label: 'Send Reset Link',
            isLoading: loading,
            onPressed: onSubmit,
            icon: const Icon(Icons.send_rounded, size: 18),
          ),
          const SizedBox(height: Spacing.xl),
          Center(
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: RichText(
                text: const TextSpan(
                  text: 'Remember your password? ',
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
        ],
      ),
    );
  }
}

// ── Success View ──────────────────────────────
class _SuccessView extends StatelessWidget {
  final String email;
  const _SuccessView({required this.email});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Spacing.page),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: MovanaColors.primarySurface,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.mark_email_read_rounded,
                size: 46, color: MovanaColors.primary),
          ),
          const SizedBox(height: Spacing.xl),
          const Text('Check your email', style: MovanaTextStyles.displayMD,
              textAlign: TextAlign.center),
          const SizedBox(height: Spacing.md),
          Text(
            'We sent a password reset link to\n$email',
            style: MovanaTextStyles.bodyLG,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: Spacing.xxxl),
          MovanaButton(
            label: 'Back to Sign In',
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_rounded, size: 18),
          ),
          const SizedBox(height: Spacing.lg),
          // Resend option
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Didn\'t receive it? Resend email',
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: MovanaColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
