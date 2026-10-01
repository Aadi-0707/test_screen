// ignore_for_file: deprecated_member_use

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'strings_service.dart';

/// Neon wave background matching the reference home UI
class NeonBackground extends StatelessWidget {
  final bool isDark;
  const NeonBackground({super.key, this.isDark = true});

  @override
  Widget build(BuildContext context) {
    final colors = StringsService.strings.colors;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [
                  const Color(0xFF0B0C1F),
                  const Color(0xFF0E1028),
                  const Color(0xFF0A0B1A),
                ]
              : [colors.lightBg1, colors.lightBg2, colors.lightBg1],
        ),
      ),
      child: CustomPaint(
        painter: _NeonWavePainter(
          purple: colors.neonPurple,
          cyan: colors.neonCyan,
          pink: colors.neonPink,
          orange: const Color(0xFFFF6B35),
        ),
        size: Size.infinite,
      ),
    );
  }
}

class _NeonWavePainter extends CustomPainter {
  final Color purple;
  final Color cyan;
  final Color pink;
  final Color orange;

  _NeonWavePainter({
    required this.purple,
    required this.cyan,
    required this.pink,
    required this.orange,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Soft glow orbs
    _drawOrb(canvas, Offset(size.width * 0.15, size.height * 0.08), 120,
        orange.withOpacity(0.35));
    _drawOrb(canvas, Offset(size.width * 0.85, size.height * 0.12), 140,
        purple.withOpacity(0.4));
    _drawOrb(canvas, Offset(size.width * 0.7, size.height * 0.05), 90,
        cyan.withOpacity(0.3));
    _drawOrb(canvas, Offset(size.width * 0.5, size.height * 0.18), 100,
        pink.withOpacity(0.2));

    // Neon wave curves (top area)
    _drawWave(
      canvas,
      size,
      yBase: size.height * 0.02,
      amplitude: 40,
      color: purple.withOpacity(0.45),
      strokeWidth: 2.5,
      phase: 0,
    );
    _drawWave(
      canvas,
      size,
      yBase: size.height * 0.08,
      amplitude: 55,
      color: cyan.withOpacity(0.35),
      strokeWidth: 2.0,
      phase: 1.2,
    );
    _drawWave(
      canvas,
      size,
      yBase: size.height * 0.05,
      amplitude: 35,
      color: pink.withOpacity(0.3),
      strokeWidth: 1.8,
      phase: 2.5,
    );
    _drawWave(
      canvas,
      size,
      yBase: size.height * 0.12,
      amplitude: 45,
      color: orange.withOpacity(0.25),
      strokeWidth: 1.5,
      phase: 0.8,
    );
  }

  void _drawOrb(Canvas canvas, Offset center, double radius, Color color) {
    final paint = Paint()
      ..shader = RadialGradient(
        colors: [color, color.withOpacity(0.0)],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, paint);
  }

  void _drawWave(
    Canvas canvas,
    Size size, {
    required double yBase,
    required double amplitude,
    required Color color,
    required double strokeWidth,
    required double phase,
  }) {
    final path = Path();
    path.moveTo(-20, yBase);
    for (double x = -20; x <= size.width + 20; x += 4) {
      final y = yBase +
          math.sin((x / size.width) * math.pi * 2.5 + phase) * amplitude +
          math.cos((x / size.width) * math.pi * 1.5 + phase * 0.7) *
              (amplitude * 0.4);
      path.lineTo(x, y);
    }
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawPath(path, paint);

    // sharper core line
    final paintCore = Paint()
      ..color = color.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paintCore);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
