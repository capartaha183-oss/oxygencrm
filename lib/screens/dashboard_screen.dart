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
    return Scaffold(
      backgroundColor: AppTheme.bg,
      body: Row(
        children: [
          Sidebar(
            selectedIndex: _idx,
            onSelect: (i) => setState(() => _idx = i),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: const BoxDecoration(
                    color: AppTheme.surface,
                    border: Border(bottom: BorderSide(color: AppTheme.border)),
                  ),
                  child: Row(
                    children: [
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
                        child: Row(
                          children: [
                            Container(
                              width: 6, height: 6,
                              decoration: const BoxDecoration(
                                color: AppTheme.accentGreen,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text('ALL SYSTEMS ONLINE', style: GoogleFonts.jetBrainsMono(
                              color: AppTheme.accentGreen, fontSize: 10,
                              fontWeight: FontWeight.w600, letterSpacing: 1.5,
                            )),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      Container(
                        width: 32, height: 32,
                        decoration: BoxDecoration(
                          color: AppTheme.accent.withOpacity(0.1),
                          border: Border.all(color: AppTheme.accent.withOpacity(0.4)),
                          borderRadius: BorderRadius.circular(3),
                        ),
                        child: const Icon(Icons.person_outline, color: AppTheme.accent, size: 18),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    child: _screens[_idx],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
