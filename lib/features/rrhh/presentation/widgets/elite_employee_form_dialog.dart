import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/models/elite_rrhh_models.dart';
import '../providers/elite_rrhh_providers.dart';

/// Diálogo modal corporativo para el alta de un nuevo colaborador.
class EliteEmployeeFormDialog extends ConsumerStatefulWidget {
  const EliteEmployeeFormDialog({super.key});

  static Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const EliteEmployeeFormDialog(),
    );
  }

  @override
  ConsumerState<EliteEmployeeFormDialog> createState() =>
      _EliteEmployeeFormDialogState();
}

class _EliteEmployeeFormDialogState
    extends ConsumerState<EliteEmployeeFormDialog> {
  final _formKey = GlobalKey<FormState>();

  final _ciController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _positionController = TextEditingController();
  final _siteController = TextEditingController(text: 'Condominio Las Palmas');
  final _salaryController = TextEditingController(text: '2800');

  EmployeeWorkplaceType _workplaceType = EmployeeWorkplaceType.campo;
  String _costCenter = EliteCostCenter.seg;
  ContractType _contractType = ContractType.indefinido;

  bool _hasSketch = true;
  bool _hasFelcc = true;
  bool _hasSus = true;

  @override
  void dispose() {
    _ciController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _positionController.dispose();
    _siteController.dispose();
    _salaryController.dispose();
    super.dispose();
  }

  void _onWorkplaceTypeChanged(EmployeeWorkplaceType type) {
    setState(() {
      _workplaceType = type;
      if (type == EmployeeWorkplaceType.oficina) {
        _siteController.text = 'Sede Central';
        _costCenter = EliteCostCenter.adm;
        if (_positionController.text.isEmpty ||
            _positionController.text == 'Guardia de Seguridad') {
          _positionController.text = 'Auxiliar Administrativo';
        }
      } else {
        _siteController.text = 'Condominio Las Palmas';
        _costCenter = EliteCostCenter.seg;
        if (_positionController.text == 'Auxiliar Administrativo') {
          _positionController.text = 'Guardia de Seguridad';
        }
      }
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final id =
        'EMP-${(ref.read(rrhhEmployeesProvider).length + 1).toString().padLeft(3, '0')}';
    final hasPendingDocs = !_hasSketch || !_hasFelcc || !_hasSus;

    final newEmployee = EliteEmployee(
      id: id,
      ci: _ciController.text.trim(),
      fullName: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      email: _emailController.text.trim(),
      workplaceType: _workplaceType,
      serviceLineCode: _costCenter,
      position: _positionController.text.trim(),
      assignedSite: _workplaceType == EmployeeWorkplaceType.oficina
          ? 'Sede Central'
          : _siteController.text.trim(),
      contractType: _contractType,
      hireDate: DateTime.now(),
      contractEndDate: _contractType == ContractType.plazoFijo
          ? DateTime.now().add(const Duration(days: 90))
          : null,
      baseSalary: double.tryParse(_salaryController.text.trim()) ?? 2500.0,
      hasPendingLegalDocs: hasPendingDocs,
      status: EmployeeStatus.activo,
    );

    ref.read(rrhhEmployeesProvider.notifier).addEmployee(newEmployee);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        backgroundColor: const Color(0xFF0D9488),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        content: Text(
          'Colaborador ${newEmployee.fullName} ($id) registrado exitosamente.',
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Column(
          children: [
            // Header modal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFCCFBF1)),
                    ),
                    alignment: Alignment.center,
                    child: const Icon(
                      Icons.person_add_outlined,
                      size: 18,
                      color: Color(0xFF0D9488),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nuevo Colaborador',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          'Alta en nómina y estructura operativa de Elite Multiservicios S.R.L.',
                          style: GoogleFonts.inter(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 20, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Formulario scrolleable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Selector de Clasificación (Oficina / Campo)
                      Text(
                        'CLASIFICACIÓN LABORAL',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTypePill(
                              type: EmployeeWorkplaceType.campo,
                              title: 'Personal de Campo',
                              subtitle: 'Operativo en sedes y clientes',
                              icon: Icons.engineering_outlined,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTypePill(
                              type: EmployeeWorkplaceType.oficina,
                              title: 'Personal de Oficina',
                              subtitle: 'Administración y soporte central',
                              icon: Icons.apartment_outlined,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 2. Datos personales
                      Text(
                        'DATOS PERSONALES',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: _buildTextField(
                              controller: _ciController,
                              label: 'C.I. / Expedido',
                              hint: 'Ej: 5938210 LP',
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 6,
                            child: _buildTextField(
                              controller: _nameController,
                              label: 'Nombre Completo',
                              hint: 'Nombres y Apellidos',
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _phoneController,
                              label: 'Teléfono / WhatsApp',
                              hint: 'Ej: 71234567',
                              keyboardType: TextInputType.phone,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: _emailController,
                              label: 'Correo Electrónico',
                              hint: 'nombre@elite.bo',
                              keyboardType: TextInputType.emailAddress,
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 3. Asignación y Puesto
                      Text(
                        'ASIGNACIÓN Y CENTRO DE COSTO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField<String>(
                              label: 'Centro de Costo',
                              value: _costCenter,
                              items: EliteCostCenter.all.map((cc) {
                                return DropdownMenuItem(
                                  value: cc,
                                  child: Text(
                                    EliteCostCenter.getLabel(cc),
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) =>
                                  setState(() => _costCenter = v ?? _costCenter),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: _positionController,
                              label: 'Cargo / Posición',
                              hint: _workplaceType == EmployeeWorkplaceType.campo
                                  ? 'Ej: Guardia de Seguridad'
                                  : 'Ej: Asistente Administrativo',
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      _buildTextField(
                        controller: _siteController,
                        label: _workplaceType == EmployeeWorkplaceType.oficina
                            ? 'Ubicación Física'
                            : 'Cliente / Sede Asignada',
                        hint: 'Nombre del condominio, mall o planta',
                        readOnly:
                            _workplaceType == EmployeeWorkplaceType.oficina,
                        validator: (v) =>
                            v?.isEmpty ?? true ? 'Requerido' : null,
                      ),
                      const SizedBox(height: 16),

                      // 4. Condiciones Contractuales
                      Text(
                        'CONDICIONES CONTRACTUALES Y SALARIO',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: _buildDropdownField<ContractType>(
                              label: 'Tipo de Contrato',
                              value: _contractType,
                              items: ContractType.values.map((ct) {
                                return DropdownMenuItem(
                                  value: ct,
                                  child: Text(
                                    ct.label,
                                    style: GoogleFonts.inter(fontSize: 12),
                                  ),
                                );
                              }).toList(),
                              onChanged: (v) => setState(
                                  () => _contractType = v ?? _contractType),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildTextField(
                              controller: _salaryController,
                              label: 'Salario Base (Bs)',
                              hint: '2500',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (v) =>
                                  v?.isEmpty ?? true ? 'Requerido' : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // 5. Checklist legal boliviano
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CHECKLIST LEGAL INICIAL (LEGAJO)',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF475569),
                              ),
                            ),
                            const SizedBox(height: 6),
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                'Croquis de Domicilio y Factura Básica (Luz/Agua)',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              value: _hasSketch,
                              activeColor: const Color(0xFF0D9488),
                              onChanged: (v) =>
                                  setState(() => _hasSketch = v ?? true),
                            ),
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                'Certificado de Antecedentes FELCC / FELCN',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              value: _hasFelcc,
                              activeColor: const Color(0xFF0D9488),
                              onChanged: (v) =>
                                  setState(() => _hasFelcc = v ?? true),
                            ),
                            CheckboxListTile(
                              dense: true,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                'Constancia de Seguro SUS / Caja de Salud',
                                style: GoogleFonts.inter(fontSize: 12),
                              ),
                              value: _hasSus,
                              activeColor: const Color(0xFF0D9488),
                              onChanged: (v) =>
                                  setState(() => _hasSus = v ?? true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer modal con botones
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xFFE2E8F0)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF64748B),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                    ),
                    child: Text(
                      'Cancelar',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D9488),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(Icons.check, size: 16),
                    label: Text(
                      'Registrar Colaborador',
                      style: GoogleFonts.inter(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypePill({
    required EmployeeWorkplaceType type,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final isSelected = _workplaceType == type;
    final color = type == EmployeeWorkplaceType.oficina
        ? const Color(0xFF2563EB)
        : const Color(0xFF0D9488);

    return InkWell(
      onTap: () => _onWorkplaceTypeChanged(type),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isSelected
              ? (type == EmployeeWorkplaceType.oficina
                  ? const Color(0xFFEFF6FF)
                  : const Color(0xFFF0FDFA))
              : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2E8F0),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? color : const Color(0xFF64748B),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w600,
                      color: isSelected ? color : const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    bool readOnly = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          validator: validator,
          readOnly: readOnly,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF94A3B8)),
            isDense: true,
            filled: true,
            fillColor: readOnly ? const Color(0xFFF1F5F9) : Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<T>(
          initialValue: value,
          items: items,
          onChanged: onChanged,
          style: GoogleFonts.inter(fontSize: 12.5, color: const Color(0xFF0F172A)),
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Color(0xFF0D9488), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
