/// Única fuente de verdad para los datos de marca y del servidor.
abstract class AppConfig {
  // --- Marca ---------------------------------------------------------------
  static const String serverName = 'Valdoria';
  static const String serverSuffix = 'RP';
  static const String tagline = 'Roleplay hispano · San Andreas Multiplayer';

  /// Mantener sincronizado con `version:` de pubspec.yaml.
  static const String appVersion = '1.0.0';

  // --- Servidor principal --------------------------------------------------
  // Se conservan los datos de conexión existentes.
  static const String serverHost = '217.77.9.210';
  static const int serverPort = 7009;
  static const String address = '$serverHost:$serverPort';

  /// Cada cuánto se vuelve a consultar el servidor mientras la app está abierta.
  static const Duration refreshInterval = Duration(seconds: 30);

  // --- Enlaces (null = aún no configurado) ---------------------------------
  static const String? discordUrl = null;
  static const String? websiteUrl = null;
}
