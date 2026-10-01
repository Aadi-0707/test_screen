import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import 'download_complete_screen.dart';

class DownloadingScreen extends StatefulWidget {
  final String fileName;
  final String fileSize;
  final String fileType;
  final String url;
  final String platform;
  final String mediaUrl;

  const DownloadingScreen({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    this.url = '',
    this.platform = 'instagram',
    this.mediaUrl = '',
  });

  @override
  State<DownloadingScreen> createState() => _DownloadingScreenState();
}

class _DownloadingScreenState extends State<DownloadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => DownloadCompleteScreen(
                fileName: widget.fileName,
                fileSize: widget.fileSize,
                fileType: widget.fileType,
                url: widget.url,
                platform: widget.platform,
              ),
            ),
          );
        }
      });
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _togglePause() {
    setState(() {
      _paused = !_paused;
      if (_paused) {
        _progressController.stop();
      } else {
        _progressController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final d = strings.downloading;

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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _CircleBtn(
                        icon: Icons.arrow_back_ios_new_rounded,
                        isDark: isDark,
                        colors: colors,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      d.title,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? colors.darkTextPrimary
                            : colors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _progressController,
                      builder: (_, __) {
                        final p = _progressController.value;
                        final pct = (p * 100).toInt();
                        return Column(
                          children: [
                            SizedBox(
                              width: 180,
                              height: 180,
                              child: CustomPaint(
                                painter: _ProgressRingPainter(
                                  progress: p,
                                  colors: colors,
                                ),
                                child: Center(
                                  child: Text(
                                    '$pct%',
                                    style: TextStyle(
                                      fontSize: 36,
                                      fontWeight: FontWeight.w700,
                                      color: isDark
                                          ? colors.darkTextPrimary
                                          : colors.lightTextPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 28),
                            Text(
                              d.downloadingText,
                              style: TextStyle(
                                fontSize: 15,
                                color: isDark
                                    ? colors.darkTextSecondary
                                    : colors.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(p * 12.4).toStringAsFixed(1)} MB / ${widget.fileSize}',
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? colors.darkTextTertiary
                                    : colors.lightTextTertiary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt_rounded,
                                    size: 16, color: colors.neonCyan),
                                const SizedBox(width: 4),
                                Text(
                                  '4.8 ${d.speedUnit}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: colors.neonCyan,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                    const Spacer(),
                    GlassContainer(
                      borderRadius: 16,
                      isDark: isDark,
                      opacity: 0.12,
                      borderOpacity: 0.08,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: colors.primaryGradient,
                            ),
                            child: Icon(Icons.play_arrow_rounded,
                                color: colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.fileName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: isDark
                                        ? colors.darkTextPrimary
                                        : colors.lightTextPrimary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${widget.fileType}  •  ${widget.fileSize}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark
                                        ? colors.darkTextTertiary
                                        : colors.lightTextTertiary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: _OutlineBtn(
                            label: _paused ? d.resume : d.pause,
                            icon: _paused
                                ? Icons.play_arrow_rounded
                                : Icons.pause_rounded,
                            isDark: isDark,
                            colors: colors,
                            onTap: _togglePause,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _OutlineBtn(
                            label: d.cancel,
                            icon: Icons.close_rounded,
                            isDark: isDark,
                            colors: colors,
                            danger: true,
                            onTap: () => Navigator.of(context).maybePop(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRingPainter extends CustomPainter {
  final double progress;
  final dynamic colors;
  _ProgressRingPainter({required this.progress, required this.colors});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 10) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 8
        ..color = colors.white.withOpacity(0.12),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round
      ..shader = SweepGradient(
        colors: [
          colors.gradientStart,
          colors.gradientMid,
          colors.gradientEnd,
          colors.gradientStart,
        ],
      ).createShader(rect);

    canvas.drawArc(rect, -1.5708, progress * 6.2832, false, paint);
  }

  @override
  bool shouldRepaint(covariant _ProgressRingPainter old) =>
      old.progress != progress;
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final VoidCallback? onTap;
  const _CircleBtn(
      {required this.icon,
      required this.isDark,
      required this.colors,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? colors.white.withOpacity(0.08)
              : colors.white.withOpacity(0.55),
          border: Border.all(
            color: isDark
                ? colors.white.withOpacity(0.1)
                : colors.black.withOpacity(0.06),
          ),
        ),
        child: Icon(icon,
            size: 18,
            color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary),
      ),
    );
  }
}

class _OutlineBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final bool danger;
  final VoidCallback? onTap;

  const _OutlineBtn({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.colors,
    this.danger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final c = danger
        ? colors.error
        : (isDark ? colors.darkTextSecondary : colors.lightTextSecondary);
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        height: 48,
        borderRadius: 14,
        isDark: isDark,
        opacity: 0.12,
        borderOpacity: 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: c),
            const SizedBox(width: 8),
            Text(label,
                style: TextStyle(
                    fontSize: 14, fontWeight: FontWeight.w500, color: c)),
          ],
        ),
      ),
    );
  }
}
