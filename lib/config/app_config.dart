/// Única fuente de verdad para los datos "de marca" y del servidor.
///
/// Si cambias de IP, nombre o enlaces, solo hay que tocar este archivo.
abstract class AppConfig {
  // --- Marca ---------------------------------------------------------------
  static const String serverName = 'Golden Underworld';
  static const String serverSuffix = 'RP';
  static const String tagline = 'Servidor de rol · San Andreas Multiplayer';

  /// Mantener sincronizado con `version:` de pubspec.yaml.
  static const String appVersion = '1.0.0';

  // --- Servidor principal --------------------------------------------------
  static const String serverHost = '217.77.9.210';
  static const int serverPort = 7009;
  static const String address = '$serverHost:$serverPort';

  /// Cada cuánto se vuelve a consultar el servidor mientras la app está abierta.
  static const Duration refreshInterval = Duration(seconds: 30);

  // --- Enlaces (null = aún no configurado) ---------------------------------
  // Ejemplo: 'https://discord.gg/xxxxxxx'
  static const String? discordUrl = null;
  static const String? websiteUrl = null;
}
