/// Anchos estandarizados y adaptables para las columnas de la tabla de Personal.
class RrhhTableWidths {
  final double codigo;
  final double foto;
  final double nombre;
  final double tipo;
  final double areaCargo;
  final double especialidad;
  final double disponibilidad;
  final double expediente;
  final double acciones;

  const RrhhTableWidths({
    this.codigo = 100.0,
    this.foto = 50.0,
    this.nombre = 220.0,
    this.tipo = 90.0,
    this.areaCargo = 210.0,
    this.especialidad = 150.0,
    this.disponibilidad = 140.0,
    this.expediente = 80.0,
    this.acciones = 110.0,
  });

  double get total =>
      codigo +
      foto +
      nombre +
      tipo +
      areaCargo +
      especialidad +
      disponibilidad +
      expediente +
      acciones;

  static RrhhTableWidths calculate(double availableWidth) {
    const double minW = RrhhPersonalTableColumns.totalWidth; // 1150
    final double extra = availableWidth - 32 - minW;
    if (extra <= 0) {
      return const RrhhTableWidths();
    }
    return RrhhTableWidths(
      nombre: RrhhPersonalTableColumns.nombre + (extra * 0.40),
      areaCargo: RrhhPersonalTableColumns.areaCargo + (extra * 0.35),
      especialidad: RrhhPersonalTableColumns.especialidad + (extra * 0.25),
    );
  }
}

abstract class RrhhPersonalTableColumns {
  static const double codigo = 100.0;
  static const double foto = 50.0;
  static const double nombre = 220.0;
  static const double tipo = 90.0;
  static const double areaCargo = 210.0;
  static const double especialidad = 150.0;
  static const double disponibilidad = 140.0;
  static const double expediente = 80.0;
  static const double acciones = 110.0;

  static const double totalWidth =
      codigo +
      foto +
      nombre +
      tipo +
      areaCargo +
      especialidad +
      disponibilidad +
      expediente +
      acciones; // 1150.0
}
