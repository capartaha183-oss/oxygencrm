import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _sessionDuration;

  @override
  void initState() {
    super.initState();
    _sessionDuration = AuthService.sessionDuration;
    // update session duration every second
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return false;
      setState(() => _sessionDuration = AuthService.sessionDuration);
      return true;
    });
  }

  void _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('OTURUMU KAPAT', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2,
              )),
              const SizedBox(height: 8),
              Text('Çıkış yapmak istediğinize emin misiniz?',
                style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
                )),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('İptal', style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textSecondary, fontSize: 12,
                  )),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentRed,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    elevation: 0,
                  ),
                  child: Text('Çıkış Yap', style: GoogleFonts.jetBrainsMono(
                    fontSize: 12, fontWeight: FontWeight.w700,
                  )),
                )),
              ]),
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;
    AuthService.logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final username = AuthService.currentUser ?? '-';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile card
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppTheme.accent.withOpacity(0.08),
                    border: Border.all(color: AppTheme.accent.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Center(
                    child: Text(
                      username[0].toUpperCase(),
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.accent,
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(username, style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      )),
                      const SizedBox(height: 4),
                      Row(children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppTheme.accentGreen.withOpacity(0.08),
                            border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: Text('ADMIN', style: GoogleFonts.jetBrainsMono(
                            color: AppTheme.accentGreen,
                            fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w700,
                          )),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 6, height: 6,
                          decoration: const BoxDecoration(
                            color: AppTheme.accentGreen, shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('Aktif oturum', style: GoogleFonts.jetBrainsMono(
                          color: AppTheme.accentGreen, fontSize: 11,
                        )),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Stats row
          Row(children: [
            _statCard('TOPLAM GİRİŞ', '${AuthService.loginCount}', Icons.login_rounded, AppTheme.accent),
            const SizedBox(width: 16),
            _statCard('SON GİRİŞ', AuthService.lastLoginFormatted, Icons.access_time_rounded, AppTheme.accentGreen),
            const SizedBox(width: 16),
            _statCard('OTURUM SÜRESİ', _sessionDuration, Icons.timer_outlined, AppTheme.accentOrange),
          ]),

          const SizedBox(height: 20),

          // Session info
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surface,
              border: Border.all(color: AppTheme.border),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('OTURUM BİLGİLERİ', style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600,
                )),
                const SizedBox(height: 16),
                _infoRow('Kullanıcı Adı', username),
                _divider(),
                _infoRow('Rol', 'Administrator'),
                _divider(),
                _infoRow('Giriş Zamanı', AuthService.lastLoginFormatted),
                _divider(),
                _infoRow('Oturum Süresi', _sessionDuration),
                _divider(),
                _infoRow('Platform', 'OxygensDNS Control Panel v1.0'),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Logout button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, size: 16, color: AppTheme.accentRed),
              label: Text('OTURUMU KAPAT', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.accentRed,
                fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 2,
              )),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppTheme.accentRed.withOpacity(0.4)),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Icon(icon, color: color, size: 14),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2,
              )),
            ]),
            const SizedBox(height: 10),
            Text(value, style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w700,
            )),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted, fontSize: 12,
            )),
          ),
          Expanded(child: Text(value, style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w500,
          ))),
        ],
      ),
    );
  }

  Widget _divider() => const Divider(color: AppTheme.border, height: 1);
}
