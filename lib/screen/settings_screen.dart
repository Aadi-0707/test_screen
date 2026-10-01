import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';
import '../../../data/download_storage.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _wifiOnly = true;
  bool _autoStart = true;
  bool _notifications = true;
  bool _animations = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final s = strings.settings;

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
              bottom: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 100),
                children: [
                  Text(
                    s.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: isDark
                          ? colors.darkTextPrimary
                          : colors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _Section(s.sections['download']!, isDark, colors),
                  _NavRow(
                    icon: Icons.folder_rounded,
                    label: s.downloadLocation,
                    value: s.downloadLocationValue,
                    isDark: isDark,
                    colors: colors,
                  ),
                  _SwitchRow(
                    icon: Icons.wifi_rounded,
                    label: s.wifiOnly,
                    value: _wifiOnly,
                    isDark: isDark,
                    colors: colors,
                    onChanged: (v) => setState(() => _wifiOnly = v),
                  ),
                  _SwitchRow(
                    icon: Icons.play_circle_rounded,
                    label: s.autoStart,
                    value: _autoStart,
                    isDark: isDark,
                    colors: colors,
                    onChanged: (v) => setState(() => _autoStart = v),
                  ),
                  _SwitchRow(
                    icon: Icons.notifications_rounded,
                    label: s.notifications,
                    value: _notifications,
                    isDark: isDark,
                    colors: colors,
                    onChanged: (v) => setState(() => _notifications = v),
                  ),
                  const SizedBox(height: 16),
                  _Section(s.sections['appearance']!, isDark, colors),
                  _NavRow(
                    icon: Icons.palette_rounded,
                    label: s.theme,
                    value: s.themeValue,
                    isDark: isDark,
                    colors: colors,
                  ),
                  _NavRow(
                    icon: Icons.color_lens_rounded,
                    label: s.accentColor,
                    isDark: isDark,
                    colors: colors,
                    trailing: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: colors.threeColorGradient,
                      ),
                    ),
                  ),
                  _SwitchRow(
                    icon: Icons.animation_rounded,
                    label: s.animations,
                    value: _animations,
                    isDark: isDark,
                    colors: colors,
                    onChanged: (v) => setState(() => _animations = v),
                  ),
                  const SizedBox(height: 16),
                  _Section(s.sections['storage']!, isDark, colors),
                  _NavRow(
                    icon: Icons.storage_rounded,
                    label: s.storageUsage,
                    value: s.storageUsageValue,
                    isDark: isDark,
                    colors: colors,
                  ),
                  GestureDetector(
                    onTap: () async {
                      await DownloadStorage.instance.clearAll();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('History cleared')),
                        );
                      }
                    },
                    child: _NavRow(
                      icon: Icons.delete_outline_rounded,
                      label: s.clearHistory,
                      isDark: isDark,
                      colors: colors,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _Section(s.sections['about']!, isDark, colors),
                  _NavRow(
                    icon: Icons.privacy_tip_outlined,
                    label: s.privacyPolicy,
                    isDark: isDark,
                    colors: colors,
                  ),
                  _NavRow(
                    icon: Icons.description_outlined,
                    label: s.termsOfService,
                    isDark: isDark,
                    colors: colors,
                  ),
                  _NavRow(
                    icon: Icons.info_outline_rounded,
                    label: s.aboutApp,
                    isDark: isDark,
                    colors: colors,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final bool isDark;
  final dynamic colors;
  const _Section(this.title, this.isDark, this.colors);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isDark ? colors.darkTextSecondary : colors.lightTextSecondary,
        ),
      ),
    );
  }
}

class _NavRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final Widget? trailing;
  final bool isDark;
  final dynamic colors;

  const _NavRow({
    required this.icon,
    required this.label,
    this.value,
    this.trailing,
    required this.isDark,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 14,
      isDark: isDark,
      opacity: 0.10,
      borderOpacity: 0.06,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      child: Row(
        children: [
          Icon(icon,
              size: 22,
              color: isDark
                  ? colors.darkTextSecondary
                  : colors.lightTextSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
              ),
            ),
          ),
          if (trailing != null) trailing!,
          if (value != null)
            Flexible(
              child: Text(
                value!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? colors.darkTextTertiary
                      : colors.lightTextTertiary,
                ),
              ),
            ),
          const SizedBox(width: 4),
          Icon(Icons.chevron_right_rounded,
              size: 20,
              color:
                  isDark ? colors.darkTextTertiary : colors.lightTextTertiary),
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool value;
  final bool isDark;
  final dynamic colors;
  final ValueChanged<bool> onChanged;

  const _SwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    required this.colors,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return GlassContainer(
      borderRadius: 14,
      isDark: isDark,
      opacity: 0.10,
      borderOpacity: 0.06,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Row(
        children: [
          Icon(icon,
              size: 22,
              color: isDark
                  ? colors.darkTextSecondary
                  : colors.lightTextSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color:
                    isDark ? colors.darkTextPrimary : colors.lightTextPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: colors.neonCyan,
          ),
        ],
      ),
    );
  }
}
