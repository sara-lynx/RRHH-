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

/// Métricas agregadas de la agenda comercial y compromisos.
abstract class CrmAgendaMetricsResponse implements _i1.SerializableModel {
  CrmAgendaMetricsResponse._({
    required this.totalTasks,
    required this.pendingTasksCount,
    required this.completedTasksCount,
    required this.todayTasksCount,
    required this.overdueTasksCount,
    required this.thisWeekTasksCount,
  });

  factory CrmAgendaMetricsResponse({
    required int totalTasks,
    required int pendingTasksCount,
    required int completedTasksCount,
    required int todayTasksCount,
    required int overdueTasksCount,
    required int thisWeekTasksCount,
  }) = _CrmAgendaMetricsResponseImpl;

  factory CrmAgendaMetricsResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return CrmAgendaMetricsResponse(
      totalTasks: jsonSerialization['totalTasks'] as int,
      pendingTasksCount: jsonSerialization['pendingTasksCount'] as int,
      completedTasksCount: jsonSerialization['completedTasksCount'] as int,
      todayTasksCount: jsonSerialization['todayTasksCount'] as int,
      overdueTasksCount: jsonSerialization['overdueTasksCount'] as int,
      thisWeekTasksCount: jsonSerialization['thisWeekTasksCount'] as int,
    );
  }

  /// Total de tareas registradas.
  int totalTasks;

  /// Tareas pendientes activas.
  int pendingTasksCount;

  /// Tareas marcadas como completadas.
  int completedTasksCount;

  /// Tareas programadas para el día de hoy.
  int todayTasksCount;

  /// Tareas vencidas sin completar.
  int overdueTasksCount;

  /// Tareas programadas para la semana actual.
  int thisWeekTasksCount;

  /// Returns a shallow copy of this [CrmAgendaMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  CrmAgendaMetricsResponse copyWith({
    int? totalTasks,
    int? pendingTasksCount,
    int? completedTasksCount,
    int? todayTasksCount,
    int? overdueTasksCount,
    int? thisWeekTasksCount,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CrmAgendaMetricsResponse',
      'totalTasks': totalTasks,
      'pendingTasksCount': pendingTasksCount,
      'completedTasksCount': completedTasksCount,
      'todayTasksCount': todayTasksCount,
      'overdueTasksCount': overdueTasksCount,
      'thisWeekTasksCount': thisWeekTasksCount,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _CrmAgendaMetricsResponseImpl extends CrmAgendaMetricsResponse {
  _CrmAgendaMetricsResponseImpl({
    required int totalTasks,
    required int pendingTasksCount,
    required int completedTasksCount,
    required int todayTasksCount,
    required int overdueTasksCount,
    required int thisWeekTasksCount,
  }) : super._(
         totalTasks: totalTasks,
         pendingTasksCount: pendingTasksCount,
         completedTasksCount: completedTasksCount,
         todayTasksCount: todayTasksCount,
         overdueTasksCount: overdueTasksCount,
         thisWeekTasksCount: thisWeekTasksCount,
       );

  /// Returns a shallow copy of this [CrmAgendaMetricsResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  CrmAgendaMetricsResponse copyWith({
    int? totalTasks,
    int? pendingTasksCount,
    int? completedTasksCount,
    int? todayTasksCount,
    int? overdueTasksCount,
    int? thisWeekTasksCount,
  }) {
    return CrmAgendaMetricsResponse(
      totalTasks: totalTasks ?? this.totalTasks,
      pendingTasksCount: pendingTasksCount ?? this.pendingTasksCount,
      completedTasksCount: completedTasksCount ?? this.completedTasksCount,
      todayTasksCount: todayTasksCount ?? this.todayTasksCount,
      overdueTasksCount: overdueTasksCount ?? this.overdueTasksCount,
      thisWeekTasksCount: thisWeekTasksCount ?? this.thisWeekTasksCount,
    );
  }
}
