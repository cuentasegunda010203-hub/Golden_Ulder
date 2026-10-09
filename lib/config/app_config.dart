/// Única fuente de verdad para los datos de marca, cliente y servidor.
abstract class AppConfig {
  // Marca
  static const String serverName = 'Golden Underworld';
  static const String serverSuffix = 'RP';
  static const String tagline = 'Servidor de rol · San Andreas Multiplayer';
  static const String appVersion = '1.0.0';

  // Servidor principal
  static const String serverHost = '217.77.9.210';
  static const int serverPort = 7009;
  static const String address = '$serverHost:$serverPort';
  static const Duration refreshInterval = Duration(seconds: 30);

  // Enlaces de comunidad (null = no configurado).
  static const String? discordUrl = null;
  static const String? websiteUrl = null;

  /// URL HTTPS del APK del cliente SA-MP Android.
  ///
  /// Debe apuntar a una publicación de confianza. Se deja null hasta que se
  /// confirme la distribución oficial; así no se ofrece un APK desconocido.
  static const String? clientApkUrl = null;
}
