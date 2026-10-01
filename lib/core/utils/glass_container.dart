// ignore_for_file: deprecated_member_use

import 'dart:ui';
import 'package:flutter/material.dart';
import '../utils/strings_service.dart';

/// Soft glass with polished shine (glossy highlight)
class GlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final bool isDark;
  final double blur;
  final double opacity;
  final double borderOpacity;
  final double borderWidth;
  final bool showBorder;
  final bool showShine;
  final List<BoxShadow>? boxShadow;

  const GlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = 16.0,
    this.padding,
    this.margin,
    this.isDark = true,
    this.blur = 16.0,
    this.opacity = 0.12,
    this.borderOpacity = 0.10,
    this.borderWidth = 1.0,
    this.showBorder = true,
    this.showShine = true,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow ??
            [
              // Soft depth
              BoxShadow(
                color: colors.black.withOpacity(isDark ? 0.25 : 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Stack(
            children: [
              // Glass base fill
              Container(
                width: width,
                height: height,
                padding: padding,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: isDark
                        ? [
                            colors.white.withOpacity(0.14),
                            colors.white.withOpacity(0.06),
                            colors.white.withOpacity(0.04),
                          ]
                        : [
                            colors.white.withOpacity(0.75),
                            colors.white.withOpacity(0.45),
                            colors.white.withOpacity(0.35),
                          ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                  border: showBorder
                      ? Border.all(
                          color: isDark
                              ? colors.white.withOpacity(borderOpacity + 0.06)
                              : colors.white.withOpacity(0.6),
                          width: borderWidth,
                        )
                      : null,
                ),
                child: child,
              ),

              // Polished shine streak (top-left gloss)
              if (showShine)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 28,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(borderRadius),
                          topRight: Radius.circular(borderRadius),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.skyBlue.withOpacity(isDark ? 0.18 : 0.45),
                            colors.skyBlue.withOpacity(isDark ? 0.04 : 0.08),
                            colors.skyBlue.withOpacity(0.0),
                          ],
                          stops: const [0.0, 0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),

              // Diagonal shine line
              if (showShine)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: _GlassShinePainter(
                        color: colors.skyBlue.withOpacity(isDark ? 0.12 : 0.28),
                        borderRadius: borderRadius,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Diagonal polished shine stroke across glass
class _GlassShinePainter extends CustomPainter {
  final Color color;
  final double borderRadius;

  _GlassShinePainter({required this.color, required this.borderRadius});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          color.withOpacity(0.0),
          color,
          color.withOpacity(0.0),
        ],
        stops: const [0.15, 0.35, 0.55],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    final path = Path()
      ..moveTo(0, size.height * 0.15)
      ..lineTo(size.width * 0.45, 0)
      ..lineTo(size.width * 0.55, 0)
      ..lineTo(0, size.height * 0.35)
      ..close();

    canvas.save();
    canvas.clipRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(borderRadius),
      ),
    );
    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class GlowContainer extends StatelessWidget {
  final Widget child;
  final double size;
  final Color? glowColor;
  final double blur;
  final double spread;

  const GlowContainer({
    super.key,
    required this.child,
    required this.size,
    this.glowColor,
    this.blur = 50.0,
    this.spread = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;
    final glow = glowColor ?? colors.neonPurple;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: glow.withOpacity(0.5),
            blurRadius: blur,
            spreadRadius: spread,
          ),
          BoxShadow(
            color: colors.neonCyan.withOpacity(0.3),
            blurRadius: blur * 1.3,
            spreadRadius: spread * 0.4,
          ),
        ],
      ),
      child: child,
    );
  }
}
