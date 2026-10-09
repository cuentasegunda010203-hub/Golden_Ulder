import 'package:flutter/material.dart';

import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/ui/theme/app_colors.dart';

/// Prototipo visual del panel de gestión.
/// Los datos mostrados son demostrativos hasta conectar una API autenticada.
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  int _section = 0;
  final List<String> _sections = const [
    'Resumen', 'Personaje', 'Facción', 'Vehículos', 'Actividad'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.inkDeep,
      child: Row(
        children: [
          Container(
            width: 190,
            padding: const EdgeInsets.fromLTRB(18, 22, 12, 16),
            decoration: const BoxDecoration(
              color: AppColors.ink,
              border: Border(right: BorderSide(color: AppColors.inkLine)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(11),
                    ),
                    child: const Icon(Icons.shield_moon_rounded,
                        color: AppColors.ink, size: 23),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('GOLDEN', style: TextStyle(
                        color: AppColors.cream, fontWeight: FontWeight.w900,
                        letterSpacing: 1.2, fontSize: 12)),
                      Text('CONTROL CENTER', style: TextStyle(
                        color: AppColors.creamDim, fontSize: 8,
                        letterSpacing: .8)),
                    ],
                  )),
                ]),
                const SizedBox(height: 28),
                const Text('GESTIÓN DEL JUGADOR', style: TextStyle(
                  color: AppColors.creamDim, fontSize: 9,
                  letterSpacing: 1.1, fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                for (int i = 0; i < _sections.length; i++)
                  _NavigationItem(
                    label: _sections[i],
                    icon: [Icons.grid_view_rounded, Icons.person_rounded,
                      Icons.shield_rounded, Icons.directions_car_rounded,
                      Icons.history_rounded][i],
                    selected: _section == i,
                    onTap: () => setState(() => _section = i),
                  ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.inkRaised,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.inkLine),
                  ),
                  child: const Row(children: [
                    Icon(Icons.lock_outline_rounded,
                      color: AppColors.gold, size: 17),
                    SizedBox(width: 8),
                    Expanded(child: Text('Conexión protegida\nAPI pendiente',
                      style: TextStyle(color: AppColors.creamDim,
                        fontSize: 10, height: 1.4))),
                  ]),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(_sections[_section].toUpperCase(),
                          style: const TextStyle(color: AppColors.gold,
                            fontSize: 10, letterSpacing: 1.5,
                            fontWeight: FontWeight.w800)),
                        const SizedBox(height: 5),
                        Text(_title,
                          style: const TextStyle(color: AppColors.cream,
                            fontSize: 25, fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        const Text('Tu mundo. Tu progreso. Todo bajo control.',
                          style: TextStyle(color: AppColors.creamDim,
                            fontSize: 11)),
                      ],
                    )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 11, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.inkRaised,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: AppColors.inkLine),
                      ),
                      child: const Row(children: [
                        Icon(Icons.circle, size: 7, color: AppColors.gold),
                        SizedBox(width: 7),
                        Text('VISTA PREVIA', style: TextStyle(
                          color: AppColors.cream, fontSize: 9,
                          fontWeight: FontWeight.w800, letterSpacing: .7)),
                      ]),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  Expanded(child: _buildContent()),
                  const SizedBox(height: 10),
                  const Row(children: [
                    Icon(Icons.info_outline_rounded,
                      color: AppColors.gold, size: 13),
                    SizedBox(width: 6),
                    Expanded(child: Text(
                      'Modo diseño: información de ejemplo, aún no conectada a tu cuenta del juego.',
                      style: TextStyle(color: AppColors.creamDim, fontSize: 9))),
                    Text('GOLDEN UNDERWORLD RP',
                      style: TextStyle(color: AppColors.creamDim,
                        fontSize: 9, letterSpacing: .7)),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String get _title => [
    'Panel de control', 'Perfil del personaje', 'Tu organización',
    'Flota de vehículos', 'Registro de actividad'
  ][_section];

  Widget _buildContent() {
    switch (_section) {
      case 1:
        return const _EmptyState(
          icon: Icons.person_search_rounded,
          title: 'Tu personaje, de un vistazo',
          description: 'Aquí aparecerán el nombre, nivel, dinero y estadísticas cuando conectemos la API.',
          tag: 'PERFIL · PENDIENTE DE CONEXIÓN');
      case 2:
        return const _EmptyState(
          icon: Icons.groups_2_rounded,
          title: 'Gestión de organización',
          description: 'Miembros, rangos y permisos se mostrarán según la organización y los permisos reales de tu cuenta.',
          tag: 'FACCIÓN · PENDIENTE DE CONEXIÓN');
      case 3:
        return const _EmptyState(
          icon: Icons.directions_car_filled_rounded,
          title: 'Control de vehículos',
          description: 'La flota, su estado y sus ubicaciones se cargarán desde datos autorizados del servidor.',
          tag: 'VEHÍCULOS · PENDIENTE DE CONEXIÓN');
      case 4:
        return const _EmptyState(
          icon: Icons.receipt_long_rounded,
          title: 'Actividad reciente',
          description: 'Cuando exista una fuente segura de eventos, aquí podrás consultar el historial de tu cuenta.',
          tag: 'ACTIVIDAD · PENDIENTE DE CONEXIÓN');
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: [Color(0xFF393020), Color(0xFF25201A)],
                  begin: Alignment.topLeft, end: Alignment.bottomRight),
                border: Border.all(color: AppColors.gold.withValues(alpha: .35)),
              ),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: .16),
                    borderRadius: BorderRadius.circular(15)),
                  child: const Icon(Icons.person_rounded,
                    color: AppColors.gold, size: 30)),
                const SizedBox(width: 16),
                const Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BIENVENIDO A SAN ANDREAS',
                      style: TextStyle(color: AppColors.gold, fontSize: 9,
                        fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                    SizedBox(height: 6),
                    Text('Tu próxima historia empieza aquí',
                      style: TextStyle(color: AppColors.cream,
                        fontSize: 19, fontWeight: FontWeight.w800)),
                    SizedBox(height: 5),
                    Text('Vincula tu cuenta cuando habilitemos el acceso seguro.',
                      style: TextStyle(color: AppColors.creamDim, fontSize: 11)),
                  ],
                )),
                const Icon(Icons.arrow_outward_rounded,
                  color: AppColors.gold, size: 23),
              ]),
            ),
            const SizedBox(height: 15),
            const Row(children: [
              Expanded(child: _MetricCard(
                icon: Icons.account_circle_outlined, label: 'PERSONAJE',
                value: 'Sin vincular', detail: 'Esperando API')),
              SizedBox(width: 12),
              Expanded(child: _MetricCard(
                icon: Icons.groups_2_outlined, label: 'ORGANIZACIÓN',
                value: 'No disponible', detail: 'Esperando API')),
              SizedBox(width: 12),
              Expanded(child: _MetricCard(
                icon: Icons.directions_car_outlined, label: 'VEHÍCULOS',
                value: '—', detail: 'Esperando API')),
            ]),
            const SizedBox(height: 15),
            Expanded(child: Container(
              padding: const EdgeInsets.all(17),
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.inkLine),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [
                    Icon(Icons.rocket_launch_rounded,
                      color: AppColors.gold, size: 17),
                    SizedBox(width: 8),
                    Text('CENTRO DE ACCESO RÁPIDO',
                      style: TextStyle(color: AppColors.cream,
                        fontSize: 11, fontWeight: FontWeight.w800)),
                  ]),
                  const SizedBox(height: 14),
                  Expanded(child: Row(children: [
                    Expanded(child: _QuickAction(
                      icon: Icons.person_rounded, title: 'Mi personaje',
                      subtitle: 'Datos y progreso',
                      onTap: () => setState(() => _section = 1))),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickAction(
                      icon: Icons.shield_rounded, title: 'Organización',
                      subtitle: 'Rangos y miembros',
                      onTap: () => setState(() => _section = 2))),
                    const SizedBox(width: 12),
                    Expanded(child: _QuickAction(
                      icon: Icons.car_rental_rounded, title: 'Vehículos',
                      subtitle: 'Estado y ubicación',
                      onTap: () => setState(() => _section = 3))),
                  ])),
                ],
              ),
            )),
          ],
        );
    }
  }
}

class _NavigationItem extends StatelessWidget {
  const _NavigationItem({required this.label, required this.icon,
    required this.selected, required this.onTap});
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Material(
        color: selected ? AppColors.gold.withValues(alpha: .14) : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: onTap,
          child: Container(
            height: 42,
            padding: const EdgeInsets.symmetric(horizontal: 11),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(9),
              border: Border.all(color: selected
                ? AppColors.gold.withValues(alpha: .4) : Colors.transparent),
            ),
            child: Row(children: [
              Icon(icon, size: 17,
                color: selected ? AppColors.gold : AppColors.creamDim),
              const SizedBox(width: 10),
              Text(label, style: TextStyle(
                color: selected ? AppColors.cream : AppColors.creamDim,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
              const Spacer(),
              if (selected) const Icon(Icons.chevron_right_rounded,
                color: AppColors.gold, size: 16),
            ]),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.icon, required this.label,
    required this.value, required this.detail});
  final IconData icon;
  final String label, value, detail;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(13),
      border: Border.all(color: AppColors.inkLine),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Icon(icon, color: AppColors.gold, size: 19),
      const SizedBox(height: 13),
      Text(label, style: const TextStyle(color: AppColors.creamDim,
        fontSize: 9, letterSpacing: .6, fontWeight: FontWeight.w700)),
      const SizedBox(height: 5),
      Text(value, maxLines: 1, overflow: TextOverflow.ellipsis,
        style: const TextStyle(color: AppColors.cream,
          fontSize: 15, fontWeight: FontWeight.w800)),
      const SizedBox(height: 4),
      Text(detail, style: const TextStyle(color: AppColors.creamDim,
        fontSize: 9)),
    ]),
  );
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.title,
    required this.subtitle, required this.onTap});
  final IconData icon;
  final String title, subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
    color: AppColors.inkRaised,
    borderRadius: BorderRadius.circular(11),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(11),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(children: [
          Icon(icon, color: AppColors.gold, size: 22),
          const SizedBox(width: 10),
          Expanded(child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: AppColors.cream,
                fontSize: 11, fontWeight: FontWeight.w700)),
              const SizedBox(height: 4),
              Text(subtitle, style: const TextStyle(
                color: AppColors.creamDim, fontSize: 9)),
            ],
          )),
          const Icon(Icons.chevron_right_rounded,
            color: AppColors.creamDim, size: 16),
        ]),
      ),
    ),
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.icon, required this.title,
    required this.description, required this.tag});
  final IconData icon;
  final String title, description, tag;

  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 470),
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: BoxDecoration(
          color: AppColors.ink,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.inkLine),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 62, height: 62,
            decoration: BoxDecoration(color: AppColors.gold.withValues(alpha: .13),
              borderRadius: BorderRadius.circular(17)),
            child: Icon(icon, color: AppColors.gold, size: 30)),
          const SizedBox(height: 18),
          Text(title, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.cream,
              fontSize: 19, fontWeight: FontWeight.w800)),
          const SizedBox(height: 9),
          Text(description, textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.creamDim,
              fontSize: 12, height: 1.6)),
          const SizedBox(height: 18),
          Container(padding: const EdgeInsets.symmetric(
            horizontal: 12, vertical: 8),
            decoration: BoxDecoration(color: AppColors.inkRaised,
              borderRadius: BorderRadius.circular(7)),
            child: Text(tag, style: const TextStyle(color: AppColors.gold,
              fontSize: 9, fontWeight: FontWeight.w800, letterSpacing: .6))),
        ]),
      ),
    ),
  );
}
