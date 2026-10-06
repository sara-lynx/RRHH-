// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html;

/// Actualiza el hash de la URL en el navegador sin recargar la página.
void setBrowserHash(String hash) {
  try {
    final cleanHash = hash.startsWith('#') ? hash : '#$hash';
    if (html.window.location.hash != cleanHash) {
      html.window.history.pushState(null, '', cleanHash);
    }
  } catch (_) {}
}

/// Obtiene el hash actual de la URL en el navegador.
String getBrowserHash() {
  try {
    return html.window.location.hash;
  } catch (_) {
    return '';
  }
}

/// Escucha eventos de navegación hacia adelante/atrás en el navegador.
void listenBrowserHashChange(void Function(String hash) onHashChange) {
  try {
    html.window.onPopState.listen((_) {
      onHashChange(html.window.location.hash);
    });
    html.window.onHashChange.listen((_) {
      onHashChange(html.window.location.hash);
    });
  } catch (_) {}
}
