import 'dart:async';
import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart';
import '../../../../main.dart' as main_app;
import '../domain/exceptions/auth_exception.dart';
import 'security_api_service.dart';

/// Servicio reactivo para orquestar la autenticación de usuarios, gestión de tokens JWT
/// y auditoría server-side de cierre de sesión en Elite Multiservicios.
class AuthService extends ChangeNotifier {
  static const _trustedDeviceKey = 'trusted_device_token';
  static const _rememberMeKey = 'remember_me_preference';
  static const _rememberedEmailKey = 'remembered_email';
  final _secureStorage = const FlutterSecureStorage();

  bool _isMfaPending = false;
  bool get isMfaPending => _isMfaPending;

  bool _isSessionMfaVerified = false;
  bool get isSessionMfaVerified => _isSessionMfaVerified;

  bool _isCheckingMfa = false;
  bool get isCheckingMfa => _isCheckingMfa;

  bool _currentRememberMe = false;
  bool get currentRememberMe => _currentRememberMe;

  MfaChallengeResponse? _currentMfaChallenge;
  MfaChallengeResponse? get currentMfaChallenge => _currentMfaChallenge;

  Future<MfaChallengeResponse?>? _inFlightCheckMfa;

  void markSessionMfaVerified() {
    _isSessionMfaVerified = true;
    _isMfaPending = false;
    _currentMfaChallenge = null;
    notifyListeners();
  }

  void setMfaPending(
    MfaChallengeResponse? challenge, {
    bool rememberMe = false,
    bool notify = true,
  }) {
    _currentMfaChallenge = challenge;
    _isMfaPending = challenge != null;
    _currentRememberMe = rememberMe;
    if (notify) notifyListeners();
  }

  void clearMfaPending() {
    _currentMfaChallenge = null;
    _isMfaPending = false;
    notifyListeners();
  }

  /// Maneja excepciones del cliente Serverpod (HTTP 401, 403, etc.):
  /// - 401 con código MFA_REQUIRED: marca MFA como pendiente y redirige al flujo de 2FA.
  /// - 401 (sin MFA o token inválido): cierra la sesión y redirige al login.
  /// - 403 (FORBIDDEN): muestra mensaje de permisos insuficientes.
  void handleServerError(Object error, {BuildContext? context}) {
    if (error is ServerpodClientException) {
      final msg = error.message.toLowerCase();
      final isMfaRequired = msg.contains('mfa_required') || msg.contains('mfa');

      if (error.statusCode == 401) {
        if (isMfaRequired) {
          _isSessionMfaVerified = false;
          _isMfaPending = true;
          notifyListeners();
        } else {
          logout();
        }
      } else if (error.statusCode == 403) {
        if (context != null && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Acceso denegado: permisos insuficientes.'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  final Client _client;
  final SecurityApiService _securityApi;

  AuthService({
    Client? client,
    SecurityApiService? securityApi,
  }) : _client = client ?? main_app.client,
       _securityApi = securityApi ?? SecurityApiService() {
    if (_client.authKeyProvider == null) {
      _client.authSessionManager = FlutterAuthSessionManager();
    }
    // Suscribirse a cambios reactivos de autenticación en Serverpod
    _client.auth.authInfoListenable.addListener(_onAuthChanged);
    _initUserEmail();
  }

  Future<void> _initUserEmail() async {
    try {
      final savedEmail = await _secureStorage.read(key: _rememberedEmailKey);
      if (savedEmail != null && savedEmail.isNotEmpty) {
        _currentUserEmail = savedEmail;
        notifyListeners();
      }
    } catch (_) {}
  }

  void _onAuthChanged() {
    notifyListeners();
  }

  /// Indica si existe una sesión activa y autenticada.
  bool get isAuthenticated =>
      _client.authKeyProvider != null && _client.auth.isAuthenticated;

  /// Retorna los metadatos de sesión y tokens JWT del usuario autenticado actual.
  AuthSuccess? get currentAuthInfo =>
      _client.authKeyProvider != null ? _client.auth.authInfo : null;

  /// Alias de conveniencia para pruebas y vistas que consultan el usuario activo.
  AuthSuccess? get currentUser => currentAuthInfo;

  String? _currentUserEmail;

  /// Correo electrónico del usuario actualmente autenticado.
  String? get currentUserEmail => _currentUserEmail;

  /// Nombre o identificador legible para presentar en la interfaz de usuario.
  String? get currentDisplayName {
    if (currentAuthInfo == null && _currentUserEmail == null) return null;
    final email = _currentUserEmail?.trim().toLowerCase();
    if (email == 'rogeliovladimir2016@gmail.com') {
      return 'Super Administrador';
    }
    return 'Administrador';
  }

  /// Acceso al servicio de API de seguridad y RBAC.
  SecurityApiService get securityApi => _securityApi;

  /// Inicia sesión con credenciales corporativas mediante emailIdp de Serverpod.
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isCheckingMfa = true;
    _currentRememberMe = rememberMe;
    _isSessionMfaVerified = false;
    _currentUserEmail = email.trim();
    try {
      final authSuccess = await _client.emailIdp.login(
        email: email.trim(),
        password: password,
      );

      // Actualizar el session manager con los tokens JWT y credenciales recibidas
      await _client.auth.updateSignedInUser(authSuccess);

      // Registrar sesión en base de datos para auditoría y monitoreo
      try {
        await _client.sessionManagement.registerSession(
          mfaVerified: false,
        );
      } catch (e) {
        if (kDebugMode) {
          print('Error registrando sesión: $e');
        }
      }

      // Verificar inmediatamente si MFA es requerido para este usuario con política Fail-Closed
      final mfaChallenge = await checkMfaRequired(
        rememberMe: rememberMe,
        notify: false,
      );
      if (mfaChallenge != null) {
        setMfaPending(mfaChallenge, rememberMe: rememberMe, notify: false);
      } else {
        clearMfaPending();
      }

      await saveRememberMePreference(
        rememberMe: rememberMe,
        email: email,
      );

      return true;
    } catch (e) {
      clearMfaPending();
      try {
        await _client.auth.signOutDevice();
      } catch (signOutError) {
        if (kDebugMode) {
          print(
            '[AuthService] Error no bloqueante al purgar dispositivo tras fallo de login: $signOutError',
          );
        }
      }
      if (kDebugMode) {
        print('Error en login: $e');
      }
      rethrow;
    } finally {
      _isCheckingMfa = false;
      notifyListeners();
    }
  }

  /// Paso 1: Inicia la solicitud de recuperación. Envía un código por email.
  /// Retorna el `passwordResetRequestId` para los siguientes pasos.
  Future<UuidValue> startPasswordReset(String email) async {
    return await _client.emailIdp.startPasswordReset(email: email.trim());
  }

  /// Paso 2: Verifica el código de 8 dígitos recibido por email.
  /// Retorna el `finishPasswordResetToken` que autoriza el cambio.
  Future<String> verifyPasswordResetCode({
    required UuidValue passwordResetRequestId,
    required String verificationCode,
  }) async {
    return await _client.emailIdp.verifyPasswordResetCode(
      passwordResetRequestId: passwordResetRequestId,
      verificationCode: verificationCode.trim(),
    );
  }

  /// Paso 3: Aplica la nueva contraseña.
  Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) async {
    await _client.emailIdp.finishPasswordReset(
      finishPasswordResetToken: finishPasswordResetToken,
      newPassword: newPassword,
    );
  }

  /// Obtiene el AppUser asociado a la sesión actual.
  Future<AppUser> getCurrentUser() async {
    return await _client.user.getCurrentUser();
  }

  /// Cambia la contraseña del usuario autenticado.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _client.user.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  /// Comprueba si la sesión activa del usuario actual ya está verificada con MFA en PostgreSQL.
  Future<bool> isCurrentSessionMfaVerified() async {
    if (_isSessionMfaVerified) return true;
    try {
      final verified = await _client.mfa.isSessionVerified();
      if (verified) {
        _isSessionMfaVerified = true;
      }
      return verified;
    } catch (e) {
      if (kDebugMode) {
        print('[AuthService] Error comprobando sesión MFA: $e');
      }
      return false;
    }
  }

  /// Clasifica si una excepción corresponde a un fallo transitorio de red.
  bool _isTransientError(Object error) {
    if (error is TimeoutException) {
      return true;
    }
    final errStr = error.toString().toLowerCase();
    return errStr.contains('socketexception') ||
        errStr.contains('connection') ||
        errStr.contains('timeout') ||
        errStr.contains('network') ||
        errStr.contains('closed') ||
        errStr.contains('clientexception') ||
        errStr.contains('failed host lookup') ||
        errStr.contains('xmlhttprequest') ||
        errStr.contains('handshake') ||
        errStr.contains('aborted');
  }

  /// Ejecuta `checkRequired` con hasta [maxAttempts] reintentos y retroceso exponencial
  /// ante fallos de conectividad transitorios.
  Future<MfaChallengeResponse?> _checkMfaWithRetry({
    required bool rememberMe,
    int maxAttempts = 3,
  }) async {
    Object? lastError;
    StackTrace? lastStackTrace;

    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final trustedToken = await getTrustedDeviceToken();
        return await _client.mfa.checkRequired(
          rememberMe: rememberMe,
          trustedDeviceToken: trustedToken,
        );
      } catch (e, stackTrace) {
        lastError = e;
        lastStackTrace = stackTrace;
        final isTransient = _isTransientError(e);

        if (kDebugMode) {
          print(
            '[AuthService] Intento $attempt/$maxAttempts de checkRequired falló (transitorio=$isTransient): $e',
          );
        }

        if (attempt < maxAttempts && isTransient) {
          final delayMs = 500 * (1 << (attempt - 1)); // 500ms, 1000ms
          await Future.delayed(Duration(milliseconds: delayMs));
        } else {
          break;
        }
      }
    }

    if (lastError != null) {
      Error.throwWithStackTrace(
        lastError,
        lastStackTrace ?? StackTrace.current,
      );
    }
    return null;
  }

  /// Verifica si el usuario autenticado requiere MFA aplicando política Fail-Closed.
  /// Si sí, retorna el challenge. Si no, retorna null.
  /// Ante cualquier fallo no recuperable, purga la sesión local y lanza [AuthException].
  /// Deduplica llamadas concurrentes para evitar colisiones en red o desafíos duplicados.
  Future<MfaChallengeResponse?> checkMfaRequired({
    required bool rememberMe,
    bool notify = true,
  }) async {
    if (_inFlightCheckMfa != null) {
      return await _inFlightCheckMfa!;
    }
    final future = _executeCheckMfa(rememberMe: rememberMe, notify: notify);
    _inFlightCheckMfa = future;
    try {
      return await future;
    } finally {
      _inFlightCheckMfa = null;
    }
  }

  Future<MfaChallengeResponse?> _executeCheckMfa({
    required bool rememberMe,
    bool notify = true,
  }) async {
    _isCheckingMfa = true;
    if (notify) notifyListeners();
    try {
      final challenge = await _checkMfaWithRetry(rememberMe: rememberMe);
      if (challenge != null) {
        _currentMfaChallenge = challenge;
        _isMfaPending = true;
        _currentRememberMe = rememberMe;
      } else {
        _currentMfaChallenge = null;
        _isMfaPending = false;
      }
      return challenge;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print(
          '[AuthService] Fallo definitivo al verificar MFA: $e\n$stackTrace',
        );
      }
      clearMfaPending();

      // Purga preventiva no bloqueante de sesión local para garantizar Fail-Closed
      try {
        await _client.auth.signOutDevice();
      } catch (signOutError) {
        if (kDebugMode) {
          print(
            '[AuthService] Error no bloqueante al purgar dispositivo tras fallo MFA: $signOutError',
          );
        }
      }

      if (_isTransientError(e)) {
        throw AuthException(
          'No se pudo verificar la seguridad de su sesión debido a un problema de conexión. Por favor, verifique su red e intente nuevamente.',
          code: 'NETWORK_ERROR',
          details: e,
        );
      } else {
        throw AuthException(
          'Error al validar la seguridad de la cuenta. Por favor intente más tarde.',
          code: 'SECURITY_CHECK_FAILED',
          details: e,
        );
      }
    } finally {
      _isCheckingMfa = false;
      if (notify) notifyListeners();
    }
  }

  /// Verifica el código MFA.
  Future<MfaVerifyResponse> verifyMfa({
    required String challengeId,
    required String code,
    required bool rememberMe,
  }) async {
    final response = await _client.mfa.verifyMfa(
      challengeId: challengeId,
      code: code,
      rememberMe: rememberMe,
    );
    if (response.success) {
      _isSessionMfaVerified = true;
      clearMfaPending();
    }
    // Si el backend devolvió un trustedDeviceToken, guardarlo
    if (response.trustedDeviceToken != null) {
      await saveTrustedDeviceToken(response.trustedDeviceToken!);
    }
    return response;
  }

  /// Reenvía un nuevo código MFA.
  Future<void> resendMfaCode({required String challengeId}) async {
    await _client.mfa.resendMfaCode(challengeId: challengeId);
  }

  /// Guarda el token de dispositivo de confianza.
  Future<void> saveTrustedDeviceToken(String token) async {
    try {
      await _secureStorage.write(key: _trustedDeviceKey, value: token);
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando trusted device token: $e');
      }
    }
  }

  /// Lee el token de dispositivo de confianza.
  Future<String?> getTrustedDeviceToken() async {
    try {
      return await _secureStorage.read(key: _trustedDeviceKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error leyendo trusted device token: $e');
      }
      return null;
    }
  }

  /// Elimina el token de dispositivo de confianza.
  Future<void> clearTrustedDeviceToken() async {
    try {
      await _secureStorage.delete(key: _trustedDeviceKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error eliminando trusted device token: $e');
      }
    }
  }

  /// Retorna si el usuario tenía activada la preferencia 'Recordarme'.
  Future<bool> getRememberMePreference() async {
    try {
      final val = await _secureStorage.read(key: _rememberMeKey);
      return val == 'true';
    } catch (_) {
      return false;
    }
  }

  /// Retorna el correo recordado si existiera.
  Future<String?> getRememberedEmail() async {
    try {
      return await _secureStorage.read(key: _rememberedEmailKey);
    } catch (_) {
      return null;
    }
  }

  /// Guarda o elimina la preferencia 'Recordarme' y el correo recordado.
  Future<void> saveRememberMePreference({
    required bool rememberMe,
    String? email,
  }) async {
    try {
      if (rememberMe) {
        await _secureStorage.write(key: _rememberMeKey, value: 'true');
        if (email != null && email.trim().isNotEmpty) {
          await _secureStorage.write(
            key: _rememberedEmailKey,
            value: email.trim(),
          );
        }
      } else {
        await _secureStorage.delete(key: _rememberMeKey);
        await _secureStorage.delete(key: _rememberedEmailKey);
        await clearTrustedDeviceToken();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error guardando preferencia rememberMe: $e');
      }
    }
  }

  /// Flujo de Logout Server-Side auditado:
  /// 1. Revoca la sesión en base de datos y registra el evento LOGOUT en el servidor.
  /// 2. Purga los tokens JWT locales de almacenamiento seguro mediante client.auth.signOutDevice().
  Future<void> logout({int? activeSessionId}) async {
    _isSessionMfaVerified = false;
    clearMfaPending();
    try {
      // 1. Intentar revocar en el servidor (best-effort)
      try {
        await _client.sessionManagement.logout();
      } catch (e) {
        if (kDebugMode) {
          print('Error revocando sesión en servidor: $e');
        }
        // Continuar con la purga local aunque falle la red
      }
    } finally {
      // 2. Purgar tokens locales
      await _client.auth.signOutDevice();
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _client.auth.authInfoListenable.removeListener(_onAuthChanged);
    super.dispose();
  }
}
