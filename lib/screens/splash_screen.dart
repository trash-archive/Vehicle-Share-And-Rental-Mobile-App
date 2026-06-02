import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import 'auth/login_screen.dart';

// ──────────────────────────────────────────────
// Splash Screen
// ──────────────────────────────────────────────
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scale = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _slide = Tween<double>(begin: 30, end: 0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );

    _ctrl.forward();

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MovanaColors.primary,
      body: Center(
        child: FadeTransition(
          opacity: _fade,
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, _slide.value),
              child: Transform.scale(
                scale: _scale.value,
                child: child,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Text(
                      'M',
                      style: TextStyle(
                        fontFamily: 'Syne',
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Movana',
                  style: TextStyle(
                    fontFamily: 'Syne',
                    fontSize: 36,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Find. Rent. Move.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.75),
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// Onboarding Screen
// ──────────────────────────────────────────────
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageCtrl = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardPage(
      emoji: '🗺️',
      title: 'Discover rentals\nnear you',
      subtitle:
          'Browse vehicles and equipment on an interactive map. Find what you need, right where you are.',
      bg: MovanaColors.primary,
    ),
    _OnboardPage(
      emoji: '🔒',
      title: 'Safe &\ntrusted listings',
      subtitle:
          'Every owner is verified. Every vehicle is checked. Rent with confidence and total peace of mind.',
      bg: Color(0xFF1A365D),
    ),
    _OnboardPage(
      emoji: '💸',
      title: 'Earn from\nyour vehicles',
      subtitle:
          'List your idle vehicles and equipment. Set your own rates. Start earning passive income today.',
      bg: MovanaColors.accent,
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageCtrl,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemCount: _pages.length,
            itemBuilder: (_, i) => _OnboardPageWidget(page: _pages[i]),
          ),
          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                    Spacing.page, 0, Spacing.page, Spacing.xxl),
                child: Column(
                  children: [
                    // Dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _pages.length,
                        (i) => AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: i == _currentPage ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(
                                i == _currentPage ? 1.0 : 0.4),
                            borderRadius: BorderRadius.circular(Radii.pill),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: Spacing.xxl),
                    // Action buttons
                    Row(
                      children: [
                        if (_currentPage < _pages.length - 1)
                          TextButton(
                            onPressed: _goToLogin,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          )
                        else
                          const SizedBox(width: 60),
                        const Spacer(),
                        GestureDetector(
                          onTap: _next,
                          child: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Radii.pill),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(
                                _currentPage == _pages.length - 1
                                    ? Icons.check_rounded
                                    : Icons.arrow_forward_rounded,
                                color: _pages[_currentPage].bg,
                              ),
                            ),
                          ),
                        ),
                      ],
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

class _OnboardPage {
  final String emoji;
  final String title;
  final String subtitle;
  final Color bg;
  const _OnboardPage({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.bg,
  });
}

class _OnboardPageWidget extends StatelessWidget {
  final _OnboardPage page;
  const _OnboardPageWidget({required this.page});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: page.bg,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              Spacing.page, 60, Spacing.page, 160),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emoji in circle
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(Radii.xxl),
                ),
                child: Center(
                  child: Text(
                    page.emoji,
                    style: const TextStyle(fontSize: 44),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                page.title,
                style: const TextStyle(
                  fontFamily: 'Syne',
                  fontSize: 38,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  height: 1.1,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: Spacing.lg),
              Text(
                page.subtitle,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.white.withOpacity(0.75),
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
