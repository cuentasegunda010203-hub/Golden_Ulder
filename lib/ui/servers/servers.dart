import 'package:flutter/material.dart';
import 'package:samp_query/samp_query.dart';
import 'package:artplay_launcher/repository/server_repository.dart';

class Servers extends StatefulWidget {
  const Servers({super.key});

  @override
  State<Servers> createState() => _ServersState();
}

class _ServersState extends State<Servers> {
  final ServerRepository _repository = ServerRepository();
  List<Server> _servers = [];

  @override
  void initState() {
    super.initState();
    _servers = _repository.fetchServers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de Fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/ic_launcher_background.png',
              fit: BoxFit.cover,
            ),
          ),
          // Capa oscura para mejorar legibilidad
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.55),
            ),
          ),
          // Contenido Principal Responsivo
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                children: [
                  // --- ENCABEZADO DE NAVEGACIÓN ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/ic_icon.png',
                            height: 36,
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'GOLDEN UNDERWORLD',
                            style: TextStyle(
                              color: Color(0xFFFFD700),
                              fontSize: 18,
                              fontWeight: FontWeight.black,
                              letterSpacing: 1.5,
                              shadows: [
                                Shadow(blurRadius: 8, color: Colors.black, offset: Offset(1, 1))
                              ],
                            ),
                          ),
                          const Text(
                            ' RP',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      // Indicador de Estado Online
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.greenAccent, width: 1),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.circle, color: Colors.greenAccent, size: 8),
                            SizedBox(width: 6),
                            Text(
                              'ONLINE',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  // --- PANEL PRINCIPAL (IZQUIERDA: DATO / DERECHA: ACCIONES) ---
                  Expanded(
                    flex: 8,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Tarjeta de Servidor (Izquierda)
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFF141414).withOpacity(0.85),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFFFD700).withOpacity(0.35),
                                width: 1.5,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.5),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                )
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Servidor Principal',
                                  style: TextStyle(
                                    color: Color(0xFFFFD700),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                _buildInfoRow(
                                  Icons.dns_rounded,
                                  _servers.isNotEmpty
                                      ? '${_servers[0].address}:${_servers[0].port}'
                                      : '217.77.9.210:7009',
                                ),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.people_alt_rounded, 'Jugadores: 0 / 100'),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.speed_rounded, 'Ping: 45 ms'),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        // Panel de Acción y Redes (Derecha)
                        Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              // Botón Conectar / Jugar
                              Expanded(
                                flex: 3,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFFD700),
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 6,
                                    shadowColor: const Color(0xFFFFD700).withOpacity(0.4),
                                  ),
                                  onPressed: () {
                                    // Lógica de conexión o descarga
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.play_arrow_rounded, size: 36, color: Colors.black),
                                      SizedBox(width: 6),
                                      Text(
                                        'JUGAR',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.black,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Acceso rápido a Redes Sociales
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: [
                                    _buildSocialButton(Icons.discord, 'Discord', () {}),
                                    const SizedBox(width: 8),
                                    _buildSocialButton(Icons.public, 'Web', () {}),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFFD700), size: 18),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label, VoidCallback onTap) {
    return Expanded(
      child: Material(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 16),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
