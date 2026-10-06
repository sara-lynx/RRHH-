// NOTE(DTO): pendiente de reemplazar por modelo Serverpod cuando el backend lo exponga.

/// DTO ligero de referencia débil hacia cuentas y sedes comerciales administradas por el CRM.
/// RRHH solo lee esta información para contexto y vinculación; nunca crea clientes comerciales.
class CrmClientRefDto {
  final int customerId;
  final String companyName;
  final String workplaceBranch;
  final int contractId;
  final String? serviceName;

  const CrmClientRefDto({
    required this.customerId,
    required this.companyName,
    required this.workplaceBranch,
    required this.contractId,
    this.serviceName,
  });
}
