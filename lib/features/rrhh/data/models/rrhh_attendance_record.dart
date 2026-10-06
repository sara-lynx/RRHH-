import 'package:flutter/material.dart';

/// Estados normalizados para el control de asistencia de campo.
class RrhhAttendanceStatus {
  static const String presente = 'presente';
  static const String tarde = 'tarde';
  static const String ausente = 'ausente';
  static const String justificado = 'justificado';
}

/// Registro consolidado de asistencia de campo (Pantalla 13 — Bloque 4).
///
/// Entidad de solo lectura para RRHH consumida desde el módulo de Operaciones/APK.
class RrhhAttendanceRecord {
  final int id;
  final String code; // 'ASI-001', 'ASI-002', ...
  final int employeeId;
  final String employeeCode; // Snapshot EMP-XXX
  final String employeeName; // Snapshot
  final DateTime date; // Fecha de la jornada
  final String clientName; // Cliente (ej: Kolping Bolivia)
  final String serviceName; // Servicio (ej: Seguridad Física)
  final String location; // Sede/ubicación (ej: Central)

  // Horas programadas
  final TimeOfDay scheduledEntry;
  final TimeOfDay scheduledExit;

  // Horas reales
  final TimeOfDay? actualEntry;
  final TimeOfDay? actualExit;

  // Cálculos
  final double? workedHours; // Calculado
  final int? lateMinutes; // Minutos de tardanza

  // Estado ('presente' | 'tarde' | 'ausente' | 'justificado')
  final String status;

  // Ubicación
  final double? latitude;
  final double? longitude;

  // Evidencias
  final String? evidencePhoto;

  // Incidencias / Observaciones
  final String? incidents;

  // Auditoría (proviene de Operaciones)
  final DateTime createdAt;
  final String createdBy; // "Operaciones/APK"

  const RrhhAttendanceRecord({
    required this.id,
    required this.code,
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.date,
    required this.clientName,
    required this.serviceName,
    required this.location,
    required this.scheduledEntry,
    required this.scheduledExit,
    this.actualEntry,
    this.actualExit,
    this.workedHours,
    this.lateMinutes,
    required this.status,
    this.latitude,
    this.longitude,
    this.evidencePhoto,
    this.incidents,
    required this.createdAt,
    this.createdBy = 'Operaciones/APK',
  });

  bool get isPresent => status == RrhhAttendanceStatus.presente;
  bool get isLate =>
      status == RrhhAttendanceStatus.tarde ||
      (lateMinutes != null && lateMinutes! > 0);
  bool get isAbsent => status == RrhhAttendanceStatus.ausente;
  bool get isJustified => status == RrhhAttendanceStatus.justificado;

  RrhhAttendanceRecord copyWith({
    int? id,
    String? code,
    int? employeeId,
    String? employeeCode,
    String? employeeName,
    DateTime? date,
    String? clientName,
    String? serviceName,
    String? location,
    TimeOfDay? scheduledEntry,
    TimeOfDay? scheduledExit,
    TimeOfDay? actualEntry,
    TimeOfDay? actualExit,
    double? workedHours,
    int? lateMinutes,
    String? status,
    double? latitude,
    double? longitude,
    String? evidencePhoto,
    String? incidents,
    DateTime? createdAt,
    String? createdBy,
  }) {
    return RrhhAttendanceRecord(
      id: id ?? this.id,
      code: code ?? this.code,
      employeeId: employeeId ?? this.employeeId,
      employeeCode: employeeCode ?? this.employeeCode,
      employeeName: employeeName ?? this.employeeName,
      date: date ?? this.date,
      clientName: clientName ?? this.clientName,
      serviceName: serviceName ?? this.serviceName,
      location: location ?? this.location,
      scheduledEntry: scheduledEntry ?? this.scheduledEntry,
      scheduledExit: scheduledExit ?? this.scheduledExit,
      actualEntry: actualEntry ?? this.actualEntry,
      actualExit: actualExit ?? this.actualExit,
      workedHours: workedHours ?? this.workedHours,
      lateMinutes: lateMinutes ?? this.lateMinutes,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      evidencePhoto: evidencePhoto ?? this.evidencePhoto,
      incidents: incidents ?? this.incidents,
      createdAt: createdAt ?? this.createdAt,
      createdBy: createdBy ?? this.createdBy,
    );
  }
}
