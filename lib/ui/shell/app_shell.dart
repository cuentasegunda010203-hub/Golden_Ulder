import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artplay_launcher/bloc/ui/pager_bloc.dart';
import 'package:artplay_launcher/ui/screens/downloads/downloads_screen.dart';
import 'package:artplay_launcher/ui/screens/home/home_screen.dart';
import 'package:artplay_launcher/ui/screens/management/management_screen.dart';
import 'package:artplay_launcher/ui/screens/servers/servers_screen.dart';
import 'package:artplay_launcher/ui/screens/settings/settings_screen.dart';
import 'package:artplay_launcher/ui/shell/nav_rail.dart';

/// Esqueleto de la app: navegación lateral + página activa.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const Map<AppPage, Widget> _pages = {
    AppPage.home: HomeScreen(),
    AppPage.servers: ServersScreen(),
    AppPage.management: ManagementScreen(),
    AppPage.downloads: DownloadsScreen(),
    AppPage.settings: SettingsScreen(),
  };

  @override
  Widget build(BuildContext context) {
    final pager = context.read<PagerBloc>();

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<AppPage>(
          stream: pager.pageStream,
          initialData: pager.currentPage,
          builder: (context, snapshot) {
            final page = snapshot.data ?? AppPage.home;

            return Row(
              children: [
                AppNavRail(current: page, onSelected: pager.changePage),
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 220),
                    child: KeyedSubtree(
                      key: ValueKey(page),
                      child: _pages[page]!,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
