import 'package:flutter/material.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/strings_service.dart';

class PlatformIconsRow extends StatelessWidget {
  final Map<String, String> platforms;
  final bool isDark;
  final Function(String)? onTap;

  const PlatformIconsRow({
    super.key,
    required this.platforms,
    this.isDark = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final images = StringsService.strings.images;
    final entries = platforms.entries.toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: entries.map((e) {
        return _PlatformItem(
          label: e.value,
          imagePath: images.platformIcon(e.key),
          isDark: isDark,
          onTap: () => onTap?.call(e.key),
        );
      }).toList(),
    );
  }
}

class _PlatformItem extends StatefulWidget {
  final String label;
  final String imagePath;
  final bool isDark;
  final VoidCallback? onTap;

  const _PlatformItem({
    required this.label,
    required this.imagePath,
    required this.isDark,
    this.onTap,
  });

  @override
  State<_PlatformItem> createState() => _PlatformItemState();
}

class _PlatformItemState extends State<_PlatformItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.homePlatformPressAnimMs),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.92)
        .animate(CurvedAnimation(parent: _c, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return GestureDetector(
      onTapDown: (_) => _c.forward(),
      onTapUp: (_) {
        _c.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _c.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (_, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: AppValues.homePlatformSize,
              height: AppValues.homePlatformSize,
              child: Center(
                child: SizedBox(
                  width: AppValues.homePlatformInner + 6,
                  height: AppValues.homePlatformInner + 6,
                  child: Image.asset(
                    widget.imagePath,
                    width: AppValues.homePlatformInner + 6,
                    height: AppValues.homePlatformInner + 6,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Icon(
                      Icons.link_rounded,
                      size: AppValues.homePlatformInner,
                      color: colors.neonPurple,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppValues.homePlatformLabelGap),
            Text(
              widget.label,
              style: TextStyle(
                fontSize: AppValues.homePlatformLabelSize,
                fontWeight: FontWeight.w500,
                color: widget.isDark
                    ? colors.darkTextSecondary
                    : colors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
