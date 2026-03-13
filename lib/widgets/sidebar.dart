import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'oxygens_logo.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  const Sidebar({super.key, required this.selectedIndex, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: AppTheme.surface,
      child: Column(
        children: [
          Container(
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppTheme.border),
                right: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                const OxygensLogo(size: 32, showText: true),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: AppTheme.border)),
              ),
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  _label('MAIN'),
                  _item(0, Icons.grid_view_rounded, 'Overview'),
                  _label('DNS'),
                  _item(1, Icons.language_rounded, 'DNS Zones'),
                  _item(2, Icons.dns_rounded, 'DNS Records'),
                  _label('ADGUARD'),
                  _item(3, Icons.router_outlined, 'Sunucular'),
                  _label('CRM'),
                  _item(4, Icons.people_outline_rounded, 'Customers'),
                  _label('HESAP'),
                  _item(5, Icons.person_outline_rounded, 'Profil'),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppTheme.border),
                right: BorderSide(color: AppTheme.border),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: const Icon(Icons.person_outline, color: AppTheme.accentGreen, size: 16),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Admin', style: GoogleFonts.spaceGrotesk(
                      color: AppTheme.textPrimary, fontSize: 12, fontWeight: FontWeight.w600,
                    )),
                    Text('root@oxygens', style: GoogleFonts.jetBrainsMono(
                      color: AppTheme.textMuted, fontSize: 10,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _label(String text) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 6),
    child: Text(text, style: GoogleFonts.jetBrainsMono(
      color: AppTheme.textMuted, fontSize: 9, letterSpacing: 2, fontWeight: FontWeight.w600,
    )),
  );

  Widget _item(int index, IconData icon, String label) {
    final sel = selectedIndex == index;
    return GestureDetector(
      onTap: () => onSelect(index),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: sel ? AppTheme.accent.withOpacity(0.08) : Colors.transparent,
          border: sel
              ? Border.all(color: AppTheme.accent.withOpacity(0.2))
              : Border.all(color: Colors.transparent),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: sel ? AppTheme.accent : AppTheme.textSecondary),
            const SizedBox(width: 10),
            Text(label, style: GoogleFonts.spaceGrotesk(
              color: sel ? AppTheme.accent : AppTheme.textSecondary,
              fontSize: 13,
              fontWeight: sel ? FontWeight.w600 : FontWeight.w400,
            )),
          ],
        ),
      ),
    );
  }
}
