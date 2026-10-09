import 'package:artplay_launcher/config/app_config.dart';
import 'package:url_launcher/url_launcher.dart';

/// Puente entre el launcher y el cliente SA-MP instalado en Android.
///
/// El cliente debe registrar el esquema samp://. Abrir el enlace no garantiza
/// por sí solo que la conexión al servidor se haya completado.
abstract class ServerConnectionService {
  static Future<bool> openServer() async {
    final uri = Uri(
      scheme: 'samp',
      host: AppConfig.serverHost,
      port: AppConfig.serverPort,
    );

    try {
      return await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      // No encontrar una aplicación compatible es un caso esperado.
      return false;
    }
  }
}
