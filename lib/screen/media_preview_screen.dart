// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_api_service.dart';
import '../../../widget/gradient_button.dart';
import 'downloading_screen.dart';

/// Media preview shows ONLY data from API (no sample/hardcoded items).
class MediaPreviewScreen extends StatefulWidget {
  final String url;
  final String platformKey;
  final List<MediaItemResult> apiItems;
  final VoidCallback? onBack;
  final VoidCallback? onDownload;

  const MediaPreviewScreen({
    super.key,
    required this.url,
    required this.platformKey,
    required this.apiItems,
    this.onBack,
    this.onDownload,
  });

  @override
  State<MediaPreviewScreen> createState() => _MediaPreviewScreenState();
}

class _MediaPreviewScreenState extends State<MediaPreviewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;
  int _currentIndex = 0;

  List<MediaItemResult> get _items => widget.apiItems;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.mediaEntranceAnimMs),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceController, curve: Curves.easeOutCubic));
    _entranceController.forward();
  }

  @override
  void dispose() {
    _entranceController.dispose();
    super.dispose();
  }

  void _prev() {
    if (_currentIndex > 0) setState(() => _currentIndex--);
  }

  void _next() {
    if (_currentIndex < _items.length - 1) setState(() => _currentIndex++);
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: widget.url));
    if (!mounted) return;
    final colors = StringsService.strings.colors;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          StringsService.strings.mediaPreview.copyLink,
          style: TextStyle(color: colors.white),
        ),
        backgroundColor: colors.darkBg2,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final media = strings.mediaPreview;
    final images = strings.images;

    if (_items.isEmpty) {
      return Scaffold(
        body: Center(
          child: Text(
            'No media found',
            style: TextStyle(
              color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
            ),
          ),
        ),
      );
    }

    final item = _items[_currentIndex];
    final total = _items.length;
    final platformName = strings.home.platforms[widget.platformKey]!;
    final metaParts = <String>[
      item.type,
      if (item.size.trim().isNotEmpty) item.size,
      if (item.quality.trim().isNotEmpty) item.quality,
    ];

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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.mediaPaddingH),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppValues.mediaTopGap),
                        Row(
                          children: [
                            _CircleBtn(
                              icon: Icons.arrow_back_ios_new_rounded,
                              isDark: isDark,
                              colors: colors,
                              onTap: widget.onBack ??
                                  () => Navigator.of(context).maybePop(),
                            ),
                            Expanded(
                              child: Text(
                                media.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: AppValues.mediaTitleSize,
                                  fontWeight: FontWeight.w600,
                                  color: isDark
                                      ? colors.darkTextPrimary
                                      : colors.lightTextPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '${_currentIndex + 1}/$total',
                              style: TextStyle(
                                fontSize: AppValues.mediaCounterSize,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? colors.darkTextSecondary
                                    : colors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.mediaHeaderGap),
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.asset(
                                images.platformIcon(widget.platformKey),
                                width: AppValues.mediaPlatformBadge,
                                height: AppValues.mediaPlatformBadge,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.link_rounded,
                                  size: AppValues.mediaPlatformBadge,
                                  color: colors.neonPurple,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              platformName,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? colors.darkTextSecondary
                                    : colors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.mediaPreviewGap),
                        Expanded(
                          child: Center(
                            child: GlassContainer(
                              borderRadius: AppValues.mediaPreviewRadius,
                              isDark: isDark,
                              opacity: 0.14,
                              borderOpacity: 0.08,
                              borderWidth: 1,
                              blur: 16,
                              showBorder: true,
                              child: SizedBox(
                                width: double.infinity,
                                height: AppValues.mediaPreviewHeight,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    // API thumbnail or gradient fallback
                                    Positioned.fill(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                            AppValues.mediaPreviewRadius),
                                        child: item.thumbnail.isNotEmpty
                                            ? Image.network(
                                                item.thumbnail,
                                                fit: BoxFit.cover,
                                                errorBuilder: (_, __, ___) =>
                                                    _GradientPlaceholder(
                                                        colors: colors),
                                              )
                                            : _GradientPlaceholder(
                                                colors: colors),
                                      ),
                                    ),
                                    if (item.type == 'MP4')
                                      Container(
                                        width: AppValues.mediaPlaySize,
                                        height: AppValues.mediaPlaySize,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: colors.white.withOpacity(0.92),
                                          boxShadow: [
                                            BoxShadow(
                                              color: colors.black
                                                  .withOpacity(0.25),
                                              blurRadius: 12,
                                              offset: const Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.play_arrow_rounded,
                                          size: 32,
                                          color: colors.black,
                                        ),
                                      ),
                                    if (_currentIndex > 0)
                                      Positioned(
                                        left: 12,
                                        child: _NavArrow(
                                          icon: Icons.chevron_left_rounded,
                                          isDark: isDark,
                                          colors: colors,
                                          onTap: _prev,
                                        ),
                                      ),
                                    if (_currentIndex < total - 1)
                                      Positioned(
                                        right: 12,
                                        child: _NavArrow(
                                          icon: Icons.chevron_right_rounded,
                                          isDark: isDark,
                                          colors: colors,
                                          onTap: _next,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppValues.mediaPreviewGap),
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: AppValues.mediaNameSize,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? colors.darkTextPrimary
                                : colors.lightTextPrimary,
                          ),
                        ),
                        const SizedBox(height: AppValues.mediaInfoGap),
                        Text(
                          metaParts.join('  •  '),
                          style: TextStyle(
                            fontSize: AppValues.mediaMetaSize,
                            color: isDark
                                ? colors.darkTextTertiary
                                : colors.lightTextTertiary,
                          ),
                        ),
                        const SizedBox(height: AppValues.mediaButtonGap),
                        GradientButton(
                          text: media.downloadNow,
                          icon: Icons.download_rounded,
                          onTap: widget.onDownload ??
                              () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => DownloadingScreen(
                                      fileName:
                                          '${item.title}.${item.type.toLowerCase()}',
                                      fileSize: item.size.isNotEmpty
                                          ? item.size
                                          : '—',
                                      fileType: item.type,
                                      url: widget.url,
                                      platform: widget.platformKey,
                                      mediaUrl: item.url,
                                    ),
                                  ),
                                );
                              },
                        ),
                        const SizedBox(height: AppValues.mediaActionGap),
                        Row(
                          children: [
                            Expanded(
                              child: _ActionBtn(
                                label: media.share,
                                icon: Icons.share_rounded,
                                isDark: isDark,
                                colors: colors,
                                onTap: () {},
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _ActionBtn(
                                label: media.copyLink,
                                icon: Icons.link_rounded,
                                isDark: isDark,
                                colors: colors,
                                onTap: _copyLink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppValues.mediaBottomGap),
                      ],
                    ),
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

class _GradientPlaceholder extends StatelessWidget {
  final dynamic colors;
  const _GradientPlaceholder({required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colors.gradientStart.withOpacity(0.45),
            colors.gradientMid.withOpacity(0.55),
            colors.gradientEnd.withOpacity(0.4),
          ],
        ),
      ),
    );
  }
}

class _CircleBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final VoidCallback? onTap;

  const _CircleBtn({
    required this.icon,
    required this.isDark,
    required this.colors,
    this.onTap,
  });

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
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
        ),
      ),
    );
  }
}

class _NavArrow extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final VoidCallback onTap;

  const _NavArrow({
    required this.icon,
    required this.isDark,
    required this.colors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: AppValues.mediaArrowSize,
        height: AppValues.mediaArrowSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? colors.black.withOpacity(0.45)
              : colors.white.withOpacity(0.85),
        ),
        child: Icon(
          icon,
          size: 24,
          color: isDark ? colors.white : colors.black,
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final VoidCallback? onTap;

  const _ActionBtn({
    required this.label,
    required this.icon,
    required this.isDark,
    required this.colors,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: GlassContainer(
        height: AppValues.mediaActionHeight,
        borderRadius: AppValues.mediaActionRadius,
        isDark: isDark,
        opacity: 0.12,
        borderOpacity: 0.08,
        borderWidth: 1,
        blur: 12,
        showBorder: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color:
                  isDark ? colors.darkTextSecondary : colors.lightTextSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
