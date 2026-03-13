import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle? style;
  const GlitchText(this.text, {super.key, this.style});

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> {
  late String _displayed;
  Timer? _timer;
  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789#@!%&';
  final _random = Random();

  @override
  void initState() {
    super.initState();
    _displayed = widget.text;
    _startGlitch();
  }

  void _startGlitch() {
    int iterations = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      if (!mounted) { t.cancel(); return; }
      setState(() {
        _displayed = widget.text.split('').map((c) {
          if (iterations > widget.text.length) return c;
          return _random.nextBool() ? _chars[_random.nextInt(_chars.length)] : c;
        }).join();
      });
      iterations++;
      if (iterations > widget.text.length + 5) {
        if (mounted) setState(() => _displayed = widget.text);
        t.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Text(_displayed, style: widget.style);
}
