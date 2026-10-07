import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artplay_launcher/bloc/ui/pager_bloc.dart';
import 'package:artplay_launcher/ui/screens/home/home_screen.dart';
import 'package:artplay_launcher/ui/screens/servers/servers_screen.dart';
import 'package:artplay_launcher/ui/screens/settings/settings_screen.dart';
import 'package:artplay_launcher/ui/shell/nav_rail.dart';

/// Esqueleto de la app: barra lateral + página activa.
///
/// Para añadir una pantalla: 1) valor nuevo en [AppPage], 2) entrada en
/// [_pages], 3) botón en `AppNavRail._items`.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const Map<AppPage, Widget> _pages = {
    AppPage.home: HomeScreen(),
    AppPage.servers: ServersScreen(),
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
