// NOTE(DTO): pendiente de reemplazar por modelo Serverpod cuando el backend lo exponga.

/// DTO de solo lectura que consolida la realidad operativa de campo recibida de la APK de Operaciones (PDF Sección 4.3).
/// 100% Solo Lectura. RRHH NUNCA modifica marcaciones reales.
class OpsAttendanceSummaryDto {
  final int employeeId;
  final String employeeCode;
  final String employeeName;
  final String customerName;
  final String branchName;
  final DateTime workDate;
  final String scheduledCheckIn;
  final String? realCheckIn;
  final int delayMinutes;
  final String? scheduledCheckOut;
  final String? realCheckOut;
  final String status; // 'PUNTUAL' | 'ATRASO' | 'FALTA' | 'JUSTIFICADO'
  final double hoursWorked;

  const OpsAttendanceSummaryDto({
    required this.employeeId,
    required this.employeeCode,
    required this.employeeName,
    required this.customerName,
    required this.branchName,
    required this.workDate,
    required this.scheduledCheckIn,
    this.realCheckIn,
    this.delayMinutes = 0,
    this.scheduledCheckOut,
    this.realCheckOut,
    required this.status,
    this.hoursWorked = 8.0,
  });

  bool get isLate => delayMinutes > 0 || status == 'ATRASO';
  bool get isAbsent => status == 'FALTA';
  bool get isPunctual => status == 'PUNTUAL';
}
