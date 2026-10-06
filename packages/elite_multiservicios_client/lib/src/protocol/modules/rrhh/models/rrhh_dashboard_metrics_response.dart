/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Métricas agregadas y KPIs ejecutivos del Dashboard de Recursos Humanos.
abstract class RrhhDashboardMetricsResponse implements _i1.SerializableModel {
  RrhhDashboardMetricsResponse._({
    required this.activeEmployeesCount,
    required this.totalEmployeesCount,
    required this.fieldEmployeesCount,
    required this.officeEmployeesCount,
    required this.pendingApplicantsCount,
    required this.selectedApplicantsCount,
    required this.completeFilesCount,
    required this.pendingFilesCount,
    required this.expedientesPercentage,
    required this.expiringContractsCount,
    required this.activeLeavesCount,
    required this.todayAttendanceRate,
    required this.todayIncidentsCount,
  });

  factory RrhhDashboardMetricsResponse({
    required int activeEmployeesCount,
    required int totalEmployeesCount,
    required int fieldEmployeesCount,
    required int officeEmployeesCount,
    required int pendingApplicantsCount,
    required int selectedApplicantsCount,
    required int completeFilesCount,
    required int pendingFilesCount,
    required double expedientesPercentage,
    required int expiringContractsCount,
    required int activeLeavesCount,
    required double todayAttendanceRate,
    required int todayIncidentsCount,
  }) = _RrhhDashboardMetricsResponseImpl;

  factory RrhhDashboardMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhDashboardMetricsResponse(
      activeEmployeesCount: jsonSerialization['activeEmployeesCount'] as int,
      totalEmployeesCount: jsonSerialization['totalEmployeesCount'] as int,
      fieldEmployeesCount: jsonSerialization['fieldEmployeesCount'] as int,
      officeEmployeesCount: jsonSerialization['officeEmployeesCount'] as int,
      pendingApplicantsCount:
          jsonSerialization['pendingApplicantsCount'] as int,
      selectedApplicantsCount:
          jsonSerialization['selectedApplicantsCount'] as int,
      completeFilesCount: jsonSerialization['completeFilesCount'] as int,
      pendingFilesCount: jsonSerialization['pendingFilesCount'] as int,
      expedientesPercentage: (jsonSerialization['expedientesPercentage'] as num)
          .toDouble(),
      expiringContractsCount:
          jsonSerialization['expiringContractsCount'] as int,
      activeLeavesCount: jsonSerialization['activeLeavesCount'] as int,
      todayAttendanceRate: (jsonSerialization['todayAttendanceRate'] as num)
          .toDouble(),
      todayIncidentsCount: jsonSerialization['todayIncidentsCount'] as int,
    );
  }

  /// Total de personal activo en planilla.
  int activeEmployeesCount;

  /// Total histórico de empleados registrados.
  int totalEmployeesCount;

  /// Personal desplegado y asignado en sedes de clientes (Campo).
  int fieldEmployeesCount;

  /// Personal administrativo en sede central (Oficina).
  int officeEmployeesCount;

  /// Postulantes activos en proceso de evaluación.
  int pendingApplicantsCount;

  /// Postulantes seleccionados listos para contrato.
  int selectedApplicantsCount;

  /// Cantidad de expedientes con los 6 documentos físicos completos.
  int completeFilesCount;

  /// Cantidad de expedientes con documentos pendientes en legajo.
  int pendingFilesCount;

  /// Porcentaje de cumplimiento global de expedientes físicos (0.0 - 100.0).
  double expedientesPercentage;

  /// Contratos a plazo fijo con vencimiento próximo en los siguientes 30 días.
  int expiringContractsCount;

  /// Colaboradores con permisos, licencias o vacaciones activas hoy.
  int activeLeavesCount;

  /// Tasa de asistencia del día en campo reportada por APK (0.0 - 100.0).
  double todayAttendanceRate;

  /// Incidencias operativas reportadas durante la jornada de hoy.
  int todayIncidentsCount;

  /// Returns a shallow copy of this [RrhhDashboardMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhDashboardMetricsResponse copyWith({
    int? activeEmployeesCount,
    int? totalEmployeesCount,
    int? fieldEmployeesCount,
    int? officeEmployeesCount,
    int? pendingApplicantsCount,
    int? selectedApplicantsCount,
    int? completeFilesCount,
    int? pendingFilesCount,
    double? expedientesPercentage,
    int? expiringContractsCount,
    int? activeLeavesCount,
    double? todayAttendanceRate,
    int? todayIncidentsCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhDashboardMetricsResponse',
      'activeEmployeesCount': activeEmployeesCount,
      'totalEmployeesCount': totalEmployeesCount,
      'fieldEmployeesCount': fieldEmployeesCount,
      'officeEmployeesCount': officeEmployeesCount,
      'pendingApplicantsCount': pendingApplicantsCount,
      'selectedApplicantsCount': selectedApplicantsCount,
      'completeFilesCount': completeFilesCount,
      'pendingFilesCount': pendingFilesCount,
      'expedientesPercentage': expedientesPercentage,
      'expiringContractsCount': expiringContractsCount,
      'activeLeavesCount': activeLeavesCount,
      'todayAttendanceRate': todayAttendanceRate,
      'todayIncidentsCount': todayIncidentsCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _RrhhDashboardMetricsResponseImpl extends RrhhDashboardMetricsResponse {
  _RrhhDashboardMetricsResponseImpl({
    required int activeEmployeesCount,
    required int totalEmployeesCount,
    required int fieldEmployeesCount,
    required int officeEmployeesCount,
    required int pendingApplicantsCount,
    required int selectedApplicantsCount,
    required int completeFilesCount,
    required int pendingFilesCount,
    required double expedientesPercentage,
    required int expiringContractsCount,
    required int activeLeavesCount,
    required double todayAttendanceRate,
    required int todayIncidentsCount,
  }) : super._(
         activeEmployeesCount: activeEmployeesCount,
         totalEmployeesCount: totalEmployeesCount,
         fieldEmployeesCount: fieldEmployeesCount,
         officeEmployeesCount: officeEmployeesCount,
         pendingApplicantsCount: pendingApplicantsCount,
         selectedApplicantsCount: selectedApplicantsCount,
         completeFilesCount: completeFilesCount,
         pendingFilesCount: pendingFilesCount,
         expedientesPercentage: expedientesPercentage,
         expiringContractsCount: expiringContractsCount,
         activeLeavesCount: activeLeavesCount,
         todayAttendanceRate: todayAttendanceRate,
         todayIncidentsCount: todayIncidentsCount,
       );

  /// Returns a shallow copy of this [RrhhDashboardMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhDashboardMetricsResponse copyWith({
    int? activeEmployeesCount,
    int? totalEmployeesCount,
    int? fieldEmployeesCount,
    int? officeEmployeesCount,
    int? pendingApplicantsCount,
    int? selectedApplicantsCount,
    int? completeFilesCount,
    int? pendingFilesCount,
    double? expedientesPercentage,
    int? expiringContractsCount,
    int? activeLeavesCount,
    double? todayAttendanceRate,
    int? todayIncidentsCount,
  }) {
    return RrhhDashboardMetricsResponse(
      activeEmployeesCount: activeEmployeesCount ?? this.activeEmployeesCount,
      totalEmployeesCount: totalEmployeesCount ?? this.totalEmployeesCount,
      fieldEmployeesCount: fieldEmployeesCount ?? this.fieldEmployeesCount,
      officeEmployeesCount: officeEmployeesCount ?? this.officeEmployeesCount,
      pendingApplicantsCount:
          pendingApplicantsCount ?? this.pendingApplicantsCount,
      selectedApplicantsCount:
          selectedApplicantsCount ?? this.selectedApplicantsCount,
      completeFilesCount: completeFilesCount ?? this.completeFilesCount,
      pendingFilesCount: pendingFilesCount ?? this.pendingFilesCount,
      expedientesPercentage:
          expedientesPercentage ?? this.expedientesPercentage,
      expiringContractsCount:
          expiringContractsCount ?? this.expiringContractsCount,
      activeLeavesCount: activeLeavesCount ?? this.activeLeavesCount,
      todayAttendanceRate: todayAttendanceRate ?? this.todayAttendanceRate,
      todayIncidentsCount: todayIncidentsCount ?? this.todayIncidentsCount,
    );
  }
}
