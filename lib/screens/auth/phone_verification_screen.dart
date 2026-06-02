import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme/app_theme.dart';
import '../../widgets/shared_widgets.dart';

class PhoneVerificationScreen extends StatefulWidget {
  final String phone;
  const PhoneVerificationScreen({super.key, required this.phone});

  @override
  State<PhoneVerificationScreen> createState() =>
      _PhoneVerificationScreenState();
}

class _PhoneVerificationScreenState extends State<PhoneVerificationScreen> {
  final List<TextEditingController> _ctrls =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _nodes = List.generate(6, (_) => FocusNode());

  bool _loading = false;
  bool _verified = false;
  bool _error = false;
  int _resendCountdown = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    for (final c in _ctrls) c.dispose();
    for (final n in _nodes) n.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _resendCountdown = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendCountdown == 0) {
        t.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  String get _otp => _ctrls.map((c) => c.text).join();

  void _onChanged(String val, int index) {
    setState(() => _error = false);
    if (val.length == 1 && index < 5) {
      _nodes[index + 1].requestFocus();
    }
    if (val.isEmpty && index > 0) {
      _nodes[index - 1].requestFocus();
    }
    // Auto-verify when all 6 filled
    if (_otp.length == 6) _verify();
  }

  void _verify() async {
    if (_otp.length < 6) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    // Mock: any 6-digit code works EXCEPT "000000"
    if (_otp == '000000') {
      setState(() {
        _loading = false;
        _error = true;
      });
      for (final c in _ctrls) c.clear();
      _nodes[0].requestFocus();
    } else {
      setState(() {
        _loading = false;
        _verified = true;
      });
    }
  }

  void _resend() {
    if (_resendCountdown > 0) return;
    for (final c in _ctrls) c.clear();
    _nodes[0].requestFocus();
    setState(() => _error = false);
    _startCountdown();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('OTP resent successfully!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_verified) return _SuccessView(phone: widget.phone);

    return Scaffold(
      backgroundColor: MovanaColors.white,
      appBar: AppBar(leading: const BackButton()),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: Spacing.page, vertical: Spacing.xxl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: MovanaColors.primarySurface,
                  borderRadius: BorderRadius.circular(Radii.lg),
                ),
                child: const Icon(Icons.sms_outlined,
                    size: 32, color: MovanaColors.primary),
              ),
              const SizedBox(height: Spacing.xl),
              const Text('Verify your\nphone number',
                  style: MovanaTextStyles.displayLG),
              const SizedBox(height: Spacing.sm),
              Text(
                'We sent a 6-digit verification code to\n${widget.phone}',
                style: MovanaTextStyles.bodyLG,
              ),
              const SizedBox(height: Spacing.xxxl),

              // OTP boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(6, (i) {
                  return SizedBox(
                    width: 48,
                    height: 58,
                    child: TextFormField(
                      controller: _ctrls[i],
                      focusNode: _nodes[i],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(1),
                      ],
                      style: const TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: MovanaColors.ink,
                      ),
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        filled: true,
                        fillColor: _error
                            ? MovanaColors.error.withOpacity(0.06)
                            : MovanaColors.surface,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.md),
                          borderSide: BorderSide(
                            color: _error
                                ? MovanaColors.error
                                : MovanaColors.border,
                            width: _error ? 1.5 : 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.md),
                          borderSide: BorderSide(
                            color: _error
                                ? MovanaColors.error
                                : MovanaColors.primary,
                            width: 2,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.md),
                        ),
                      ),
                      onChanged: (v) => _onChanged(v, i),
                    ),
                  );
                }),
              ),

              // Error message
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: _error ? 32 : 0,
                child: _error
                    ? Padding(
                        padding: const EdgeInsets.only(top: Spacing.sm),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline,
                                size: 14, color: MovanaColors.error),
                            const SizedBox(width: 4),
                            Text(
                              'Invalid code. Please try again.',
                              style: MovanaTextStyles.bodySM
                                  .copyWith(color: MovanaColors.error),
                            ),
                          ],
                        ),
                      )
                    : null,
              ),

              const SizedBox(height: Spacing.xxl),

              // Verify button
              MovanaButton(
                label: 'Verify',
                isLoading: _loading,
                onPressed: _otp.length == 6 ? _verify : null,
                icon: const Icon(Icons.check_rounded, size: 18),
              ),
              const SizedBox(height: Spacing.xl),

              // Resend
              Center(
                child: GestureDetector(
                  onTap: _resendCountdown == 0 ? _resend : null,
                  child: RichText(
                    text: TextSpan(
                      text: 'Didn\'t receive the code? ',
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        color: MovanaColors.inkLight,
                        fontSize: 14,
                      ),
                      children: [
                        TextSpan(
                          text: _resendCountdown > 0
                              ? 'Resend in ${_resendCountdown}s'
                              : 'Resend',
                          style: TextStyle(
                            color: _resendCountdown > 0
                                ? MovanaColors.inkLight
                                : MovanaColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Spacing.xl),

              // Change number hint
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Text(
                    'Wrong number? Go back',
                    style: TextStyle(
                      fontFamily: 'Inter',
                      color: MovanaColors.inkLight,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
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

// ── Success View ──────────────────────────────
class _SuccessView extends StatelessWidget {
  final String phone;
  const _SuccessView({required this.phone});

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
                child: const Icon(Icons.phone_iphone_rounded,
                    size: 50, color: MovanaColors.primary),
              ),
              const SizedBox(height: Spacing.xl),
              const Text('Phone Verified!',
                  style: MovanaTextStyles.displayMD,
                  textAlign: TextAlign.center),
              const SizedBox(height: Spacing.md),
              Text(
                '$phone has been verified\nand linked to your account.',
                style: MovanaTextStyles.bodyLG,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: Spacing.xxl),
              Container(
                padding: const EdgeInsets.all(Spacing.lg),
                decoration: BoxDecoration(
                  color: MovanaColors.success.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(Radii.lg),
                  border: Border.all(
                      color: MovanaColors.success.withOpacity(0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        size: 22, color: MovanaColors.success),
                    SizedBox(width: Spacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Phone Verified',
                              style: MovanaTextStyles.labelMD),
                          Text(
                              'Your account security has been improved.',
                              style: MovanaTextStyles.bodyMD),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Spacing.xxxl),
              MovanaButton(
                label: 'Back to Profile',
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.arrow_back_rounded, size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
