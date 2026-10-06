/// Modelo de Turno de Trabajo reutilizable (Catálogo de Turnos de RRHH).
/// Representa un bloque horario concreto (ej: 08:00 a 16:00, Lun-Vie).
class RrhhShift {
  final int id;
  final String code; // TURNO-XXX
  final String name;
  final String startTime; // "HH:mm" (24h)
  final String endTime; // "HH:mm" (24h)
  final List<int> workDays; // 1=Lunes, 2=Martes, ..., 7=Domingo
  final String shiftType; // 'Completa', 'Parcial', 'Nocturna'
  final String? description;
  final bool isActive;
  final int assignedEmployeesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RrhhShift({
    required this.id,
    required this.code,
    required this.name,
    required this.startTime,
    required this.endTime,
    required this.workDays,
    required this.shiftType,
    this.description,
    this.isActive = true,
    this.assignedEmployeesCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Determina si el turno cruza la medianoche (ej: 22:00 a 06:00)
  bool get isCrossMidnight {
    final startMinutes = _timeToMinutes(startTime);
    final endMinutes = _timeToMinutes(endTime);
    return endMinutes <= startMinutes;
  }

  /// Calcula la duración diaria del turno en horas
  double get durationHours {
    final startMinutes = _timeToMinutes(startTime);
    final endMinutes = _timeToMinutes(endTime);
    int diff;
    if (endMinutes > startMinutes) {
      diff = endMinutes - startMinutes;
    } else {
      diff = (24 * 60 - startMinutes) + endMinutes;
    }
    return diff / 60.0;
  }

  /// Horas semanales totales generadas por este turno
  double get weeklyHours => durationHours * workDays.length;

  /// Rango horario formateado (ej: "08:00 - 16:00")
  String get formattedTimeRange => '$startTime - $endTime';

  /// Resumen textual de días (ej: "Lun - Vie" o "L, M, X, J, V")
  String get daysSummary {
    if (workDays.isEmpty) return 'Sin días';
    final sorted = List<int>.from(workDays)..sort();
    if (sorted.length == 5 && sorted.first == 1 && sorted.last == 5) {
      return 'Lun - Vie';
    }
    if (sorted.length == 6 && sorted.first == 1 && sorted.last == 6) {
      return 'Lun - Sáb';
    }
    if (sorted.length == 2 && sorted.contains(6) && sorted.contains(7)) {
      return 'Sáb - Dom';
    }
    const dayNames = {
      1: 'Lun',
      2: 'Mar',
      3: 'Mié',
      4: 'Jue',
      5: 'Vie',
      6: 'Sáb',
      7: 'Dom',
    };
    return sorted.map((d) => dayNames[d] ?? '$d').join(', ');
  }

  RrhhShift copyWith({
    int? id,
    String? code,
    String? name,
    String? startTime,
    String? endTime,
    List<int>? workDays,
    String? shiftType,
    String? description,
    bool? isActive,
    int? assignedEmployeesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhShift(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      workDays: workDays ?? this.workDays,
      shiftType: shiftType ?? this.shiftType,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      assignedEmployeesCount:
          assignedEmployeesCount ?? this.assignedEmployeesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    if (parts.length < 2) return 0;
    final h = int.tryParse(parts[0]) ?? 0;
    final m = int.tryParse(parts[1]) ?? 0;
    return (h * 60) + m;
  }
}

/// Asignación de un turno específico a un día de la semana dentro de un Horario Base.
class RrhhScheduleShiftDay {
  final String shiftCode;
  final String shiftName;
  final int dayOfWeek; // 1=Lun, ..., 7=Dom

  const RrhhScheduleShiftDay({
    required this.shiftCode,
    required this.shiftName,
    required this.dayOfWeek,
  });

  Map<String, dynamic> toJson() => {
    'shiftCode': shiftCode,
    'shiftName': shiftName,
    'dayOfWeek': dayOfWeek,
  };

  factory RrhhScheduleShiftDay.fromJson(Map<String, dynamic> json) =>
      RrhhScheduleShiftDay(
        shiftCode: json['shiftCode'] as String,
        shiftName: json['shiftName'] as String,
        dayOfWeek: json['dayOfWeek'] as int,
      );
}

/// Modelo de Horario Base (Plantilla semanal que combina turnos).
class RrhhBaseSchedule {
  final int id;
  final String code; // HORARIO-XXX
  final String name;
  final List<String> includedShiftCodes; // Códigos de turnos incluidos
  final List<RrhhScheduleShiftDay> shiftDays; // Mapeo de día a turno
  final String workerType; // 'CAMPO', 'OFICINA', 'Ambos'
  final double totalWeeklyHours;
  final String? description;
  final bool isActive;
  final int assignedEmployeesCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RrhhBaseSchedule({
    required this.id,
    required this.code,
    required this.name,
    required this.includedShiftCodes,
    this.shiftDays = const [],
    required this.workerType,
    required this.totalWeeklyHours,
    this.description,
    this.isActive = true,
    this.assignedEmployeesCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  RrhhBaseSchedule copyWith({
    int? id,
    String? code,
    String? name,
    List<String>? includedShiftCodes,
    List<RrhhScheduleShiftDay>? shiftDays,
    String? workerType,
    double? totalWeeklyHours,
    String? description,
    bool? isActive,
    int? assignedEmployeesCount,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhBaseSchedule(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      includedShiftCodes: includedShiftCodes ?? this.includedShiftCodes,
      shiftDays: shiftDays ?? this.shiftDays,
      workerType: workerType ?? this.workerType,
      totalWeeklyHours: totalWeeklyHours ?? this.totalWeeklyHours,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      assignedEmployeesCount:
          assignedEmployeesCount ?? this.assignedEmployeesCount,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
