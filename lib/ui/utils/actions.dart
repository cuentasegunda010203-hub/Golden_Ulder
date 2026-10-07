import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Acciones de UI reutilizables (avisos, portapapeles, enlaces externos).

void showAppSnack(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

Future<void> copyText(
  BuildContext context,
  String text, {
  String message = 'Copiado al portapapeles',
}) async {
  final messenger = ScaffoldMessenger.of(context);
  await Clipboard.setData(ClipboardData(text: text));
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

/// Abre [url] fuera de la app. Si no está configurada (null) avisa al usuario.
Future<void> openLink(BuildContext context, String? url) async {
  final messenger = ScaffoldMessenger.of(context);

  void notify(String message) {
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  if (url == null) {
    notify('Este enlace aún no está configurado');
    return;
  }

  try {
    final opened = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!opened) notify('No se pudo abrir el enlace');
  } catch (_) {
    notify('No se pudo abrir el enlace');
  }
}
