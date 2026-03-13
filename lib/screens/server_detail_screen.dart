import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/adguard_service.dart';

class ServerDetailScreen extends StatefulWidget {
  final AdGuardServer server;
  const ServerDetailScreen({super.key, required this.server});

  @override
  State<ServerDetailScreen> createState() => _ServerDetailScreenState();
}

class _ServerDetailScreenState extends State<ServerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;
  AdGuardStats? _stats;
  List<String> _clients = [];
  List<Map<String, dynamic>> _filters = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final stats = await AdGuardService.getStats(widget.server);
    final clients = await AdGuardService.getClients(widget.server);
    final filters = await AdGuardService.getFilters(widget.server);
    if (mounted) {
      setState(() {
        _stats = stats;
        _clients = clients;
        _filters = filters;
        _loading = false;
      });
    }
  }

  Future<void> _sendCommand(String cmd, String label) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('$label komutu gönderilsin mi?', style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: Text('İptal', style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary)),
                )),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentOrange,
                    foregroundColor: AppTheme.bg,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                    elevation: 0,
                  ),
                  child: Text('Evet', style: GoogleFonts.jetBrainsMono(fontWeight: FontWeight.w700)),
                )),
              ]),
            ],
          ),
        ),
      ),
    );

    if (confirm != true) return;
    final ok = await AdGuardService.sendCommand(widget.server, cmd);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(ok ? '$label başarılı!' : '$label başarısız!',
          style: GoogleFonts.jetBrainsMono(color: AppTheme.bg),
        ),
        backgroundColor: ok ? AppTheme.accentGreen : AppTheme.accentRed,
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        backgroundColor: AppTheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textSecondary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(children: [
          Container(
            width: 10, height: 10,
            decoration: BoxDecoration(
              color: widget.server.isOnline ? AppTheme.accentGreen : AppTheme.accentRed,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Text(widget.server.name, style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
          )),
          const SizedBox(width: 8),
          Text('${widget.server.ip}:${widget.server.port}',
            style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ]),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppTheme.textSecondary),
            onPressed: _loadData,
          ),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          indicatorColor: AppTheme.accent,
          labelColor: AppTheme.accent,
          unselectedLabelColor: AppTheme.textSecondary,
          labelStyle: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 1),
          tabs: const [
            Tab(text: 'İSTATİSTİKLER'),
            Tab(text: 'CİHAZLAR'),
            Tab(text: 'FİLTRELER'),
          ],
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.accent))
          : Column(
              children: [
                // Quick actions
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(children: [
                    Text('Hızlı Aksiyonlar:', style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textMuted, fontSize: 11, letterSpacing: 1,
                    )),
                    const SizedBox(width: 12),
                    _actionBtn('Restart', Icons.restart_alt, AppTheme.accentOrange,
                      () => _sendCommand('restart', 'Restart')),
                    const SizedBox(width: 8),
                    _actionBtn('Flush DNS', Icons.cleaning_services_outlined, AppTheme.accent,
                      () => _sendCommand('flush_dns', 'Flush DNS')),
                  ]),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabCtrl,
                    children: [
                      _statsTab(),
                      _clientsTab(),
                      _filtersTab(),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _actionBtn(String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.jetBrainsMono(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
        ]),
      ),
    );
  }

  Widget _statsTab() {
    if (_stats == null) {
      return Center(child: Text('Veri alınamadı', style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted)));
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          _statCard('TOPLAM SORGU', _stats!.totalQueries.toString(), Icons.query_stats, AppTheme.accent),
          const SizedBox(width: 16),
          _statCard('ENGELLENDİ', _stats!.blockedQueries.toString(), Icons.block, AppTheme.accentRed),
          const SizedBox(width: 16),
          _statCard('ENGELLEME %', '${_stats!.blockedPercent.toStringAsFixed(1)}%', Icons.pie_chart_outline, AppTheme.accentOrange),
          const SizedBox(width: 16),
          _statCard('ORT. SÜRE', '${_stats!.avgProcessingTime}ms', Icons.timer_outlined, AppTheme.accentGreen),
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
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(label, style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2)),
            ]),
            const SizedBox(height: 12),
            Text(value, style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.w700,
            )),
          ],
        ),
      ),
    );
  }

  Widget _clientsTab() {
    if (_clients.isEmpty) {
      return Center(child: Text('Cihaz bulunamadı', style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _clients.length,
      itemBuilder: (ctx, i) => Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          border: Border.all(color: AppTheme.border),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(children: [
          const Icon(Icons.computer_outlined, color: AppTheme.accent, size: 16),
          const SizedBox(width: 12),
          Text(_clients[i], style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13)),
        ]),
      ),
    );
  }

  Widget _filtersTab() {
    if (_filters.isEmpty) {
      return Center(child: Text('Filtre bulunamadı', style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted)));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: _filters.length,
      itemBuilder: (ctx, i) {
        final f = _filters[i];
        final enabled = f['enabled'] ?? false;
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppTheme.surface,
            border: Border.all(color: AppTheme.border),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(
                color: enabled ? AppTheme.accentGreen : AppTheme.textMuted,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(f['name'] ?? 'Filtre', style: GoogleFonts.spaceGrotesk(
                  color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500,
                )),
                Text('${f['rules_count'] ?? 0} kural', style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.textSecondary, fontSize: 11,
                )),
              ],
            )),
            Text(enabled ? 'AKTİF' : 'PASİF', style: GoogleFonts.jetBrainsMono(
              color: enabled ? AppTheme.accentGreen : AppTheme.textMuted,
              fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w600,
            )),
          ]),
        );
      },
    );
  }
}
