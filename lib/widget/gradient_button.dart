import 'package:flutter/material.dart';
import '../../../core/constants/_values.dart';
import '../../../core/utils/strings_service.dart';

class GradientButton extends StatefulWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onTap;
  final double? width;
  final double height;

  const GradientButton({
    super.key,
    required this.text,
    this.icon,
    this.onTap,
    this.width,
    this.height = AppValues.homeButtonHeight,
  });

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppValues.homeBtnPressAnimMs),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.96).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) {
        _controller.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) =>
            Transform.scale(scale: _scale.value, child: child),
        child: Container(
          width: widget.width ?? double.infinity,
          height: widget.height,
          decoration: BoxDecoration(
            gradient: colors.threeColorGradient,
            borderRadius: BorderRadius.circular(AppValues.homeButtonRadius),
            boxShadow: [
              BoxShadow(
                color: colors.neonPink.withOpacity(0.45),
                blurRadius: AppValues.homeButtonGlowBlur,
                offset: const Offset(0, AppValues.homeButtonGlowY),
              ),
              BoxShadow(
                color: colors.neonPurple.withOpacity(0.35),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: colors.neonCyan.withOpacity(0.25),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                Icon(widget.icon,
                    color: colors.white, size: AppValues.homeButtonIconSize),
                const SizedBox(width: AppValues.homeButtonIconGap),
              ],
              Text(
                widget.text,
                style: TextStyle(
                  color: colors.white,
                  fontSize: AppValues.homeButtonFontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
