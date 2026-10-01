import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_downloader/widget/glass_input_field.dart';
import 'package:insta_downloader/widget/gradient_button.dart';
import 'package:insta_downloader/widget/platform_icons.dart';
import 'package:insta_downloader/widget/recent_download_item.dart';
import 'package:insta_downloader/screen/detect_screen.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_storage.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onOpenMenu;
  final ValueChanged<int>? onNavChanged;

  const HomeScreen({super.key, this.onOpenMenu, this.onNavChanged});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _linkController = TextEditingController();
  late AnimationController _entranceController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    DownloadStorage.instance.addListener(_onStorageChanged);
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.homeEntranceAnimMs),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _entranceController, curve: Curves.easeOutCubic));
    _entranceController.forward();
  }

  void _onStorageChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    DownloadStorage.instance.removeListener(_onStorageChanged);
    _linkController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  /// Returns true if URL belongs to a supported platform.
  bool _isValidUrl(String url) {
    final lower = url.trim().toLowerCase();
    if (lower.isEmpty) return false;
    final uri = Uri.tryParse(lower);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https')) {
      // also allow bare domain without scheme
      if (!lower.contains('.')) return false;
    }
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

  void _onDownloadTap() {
    final url = _linkController.text.trim();
    if (url.isEmpty) {
      _showInvalidUrlDialog(empty: true);
      return;
    }
    if (!_isValidUrl(url)) {
      _showInvalidUrlDialog(empty: false);
      return;
    }
    FocusScope.of(context).unfocus();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => DetectScreen(url: url),
      ),
    );
  }

  Future<void> _pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text?.trim() ?? '';
    if (text.isEmpty) return;
    setState(() {
      _linkController.text = text;
      _linkController.selection = TextSelection.collapsed(offset: text.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final home = strings.home;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        // Keep bottom nav fixed — do not push up when keyboard opens
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            // Background image from JSON
            Positioned.fill(
              child: Image.asset(
                isDark ? strings.images.homeBgDark : strings.images.homeBgLight,
                fit: BoxFit.cover,
              ),
            ),

            // Frost blur overlay on background
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
              bottom: false,
              child: FadeTransition(
                opacity: _fadeAnim,
                child: SlideTransition(
                  position: _slideAnim,
                  child: Column(
                    children: [
                      Expanded(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics(),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppValues.homePaddingH),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  minHeight: constraints.maxHeight,
                                ),
                                child: IntrinsicHeight(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                          height: AppValues.homeTopGap),

                                      // Top bar only
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _CircleIconBtn(
                                            icon: Icons.menu_rounded,
                                            isDark: isDark,
                                            colors: colors,
                                            onTap: widget.onOpenMenu,
                                          ),
                                          _CircleIconBtn(
                                            icon: Icons.settings_rounded,
                                            isDark: isDark,
                                            colors: colors,
                                            onTap: () =>
                                                widget.onNavChanged?.call(3),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height: AppValues.homeTitleGap),

                                      // "Download Anything" — Anything in 3 colors
                                      _buildTitle(home, isDark, colors),

                                      const SizedBox(
                                          height: AppValues.homeSubtitleGap),

                                      Text(
                                        home.subtitle,
                                        style: TextStyle(
                                          fontSize: AppValues.homeSubtitleSize,
                                          fontWeight: FontWeight.w400,
                                          color: isDark
                                              ? colors.darkTextSecondary
                                              : colors.lightTextSecondary,
                                        ),
                                      ),

                                      const SizedBox(
                                          height: AppValues.homeInputGap),

                                      GlassInputField(
                                        controller: _linkController,
                                        hintText: home.pasteHint,
                                        isDark: isDark,
                                        onPaste: _pasteFromClipboard,
                                      ),

                                      const SizedBox(
                                          height: AppValues.homeButtonGap),

                                      GradientButton(
                                        text: home.downloadButton,
                                        icon: Icons.download_rounded,
                                        onTap: _onDownloadTap,
                                      ),

                                      const SizedBox(
                                          height: AppValues.homePlatformGap),

                                      PlatformIconsRow(
                                        platforms: home.platforms,
                                        isDark: isDark,
                                        onTap: (platformKey) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => DetectScreen(
                                                platformKey: platformKey,
                                              ),
                                            ),
                                          );
                                        },
                                      ),

                                      const SizedBox(
                                          height: AppValues.homeRecentGap),

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            home.recentDownloads,
                                            style: TextStyle(
                                              fontSize: AppValues
                                                  .homeSectionTitleSize,
                                              fontWeight: FontWeight.w600,
                                              color: isDark
                                                  ? colors.darkTextPrimary
                                                  : colors.lightTextPrimary,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {},
                                            child: Row(
                                              children: [
                                                Text(
                                                  home.seeAll,
                                                  style: TextStyle(
                                                    fontSize: AppValues
                                                        .homeSeeAllSize,
                                                    fontWeight: FontWeight.w500,
                                                    color: colors.neonCyan,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.chevron_right_rounded,
                                                  size: 16,
                                                  color: colors.neonCyan,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                          height:
                                              AppValues.homeRecentHeaderGap),

                                      // Last 3 from local storage
                                      ...DownloadStorage.instance.recent
                                          .take(3)
                                          .map(
                                            (item) => RecentDownloadItem(
                                              title: item.title,
                                              size: item.size,
                                              type: item.type,
                                              isDark: isDark,
                                              onMore: () {},
                                            ),
                                          ),

                                      const SizedBox(
                                          height: AppValues.homeListBottomGap +
                                              AppValues.homeBottomNavHeight +
                                              AppValues.homeBottomNavPadB),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
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
    );
  }

  /// "Download" normal + "Anything" with 3-color gradient
  Widget _buildTitle(dynamic home, bool isDark, dynamic colors) {
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: '${home.title} ',
            style: TextStyle(
              fontSize: AppValues.homeTitleSize,
              fontWeight: FontWeight.w700,
              color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
            ),
          ),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: ShaderMask(
              shaderCallback: (bounds) =>
                  colors.threeColorGradient.createShader(bounds),
              child: Text(
                home.titleHighlight,
                style: TextStyle(
                  fontSize: AppValues.homeTitleSize,
                  fontWeight: FontWeight.w800,
                  color: colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconBtn extends StatelessWidget {
  final IconData icon;
  final bool isDark;
  final dynamic colors;
  final VoidCallback? onTap;

  const _CircleIconBtn({
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
          size: 22,
          color: isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
        ),
      ),
    );
  }
}
