import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/adguard_service.dart';
import 'server_detail_screen.dart';

class ServersScreen extends StatefulWidget {
  const ServersScreen({super.key});

  @override
  State<ServersScreen> createState() => _ServersScreenState();
}

class _ServersScreenState extends State<ServersScreen> {
  final List<AdGuardServer> _servers = [];
  bool _checking = false;

  @override
  void initState() {
    super.initState();
    _checkAll();
  }

  Future<void> _checkAll() async {
    if (_servers.isEmpty) return;
    setState(() => _checking = true);
    for (final s in _servers) {
      final online = await AdGuardService.checkStatus(s);
      if (mounted) setState(() => s.isOnline = online);
    }
    if (mounted) setState(() => _checking = false);
  }

  void _showAddDialog() {
    final nameCtrl = TextEditingController();
    final ipCtrl = TextEditingController();
    final portCtrl = TextEditingController(text: '3000');
    final userCtrl = TextEditingController();
    final passCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('YENİ SUNUCU', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2,
              )),
              const SizedBox(height: 8),
              Text('AdGuard Sunucu Ekle', style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 20),
              _dialogField('SUNUCU ADI', nameCtrl, 'Sınıf 1', false),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: _dialogField('IP ADRESİ', ipCtrl, '192.168.1.10', false)),
                const SizedBox(width: 12),
                SizedBox(width: 80, child: _dialogField('PORT', portCtrl, '3000', false)),
              ]),
              const SizedBox(height: 12),
              _dialogField('KULLANICI ADI', userCtrl, 'admin', false),
              const SizedBox(height: 12),
              _dialogField('ŞİFRE', passCtrl, '••••••••', true),
              const SizedBox(height: 24),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: Text('İPTAL', style: GoogleFonts.jetBrainsMono(
                    color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1,
                  )),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () {
                    if (nameCtrl.text.isEmpty || ipCtrl.text.isEmpty) return;
                    final server = AdGuardServer(
                      id: DateTime.now().millisecondsSinceEpoch.toString(),
                      name: nameCtrl.text,
                      ip: ipCtrl.text,
                      port: int.tryParse(portCtrl.text) ?? 3000,
                      username: userCtrl.text,
                      password: passCtrl.text,
                    );
                    setState(() => _servers.add(server));
                    Navigator.pop(ctx);
                    AdGuardService.checkStatus(server).then((online) {
                      if (mounted) setState(() => server.isOnline = online);
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accent,
                    foregroundColor: AppTheme.bg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    elevation: 0,
                  ),
                  child: Text('EKLE', style: GoogleFonts.jetBrainsMono(
                    fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1,
                  )),
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dialogField(String label, TextEditingController ctrl, String hint, bool obscure) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w600,
        )),
        const SizedBox(height: 5),
        TextField(
          controller: ctrl,
          obscureText: obscure,
          style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12),
            filled: true,
            fillColor: AppTheme.card,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Expanded(
              child: Text(
                '${_servers.length} sunucu kayıtlı — ${_servers.where((s) => s.isOnline).length} online',
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ),
            if (_checking)
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
                ),
              ),
            TextButton.icon(
              onPressed: _checkAll,
              icon: const Icon(Icons.refresh, size: 14, color: AppTheme.textSecondary),
              label: Text('Yenile', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textSecondary, fontSize: 12,
              )),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, size: 16),
              label: Text('SUNUCU EKLE', style: GoogleFonts.jetBrainsMono(
                fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1,
              )),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                elevation: 0,
              ),
            ),
          ]),
          const SizedBox(height: 20),
          if (_servers.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.dns_outlined, color: AppTheme.textMuted, size: 48),
                    const SizedBox(height: 16),
                    Text('Henüz sunucu eklenmedi', style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textMuted, fontSize: 16,
                    )),
                    const SizedBox(height: 8),
                    Text('Sağ üstteki butona tıklayarak sunucu ekleyin',
                      style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 340,
                  mainAxisExtent: 200,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _servers.length,
                itemBuilder: (ctx, i) => _serverCard(_servers[i]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _serverCard(AdGuardServer server) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(
        builder: (_) => ServerDetailScreen(server: server),
      )),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(
            color: server.isOnline
                ? AppTheme.accentGreen.withOpacity(0.3)
                : AppTheme.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(
                  color: server.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
                  shape: BoxShape.circle,
                  boxShadow: server.isOnline ? [
                    BoxShadow(color: AppTheme.accentGreen.withOpacity(0.4), blurRadius: 6),
                  ] : [],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                server.isOnline ? 'ONLINE' : 'OFFLINE',
                style: GoogleFonts.jetBrainsMono(
                  color: server.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
                  fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.accentRed),
                onPressed: () => setState(() => _servers.remove(server)),
                constraints: const BoxConstraints(),
                padding: EdgeInsets.zero,
              ),
            ]),
            const SizedBox(height: 16),
            Text(server.name, style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 4),
            Text('${server.ip}:${server.port}', style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textSecondary, fontSize: 12,
            )),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.accent.withOpacity(0.08),
                border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text('Detayları Gör →', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.accent, fontSize: 11,
              )),
            ),
          ],
        ),
      ),
    );
  }
}
