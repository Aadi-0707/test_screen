import 'package:flutter/material.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/glass_container.dart';
import '../../../core/utils/strings_service.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final bool isDark;
  final List<String> labels;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.labels,
    this.isDark = true,
  });

  static const List<IconData> _icons = [
    Icons.home_rounded,
    Icons.download_rounded,
    Icons.history_rounded,
    Icons.settings_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppValues.homeBottomNavPadH,
        0,
        AppValues.homeBottomNavPadH,
        AppValues.homeBottomNavPadB,
      ),
      child: GlassContainer(
        height: AppValues.homeBottomNavHeight,
        borderRadius: 28,
        isDark: isDark,
        opacity: 0.18,
        borderOpacity: 0.08,
        borderWidth: 1,
        blur: 20,
        showBorder: true,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_icons.length, (i) {
            return _NavItem(
              icon: _icons[i],
              label: labels[i],
              isSelected: currentIndex == i,
              isDark: isDark,
              onTap: () => onTap(i),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isDark;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    final neonGradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        colors.neonPink,
        colors.neonPurple,
        colors.neonCyan,
      ],
    );

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Active icon with 3-neon-color glow
          Container(
            decoration: isSelected
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: colors.neonPink.withOpacity(0.35),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: colors.neonPurple.withOpacity(0.45),
                        blurRadius: 20,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: colors.neonCyan.withOpacity(0.35),
                        blurRadius: 18,
                        spreadRadius: 2,
                      ),
                    ],
                  )
                : null,
            child: isSelected
                ? ShaderMask(
                    shaderCallback: (bounds) =>
                        neonGradient.createShader(bounds),
                    child: Icon(
                      icon,
                      size: AppValues.homeBottomNavIcon,
                      color: colors.white,
                    ),
                  )
                : Icon(
                    icon,
                    size: AppValues.homeBottomNavIcon,
                    color: isDark
                        ? colors.darkTextPrimary
                        : colors.lightTextTertiary,
                  ),
          ),

          const SizedBox(
            height: AppValues.homeBottomNavIconGap,
          ),

          // Active label with 3-neon-color gradient
          isSelected
              ? ShaderMask(
                  shaderCallback: (bounds) => neonGradient.createShader(bounds),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: AppValues.homeBottomNavLabel,
                      fontWeight: FontWeight.w600,
                      color: colors.white,
                    ),
                  ),
                )
              : Text(
                  label,
                  style: TextStyle(
                    fontSize: AppValues.homeBottomNavLabel,
                    color: isDark
                        ? colors.darkTextTertiary
                        : colors.lightTextTertiary,
                  ),
                ),

          // Active 3-color neon indicator
          if (isSelected)
            Container(
              margin: const EdgeInsets.only(top: 3),
              width: 20,
              height: 3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: neonGradient,
                boxShadow: [
                  BoxShadow(
                    color: colors.neonPink.withOpacity(0.35),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: colors.neonPurple.withOpacity(0.4),
                    blurRadius: 8,
                  ),
                  BoxShadow(
                    color: colors.neonCyan.withOpacity(0.35),
                    blurRadius: 6,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
