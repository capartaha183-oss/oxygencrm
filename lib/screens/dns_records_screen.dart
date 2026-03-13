import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class DNSRecordsScreen extends StatelessWidget {
  const DNSRecordsScreen({super.key});

  static const _records = [
    {'zone': 'oxygens.ddns.net', 'name': '@', 'type': 'A', 'value': '192.168.1.1', 'ttl': '3600'},
    {'zone': 'oxygens.ddns.net', 'name': 'www', 'type': 'CNAME', 'value': 'oxygens.ddns.net', 'ttl': '3600'},
    {'zone': 'oxygens.ddns.net', 'name': 'mail', 'type': 'MX', 'value': 'mail.oxygens.ddns.net', 'ttl': '3600'},
    {'zone': 'example.com', 'name': '@', 'type': 'A', 'value': '203.0.113.10', 'ttl': '300'},
    {'zone': 'example.com', 'name': 'api', 'type': 'A', 'value': '203.0.113.11', 'ttl': '300'},
    {'zone': 'example.com', 'name': '_dmarc', 'type': 'TXT', 'value': 'v=DMARC1; p=none', 'ttl': '3600'},
  ];

  static const _typeColors = {
    'A': AppTheme.accent,
    'CNAME': AppTheme.accentGreen,
    'MX': AppTheme.accentOrange,
    'TXT': Color(0xFFBB86FC),
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(children: [
            Expanded(
              child: TextField(
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Kayıt filtrele...',
                  hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 13),
                  prefixIcon: const Icon(Icons.filter_list, color: AppTheme.textMuted, size: 18),
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
              onPressed: () {},
              icon: const Icon(Icons.add, size: 16),
              label: Text('EKLE', style: GoogleFonts.jetBrainsMono(fontSize: 11, fontWeight: FontWeight.w700)),
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
              itemCount: _records.length,
              itemBuilder: (ctx, i) => _card(_records[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Map<String, String> r) {
    final typeColor = _typeColors[r['type']] ?? AppTheme.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(children: [
        Container(
          width: 40,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          decoration: BoxDecoration(
            color: typeColor.withOpacity(0.08),
            border: Border.all(color: typeColor.withOpacity(0.3)),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(r['type']!, textAlign: TextAlign.center, style: GoogleFonts.jetBrainsMono(
            color: typeColor, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w700,
          )),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text(r['name']!, style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w600,
              )),
              const SizedBox(width: 6),
              Expanded(child: Text(r['zone']!, style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 10,
              ), overflow: TextOverflow.ellipsis)),
            ]),
            const SizedBox(height: 3),
            Text(r['value']!, style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textSecondary, fontSize: 11,
            ), overflow: TextOverflow.ellipsis),
            Text('TTL: ${r['ttl']}s', style: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 10)),
          ]),
        ),
        Row(children: [
          IconButton(icon: const Icon(Icons.edit_outlined, size: 15, color: AppTheme.textSecondary), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
          IconButton(icon: const Icon(Icons.delete_outline, size: 15, color: AppTheme.accentRed), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
        ]),
      ]),
    );
  }
}
