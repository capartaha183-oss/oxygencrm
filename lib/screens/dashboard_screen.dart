import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/sidebar.dart';
import 'overview_screen.dart';
import 'dns_zones_screen.dart';
import 'dns_records_screen.dart';
import 'customers_screen.dart';
import 'servers_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _idx = 0;

  final _screens = const [
    OverviewScreen(),
    DNSZonesScreen(),
    DNSRecordsScreen(),
    ServersScreen(),
    CustomersScreen(),
    ProfileScreen(),
  ];

  final _titles = ['Overview', 'DNS Zones', 'DNS Records', 'Sunucular', 'Customers', 'Profil'];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 700;

    if (isWide) {
      // Tablet/Desktop: yan sidebar
      return Scaffold(
        backgroundColor: AppTheme.bg,
        body: Row(
          children: [
            Sidebar(selectedIndex: _idx, onSelect: (i) => setState(() => _idx = i)),
            Expanded(child: _mainContent()),
          ],
        ),
      );
    } else {
      // Mobil: alt navbar
      return Scaffold(
        backgroundColor: AppTheme.bg,
        appBar: AppBar(
          backgroundColor: AppTheme.surface,
          elevation: 0,
          title: Row(children: [
            Text(_titles[_idx], style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
            )),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.08),
                border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(children: [
                Container(width: 5, height: 5,
                  decoration: const BoxDecoration(color: AppTheme.accentGreen, shape: BoxShape.circle)),
                const SizedBox(width: 5),
                Text('ONLINE', style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.accentGreen, fontSize: 9, fontWeight: FontWeight.w600, letterSpacing: 1,
                )),
              ]),
            ),
          ]),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(height: 1, color: AppTheme.border),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _screens[_idx],
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          child: BottomNavigationBar(
            currentIndex: _idx,
            onTap: (i) => setState(() => _idx = i),
            backgroundColor: Colors.transparent,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppTheme.accent,
            unselectedItemColor: AppTheme.textMuted,
            selectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 9, fontWeight: FontWeight.w600),
            unselectedLabelStyle: GoogleFonts.jetBrainsMono(fontSize: 9),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.grid_view_rounded, size: 20), label: 'Overview'),
              BottomNavigationBarItem(icon: Icon(Icons.language_rounded, size: 20), label: 'DNS Zones'),
              BottomNavigationBarItem(icon: Icon(Icons.dns_rounded, size: 20), label: 'Records'),
              BottomNavigationBarItem(icon: Icon(Icons.router_outlined, size: 20), label: 'Sunucular'),
              BottomNavigationBarItem(icon: Icon(Icons.people_outline_rounded, size: 20), label: 'CRM'),
              BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded, size: 20), label: 'Profil'),
            ],
          ),
        ),
      );
    }
  }

  Widget _mainContent() {
    return Column(
      children: [
        Container(
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          decoration: const BoxDecoration(
            color: AppTheme.surface,
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Row(children: [
            Text(_titles[_idx], style: GoogleFonts.spaceGrotesk(
              color: AppTheme.textPrimary, fontSize: 16, fontWeight: FontWeight.w600,
            )),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppTheme.accentGreen.withOpacity(0.08),
                border: Border.all(color: AppTheme.accentGreen.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(children: [
                Container(width: 6, height: 6,
                  decoration: const BoxDecoration(color: AppTheme.accentGreen, shape: BoxShape.circle)),
                const SizedBox(width: 6),
                Text('ALL SYSTEMS ONLINE', style: GoogleFonts.jetBrainsMono(
                  color: AppTheme.accentGreen, fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 1.5,
                )),
              ]),
            ),
          ]),
        ),
        Expanded(child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _screens[_idx],
        )),
      ],
    );
  }
}
