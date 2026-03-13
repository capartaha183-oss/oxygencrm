import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/glitch_text.dart';
import '../widgets/oxygens_logo.dart';
import '../services/auth_service.dart';
import 'dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;
  String? _error;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;

  static const _users = {
    'goktug': 'goktug123',
    'ahmet': 'ahmet123',
    'sabri': 'sabri123',
    'tayfun': 'tayfun123',
    'sinan': 'sinan123',
    'taha': 'taha123',
  };

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    _userCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _userCtrl.text.trim().toLowerCase();
    final password = _passCtrl.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() => _error = 'Kullanıcı adı ve şifre gerekli.');
      return;
    }

    if (!_users.containsKey(username) || _users[username] != password) {
      setState(() => _error = 'Geçersiz kullanıcı adı veya şifre.');
      return;
    }

    setState(() { _loading = true; _error = null; });
    AuthService.login(username);
    await Future.delayed(const Duration(milliseconds: 1000));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (_) => const DashboardScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Stack(
        children: [
          CustomPaint(painter: _GridPainter(), child: const SizedBox.expand()),
          Center(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: Container(
                width: 420,
                padding: const EdgeInsets.all(40),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  border: Border.all(color: AppTheme.border),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.accent.withOpacity(0.05),
                      blurRadius: 60,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const OxygensLogo(size: 40, showText: true),
                    const SizedBox(height: 36),
                    Text('Control Panel', style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w600,
                    )),
                    const SizedBox(height: 4),
                    Text('Sign in to manage your DNS infrastructure',
                      style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 12),
                    ),
                    const SizedBox(height: 32),
                    _field('KULLANICI ADI', _userCtrl, 'kullanici_adi', false),
                    const SizedBox(height: 16),
                    _field('ŞİFRE', _passCtrl, '••••••••••••', true),
                    if (_error != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppTheme.accentRed.withOpacity(0.08),
                          border: Border.all(color: AppTheme.accentRed.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error_outline, color: AppTheme.accentRed, size: 14),
                            const SizedBox(width: 8),
                            Text(_error!, style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.accentRed, fontSize: 11,
                            )),
                          ],
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: _loading
                          ? Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: AppTheme.accent),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Center(child: SizedBox(
                                width: 20, height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
                              )),
                            )
                          : ElevatedButton(
                              onPressed: _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accent,
                                foregroundColor: AppTheme.bg,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                                elevation: 0,
                              ),
                              child: Text('GİRİŞ YAP', style: GoogleFonts.jetBrainsMono(
                                fontSize: 13, fontWeight: FontWeight.w700, letterSpacing: 2,
                              )),
                            ),
                    ),
                    const SizedBox(height: 20),
                    Row(children: [
                      Container(
                        width: 6, height: 6,
                        decoration: const BoxDecoration(color: AppTheme.accentGreen, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 8),
                      Text('oxygens.ddns.net — ONLINE', style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.textMuted, fontSize: 11, letterSpacing: 1,
                      )),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(String label, TextEditingController ctrl, String hint, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 6),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          onSubmitted: (_) => _login(),
          style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 13),
            filled: true,
            fillColor: AppTheme.card,
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(color: AppTheme.border),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(3)),
              borderSide: BorderSide(color: AppTheme.accent, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E2D3D).withOpacity(0.3)
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
