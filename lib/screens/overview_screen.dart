import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../services/adguard_service.dart';
import '../services/server_store.dart';
import '../services/auth_service.dart';

class OverviewScreen extends StatefulWidget {
  const OverviewScreen({super.key});

  @override
  State<OverviewScreen> createState() => _OverviewScreenState();
}

class _OverviewScreenState extends State<OverviewScreen> {
  bool _loading = false;
  int _totalQueries = 0;
  int _totalBlocked = 0;
  int _totalClients = 0;
  List<Map<String, dynamic>> _serverStatuses = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    if (ServerStore.servers.isEmpty) return;
    setState(() => _loading = true);

    int queries = 0;
    int blocked = 0;
    int clients = 0;
    List<Map<String, dynamic>> statuses = [];

    for (final server in ServerStore.servers) {
      final online = await AdGuardService.checkStatus(server);
      server.isOnline = online;

      if (online) {
        final stats = await AdGuardService.getStats(server);
        final clientList = await AdGuardService.getClients(server);
        if (stats != null) {
          queries += stats.totalQueries;
          blocked += stats.blockedQueries;
        }
        clients += clientList.length;
      }

      statuses.add({
        'name': server.name,
        'ip': '${server.ip}:${server.port}',
        'online': online,
      });
    }

    if (mounted) {
      setState(() {
        _totalQueries = queries;
        _totalBlocked = blocked;
        _totalClients = clients;
        _serverStatuses = statuses;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final onlineCount = ServerStore.onlineCount;
    final totalCount = ServerStore.servers.length;

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppTheme.accent,
      backgroundColor: AppTheme.surface,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hoş geldin, ${AuthService.currentUser ?? 'Admin'}',
                      style: GoogleFonts.spaceGrotesk(
                        color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(_getDateString(), style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textSecondary, fontSize: 12,
                    )),
                  ],
                ),
              ),
              if (_loading)
                const SizedBox(
                  width: 18, height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.accent),
                )
              else
                GestureDetector(
                  onTap: _loadData,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.surface,
                      border: Border.all(color: AppTheme.border),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Row(children: [
                      const Icon(Icons.refresh, size: 14, color: AppTheme.textSecondary),
                      const SizedBox(width: 6),
                      Text('Yenile', style: GoogleFonts.jetBrainsMono(
                        color: AppTheme.textSecondary, fontSize: 11,
                      )),
                    ]),
                  ),
                ),
            ]),
            const SizedBox(height: 24),

            if (totalCount == 0)
              _noServersBanner()
            else ...[
              Row(children: [
                _stat('SUNUCULAR', '$onlineCount / $totalCount online',
                    Icons.router_outlined, AppTheme.accent,
                    onlineCount == totalCount ? 'Hepsi online' : '${ServerStore.offlineCount} offline'),
                const SizedBox(width: 16),
                _stat('TOPLAM SORGU', _formatNumber(_totalQueries),
                    Icons.query_stats_rounded, AppTheme.accentGreen, 'tüm sunucular'),
                const SizedBox(width: 16),
                _stat('ENGELLENDİ', _formatNumber(_totalBlocked),
                    Icons.block_rounded, AppTheme.accentRed,
                    _totalQueries > 0
                        ? '%${(_totalBlocked / _totalQueries * 100).toStringAsFixed(1)}'
                        : '-'),
                const SizedBox(width: 16),
                _stat('BAĞLI CİHAZ', '$_totalClients',
                    Icons.devices_rounded, AppTheme.accentOrange, 'toplam'),
              ]),
              const SizedBox(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: _panel('SUNUCU DURUMU', Column(
                      children: _serverStatuses.isEmpty
                          ? [Center(child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Text('Veri yükleniyor...',
                                style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12)),
                            ))]
                          : _serverStatuses.map((s) => _serverRow(s)).toList(),
                    )),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: _panel('GENEL DURUM', Column(
                      children: [
                        _infoRow('Toplam Sunucu', '$totalCount'),
                        _infoRow('Online', '$onlineCount'),
                        _infoRow('Offline', '${ServerStore.offlineCount}'),
                        _infoRow('Toplam Sorgu', _formatNumber(_totalQueries)),
                        _infoRow('Engellenen', _formatNumber(_totalBlocked)),
                        _infoRow('Bağlı Cihaz', '$_totalClients'),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.card,
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: AppTheme.border),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ENGELLEME ORANI', style: GoogleFonts.jetBrainsMono(
                                color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2,
                              )),
                              const SizedBox(height: 4),
                              Text(
                                _totalQueries > 0
                                    ? '%${(_totalBlocked / _totalQueries * 100).toStringAsFixed(2)}'
                                    : '-%',
                                style: GoogleFonts.spaceGrotesk(
                                  color: AppTheme.accentRed, fontSize: 28, fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text('son 24 saat', style: GoogleFonts.jetBrainsMono(
                                color: AppTheme.textSecondary, fontSize: 11,
                              )),
                            ],
                          ),
                        ),
                      ],
                    )),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _noServersBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(children: [
        const Icon(Icons.dns_outlined, color: AppTheme.textMuted, size: 48),
        const SizedBox(height: 16),
        Text('Henüz sunucu eklenmedi', style: GoogleFonts.spaceGrotesk(
          color: AppTheme.textMuted, fontSize: 16,
        )),
        const SizedBox(height: 8),
        Text('Sol menüden "Sunucular" sekmesine giderek AdGuard sunucusu ekleyin.',
          style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ]),
    );
  }

  Widget _stat(String label, String value, IconData icon, Color color, String sub) {
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
              Expanded(child: Text(label, style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2,
              ))),
            ]),
            const SizedBox(height: 10),
            Text(value, style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 22, fontWeight: FontWeight.w700,
            )),
            Text(sub, style: GoogleFonts.jetBrainsMono(
              color: color.withOpacity(0.7), fontSize: 11,
            )),
          ],
        ),
      ),
    );
  }

  Widget _panel(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.w600,
          )),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _serverRow(Map<String, dynamic> s) {
    final online = s['online'] as bool;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(
            color: online ? AppTheme.accentGreen : AppTheme.accentRed,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(s['name'], style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500,
            )),
            Text(s['ip'], style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textSecondary, fontSize: 11,
            )),
          ],
        )),
        Text(online ? 'ONLINE' : 'OFFLINE', style: GoogleFonts.jetBrainsMono(
          color: online ? AppTheme.accentGreen : AppTheme.accentRed,
          fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w600,
        )),
      ]),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(children: [
        Expanded(child: Text(label, style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textMuted, fontSize: 11,
        ))),
        Text(value, style: GoogleFonts.jetBrainsMono(
          color: AppTheme.textPrimary, fontSize: 11, fontWeight: FontWeight.w600,
        )),
      ]),
    );
  }

  String _formatNumber(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return '$n';
  }

  String _getDateString() {
    final now = DateTime.now();
    const days = ['Pazartesi', 'Salı', 'Çarşamba', 'Perşembe', 'Cuma', 'Cumartesi', 'Pazar'];
    const months = ['Ocak', 'Şubat', 'Mart', 'Nisan', 'Mayıs', 'Haziran',
        'Temmuz', 'Ağustos', 'Eylül', 'Ekim', 'Kasım', 'Aralık'];
    return '${days[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
  }
}
