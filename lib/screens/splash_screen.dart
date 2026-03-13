import 'package:flutter/material.dart';
import 'dart:math';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _ringCtrl;
  late AnimationController _fadeCtrl;
  late AnimationController _scaleCtrl;
  late AnimationController _textCtrl;
  late AnimationController _exitCtrl;

  late Animation<double> _ring1;
  late Animation<double> _ring2;
  late Animation<double> _ring3;
  late Animation<double> _fadeIn;
  late Animation<double> _scale;
  late Animation<double> _textFade;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    _ringCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
    _textCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _exitCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));

    _ring1 = CurvedAnimation(parent: _ringCtrl, curve: const Interval(0.0, 0.6, curve: Curves.easeOut));
    _ring2 = CurvedAnimation(parent: _ringCtrl, curve: const Interval(0.2, 0.8, curve: Curves.easeOut));
    _ring3 = CurvedAnimation(parent: _ringCtrl, curve: const Interval(0.4, 1.0, curve: Curves.easeOut));
    _fadeIn = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _scale = CurvedAnimation(parent: _scaleCtrl, curve: Curves.elasticOut);
    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeIn);
    _exitFade = CurvedAnimation(parent: _exitCtrl, curve: Curves.easeIn);

    _startSequence();
  }

  void _startSequence() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _fadeCtrl.forward();
    _scaleCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _ringCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 1200));
    _exitCtrl.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (_, __, ___) => const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  void dispose() {
    _ringCtrl.dispose();
    _fadeCtrl.dispose();
    _scaleCtrl.dispose();
    _textCtrl.dispose();
    _exitCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF080C10),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _ringCtrl, _fadeCtrl, _scaleCtrl, _textCtrl, _exitCtrl
        ]),
        builder: (ctx, _) {
          return Opacity(
            opacity: 1.0 - _exitFade.value,
            child: Stack(
              children: [
                // Grid background
                CustomPaint(
                  painter: _GridPainter(),
                  child: const SizedBox.expand(),
                ),
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo
                      Opacity(
                        opacity: _fadeIn.value,
                        child: Transform.scale(
                          scale: 0.7 + (_scale.value * 0.3),
                          child: SizedBox(
                            width: 180,
                            height: 180,
                            child: CustomPaint(
                              painter: _LogoPainter(
                                ring1: _ring1.value,
                                ring2: _ring2.value,
                                ring3: _ring3.value,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Text
                      Opacity(
                        opacity: _textFade.value,
                        child: Transform.translate(
                          offset: Offset(0, 10 * (1 - _textFade.value)),
                          child: Column(
                            children: [
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFFE6EDF3), Color(0xFF00D4FF)],
                                ).createShader(bounds),
                                child: const Text(
                                  'OXYGENS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 10,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'CONTROL PANEL',
                                style: TextStyle(
                                  color: Color(0xFF00D4FF),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 6,
                                  fontFamily: 'monospace',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      // Loading dots
                      Opacity(
                        opacity: _textFade.value,
                        child: _LoadingDots(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  final double ring1;
  final double ring2;
  final double ring3;

  _LogoPainter({required this.ring1, required this.ring2, required this.ring3});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    // Rings
    _drawRing(canvas, cx, cy, 85, ring1, const Color(0xFF00D4FF), 0.25);
    _drawRing(canvas, cx, cy, 62, ring2, const Color(0xFF00AADD), 0.4);
    _drawRing(canvas, cx, cy, 40, ring3, const Color(0xFF00BBEE), 0.65);

    if (ring3 > 0) {
      // Hex
      final hexPaint = Paint()
        ..color = const Color(0xFF001824)
        ..style = PaintingStyle.fill;
      final hexBorderPaint = Paint()
        ..color = const Color(0xFF00BBEE).withOpacity(ring3)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5;

      final hexPath = Path();
      for (int i = 0; i < 6; i++) {
        final angle = (pi / 6) + (i * pi / 3);
        final x = cx + 38 * cos(angle);
        final y = cy + 38 * sin(angle);
        if (i == 0) hexPath.moveTo(x, y); else hexPath.lineTo(x, y);
      }
      hexPath.close();
      canvas.drawPath(hexPath, hexPaint);
      canvas.drawPath(hexPath, hexBorderPaint);

      // Center dot
      canvas.drawCircle(
        Offset(cx, cy), 7,
        Paint()..color = const Color(0xFF00D4FF).withOpacity(ring3),
      );

      // 6 outer nodes
      final nodePaint = Paint()..color = const Color(0xFF00D4FF).withOpacity(ring3);
      final nodePaint2 = Paint()..color = const Color(0xFF0088BB).withOpacity(ring3);
      final linePaint = Paint()
        ..color = const Color(0xFF004466).withOpacity(ring1 * 0.7)
        ..strokeWidth = 1.0
        ..style = PaintingStyle.stroke;

      final nodePositions = List.generate(6, (i) {
        final angle = -pi / 2 + i * pi / 3;
        return Offset(cx + 85 * cos(angle), cy + 85 * sin(angle));
      });

      // Lines between nodes
      for (int i = 0; i < 6; i++) {
        canvas.drawLine(nodePositions[i], nodePositions[(i + 1) % 6], linePaint);
      }

      // Lines from hex to nodes
      final innerLinePaint = Paint()
        ..color = const Color(0xFF00D4FF).withOpacity(ring1 * 0.4)
        ..strokeWidth = 0.8
        ..style = PaintingStyle.stroke;

      for (int i = 0; i < 6; i++) {
        final angle = -pi / 2 + i * pi / 3;
        final hexEdgeX = cx + 38 * cos(angle);
        final hexEdgeY = cy + 38 * sin(angle);
        canvas.drawLine(Offset(hexEdgeX, hexEdgeY), nodePositions[i], innerLinePaint);
      }

      // Draw nodes
      for (int i = 0; i < 6; i++) {
        final p = i % 2 == 0 ? nodePaint : nodePaint2;
        canvas.drawCircle(nodePositions[i], 5, p);
      }
    }
  }

  void _drawRing(Canvas canvas, double cx, double cy, double r,
      double progress, Color color, double opacity) {
    if (progress <= 0) return;
    final paint = Paint()
      ..color = color.withOpacity(opacity * progress)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_LogoPainter old) =>
      old.ring1 != ring1 || old.ring2 != ring2 || old.ring3 != ring3;
}

class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          final delay = i / 3;
          final t = (_ctrl.value - delay) % 1.0;
          final opacity = t < 0.5 ? t * 2 : (1 - t) * 2;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: 5,
            height: 5,
            decoration: BoxDecoration(
              color: const Color(0xFF00D4FF).withOpacity(opacity.clamp(0.1, 1.0)),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2D3D).withOpacity(0.2)
      ..strokeWidth = 0.5;
    const spacing = 40.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
