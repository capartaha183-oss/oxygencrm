import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DNSZonesScreen extends StatefulWidget {
  const DNSZonesScreen({super.key});

  @override
  State<DNSZonesScreen> createState() => _DNSZonesScreenState();
}

class _DNSZonesScreenState extends State<DNSZonesScreen> {
  final _searchCtrl = TextEditingController();

  final _zones = [
    {'zone': 'oxygens.ddns.net', 'type': 'PRIMARY', 'records': '12', 'status': 'active', 'customer': 'Admin'},
    {'zone': 'example.com', 'type': 'PRIMARY', 'records': '8', 'status': 'active', 'customer': 'Acme Corp'},
    {'zone': 'api.mydomain.net', 'type': 'SECONDARY', 'records': '5', 'status': 'active', 'customer': 'TechFirm'},
    {'zone': 'mail.company.org', 'type': 'PRIMARY', 'records': '6', 'status': 'inactive', 'customer': 'GlobeCo'},
    {'zone': 'dev.startup.io', 'type': 'PRIMARY', 'records': '14', 'status': 'active', 'customer': 'Startup Inc'},
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                controller: _searchCtrl,
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search zones...',
                  hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: AppTheme.textMuted, size: 18),
                  filled: true,
                  fillColor: AppTheme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.accent)),
                ),
              ),
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => _showAddDialog(context),
              icon: const Icon(Icons.add, size: 16),
              label: Text('YENİ', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: AppTheme.bg,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                elevation: 0,
              ),
            ),
          ]),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _zones.length,
              itemBuilder: (ctx, i) => _card(_zones[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Map<String, String> z) {
    final active = z['status'] == 'active';
    final isPrimary = z['type'] == 'PRIMARY';
    final typeColor = isPrimary ? AppTheme.accent : AppTheme.accentOrange;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(children: [
        const Icon(Icons.language_rounded, color: AppTheme.accent, size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(z['zone']!, style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600,
            )),
            const SizedBox(height: 4),
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.08),
                  border: Border.all(color: typeColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(z['type']!, style: GoogleFonts.jetBrainsMono(
                  color: typeColor, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600,
                )),
              ),
              const SizedBox(width: 8),
              Text('${z['records']} kayıt · ${z['customer']}', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 10,
              )),
            ]),
          ]),
        ),
        Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(
              color: active ? AppTheme.accentGreen : AppTheme.accentRed,
              shape: BoxShape.circle,
            )),
            const SizedBox(width: 5),
            Text(active ? 'Aktif' : 'Pasif', style: GoogleFonts.jetBrainsMono(
              color: active ? AppTheme.accentGreen : AppTheme.accentRed, fontSize: 11,
            )),
          ]),
          const SizedBox(height: 8),
          Row(children: [
            IconButton(icon: const Icon(Icons.edit_outlined, size: 15, color: AppTheme.textSecondary), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
            const SizedBox(width: 2),
            IconButton(icon: const Icon(Icons.delete_outline, size: 15, color: AppTheme.accentRed), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
          ]),
        ]),
      ]),
    );
  }

  void _showAddDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4), side: const BorderSide(color: AppTheme.border)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('YENİ DNS ZONE', style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2)),
              const SizedBox(height: 8),
              Text('DNS Zone Oluştur', style: GoogleFonts.spaceGrotesk(color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 20),
              TextField(
                controller: ctrl,
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'example.com',
                  hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 13),
                  filled: true, fillColor: AppTheme.card,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.border)),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.border)),
                  focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(3), borderSide: const BorderSide(color: AppTheme.accent, width: 1.5)),
                ),
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: TextButton(onPressed: () => Navigator.pop(ctx), child: Text('İPTAL', style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 12)))),
                const SizedBox(width: 12),
                Expanded(child: ElevatedButton(
                  onPressed: () => Navigator.pop(ctx),
                  style: ElevatedButton.styleFrom(backgroundColor: AppTheme.accent, foregroundColor: AppTheme.bg, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)), elevation: 0),
                  child: Text('OLUŞTUR', style: GoogleFonts.jetBrainsMono(fontSize: 12, fontWeight: FontWeight.w700)),
                )),
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
