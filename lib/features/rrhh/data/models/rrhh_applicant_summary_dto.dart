// NOTE(DTO): pendiente de reemplazar por modelo Serverpod cuando el backend lo exponga.

/// DTO ligero para listados y embudo Kanban de postulantes y reclutamiento.
/// Protege datos sensibles (pretensión salarial, CI, contacto de emergencia).
class RrhhApplicantSummaryDto {
  final int id;
  final String code; // POST-001
  final String fullName;
  final String targetType; // 'OFICINA' | 'CAMPO'
  final String targetPosition;
  final String specialty;
  final String
  status; // 'NUEVO' | 'EN_EVALUACION' | 'SELECCIONADO' | 'RECHAZADO' | 'CONTRATADO'
  final DateTime applicationDate;
  final bool hasCv;

  const RrhhApplicantSummaryDto({
    required this.id,
    required this.code,
    required this.fullName,
    required this.targetType,
    required this.targetPosition,
    required this.specialty,
    required this.status,
    required this.applicationDate,
    required this.hasCv,
  });

  bool get isSelected => status.toUpperCase() == 'SELECCIONADO';
  bool get isRejected => status.toUpperCase() == 'RECHAZADO';

  RrhhApplicantSummaryDto copyWith({
    int? id,
    String? code,
    String? fullName,
    String? targetType,
    String? targetPosition,
    String? specialty,
    String? status,
    DateTime? applicationDate,
    bool? hasCv,
  }) {
    return RrhhApplicantSummaryDto(
      id: id ?? this.id,
      code: code ?? this.code,
      fullName: fullName ?? this.fullName,
      targetType: targetType ?? this.targetType,
      targetPosition: targetPosition ?? this.targetPosition,
      specialty: specialty ?? this.specialty,
      status: status ?? this.status,
      applicationDate: applicationDate ?? this.applicationDate,
      hasCv: hasCv ?? this.hasCv,
    );
  }
}
