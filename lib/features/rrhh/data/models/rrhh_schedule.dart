import 'package:flutter/material.dart';

/// Horario o turno de trabajo definido por RRHH
class RrhhWorkSchedule {
  final String id;
  final String
  name; // Ej: 'Administrativo Central', 'Turno Mañana Operativo', 'Turno Nocturno Seguridad'
  final String employeeTypeScope; // 'OFICINA', 'CAMPO', 'MIXTO'
  final List<String>
  workingDays; // ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado']
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int gracePeriodMinutes; // Tolerancia en minutos
  final int totalWeeklyHours;
  final bool isRotative;
  final String observations;
  final bool isActive;

  const RrhhWorkSchedule({
    required this.id,
    required this.name,
    required this.employeeTypeScope,
    required this.workingDays,
    required this.startTime,
    required this.endTime,
    this.gracePeriodMinutes = 10,
    required this.totalWeeklyHours,
    this.isRotative = false,
    required this.observations,
    this.isActive = true,
  });

  String get appliesTo => employeeTypeScope;
  List<String> get daysOfWeek => workingDays;
  bool get isNightShift =>
      startTime.hour >= 20 || startTime.hour < 5 || endTime.hour < 7;
  String get formattedStartTime =>
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
  String get formattedEndTime =>
      '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

  String get formattedTimeRange {
    final startStr =
        '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')}';
    final endStr =
        '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';
    return '$startStr - $endStr';
  }

  String get formattedDaysSummary {
    if (workingDays.length == 5 &&
        workingDays.first == 'Lunes' &&
        workingDays.last == 'Viernes') {
      return 'Lunes a Viernes';
    }
    if (workingDays.length == 6 &&
        workingDays.first == 'Lunes' &&
        workingDays.last == 'Sábado') {
      return 'Lunes a Sábado';
    }
    return workingDays.join(', ');
  }
}
