import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import '../repositories/rrhh_repository.dart';

/// Servicio cliente tipado para el Módulo de Recursos Humanos (RRHH).
/// Enruta las llamadas a través de RrhhRepository para preservar las reglas R1 y R2.
class RrhhApiService {
  static final RrhhApiService _instance = RrhhApiService._internal();
  factory RrhhApiService({Client? client}) {
    return _instance;
  }

  RrhhApiService._internal();

  /// Obtiene las métricas y KPIs consolidados del Dashboard de RRHH.
  Future<RrhhDashboardMetricsResponse> getDashboardMetrics() async {
    return RrhhRepository.current.getDashboardMetrics();
  }

  /// Obtiene la lista de movimientos y novedades laborales recientes.
  Future<List<RrhhRecentMovementDto>> getRecentMovements({
    int limit = 10,
  }) async {
    return RrhhRepository.current.getRecentMovements();
  }
}
