import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/_values.dart';
import '../../core/utils/glass_container.dart';
import '../../core/utils/strings_service.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const SplashScreen({super.key, this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _pulseController;
  late AnimationController _progressController;
  late AnimationController _fadeController;
  late AnimationController _particleController;

  late Animation<double> _logoScale;
  late Animation<double> _logoOpacity;
  late Animation<double> _textOpacity;
  late Animation<double> _textSlide;
  late Animation<double> _progressValue;
  late Animation<double> _pulseScale;

  @override
  void initState() {
    super.initState();
    _initAnimations();
    _startAnimations();
  }

  void _initAnimations() {
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.splashLogoAnimMs),
    );
    _logoScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _logoController,
          curve: const Interval(0.0, 0.5, curve: Curves.easeOut)),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.splashPulseAnimMs),
    )..repeat(reverse: true);
    _pulseScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.splashTextAnimMs),
    );
    _textOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _textSlide = Tween<double>(begin: 24.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.splashProgressAnimMs),
    );
    _progressValue = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 250));
    _fadeController.forward();
    await Future.delayed(const Duration(milliseconds: 150));
    _progressController.forward();

    // Instant navigation when progress completes — no extra delay
    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onFinished?.call();
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _pulseController.dispose();
    _progressController.dispose();
    _fadeController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: AnimatedBuilder(
          animation: Listenable.merge([
            _logoController,
            _pulseController,
            _progressController,
            _fadeController,
            _particleController,
          ]),
          builder: (context, _) {
            return Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          colors.darkBg1,
                          colors.darkBg2,
                          colors.darkBg3,
                          colors.darkBg1
                        ]
                      : [
                          colors.lightBg1,
                          colors.lightBg2,
                          colors.lightBg3,
                          colors.lightBg1
                        ],
                ),
              ),
              child: Stack(
                children: [
                  ..._buildOrbs(isDark, colors),
                  ..._buildParticles(isDark, colors),
                  SafeArea(
                    child: SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(flex: 3),
                          Center(child: _buildLogo(isDark, colors)),
                          const SizedBox(height: AppValues.splashLogoGap),
                          Center(child: _buildTitle(strings, isDark, colors)),
                          const Spacer(flex: 2),
                          Center(
                              child: _buildProgress(strings, isDark, colors)),
                          const SizedBox(height: AppValues.splashBottomGap),
                          Center(
                            child: Opacity(
                              opacity: _textOpacity.value,
                              child: Text(
                                strings.splash.version,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDark
                                      ? colors.darkTextTertiary
                                      : colors.lightTextTertiary,
                                  fontSize: AppValues.splashVersionSize,
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: AppValues.splashVersionGap),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo(bool isDark, dynamic colors) {
    return Transform.scale(
      scale: _logoScale.value * _pulseScale.value,
      child: Opacity(
        opacity: _logoOpacity.value,
        child: GlowContainer(
          size: AppValues.splashLogoSize + 40,
          glowColor: colors.neonPurple,
          blur: AppValues.splashGlowBlur * _pulseScale.value,
          spread: AppValues.splashGlowSpread * _pulseScale.value,
          child: Center(
            child: GlassContainer(
              width: AppValues.splashLogoSize,
              height: AppValues.splashLogoSize,
              borderRadius: AppValues.splashLogoRadius,
              isDark: isDark,
              opacity: AppValues.splashGlassOpacity,
              borderOpacity: AppValues.splashBorderOpacity,
              borderWidth: AppValues.splashBorderWidth,
              blur: AppValues.splashGlassBlur,
              showBorder: true,
              child: Center(
                child: Container(
                  width: AppValues.splashLogoInnerSize,
                  height: AppValues.splashLogoInnerSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: colors.threeColorGradient,
                    boxShadow: [
                      BoxShadow(
                          color: colors.neonCyan.withOpacity(0.5),
                          blurRadius: 20,
                          spreadRadius: 1),
                      BoxShadow(
                          color: colors.neonPink.withOpacity(0.3),
                          blurRadius: 14,
                          spreadRadius: 0),
                    ],
                  ),
                  child: Icon(Icons.download_rounded,
                      size: AppValues.splashIconSize, color: colors.white),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(dynamic strings, bool isDark, dynamic colors) {
    return Transform.translate(
      offset: Offset(0, _textSlide.value),
      child: Opacity(
        opacity: _textOpacity.value,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App name with 3-color gradient
            ShaderMask(
              shaderCallback: (bounds) =>
                  colors.threeColorGradient.createShader(
                Rect.fromLTWH(0, 0, bounds.width, bounds.height),
              ),
              child: Text(
                strings.appName,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: AppValues.splashTitleSize,
                  fontWeight: FontWeight.w800,
                  color: colors.white,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            const SizedBox(height: AppValues.splashTitleGap),
            Text(
              strings.appTagline,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: AppValues.splashTaglineSize,
                fontWeight: FontWeight.w400,
                color: isDark
                    ? colors.darkTextSecondary
                    : colors.lightTextSecondary,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress(dynamic strings, bool isDark, dynamic colors) {
    return Opacity(
      opacity: _textOpacity.value,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GlassContainer(
            width: AppValues.splashProgressWidth,
            height: AppValues.splashProgressHeight,
            borderRadius: 100,
            isDark: isDark,
            opacity: 0.08,
            borderOpacity: AppValues.splashBorderOpacity,
            borderWidth: 1.2,
            blur: AppValues.splashGlassBlur,
            showBorder: true,
            padding: const EdgeInsets.all(AppValues.splashProgressPadding),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: isDark
                        ? colors.white.withOpacity(0.06)
                        : colors.black.withOpacity(0.05),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: _progressValue.value,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      gradient: colors.threeColorGradient,
                      boxShadow: [
                        BoxShadow(
                            color: colors.neonPink.withOpacity(0.5),
                            blurRadius: 8),
                        BoxShadow(
                            color: colors.neonCyan.withOpacity(0.3),
                            blurRadius: 6),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.splashProgressGap),
          Text(
            strings.splash.loadingText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppValues.splashLoadingSize,
              fontWeight: FontWeight.w400,
              color:
                  isDark ? colors.darkTextTertiary : colors.lightTextTertiary,
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildOrbs(bool isDark, dynamic colors) {
    return [
      Positioned(
        top: -80,
        left: -60,
        child: Transform.scale(
          scale: 0.9 + (_pulseScale.value - 1.0) * 2,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                colors.neonPurple.withOpacity(isDark ? 0.28 : 0.15),
                colors.neonPurple.withOpacity(0.0),
              ]),
            ),
          ),
        ),
      ),
      Positioned(
        bottom: -100,
        right: -80,
        child: Transform.scale(
          scale: 1.0 + (1.1 - _pulseScale.value) * 1.5,
          child: Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(colors: [
                colors.neonCyan.withOpacity(isDark ? 0.22 : 0.12),
                colors.neonCyan.withOpacity(0.0),
              ]),
            ),
          ),
        ),
      ),
      Positioned(
        top: MediaQuery.of(context).size.height * 0.35,
        right: -40,
        child: Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [
              colors.neonPink.withOpacity(isDark ? 0.18 : 0.1),
              colors.neonPink.withOpacity(0.0),
            ]),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildParticles(bool isDark, dynamic colors) {
    final particles = <Widget>[];
    final random = math.Random(42);
    for (int i = 0; i < 14; i++) {
      final size = 2.5 + random.nextDouble() * 4;
      final left = random.nextDouble() * MediaQuery.of(context).size.width;
      final top = random.nextDouble() * MediaQuery.of(context).size.height;
      final speed = 0.3 + random.nextDouble() * 0.7;
      final opacity = 0.2 + random.nextDouble() * 0.3;
      final offset =
          math.sin((_particleController.value * 2 * math.pi * speed) + i) * 18;
      final c = i % 3 == 0
          ? colors.neonPurple
          : i % 3 == 1
              ? colors.neonCyan
              : colors.neonPink;
      particles.add(Positioned(
        left: left,
        top: top + offset,
        child: Opacity(
          opacity: opacity * _logoOpacity.value,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c,
              boxShadow: [
                BoxShadow(
                    color: c.withOpacity(0.7), blurRadius: 6, spreadRadius: 1)
              ],
            ),
          ),
        ),
      ));
    }
    return particles;
  }
}
