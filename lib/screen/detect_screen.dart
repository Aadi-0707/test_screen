import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/strings_service.dart';
import '../../../widget/glass_input_field.dart';
import '../../../widget/gradient_button.dart';
import 'media_preview_screen.dart';
import '../../../data/download_api_service.dart';

class DetectScreen extends StatefulWidget {
  final String url;
  final String? platformKey;
  final VoidCallback? onContinue;
  final VoidCallback? onBack;

  const DetectScreen({
    super.key,
    this.url = '',
    this.platformKey,
    this.onContinue,
    this.onBack,
  });

  @override
  State<DetectScreen> createState() => _DetectScreenState();
}

class _DetectScreenState extends State<DetectScreen>
    with TickerProviderStateMixin {
  late TextEditingController _urlController;
  late AnimationController _ringController;
  late AnimationController _entranceController;
  late AnimationController _successController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  late Animation<double> _successFade;

  bool _detected = false;
  String _platformKey = 'instagram';
  String _platformName = '';

  @override
  void initState() {
    super.initState();
    _urlController = TextEditingController(text: widget.url);
    if (widget.platformKey != null && widget.platformKey!.isNotEmpty) {
      _platformKey = widget.platformKey!;
      final platforms = StringsService.strings.home.platforms;
      _platformName = platforms[_platformKey]!;
    }
    _initAnimations();
    _entranceController.forward();

    // Wait until after first frame — FocusScope needs context ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.url.trim().isNotEmpty) {
        _startDetection();
      } else if (widget.platformKey != null) {
        setState(() {
          _detected = false;
        });
      }
    });
  }

  void _detectPlatformFromUrl(String url) {
    final lower = url.toLowerCase();
    final platforms = StringsService.strings.home.platforms;
    if (lower.contains('instagram') || lower.contains('instagr.am')) {
      _platformKey = 'instagram';
      _platformName = platforms['instagram']!;
    } else if (lower.contains('facebook') || lower.contains('fb.')) {
      _platformKey = 'facebook';
      _platformName = platforms['facebook']!;
    } else if (lower.contains('pinterest') || lower.contains('pin.it')) {
      _platformKey = 'pinterest';
      _platformName = platforms['pinterest']!;
    } else if (lower.contains('twitter') ||
        lower.contains('x.com') ||
        lower.contains('t.co')) {
      _platformKey = 'x';
      _platformName = platforms['x']!;
    } else if (widget.platformKey != null && widget.platformKey!.isNotEmpty) {
      _platformKey = widget.platformKey!;
      _platformName = platforms[_platformKey]!;
    } else {
      _platformKey = 'instagram';
      _platformName = platforms['instagram']!;
    }
  }

  void _initAnimations() {
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.detectEntranceAnimMs),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceController, curve: Curves.easeOutCubic));

    _ringController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.detectAnimMs),
    );

    _successController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _successFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _successController, curve: Curves.easeOut),
    );
  }

  bool _isValidUrl(String url) {
    final lower = url.trim().toLowerCase();
    if (lower.isEmpty) return false;
    return lower.contains('instagram.com') ||
        lower.contains('instagr.am') ||
        lower.contains('facebook.com') ||
        lower.contains('fb.watch') ||
        lower.contains('fb.com') ||
        lower.contains('pinterest.com') ||
        lower.contains('pin.it') ||
        lower.contains('twitter.com') ||
        lower.contains('x.com') ||
        lower.contains('t.co');
  }

  void _showInvalidUrlDialog({required bool empty}) {
    final home = StringsService.strings.home;
    final colors = StringsService.strings.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? colors.darkBg2 : colors.lightBg1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          home.invalidUrlTitle,
          style: TextStyle(
            color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          empty ? home.emptyUrlMessage : home.invalidUrlMessage,
          style: TextStyle(
            color:
                isDark ? colors.darkTextSecondary : colors.lightTextSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              home.invalidUrlOk,
              style: TextStyle(
                color: colors.neonCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _startDetection() {
    final url = _urlController.text.trim();
    if (url.isEmpty) {
      _showInvalidUrlDialog(empty: true);
      return;
    }
    if (!_isValidUrl(url)) {
      _showInvalidUrlDialog(empty: false);
      return;
    }

    FocusScope.of(context).unfocus();
    _detectPlatformFromUrl(url);
    setState(() {
      _detected = false;
    });
    _successController.reset();
    _ringController.reset();
    _ringController.forward().then((_) {
      if (mounted) {
        setState(() {
          _detected = true;
        });
        _successController.forward();
      }
    });
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isEmpty) return;
    _urlController.text = text;
    _urlController.selection = TextSelection.collapsed(offset: text.length);
    _startDetection();
  }

  Future<void> _onContinuePressed() async {
    if (widget.onContinue != null) {
      widget.onContinue!();
      return;
    }
    final url = _urlController.text.trim();
    final home = StringsService.strings.home;
    if (url.isEmpty) {
      _showInvalidUrlDialog(empty: true);
      return;
    }
    if (!DownloadApiService.isSupportedUrl(url) && !_isValidUrl(url)) {
      _showInvalidUrlDialog(empty: false);
      return;
    }
    final result = await DownloadApiService.instance.fetchMedia(
      url,
      platformKey: _platformKey,
    );
    if (!mounted) return;
    if (!result.success || result.items.isEmpty) {
      _showApiErrorDialog(result.error ?? home.networkError);
      return;
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MediaPreviewScreen(
          url: url,
          platformKey: _platformKey,
          apiItems: result.items,
        ),
      ),
    );
  }

  void _showApiErrorDialog(String message) {
    final home = StringsService.strings.home;
    final colors = StringsService.strings.colors;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? colors.darkBg2 : colors.lightBg1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          home.apiErrorTitle,
          style: TextStyle(
            color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color:
                isDark ? colors.darkTextSecondary : colors.lightTextSecondary,
            fontSize: 14,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              home.invalidUrlOk,
              style: TextStyle(
                color: colors.neonCyan,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _urlController.dispose();
    _ringController.dispose();
    _entranceController.dispose();
    _successController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final detect = strings.detect;
    final home = strings.home;
    final images = strings.images;

    if (_platformName.isEmpty) {
      _platformName = home.platforms[_platformKey]!;
    }

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(
                isDark ? strings.images.homeBgDark : strings.images.homeBgLight,
                fit: BoxFit.cover,
              ),
            ),
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                    sigmaX: AppValues.homeBgBlur, sigmaY: AppValues.homeBgBlur),
                child: Container(
                  color: isDark
                      ? colors.black.withOpacity(AppValues.homeBgOverlayOpacity)
                      : colors.white
                          .withOpacity(AppValues.homeBgOverlayOpacity * 0.6),
                ),
              ),
            ),
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics(),
                        ),
                        keyboardDismissBehavior:
                            ScrollViewKeyboardDismissBehavior.onDrag,
                        padding: EdgeInsets.only(
                          left: AppValues.detectPaddingH,
                          right: AppValues.detectPaddingH,
                          bottom: bottomInset + AppValues.detectButtonGap,
                        ),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            minHeight: constraints.maxHeight - bottomInset,
                          ),
                          child: IntrinsicHeight(
                            child: Column(
                              children: [
                                SizedBox(height: AppValues.detectTopGap),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: _BackBtn(
                                    isDark: isDark,
                                    colors: colors,
                                    onTap: widget.onBack ??
                                        () => Navigator.of(context).maybePop(),
                                  ),
                                ),
                                SizedBox(height: AppValues.detectTitleGap),
                                Text(
                                  detect.title,
                                  style: TextStyle(
                                    fontSize: AppValues.detectTitleSize,
                                    fontWeight: FontWeight.w700,
                                    color: isDark
                                        ? colors.darkTextPrimary
                                        : colors.lightTextPrimary,
                                  ),
                                ),
                                SizedBox(height: AppValues.detectSubtitleGap),
                                Text(
                                  detect.subtitle,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: AppValues.detectSubtitleSize,
                                    fontWeight: FontWeight.w400,
                                    color: isDark
                                        ? colors.darkTextSecondary
                                        : colors.lightTextSecondary,
                                  ),
                                ),
                                SizedBox(height: AppValues.detectRingGap),
                                _DetectRing(
                                  controller: _ringController,
                                  detected: _detected,
                                  imagePath: images.platformIcon(_platformKey),
                                  colors: colors,
                                ),
                                SizedBox(height: AppValues.detectPlatformGap),
                                Text(
                                  _platformName,
                                  style: TextStyle(
                                    fontSize: AppValues.detectPlatformNameSize,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? colors.darkTextPrimary
                                        : colors.lightTextPrimary,
                                  ),
                                ),
                                SizedBox(height: AppValues.detectSuccessGap),
                                SizedBox(
                                  height: 22,
                                  child: FadeTransition(
                                    opacity: _successFade,
                                    child: _detected
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 18,
                                                color: colors.success,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                detect.success,
                                                style: TextStyle(
                                                  fontSize: AppValues
                                                      .detectSuccessSize,
                                                  fontWeight: FontWeight.w500,
                                                  color: colors.success,
                                                ),
                                              ),
                                            ],
                                          )
                                        : const SizedBox.shrink(),
                                  ),
                                ),
                                SizedBox(height: AppValues.detectUrlGap),
                                GlassInputField(
                                  controller: _urlController,
                                  hintText: home.pasteHint,
                                  isDark: isDark,
                                  onPaste: _pasteFromClipboard,
                                ),
                                SizedBox(height: AppValues.detectButtonGap * 2),
                                GradientButton(
                                  text: detect.continueButton,
                                  onTap: _detected
                                      ? _onContinuePressed
                                      : () {
                                          if (_urlController.text
                                              .trim()
                                              .isNotEmpty) {
                                            _startDetection();
                                          }
                                        },
                                ),
                                SizedBox(height: AppValues.detectButtonGap),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackBtn extends StatelessWidget {
  final bool isDark;
  final dynamic colors;
  final VoidCallback? onTap;

  const _BackBtn({
    required this.isDark,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppValues.detectBackBtnSize,
        height: AppValues.detectBackBtnSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? colors.white.withOpacity(0.08)
              : colors.white.withOpacity(0.55),
          border: Border.all(
            color: isDark
                ? colors.white.withOpacity(0.1)
                : colors.black.withOpacity(0.06),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          size: 18,
          color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
        ),
      ),
    );
  }
}

class _DetectRing extends StatelessWidget {
  final AnimationController controller;
  final bool detected;
  final String imagePath;
  final dynamic colors;

  const _DetectRing({
    required this.controller,
    required this.detected,
    required this.imagePath,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppValues.detectRingSize,
      height: AppValues.detectRingSize,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _RingPainter(
              progress: controller.value,
              colors: colors,
              completed: detected,
            ),
            child: Center(
              child: Container(
                width: AppValues.detectLogoSize,
                height: AppValues.detectLogoSize,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: colors.neonPurple.withOpacity(0.35),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: colors.neonPurple.withOpacity(0.3),
                      child: Icon(Icons.link_rounded,
                          color: colors.white, size: 28),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double progress;
  final dynamic colors;
  final bool completed;

  _RingPainter({
    required this.progress,
    required this.colors,
    required this.completed,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - AppValues.detectRingStroke) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppValues.detectRingStroke
      ..color = colors.white.withOpacity(0.12);
    canvas.drawCircle(center, radius, bgPaint);

    final gradient = SweepGradient(
      colors: [
        colors.gradientStart,
        colors.gradientMid,
        colors.gradientEnd,
        colors.gradientStart,
      ],
      stops: const [0.0, 0.35, 0.7, 1.0],
    );

    final fgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = AppValues.detectRingStroke
      ..strokeCap = StrokeCap.round
      ..shader = gradient.createShader(rect);

    canvas.drawArc(
      rect,
      -1.5708,
      progress * 6.2832,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) =>
      old.progress != progress || old.completed != completed;
}
