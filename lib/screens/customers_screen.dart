import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  static const _customers = [
    {'name': 'Acme Corp', 'email': 'admin@acme.com', 'zones': '4', 'plan': 'PRO', 'since': '2024-01'},
    {'name': 'TechFirm Ltd', 'email': 'ops@techfirm.io', 'zones': '2', 'plan': 'BASIC', 'since': '2024-03'},
    {'name': 'GlobeCo', 'email': 'dns@globeco.net', 'zones': '6', 'plan': 'ENTERPRISE', 'since': '2023-11'},
    {'name': 'Startup Inc', 'email': 'dev@startup.io', 'zones': '1', 'plan': 'BASIC', 'since': '2025-01'},
    {'name': 'ShopNow', 'email': 'it@shopnow.com', 'zones': '3', 'plan': 'PRO', 'since': '2024-07'},
  ];

  static const _planColors = {
    'BASIC': AppTheme.textSecondary,
    'PRO': AppTheme.accent,
    'ENTERPRISE': AppTheme.accentGreen,
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
                  hintText: 'Search customers...',
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
              onPressed: () {},
              icon: const Icon(Icons.person_add_outlined, size: 16),
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
              itemCount: _customers.length,
              itemBuilder: (ctx, i) => _card(_customers[i]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Map<String, String> c) {
    final planColor = _planColors[c['plan']] ?? AppTheme.textSecondary;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        border: Border.all(color: AppTheme.border),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(children: [
        Container(
          width: 36, height: 36,
          decoration: BoxDecoration(
            color: AppTheme.accent.withOpacity(0.08),
            border: Border.all(color: AppTheme.accent.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Center(child: Text(c['name']![0], style: GoogleFonts.spaceGrotesk(
            color: AppTheme.accent, fontSize: 16, fontWeight: FontWeight.w700,
          ))),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Expanded(child: Text(c['name']!, style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary, fontSize: 14, fontWeight: FontWeight.w600,
              ))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: planColor.withOpacity(0.08),
                  border: Border.all(color: planColor.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(c['plan']!, style: GoogleFonts.jetBrainsMono(
                  color: planColor, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w700,
                )),
              ),
            ]),
            const SizedBox(height: 4),
            Text(c['email']!, style: GoogleFonts.jetBrainsMono(color: AppTheme.textSecondary, fontSize: 11)),
            const SizedBox(height: 2),
            Text('${c['zones']} zone · ${c['since']}', style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textMuted, fontSize: 10,
            )),
          ]),
        ),
        const SizedBox(width: 8),
        Column(children: [
          IconButton(icon: const Icon(Icons.visibility_outlined, size: 16, color: AppTheme.accent), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
          IconButton(icon: const Icon(Icons.edit_outlined, size: 16, color: AppTheme.textSecondary), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
          IconButton(icon: const Icon(Icons.delete_outline, size: 16, color: AppTheme.accentRed), onPressed: () {}, constraints: const BoxConstraints(), padding: const EdgeInsets.all(4)),
        ]),
      ]),
    );
  }
}
