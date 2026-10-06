// NOTE(DTO): pendiente de reemplazar por modelo Serverpod cuando el backend lo exponga.

/// DTO de corte laboral mensual consolidado por RRHH para entrega formal a Contabilidad (PDF Sección 6.1).
/// NO liquida pagos bancarios ni genera asientos contables.
class RrhhPayrollExportDto {
  final int employeeId;
  final String employeeCode;
  final String fullName;
  final String identityCard;
  final String contractType;
  final double baseSalary;
  final int daysWorked;
  final double authorizedBonuses;
  final double authorizedDeductions;
  final String notes;

  const RrhhPayrollExportDto({
    required this.employeeId,
    required this.employeeCode,
    required this.fullName,
    required this.identityCard,
    required this.contractType,
    required this.baseSalary,
    required this.daysWorked,
    required this.authorizedBonuses,
    required this.authorizedDeductions,
    this.notes = 'Normal',
  });

  double get netEstimatedTotal =>
      baseSalary + authorizedBonuses - authorizedDeductions;
}
