import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/utils/strings_service.dart';

class SideMenuDrawer extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onSelect;

  const SideMenuDrawer({
    super.key,
    required this.currentIndex,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final strings = StringsService.strings;
    final colors = strings.colors;
    final m = strings.sideMenu;

    final items = [
      (Icons.home_rounded, m.home, 0),
      (Icons.download_rounded, m.downloads, 1),
      (Icons.history_rounded, m.history, 2),
      (Icons.settings_rounded, m.settings, 3),
      (Icons.share_rounded, m.shareApp, -1),
      (Icons.star_rounded, m.rateUs, -2),
      (Icons.apps_rounded, m.moreApps, -3),
    ];

    return Drawer(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            color: isDark
                ? colors.darkBg1.withOpacity(0.92)
                : colors.lightBg1.withOpacity(0.95),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            gradient: colors.threeColorGradient,
                          ),
                          child: Icon(Icons.download_rounded,
                              color: colors.white, size: 26),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                strings.appName,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: isDark
                                      ? colors.darkTextPrimary
                                      : colors.lightTextPrimary,
                                ),
                              ),
                              Text(
                                strings.appTagline,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isDark
                                      ? colors.darkTextTertiary
                                      : colors.lightTextTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(Icons.close_rounded,
                              color: isDark
                                  ? colors.darkTextSecondary
                                  : colors.lightTextSecondary),
                        ),
                      ],
                    ),
                  ),
                  ...items.map((e) {
                    final selected = e.$3 == currentIndex;
                    return ListTile(
                      leading: Icon(
                        e.$1,
                        color: selected
                            ? colors.neonCyan
                            : (isDark
                                ? colors.darkTextSecondary
                                : colors.lightTextSecondary),
                      ),
                      title: Text(
                        e.$2,
                        style: TextStyle(
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected
                              ? colors.neonCyan
                              : (isDark
                                  ? colors.darkTextPrimary
                                  : colors.lightTextPrimary),
                        ),
                      ),
                      selected: selected,
                      onTap: () {
                        Navigator.of(context).pop();
                        if (e.$3 >= 0) onSelect(e.$3);
                      },
                    );
                  }),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        gradient: colors.threeColorGradient,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.workspace_premium_rounded,
                                  color: colors.white, size: 22),
                              const SizedBox(width: 8),
                              Text(
                                m.premiumTitle,
                                style: TextStyle(
                                  color: colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            m.premiumSubtitle,
                            style: TextStyle(
                              color: colors.white.withOpacity(0.85),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
