import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'rrhh_payroll_exporter_stub.dart'
    if (dart.library.html) 'rrhh_payroll_exporter_web.dart';

/// Servicio de generación y exportación de la Planilla Oficial de Sueldos y Salarios
/// bajo la normativa del Ministerio de Trabajo / OVT y Contabilidad de Bolivia.
class RrhhPayrollExporter {
  /// Genera y descarga el archivo .xls en formato Microsoft Excel SpreadsheetML
  static void exportToExcel({
    required List<RrhhEmployee> employees,
    required String monthName,
    required int year,
    String companyName = 'ELITE MULTISERVICIOS',
    String nit = '4625505019',
    String representativeName = 'ROGELIO ARANDIA ARANDIA',
    String representativeCi = '4444455 OR',
    String legalCity = 'La Paz',
  }) {
    final xmlContent = generateSpreadsheetXml(
      employees: employees,
      monthName: monthName,
      year: year,
      companyName: companyName,
      nit: nit,
      representativeName: representativeName,
      representativeCi: representativeCi,
      legalCity: legalCity,
    );

    final cleanMonth = monthName.toUpperCase().replaceAll(' ', '_');
    final fileName = 'Planilla_Sueldos_Elite_${cleanMonth}_$year.xls';

    downloadFileWeb(
      xmlContent,
      fileName,
      'application/vnd.ms-excel;charset=utf-8',
    );
  }

  /// Calcula el porcentaje de Bono de Antigüedad según la escala de la Ley General del Trabajo de Bolivia (D.S. 21060).
  /// Base: 3 Salarios Mínimos Nacionales (SMN 2026 aprox. Bs. 2.500 x 3 = Bs. 7.500).
  static double calculateSeniorityBonus(
    DateTime startDate,
    DateTime referenceDate,
  ) {
    final diffDays = referenceDate.difference(startDate).inDays;
    final years = (diffDays / 365.25).floor();

    const threeSmn = 7500.0; // 3 Salarios Mínimos Nacionales en Bolivia

    double percentage = 0.0;
    if (years >= 25) {
      percentage = 0.50;
    } else if (years >= 20) {
      percentage = 0.42;
    } else if (years >= 15) {
      percentage = 0.34;
    } else if (years >= 11) {
      percentage = 0.26;
    } else if (years >= 8) {
      percentage = 0.18;
    } else if (years >= 5) {
      percentage = 0.11;
    } else if (years >= 2) {
      percentage = 0.05;
    }

    return threeSmn * percentage;
  }

  /// Deduce el sexo a partir de nombres comunes si no está explícito
  static String inferGender(String fullName) {
    final lower = fullName.trim().toLowerCase();
    final femaleNames = [
      'andrea',
      'mariana',
      'paola',
      'sara',
      'carla',
      'patricia',
      'maria',
      'lucia',
      'gabriela',
      'laura',
      'valeria',
      'camila',
      'natalia',
      'claudia',
      'daniela',
      'ana',
      'silvia',
      'belen',
      'victoria',
      'alejandra',
      'lorena',
    ];
    for (final name in femaleNames) {
      if (lower.contains(name)) return 'F';
    }
    return 'M';
  }

  /// Genera el contenido XML completo compatible con Microsoft Excel (SpreadsheetML 2003 / OpenOffice / LibreOffice)
  static String generateSpreadsheetXml({
    required List<RrhhEmployee> employees,
    required String monthName,
    required int year,
    required String companyName,
    required String nit,
    required String representativeName,
    required String representativeCi,
    required String legalCity,
  }) {
    final refDate = DateTime(year, _monthNumber(monthName), 28);
    final buffer = StringBuffer();

    // XML Declaration y encabezados Excel
    buffer.writeln('<?xml version="1.0" encoding="UTF-8"?>');
    buffer.writeln('<?mso-application progid="Excel.Sheet"?>');
    buffer.writeln(
      '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"',
    );
    buffer.writeln(' xmlns:o="urn:schemas-microsoft-com:office:office"');
    buffer.writeln(' xmlns:x="urn:schemas-microsoft-com:office:excel"');
    buffer.writeln(' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"');
    buffer.writeln(' xmlns:html="http://www.w3.org/TR/REC-html40">');

    // Estilos
    buffer.writeln(' <Styles>');
    buffer.writeln('  <Style ss:ID="Default" ss:Name="Normal">');
    buffer.writeln('   <Alignment ss:Vertical="Center"/>');
    buffer.writeln('   <Font ss:FontName="Calibri" ss:Size="10"/>');
    buffer.writeln('  </Style>');

    // Estilos de encabezado institucional
    buffer.writeln('  <Style ss:ID="sCompany">');
    buffer.writeln('   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>');
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="14" ss:Bold="1" ss:Color="#0F172A"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sNit">');
    buffer.writeln('   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>');
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="10" ss:Bold="1" ss:Color="#334155"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sTitle">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="13" ss:Bold="1" ss:Color="#0F172A"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sSubtitle">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="11" ss:Bold="1" ss:Color="#1E293B"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sExpresado">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="9" ss:Bold="1" ss:Color="#475569"/>',
    );
    buffer.writeln('  </Style>');

    // Estilos de tabla
    buffer.writeln('  <Style ss:ID="sH1">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center" ss:WrapText="1"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="8.5" ss:Bold="1"/>',
    );
    buffer.writeln('   <Interior ss:Color="#F8FAFC" ss:Pattern="Solid"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sDataLeft">');
    buffer.writeln('   <Alignment ss:Horizontal="Left" ss:Vertical="Center"/>');
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln('   <Font ss:FontName="Calibri" ss:Size="9"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sDataCenter">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln('   <Font ss:FontName="Calibri" ss:Size="9"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sDataNum">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln('   <Font ss:FontName="Calibri" ss:Size="9"/>');
    buffer.writeln('   <NumberFormat ss:Format="#,##0.00"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sDataInt">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#CBD5E1"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln('   <Font ss:FontName="Calibri" ss:Size="9"/>');
    buffer.writeln('   <NumberFormat ss:Format="0"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sTotalLabel">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="9.5" ss:Bold="1"/>',
    );
    buffer.writeln('   <Interior ss:Color="#F1F5F9" ss:Pattern="Solid"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sTotalNum">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',
    );
    buffer.writeln('   <Borders>');
    buffer.writeln(
      '    <Border ss:Position="Bottom" ss:LineStyle="Double" ss:Weight="3" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Left" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Right" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln(
      '    <Border ss:Position="Top" ss:LineStyle="Continuous" ss:Weight="1" ss:Color="#000000"/>',
    );
    buffer.writeln('   </Borders>');
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="9.5" ss:Bold="1"/>',
    );
    buffer.writeln('   <Interior ss:Color="#F1F5F9" ss:Pattern="Solid"/>');
    buffer.writeln('   <NumberFormat ss:Format="#,##0.00"/>');
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sFooterLine">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="9.5" ss:Bold="1"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sFooterText">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Center" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="8.5" ss:Bold="1" ss:Color="#334155"/>',
    );
    buffer.writeln('  </Style>');

    buffer.writeln('  <Style ss:ID="sFooterCity">');
    buffer.writeln(
      '   <Alignment ss:Horizontal="Right" ss:Vertical="Center"/>',
    );
    buffer.writeln(
      '   <Font ss:FontName="Calibri" ss:Size="9" ss:Italic="1" ss:Color="#475569"/>',
    );
    buffer.writeln('  </Style>');
    buffer.writeln(' </Styles>');

    // Hoja PSUELDOS (Nombre exacto de la plantilla oficial)
    buffer.writeln(' <Worksheet ss:Name="PSUELDOS">');
    buffer.writeln('  <Table ss:DefaultRowHeight="20">');

    // Definición de anchos de columnas
    buffer.writeln('   <Column ss:Index="1" ss:Width="30"/>'); // N O
    buffer.writeln('   <Column ss:Index="2" ss:Width="95"/>'); // CARNET
    buffer.writeln('   <Column ss:Index="3" ss:Width="200"/>'); // NOMBRE
    buffer.writeln('   <Column ss:Index="4" ss:Width="80"/>'); // NACIONALIDAD
    buffer.writeln(
      '   <Column ss:Index="5" ss:Width="85"/>',
    ); // FECHA NACIMIENTO
    buffer.writeln('   <Column ss:Index="6" ss:Width="45"/>'); // SEXO
    buffer.writeln('   <Column ss:Index="7" ss:Width="175"/>'); // OCUPACION
    buffer.writeln('   <Column ss:Index="8" ss:Width="85"/>'); // FECHA INGRESO
    buffer.writeln('   <Column ss:Index="9" ss:Width="80"/>'); // SUELDO BASICO
    buffer.writeln('   <Column ss:Index="10" ss:Width="50"/>'); // DIAS PAGADOS
    buffer.writeln('   <Column ss:Index="11" ss:Width="55"/>'); // HORAS/DIAS
    buffer.writeln(
      '   <Column ss:Index="12" ss:Width="85"/>',
    ); // SALARIO GANADO (A)
    buffer.writeln(
      '   <Column ss:Index="13" ss:Width="85"/>',
    ); // BONO ANTIGUEDAD (B)
    buffer.writeln('   <Column ss:Index="14" ss:Width="45"/>'); // H.E. CANT
    buffer.writeln(
      '   <Column ss:Index="15" ss:Width="75"/>',
    ); // H.E. MONTO (C)
    buffer.writeln(
      '   <Column ss:Index="16" ss:Width="75"/>',
    ); // BONO PRODUCCION (D)
    buffer.writeln(
      '   <Column ss:Index="17" ss:Width="70"/>',
    ); // DOMINICALES (E)
    buffer.writeln(
      '   <Column ss:Index="18" ss:Width="65"/>',
    ); // OTROS BONOS (F)
    buffer.writeln(
      '   <Column ss:Index="19" ss:Width="95"/>',
    ); // TOTAL GANADO (G)
    buffer.writeln(
      '   <Column ss:Index="20" ss:Width="85"/>',
    ); // RETENCION 12.71%
    buffer.writeln(
      '   <Column ss:Index="21" ss:Width="80"/>',
    ); // APORTE SOLIDARIO (I)
    buffer.writeln('   <Column ss:Index="22" ss:Width="75"/>'); // RC-IVA (J)
    buffer.writeln('   <Column ss:Index="23" ss:Width="85"/>'); // ANTICIPOS (K)
    buffer.writeln(
      '   <Column ss:Index="24" ss:Width="90"/>',
    ); // TOTAL DESCUENTOS (L)
    buffer.writeln(
      '   <Column ss:Index="25" ss:Width="95"/>',
    ); // LIQUIDO PAGABLE (LL)
    buffer.writeln('   <Column ss:Index="26" ss:Width="110"/>'); // FIRMA

    // Fila 1: ELITE MULTISERVICIOS
    buffer.writeln('   <Row ss:Index="1" ss:Height="24">');
    buffer.writeln(
      '    <Cell ss:StyleID="sCompany"><Data ss:Type="String">${_xmlEscape(companyName)}</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 2: NIT: 4625505019
    buffer.writeln('   <Row ss:Index="2" ss:Height="18">');
    buffer.writeln(
      '    <Cell ss:StyleID="sNit"><Data ss:Type="String">NIT: ${_xmlEscape(nit)}</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 5: PLANILLA DE SUELDOS Y SALARIOS (Centrado en columnas medias J a S)
    buffer.writeln('   <Row ss:Index="5" ss:Height="22">');
    buffer.writeln(
      '    <Cell ss:Index="10" ss:MergeAcross="9" ss:StyleID="sTitle"><Data ss:Type="String">PLANILLA DE SUELDOS Y SALARIOS</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 6: Correspondiente al mes: [MES] [AÑO]
    buffer.writeln('   <Row ss:Index="6" ss:Height="20">');
    buffer.writeln(
      '    <Cell ss:Index="10" ss:MergeAcross="9" ss:StyleID="sSubtitle"><Data ss:Type="String">Correspondiente al mes:   ${monthName.toUpperCase()}   $year</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 7: (EXPRESADO EN BOLIVIANOS)
    buffer.writeln('   <Row ss:Index="7" ss:Height="18">');
    buffer.writeln(
      '    <Cell ss:Index="10" ss:MergeAcross="9" ss:StyleID="sExpresado"><Data ss:Type="String">(EXPRESADO EN BOLIVIANOS)</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 9: Encabezados superiores con Merges
    buffer.writeln('   <Row ss:Index="9" ss:Height="28">');
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">N O</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">CARNET&#10;DE&#10;IDENTIDAD</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">NOMBRE DEL EMPLEADO</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">NACIONA&#10;LI-DAD</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">FECHA&#10;DE&#10;NACIMIEN&#10;TO</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">SEX&#10;O&#10;(F/M&#10;)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">OCUPACION QUE DESEMPEÑA</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">FECHA DE&#10;INGRESO</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">SUELDO&#10;BASICO</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">DIAS&#10;PAG&#10;ADOS&#10;MES</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">HOR&#10;AS/DI&#10;A&#10;PAG&#10;A-&#10;DAS</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">SALARI&#10;O&#10;GANAD&#10;O&#10;(A)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">BONO DE&#10;ANTIGÜEDA&#10;D (B)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeAcross="1" ss:StyleID="sH1"><Data ss:Type="String">HORAS EXTRAS</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeAcross="2" ss:StyleID="sH1"><Data ss:Type="String">OTROS BONOS</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">TOTAL&#10;GANADO&#10;(G)&#10;A+B+C+D+&#10;E+F</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeAcross="3" ss:StyleID="sH1"><Data ss:Type="String">DESCUENTOS</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">TOTAL&#10;DESCUENT&#10;OS&#10;(L)&#10;H+I+J+K</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">LIQUIDO&#10;PAGAB&#10;LE&#10;(LL)&#10;G-L</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:MergeDown="1" ss:StyleID="sH1"><Data ss:Type="String">FIRMA DEL&#10;EMPLEADO</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Fila 10: Sub-encabezados
    buffer.writeln('   <Row ss:Index="10" ss:Height="26">');
    buffer.writeln(
      '    <Cell ss:Index="14" ss:StyleID="sH1"><Data ss:Type="String">CAN&#10;T.</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="15" ss:StyleID="sH1"><Data ss:Type="String">MONTO&#10;PAGADO (C&#10;)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="16" ss:StyleID="sH1"><Data ss:Type="String">BONO DE&#10;PRODUCCI&#10;ON (D)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="17" ss:StyleID="sH1"><Data ss:Type="String">DOMINI&#10;CALES&#10;(E )</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="18" ss:StyleID="sH1"><Data ss:Type="String">OTRO&#10;S&#10;BON&#10;OS (&#10;F)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="20" ss:StyleID="sH1"><Data ss:Type="String">RETENCI&#10;ON 12.71&#10;%</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="21" ss:StyleID="sH1"><Data ss:Type="String">APOR&#10;TE&#10;NACI&#10;ONAL&#10;SOLID&#10;ARIO&#10;(I)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="22" ss:StyleID="sH1"><Data ss:Type="String">RC-&#10;IVA&#10;13 %&#10;(J)</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="23" ss:StyleID="sH1"><Data ss:Type="String">ANTICIPO&#10;Y OTROS&#10;DESCUENT&#10;OS&#10;(K)</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Filas de datos
    int rowIndex = 11;
    for (int i = 0; i < employees.length; i++) {
      final emp = employees[i];
      final num = i + 1;
      final ci = emp.identityCard.isNotEmpty
          ? emp.identityCard
          : '${emp.code} SC';
      final name = emp.fullName.toUpperCase();
      final nationality = 'BOLIVIANA';
      final birthStr = emp.birthDate != null
          ? '${emp.birthDate!.day.toString().padLeft(2, "0")}/${emp.birthDate!.month.toString().padLeft(2, "0")}/${emp.birthDate!.year}'
          : '15/04/1992';
      final sex = inferGender(emp.fullName);
      final occupation = emp.position.isNotEmpty
          ? emp.position.toUpperCase()
          : emp.occupation.toUpperCase();
      final startDateStr =
          '${emp.fiscalStartDate.day.toString().padLeft(2, "0")}/${emp.fiscalStartDate.month.toString().padLeft(2, "0")}/${emp.fiscalStartDate.year}';

      final sueldoBasico = emp.agreedSalary ?? 0.0;
      const diasPagados = 30;
      const horasDias = 8;
      final salarioGanado = sueldoBasico; // Para 30 días
      final bonoAntiguedad = calculateSeniorityBonus(
        emp.fiscalStartDate,
        refDate,
      );
      const horasExtrasCant = 0;
      const horasExtrasMonto = 0.0;
      const bonoProduccion = 0.0;
      const dominicales = 0.0;
      const otrosBonos = 0.0;

      final totalGanado =
          salarioGanado +
          bonoAntiguedad +
          horasExtrasMonto +
          bonoProduccion +
          dominicales +
          otrosBonos;
      final retencion1271 = double.parse(
        (totalGanado * 0.1271).toStringAsFixed(2),
      );
      const aporteSolidario = 0.0;
      const rcIva = 0.0;
      const anticipos = 0.0;
      final totalDescuentos =
          retencion1271 + aporteSolidario + rcIva + anticipos;
      final liquidoPagable = totalGanado - totalDescuentos;

      buffer.writeln('   <Row ss:Index="$rowIndex" ss:Height="21">');
      // Col 1: N O
      buffer.writeln(
        '    <Cell ss:StyleID="sDataInt"><Data ss:Type="Number">$num</Data></Cell>',
      );
      // Col 2: CARNET
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String">${_xmlEscape(ci)}</Data></Cell>',
      );
      // Col 3: NOMBRE
      buffer.writeln(
        '    <Cell ss:StyleID="sDataLeft"><Data ss:Type="String">${_xmlEscape(name)}</Data></Cell>',
      );
      // Col 4: NACIONALIDAD
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String">$nationality</Data></Cell>',
      );
      // Col 5: FECHA NACIMIENTO
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String">$birthStr</Data></Cell>',
      );
      // Col 6: SEXO
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String">$sex</Data></Cell>',
      );
      // Col 7: OCUPACION
      buffer.writeln(
        '    <Cell ss:StyleID="sDataLeft"><Data ss:Type="String">${_xmlEscape(occupation)}</Data></Cell>',
      );
      // Col 8: FECHA INGRESO
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String">$startDateStr</Data></Cell>',
      );
      // Col 9: SUELDO BASICO
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${sueldoBasico.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 10: DIAS PAGADOS
      buffer.writeln(
        '    <Cell ss:StyleID="sDataInt"><Data ss:Type="Number">$diasPagados</Data></Cell>',
      );
      // Col 11: HORAS/DIAS
      buffer.writeln(
        '    <Cell ss:StyleID="sDataInt"><Data ss:Type="Number">$horasDias</Data></Cell>',
      );
      // Col 12: SALARIO GANADO (A)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${salarioGanado.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 13: BONO ANTIGUEDAD (B)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${bonoAntiguedad.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 14: HE CANT
      buffer.writeln(
        '    <Cell ss:StyleID="sDataInt"><Data ss:Type="Number">$horasExtrasCant</Data></Cell>',
      );
      // Col 15: HE MONTO (C)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${horasExtrasMonto.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 16: BONO PROD (D)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${bonoProduccion.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 17: DOMINICALES (E)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${dominicales.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 18: OTROS BONOS (F)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${otrosBonos.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 19: TOTAL GANADO (G) [A+B+C+D+E+F]
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum" ss:Formula="=SUM(RC[-7]:RC[-1])"><Data ss:Type="Number">${totalGanado.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 20: RETENCION 12.71% (H)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum" ss:Formula="=ROUND(RC[-1]*0.1271,2)"><Data ss:Type="Number">${retencion1271.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 21: APORTE SOLIDARIO (I)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${aporteSolidario.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 22: RC-IVA (J)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${rcIva.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 23: ANTICIPOS (K)
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum"><Data ss:Type="Number">${anticipos.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 24: TOTAL DESCUENTOS (L) [H+I+J+K]
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum" ss:Formula="=SUM(RC[-4]:RC[-1])"><Data ss:Type="Number">${totalDescuentos.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 25: LIQUIDO PAGABLE (LL) [G-L]
      buffer.writeln(
        '    <Cell ss:StyleID="sDataNum" ss:Formula="=RC[-6]-RC[-1]"><Data ss:Type="Number">${liquidoPagable.toStringAsFixed(2)}</Data></Cell>',
      );
      // Col 26: FIRMA
      buffer.writeln(
        '    <Cell ss:StyleID="sDataCenter"><Data ss:Type="String"></Data></Cell>',
      );
      buffer.writeln('   </Row>');

      rowIndex++;
    }

    // Fila de Totales Generales
    final firstDataRow = 11;
    final lastDataRow = rowIndex - 1;
    final totalRow = rowIndex;

    buffer.writeln('   <Row ss:Index="$totalRow" ss:Height="24">');
    buffer.writeln(
      '    <Cell ss:Index="1" ss:MergeAcross="7" ss:StyleID="sTotalLabel"><Data ss:Type="String">TOTAL GENERAL</Data></Cell>',
    );
    // Col 9: Sueldo Básico
    buffer.writeln(
      '    <Cell ss:Index="9" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C9:R${lastDataRow}C9)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 10-11 vacíos
    buffer.writeln(
      '    <Cell ss:Index="10" ss:StyleID="sTotalLabel"><Data ss:Type="String"></Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="11" ss:StyleID="sTotalLabel"><Data ss:Type="String"></Data></Cell>',
    );
    // Col 12: Salario Ganado
    buffer.writeln(
      '    <Cell ss:Index="12" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C12:R${lastDataRow}C12)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 13: Bono Antigüedad
    buffer.writeln(
      '    <Cell ss:Index="13" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C13:R${lastDataRow}C13)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 14 vacío
    buffer.writeln(
      '    <Cell ss:Index="14" ss:StyleID="sTotalLabel"><Data ss:Type="String"></Data></Cell>',
    );
    // Col 15: Horas Extras Monto
    buffer.writeln(
      '    <Cell ss:Index="15" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C15:R${lastDataRow}C15)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 16: Bono Producción
    buffer.writeln(
      '    <Cell ss:Index="16" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C16:R${lastDataRow}C16)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 17: Dominicales
    buffer.writeln(
      '    <Cell ss:Index="17" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C17:R${lastDataRow}C17)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 18: Otros Bonos
    buffer.writeln(
      '    <Cell ss:Index="18" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C18:R${lastDataRow}C18)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 19: Total Ganado
    buffer.writeln(
      '    <Cell ss:Index="19" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C19:R${lastDataRow}C19)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 20: Retención 12.71%
    buffer.writeln(
      '    <Cell ss:Index="20" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C20:R${lastDataRow}C20)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 21: Aporte Solidario
    buffer.writeln(
      '    <Cell ss:Index="21" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C21:R${lastDataRow}C21)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 22: RC-IVA
    buffer.writeln(
      '    <Cell ss:Index="22" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C22:R${lastDataRow}C22)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 23: Anticipos
    buffer.writeln(
      '    <Cell ss:Index="23" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C23:R${lastDataRow}C23)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 24: Total Descuentos
    buffer.writeln(
      '    <Cell ss:Index="24" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C24:R${lastDataRow}C24)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 25: Líquido Pagable
    buffer.writeln(
      '    <Cell ss:Index="25" ss:StyleID="sTotalNum" ss:Formula="=SUM(R${firstDataRow}C25:R${lastDataRow}C25)"><Data ss:Type="Number">0.00</Data></Cell>',
    );
    // Col 26 vacío
    buffer.writeln(
      '    <Cell ss:Index="26" ss:StyleID="sTotalLabel"><Data ss:Type="String"></Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Bloque de Firma Oficial al pie (conforme a la foto del usuario)
    final lineRow = totalRow + 5;
    final labelRow = lineRow + 1;
    final valRow = labelRow + 1;

    // Líneas para firmar
    buffer.writeln('   <Row ss:Index="$lineRow" ss:Height="18">');
    buffer.writeln(
      '    <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="sFooterLine"><Data ss:Type="String">________________________________________</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="8" ss:MergeAcross="2" ss:StyleID="sFooterLine"><Data ss:Type="String">________________________________________</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="13" ss:MergeAcross="2" ss:StyleID="sFooterLine"><Data ss:Type="String">________________________________________</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Títulos de firma
    buffer.writeln('   <Row ss:Index="$labelRow" ss:Height="18">');
    buffer.writeln(
      '    <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="sFooterText"><Data ss:Type="String">NOMBRE DEL EMPLEADOR O REPRESENTANTE LEGAL</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="8" ss:MergeAcross="2" ss:StyleID="sFooterText"><Data ss:Type="String">NO. CARNET DE IDENTIDAD</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="13" ss:MergeAcross="2" ss:StyleID="sFooterText"><Data ss:Type="String">FIRMA</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    // Valores y fecha legal
    final now = DateTime.now();
    final dayNames = [
      'lunes',
      'martes',
      'miércoles',
      'jueves',
      'viernes',
      'sábado',
      'domingo',
    ];
    final monthNames = [
      'enero',
      'febrero',
      'marzo',
      'abril',
      'mayo',
      'junio',
      'julio',
      'agosto',
      'septiembre',
      'octubre',
      'noviembre',
      'diciembre',
    ];
    final dayName = dayNames[now.weekday - 1];
    final monthStr = monthNames[now.month - 1];
    final legalDateString =
        '$legalCity, $dayName, ${now.day} de $monthStr de ${now.year}';

    buffer.writeln('   <Row ss:Index="$valRow" ss:Height="20">');
    buffer.writeln(
      '    <Cell ss:Index="3" ss:MergeAcross="2" ss:StyleID="sFooterLine"><Data ss:Type="String">${_xmlEscape(representativeName)}</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="8" ss:MergeAcross="2" ss:StyleID="sFooterLine"><Data ss:Type="String">${_xmlEscape(representativeCi)}</Data></Cell>',
    );
    buffer.writeln(
      '    <Cell ss:Index="19" ss:MergeAcross="6" ss:StyleID="sFooterCity"><Data ss:Type="String">${_xmlEscape(legalDateString)}</Data></Cell>',
    );
    buffer.writeln('   </Row>');

    buffer.writeln('  </Table>');
    buffer.writeln(' </Worksheet>');
    buffer.writeln('</Workbook>');

    return buffer.toString();
  }

  static int _monthNumber(String monthName) {
    switch (monthName.toUpperCase().trim()) {
      case 'ENERO':
        return 1;
      case 'FEBRERO':
        return 2;
      case 'MARZO':
        return 3;
      case 'ABRIL':
        return 4;
      case 'MAYO':
        return 5;
      case 'JUNIO':
        return 6;
      case 'JULIO':
        return 7;
      case 'AGOSTO':
        return 8;
      case 'SEPTIEMBRE':
        return 9;
      case 'OCTUBRE':
        return 10;
      case 'NOVIEMBRE':
        return 11;
      case 'DICIEMBRE':
        return 12;
      default:
        return 9;
    }
  }

  static String _xmlEscape(String text) {
    return text
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&apos;');
  }
}
