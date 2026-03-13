import 'package:flutter/material.dart';
import 'dart:math';

class OxygensLogo extends StatelessWidget {
  final double size;
  final bool showText;

  const OxygensLogo({super.key, this.size = 48, this.showText = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: _LogoIconPainter()),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [Color(0xFFE6EDF3), Color(0xFF00D4FF)],
                ).createShader(bounds),
                child: Text(
                  'OXYGENS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: size * 0.45,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
              ),
              Text(
                'DNS PANEL',
                style: TextStyle(
                  color: const Color(0xFF00D4FF),
                  fontSize: size * 0.22,
                  letterSpacing: 3,
                  fontFamily: 'monospace',
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _LogoIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width / 2;

    // Outer ring
    canvas.drawCircle(Offset(cx, cy), r * 0.95,
        Paint()..color = const Color(0xFF00D4FF).withOpacity(0.2)
          ..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.drawCircle(Offset(cx, cy), r * 0.7,
        Paint()..color = const Color(0xFF00AADD).withOpacity(0.35)
          ..style = PaintingStyle.stroke..strokeWidth = 1);
    canvas.drawCircle(Offset(cx, cy), r * 0.46,
        Paint()..color = const Color(0xFF00BBEE).withOpacity(0.55)
          ..style = PaintingStyle.stroke..strokeWidth = 1);

    // Hex
    final hexPath = Path();
    for (int i = 0; i < 6; i++) {
      final angle = pi / 6 + i * pi / 3;
      final x = cx + r * 0.44 * cos(angle);
      final y = cy + r * 0.44 * sin(angle);
      if (i == 0) hexPath.moveTo(x, y); else hexPath.lineTo(x, y);
    }
    hexPath.close();
    canvas.drawPath(hexPath, Paint()..color = const Color(0xFF001824));
    canvas.drawPath(hexPath, Paint()
      ..color = const Color(0xFF00BBEE)
      ..style = PaintingStyle.stroke..strokeWidth = 1);

    // Center dot
    canvas.drawCircle(Offset(cx, cy), r * 0.09,
        Paint()..color = const Color(0xFF00D4FF));

    // 6 nodes + lines
    final nodePositions = List.generate(6, (i) {
      final angle = -pi / 2 + i * pi / 3;
      return Offset(cx + r * 0.95 * cos(angle), cy + r * 0.95 * sin(angle));
    });

    final linePaint = Paint()
      ..color = const Color(0xFF004466).withOpacity(0.6)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      canvas.drawLine(nodePositions[i], nodePositions[(i + 1) % 6], linePaint);
    }

    final innerLinePaint = Paint()
      ..color = const Color(0xFF00D4FF).withOpacity(0.3)
      ..strokeWidth = 0.6
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < 6; i++) {
      final angle = -pi / 2 + i * pi / 3;
      final hexEdgeX = cx + r * 0.44 * cos(angle);
      final hexEdgeY = cy + r * 0.44 * sin(angle);
      canvas.drawLine(Offset(hexEdgeX, hexEdgeY), nodePositions[i], innerLinePaint);
    }

    for (int i = 0; i < 6; i++) {
      final color = i % 2 == 0 ? const Color(0xFF00D4FF) : const Color(0xFF0088BB);
      canvas.drawCircle(nodePositions[i], r * 0.07, Paint()..color = color);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
