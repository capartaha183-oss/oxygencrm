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
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Row(
            children: [
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(3),
                      borderSide: const BorderSide(color: AppTheme.accent),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: () => _showAddDialog(context),
                icon: const Icon(Icons.add, size: 16),
                label: Text('NEW ZONE', style: GoogleFonts.jetBrainsMono(
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
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.surface,
                border: Border.all(color: AppTheme.border),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: const BoxDecoration(
                      border: Border(bottom: BorderSide(color: AppTheme.border)),
                    ),
                    child: Row(children: [
                      _th('ZONE NAME', 3), _th('TYPE', 1), _th('RECORDS', 1),
                      _th('CUSTOMER', 2), _th('STATUS', 1), _th('', 1),
                    ]),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _zones.length,
                      itemBuilder: (ctx, i) => _row(_zones[i], i),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _th(String label, int flex) => Expanded(
    flex: flex,
    child: Text(label, style: GoogleFonts.jetBrainsMono(
      color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w600,
    )),
  );

  Widget _row(Map<String, String> z, int i) {
    final active = z['status'] == 'active';
    final isPrimary = z['type'] == 'PRIMARY';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: i.isEven ? Colors.transparent : AppTheme.card.withOpacity(0.3),
        border: const Border(bottom: BorderSide(color: AppTheme.border, width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(flex: 3, child: Row(children: [
            const Icon(Icons.language_rounded, color: AppTheme.accent, size: 14),
            const SizedBox(width: 8),
            Text(z['zone']!, style: GoogleFonts.jetBrainsMono(
              color: AppTheme.textPrimary, fontSize: 13, fontWeight: FontWeight.w500,
            )),
          ])),
          Expanded(flex: 1, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: isPrimary ? AppTheme.accent.withOpacity(0.08) : AppTheme.accentOrange.withOpacity(0.08),
              border: Border.all(color: isPrimary ? AppTheme.accent.withOpacity(0.3) : AppTheme.accentOrange.withOpacity(0.3)),
              borderRadius: BorderRadius.circular(2),
            ),
            child: Text(z['type']!, textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(
                color: isPrimary ? AppTheme.accent : AppTheme.accentOrange,
                fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w600,
              ),
            ),
          )),
          Expanded(flex: 1, child: Text(z['records']!, style: GoogleFonts.jetBrainsMono(
            color: AppTheme.textSecondary, fontSize: 13,
          ))),
          Expanded(flex: 2, child: Text(z['customer']!, style: GoogleFonts.spaceGrotesk(
            color: AppTheme.textSecondary, fontSize: 13,
          ))),
          Expanded(flex: 1, child: Row(children: [
            Container(width: 6, height: 6, decoration: BoxDecoration(
              color: active ? AppTheme.accentGreen : AppTheme.accentRed,
              shape: BoxShape.circle,
            )),
            const SizedBox(width: 6),
            Text(active ? 'Active' : 'Inactive', style: GoogleFonts.jetBrainsMono(
              color: active ? AppTheme.accentGreen : AppTheme.accentRed, fontSize: 11,
            )),
          ])),
          Expanded(flex: 1, child: Row(children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined, size: 15, color: AppTheme.textSecondary),
              onPressed: () {},
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 15, color: AppTheme.accentRed),
              onPressed: () {},
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(4),
            ),
          ])),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: const BorderSide(color: AppTheme.border),
        ),
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ADD DNS ZONE', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 10, letterSpacing: 2,
              )),
              const SizedBox(height: 8),
              Text('Create a new DNS zone', style: GoogleFonts.spaceGrotesk(
                color: AppTheme.textPrimary, fontSize: 18, fontWeight: FontWeight.w600,
              )),
              const SizedBox(height: 24),
              Text('ZONE NAME', style: GoogleFonts.jetBrainsMono(
                color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2,
              )),
              const SizedBox(height: 6),
              TextField(
                controller: ctrl,
                style: GoogleFonts.jetBrainsMono(color: AppTheme.textPrimary, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'example.com',
                  hintStyle: GoogleFonts.jetBrainsMono(color: AppTheme.textMuted, fontSize: 13),
                  filled: true,
                  fillColor: AppTheme.card,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(color: AppTheme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(3),
                    borderSide: const BorderSide(color: AppTheme.accent, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text('CANCEL', style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textSecondary, fontSize: 12, letterSpacing: 1,
                    )),
                  )),
                  const SizedBox(width: 12),
                  Expanded(child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.accent,
                      foregroundColor: AppTheme.bg,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
                      elevation: 0,
                    ),
                    child: Text('CREATE', style: GoogleFonts.jetBrainsMono(
                      fontSize: 12, fontWeight: FontWeight.w700, letterSpacing: 1,
                    )),
                  )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
