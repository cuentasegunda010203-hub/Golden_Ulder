import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:artplay_launcher/bloc/ui/pager_bloc.dart';
import 'package:artplay_launcher/ui/screens/home/home_screen.dart';
import 'package:artplay_launcher/ui/screens/servers/servers_screen.dart';
import 'package:artplay_launcher/ui/screens/settings/settings_screen.dart';
import 'package:artplay_launcher/ui/shell/nav_rail.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Navegación adaptable: rail premium en pantallas amplias y barra inferior
/// cómoda en Android vertical.
class AppShell extends StatelessWidget {
  const AppShell({super.key});

  static const Map<AppPage, Widget> _pages = {
    AppPage.home: HomeScreen(),
    AppPage.servers: ServersScreen(),
    AppPage.settings: SettingsScreen(),
  };

  static const _destinations = <NavigationDestination>[
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home_rounded),
      label: 'Inicio',
    ),
    NavigationDestination(
      icon: Icon(Icons.dns_outlined),
      selectedIcon: Icon(Icons.dns_rounded),
      label: 'Servidores',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune_rounded),
      label: 'Ajustes',
    ),
  ];

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
            final content = Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 260),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                child: KeyedSubtree(
                  key: ValueKey(page),
                  child: _pages[page]!,
                ),
              ),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 720) {
                  return Column(
                    children: [
                      content,
                      NavigationBar(
                        height: 66,
                        selectedIndex: AppPage.values.indexOf(page),
                        onDestinationSelected: (index) =>
                            pager.changePage(AppPage.values[index]),
                        destinations: _destinations,
                        backgroundColor: AppColors.inkDeep,
                        indicatorColor: AppColors.burgundy.withValues(alpha: 0.55),
                        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                      ),
                    ],
                  );
                }

                return Row(
                  children: [
                    AppNavRail(
                      current: page,
                      onSelected: pager.changePage,
                    ),
                    content,
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
