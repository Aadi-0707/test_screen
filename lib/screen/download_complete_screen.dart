import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_storage.dart';
import '../../../data/download_api_service.dart';
import '../../../widget/gradient_button.dart';

class DownloadCompleteScreen extends StatefulWidget {
  final String fileName;
  final String fileSize;
  final String fileType;
  final String url;
  final String platform;
  final String mediaUrl;

  const DownloadCompleteScreen({
    super.key,
    required this.fileName,
    required this.fileSize,
    required this.fileType,
    this.url = '',
    this.platform = 'instagram',
    this.mediaUrl = '',
  });

  @override
  State<DownloadCompleteScreen> createState() => _DownloadCompleteScreenState();
}

class _DownloadCompleteScreenState extends State<DownloadCompleteScreen> {
  bool _saving = true;

  @override
  void initState() {
    super.initState();
    _saveToLocal();
  }

  Future<void> _saveToLocal() async {
    final platforms = StringsService.strings.home.platforms;
    final platformName = platforms[widget.platform] ?? widget.platform;
    List<int>? bytes;
    if (widget.mediaUrl.isNotEmpty) {
      bytes = await DownloadApiService.instance.downloadBytes(widget.mediaUrl);
    }
    await DownloadStorage.instance.saveCompleted(
      title: widget.fileName,
      size: widget.fileSize,
      type: widget.fileType,
      platform: platformName,
      url: widget.url,
      bytes: bytes,
    );
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final c = strings.downloadComplete;

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
                    const Spacer(flex: 2),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: colors.success.withOpacity(0.15),
                        boxShadow: [
                          BoxShadow(
                            color: colors.success.withOpacity(0.35),
                            blurRadius: 30,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: _saving
                          ? Padding(
                              padding: const EdgeInsets.all(28),
                              child: CircularProgressIndicator(
                                color: colors.success,
                                strokeWidth: 3,
                              ),
                            )
                          : Icon(Icons.check_rounded,
                              size: 52, color: colors.success),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      c.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: isDark
                            ? colors.darkTextPrimary
                            : colors.lightTextPrimary,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      c.subtitle,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark
                            ? colors.darkTextSecondary
                            : colors.lightTextSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    GlassContainer(
                      borderRadius: 16,
                      isDark: isDark,
                      opacity: 0.12,
                      borderOpacity: 0.08,
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: colors.primaryGradient,
                            ),
                            child: Icon(Icons.play_arrow_rounded,
                                color: colors.white, size: 28),
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
                                  '${widget.fileSize}  •  ${widget.fileType}',
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
                    const SizedBox(height: 28),
                    GradientButton(
                      text: c.openFile,
                      icon: Icons.folder_open_rounded,
                      onTap: _saving
                          ? null
                          : () {
                              Navigator.of(context).popUntil((r) => r.isFirst);
                            },
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _ActionBtn(
                            label: c.share,
                            icon: Icons.share_rounded,
                            isDark: isDark,
                            colors: colors,
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionBtn(
                            label: c.viewInFolder,
                            icon: Icons.folder_rounded,
                            isDark: isDark,
                            colors: colors,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    const Spacer(flex: 3),
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
        height: 48,
        borderRadius: 14,
        isDark: isDark,
        opacity: 0.12,
        borderOpacity: 0.08,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18,
                color: isDark
                    ? colors.darkTextSecondary
                    : colors.lightTextSecondary),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color:
                      isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
