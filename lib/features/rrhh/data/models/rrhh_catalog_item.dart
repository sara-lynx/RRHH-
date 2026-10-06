/// Enumeración de los 7 catálogos auxiliares maestros de RRHH.
enum RrhhCatalogType {
  banks('Bancos', 'BANCO', 'Bancos e Instituciones Financieras'),
  afps('AFPs', 'AFP', 'Administradoras de Fondos de Pensiones / Gestora'),
  healthInsurances(
    'Seguros de Salud',
    'SEGURO',
    'Entidades de Seguridad Social y Seguros',
  ),
  contractTypes(
    'Tipos de Contrato',
    'CONTRATO',
    'Modalidades de Contratación Laboral',
  ),
  paymentModalities(
    'Modalidades de Pago',
    'PAGO',
    'Frecuencias y Esquemas de Liquidación',
  ),
  bonuses('Bonificaciones', 'BONO', 'Bonos, Primas y Asignaciones Salariales'),
  deductions(
    'Descuentos',
    'DESC',
    'Descuentos de Ley, Préstamos y Deducciones',
  );

  final String title;
  final String prefix;
  final String description;
  const RrhhCatalogType(this.title, this.prefix, this.description);
}

/// Modelo genérico y tipado para los elementos de catálogos maestros de RRHH.
class RrhhCatalogItem {
  final int id;
  final RrhhCatalogType catalogType;
  final String code; // BANCO-XXX, AFP-XXX, etc.
  final String name;
  final String? description;
  final String?
  subType; // Para Bonos: 'Fija mensual' | 'Por evento' | 'Variable'; Para Descuentos: 'Fijo' | 'Porcentaje' | 'Por evento'
  final double? defaultAmount; // Para Bonificaciones
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RrhhCatalogItem({
    required this.id,
    required this.catalogType,
    required this.code,
    required this.name,
    this.description,
    this.subType,
    this.defaultAmount,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  RrhhCatalogItem copyWith({
    int? id,
    RrhhCatalogType? catalogType,
    String? code,
    String? name,
    String? description,
    String? subType,
    double? defaultAmount,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhCatalogItem(
      id: id ?? this.id,
      catalogType: catalogType ?? this.catalogType,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      subType: subType ?? this.subType,
      defaultAmount: defaultAmount ?? this.defaultAmount,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
