/// Configuración declarativa que define el comportamiento y defaults del wizard
/// según el tipo de trabajador: CAMPO vs OFICINA (Opción C).
class RrhhHireTypeConfig {
  final String type; // 'CAMPO' | 'OFICINA'
  final String defaultContractType;
  final List<String> contractTypeOptions;
  final String defaultPaymentModality;
  final List<String> paymentModalityOptions;
  final String defaultScheduleType;
  final List<Map<String, String>> scheduleOptions;
  final bool isSpecialtyRequired;
  final bool isFelccStrictlyRequired;
  final int totalBaseDocs;
  final String roleBadgeText;
  final String successSubtitle;

  const RrhhHireTypeConfig({
    required this.type,
    required this.defaultContractType,
    required this.contractTypeOptions,
    required this.defaultPaymentModality,
    required this.paymentModalityOptions,
    required this.defaultScheduleType,
    required this.scheduleOptions,
    required this.isSpecialtyRequired,
    required this.isFelccStrictlyRequired,
    required this.totalBaseDocs,
    required this.roleBadgeText,
    required this.successSubtitle,
  });

  static const campo = RrhhHireTypeConfig(
    type: 'CAMPO',
    defaultContractType: 'Plazo Fijo',
    contractTypeOptions: ['Plazo Fijo', 'Servicios', 'Indefinido'],
    defaultPaymentModality: 'JORNAL',
    paymentModalityOptions: ['JORNAL', 'POR_HORAS', 'MENSUAL'],
    defaultScheduleType: 'TIEMPO_COMPLETO_48H',
    scheduleOptions: [
      {'value': 'TIEMPO_COMPLETO_48H', 'label': 'Operativa 48h (Campo)'},
      {'value': 'TURNOS_ROTATIVOS', 'label': 'Mixta / Rotativa'},
      {'value': 'ADMINISTRATIVA_40H', 'label': 'Administrativa (Base)'},
    ],
    isSpecialtyRequired: true,
    isFelccStrictlyRequired: true,
    totalBaseDocs: 6,
    roleBadgeText: 'Personal de Campo',
    successSubtitle: 'Colaborador de Campo ingresado a nómina operativa',
  );

  static const oficina = RrhhHireTypeConfig(
    type: 'OFICINA',
    defaultContractType: 'Indefinido',
    contractTypeOptions: ['Indefinido', 'Plazo Fijo', 'Servicios'],
    defaultPaymentModality: 'MENSUAL',
    paymentModalityOptions: ['MENSUAL', 'JORNAL', 'POR_HORAS'],
    defaultScheduleType: 'ADMINISTRATIVA_40H',
    scheduleOptions: [
      {'value': 'ADMINISTRATIVA_40H', 'label': 'Administrativa 40h'},
      {'value': 'TIEMPO_COMPLETO_48H', 'label': 'Administrativa 48h'},
      {'value': 'TURNOS_ROTATIVOS', 'label': 'Mixta / Flexible'},
    ],
    isSpecialtyRequired: false,
    isFelccStrictlyRequired: false,
    totalBaseDocs: 5,
    roleBadgeText: 'Personal de Oficina',
    successSubtitle: 'Colaborador Administrativo ingresado a nómina',
  );

  static RrhhHireTypeConfig forType(String type) {
    return type == 'OFICINA' ? oficina : campo;
  }
}
