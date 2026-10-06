import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../security/services/auth_service.dart';
import '../../data/models/rrhh_catalog_item.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_snack_bar.dart';

/// Modal para la edición de datos MUTABLES del colaborador (Feature 1).
/// No permite alterar campos contractuales (éstos se gestionan con Modificar Datos Contractuales).
class RrhhEditEmployeeDialog extends StatefulWidget {
  final RrhhEmployee employee;

  const RrhhEditEmployeeDialog({
    super.key,
    required this.employee,
  });

  static Future<bool?> show(BuildContext context, RrhhEmployee employee) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhEditEmployeeDialog(employee: employee),
    );
  }

  @override
  State<RrhhEditEmployeeDialog> createState() => _RrhhEditEmployeeDialogState();
}

class _RrhhEditEmployeeDialogState extends State<RrhhEditEmployeeDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  bool _isLoadingCatalogs = true;

  // Catálogos
  List<RrhhCatalogItem> _afps = [];
  List<RrhhCatalogItem> _healthInsurances = [];
  List<RrhhCatalogItem> _banks = [];

  // Controladores Bloque A: Datos Personales
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _addressController;
  String? _maritalStatus;
  late final TextEditingController _childrenCountController;

  // Controladores Bloque B: Contacto de Emergencia
  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  String? _emergencyRelation;

  // Controladores Bloque C: Seguridad Social
  String? _selectedAfpName;
  late final TextEditingController _afpNumberController;
  String? _selectedHealthInsurance;

  // Controladores Bloque D: Datos Bancarios
  String? _selectedBankName;
  String _accountType = 'Ahorro';
  late final TextEditingController _accountNumberController;

  // Controladores Bloque E: Notas Internas
  late final TextEditingController _notesController;

  final List<String> _maritalStatusOptions = [
    'Soltero',
    'Casado',
    'Divorciado',
    'Viudo',
    'Unión Libre',
  ];

  final List<String> _relationOptions = [
    'Cónyuge',
    'Madre',
    'Padre',
    'Hermano/a',
    'Hijo/a',
    'Tío/a',
    'Abuelo/a',
    'Amigo/a',
    'Otro',
  ];

  final List<String> _accountTypeOptions = [
    'Ahorro',
    'Corriente',
  ];

  @override
  void initState() {
    super.initState();
    final emp = widget.employee;

    // Inicializar Bloque A
    _phoneController = TextEditingController(text: emp.phone);
    _emailController = TextEditingController(text: emp.corporateEmail ?? '');
    _addressController = TextEditingController(
      text: emp.fullAddress ?? emp.address,
    );
    _maritalStatus = emp.maritalStatus;
    _childrenCountController = TextEditingController(
      text: emp.childrenCount != null ? emp.childrenCount.toString() : '',
    );

    // Inicializar Bloque B
    _emergencyNameController = TextEditingController(
      text: emp.emergencyContactName ?? '',
    );
    _emergencyPhoneController = TextEditingController(
      text: emp.emergencyContactPhone ?? '',
    );
    _emergencyRelation = emp.emergencyContactRelation;

    // Inicializar Bloque C
    _selectedAfpName = emp.afpName;
    _afpNumberController = TextEditingController(text: emp.afpNumber ?? '');
    _selectedHealthInsurance = emp.healthInsurance;

    // Inicializar Bloque D
    _selectedBankName = emp.bankName;
    _accountType =
        (emp.accountType != null &&
            emp.accountType!.toLowerCase().contains('corriente'))
        ? 'Corriente'
        : 'Ahorro';
    _accountNumberController = TextEditingController(
      text: emp.accountNumber ?? '',
    );

    // Inicializar Bloque E
    _notesController = TextEditingController(text: emp.observations ?? '');

    _loadCatalogs();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _childrenCountController.dispose();
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _afpNumberController.dispose();
    _accountNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    try {
      final repo = RrhhRepository.current;
      final results = await Future.wait([
        repo.listCatalogItems(RrhhCatalogType.afps),
        repo.listCatalogItems(RrhhCatalogType.healthInsurances),
        repo.listCatalogItems(RrhhCatalogType.banks),
      ]);

      if (mounted) {
        setState(() {
          _afps = results[0].where((e) => e.isActive).toList();
          _healthInsurances = results[1].where((e) => e.isActive).toList();
          _banks = results[2].where((e) => e.isActive).toList();
          _isLoadingCatalogs = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isLoadingCatalogs = false);
      }
    }
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);
    final repo = RrhhRepository.current;
    final emp = widget.employee;

    final newPhone = _phoneController.text.trim();
    final newEmail = _emailController.text.trim();
    final newAddress = _addressController.text.trim();
    final newChildrenCount = int.tryParse(_childrenCountController.text.trim());
    final newEmergencyName = _emergencyNameController.text.trim();
    final newEmergencyPhone = _emergencyPhoneController.text.trim();
    final newAfpNumber = _afpNumberController.text.trim();
    final newAccountNumber = _accountNumberController.text.trim();
    final newNotes = _notesController.text.trim();

    // 1. Detectar cambios específicos para trazabilidad
    final List<String> changeDetails = [];
    if (newPhone != emp.phone) {
      changeDetails.add('Teléfono cambiado de ${emp.phone} a $newPhone');
    }
    if (newEmail.isNotEmpty && newEmail != (emp.corporateEmail ?? '')) {
      changeDetails.add('Email actualizado');
    }
    if (newAddress.isNotEmpty &&
        newAddress != (emp.fullAddress ?? emp.address)) {
      changeDetails.add('Dirección actualizada');
    }
    if (_maritalStatus != emp.maritalStatus && _maritalStatus != null) {
      changeDetails.add('Estado civil: $_maritalStatus');
    }
    if (newChildrenCount != emp.childrenCount && newChildrenCount != null) {
      changeDetails.add('Hijos: $newChildrenCount');
    }
    if (newEmergencyPhone.isNotEmpty &&
        newEmergencyPhone != (emp.emergencyContactPhone ?? '')) {
      changeDetails.add('Contacto de emergencia actualizado');
    }
    if (_selectedAfpName != null && _selectedAfpName != emp.afpName) {
      changeDetails.add('AFP cambiada a $_selectedAfpName');
    }
    if (_selectedHealthInsurance != null &&
        _selectedHealthInsurance != emp.healthInsurance) {
      changeDetails.add('Seguro médico actualizado');
    }
    if (_selectedBankName != null && _selectedBankName != emp.bankName) {
      changeDetails.add('Banco actualizado a $_selectedBankName');
    }
    if (newAccountNumber.isNotEmpty &&
        newAccountNumber != (emp.accountNumber ?? '')) {
      changeDetails.add('Nº de cuenta bancaria actualizado');
    }

    try {
      final updated = emp.copyWith(
        phone: newPhone,
        corporateEmail: newEmail.isNotEmpty ? newEmail : emp.corporateEmail,
        address: newAddress.isNotEmpty ? newAddress : emp.address,
        fullAddress: newAddress.isNotEmpty ? newAddress : emp.fullAddress,
        maritalStatus: _maritalStatus,
        childrenCount: newChildrenCount,
        emergencyContactName: newEmergencyName.isNotEmpty
            ? newEmergencyName
            : null,
        emergencyContactPhone: newEmergencyPhone.isNotEmpty
            ? newEmergencyPhone
            : null,
        emergencyContactRelation: _emergencyRelation,
        afpName: _selectedAfpName,
        afpNumber: newAfpNumber.isNotEmpty ? newAfpNumber : null,
        healthInsurance: _selectedHealthInsurance,
        bankName: _selectedBankName,
        accountType: _accountType,
        accountNumber: newAccountNumber.isNotEmpty ? newAccountNumber : null,
        observations: newNotes.isNotEmpty ? newNotes : null,
        updatedAt: DateTime.now(),
      );

      await repo.updateEmployee(updated);

      // Registrar en bitácora de historial
      final now = DateTime.now();
      final userName = AuthService().currentDisplayName ?? 'Administrador';
      final formattedDate =
          '${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}';

      final desc = changeDetails.isNotEmpty
          ? 'Ficha actualizada — ${changeDetails.join(', ')} — $formattedDate por $userName'
          : 'Ficha actualizada el $formattedDate por $userName';

      final timelineEvent = RrhhTimelineEvent(
        employeeId: emp.id ?? 1,
        date: now,
        title: 'Ficha actualizada',
        description: desc,
        category: 'FICHA',
        registeredBy: userName,
        createdAt: now,
      );

      await repo.addTimelineEvent(timelineEvent);

      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        RrhhSnackBar.showError(context, 'Error al guardar cambios: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFF1E293B)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 820, maxHeight: 780),
        child: Column(
          children: [
            _buildHeader(),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            Expanded(
              child: _isLoadingCatalogs
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFF2563EB),
                        ),
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBlockA(),
                            const SizedBox(height: 20),
                            _buildBlockB(),
                            const SizedBox(height: 20),
                            _buildBlockC(),
                            const SizedBox(height: 20),
                            _buildBlockD(),
                            const SizedBox(height: 20),
                            _buildBlockE(),
                          ],
                        ),
                      ),
                    ),
            ),
            const Divider(height: 1, color: Color(0xFF1E293B)),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.3),
              ),
            ),
            child: const Icon(
              Icons.edit_note_outlined,
              color: Color(0xFF38BDF8),
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Editar Ficha — ${widget.employee.fullName}',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF8FAFC),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Solo se editan datos personales y de contacto. Los datos contractuales se modifican con el botón [Modificar Datos Contractuales].',
                  style: GoogleFonts.inter(
                    fontSize: 11.5,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(false),
            icon: const Icon(Icons.close, size: 20, color: Color(0xFF94A3B8)),
            tooltip: 'Cerrar',
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: const Color(0xFF38BDF8)),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF38BDF8),
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  // ── BLOQUE A: Datos Personales ──
  Widget _buildBlockA() {
    return _buildCardContainer(
      children: [
        _buildSectionTitle('BLOQUE A — DATOS PERSONALES', Icons.person_outline),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildTextField(
                controller: _phoneController,
                label: 'Teléfono / Celular *',
                hint: 'Ej: 77123456',
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'El teléfono es obligatorio';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 6,
              child: _buildTextField(
                controller: _emailController,
                label: 'Email personal (opcional)',
                hint: 'usuario@ejemplo.com',
                keyboardType: TextInputType.emailAddress,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _addressController,
          label: 'Dirección completa (opcional)',
          hint: 'Zona, calle, número de vivienda y referencia',
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _buildDropdown<String>(
                label: 'Estado civil (opcional)',
                value: _maritalStatus,
                hint: 'Seleccionar estado civil',
                items: _maritalStatusOptions
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _maritalStatus = val),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: _buildTextField(
                controller: _childrenCountController,
                label: 'Número de hijos (opcional)',
                hint: '0',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── BLOQUE B: Contacto de Emergencia ──
  Widget _buildBlockB() {
    return _buildCardContainer(
      children: [
        _buildSectionTitle(
          'BLOQUE B — CONTACTO DE EMERGENCIA',
          Icons.emergency_outlined,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: _buildTextField(
                controller: _emergencyNameController,
                label: 'Nombre del contacto (opcional)',
                hint: 'Ej: María Gonzales',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: _buildTextField(
                controller: _emergencyPhoneController,
                label: 'Teléfono del contacto (opcional)',
                hint: 'Ej: 78901234',
                keyboardType: TextInputType.phone,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: _buildDropdown<String>(
                label: 'Parentesco (opcional)',
                value: _emergencyRelation,
                hint: 'Seleccionar parentesco',
                items: _relationOptions
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) => setState(() => _emergencyRelation = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── BLOQUE C: Seguridad Social ──
  Widget _buildBlockC() {
    return _buildCardContainer(
      children: [
        _buildSectionTitle(
          'BLOQUE C — SEGURIDAD SOCIAL',
          Icons.health_and_safety_outlined,
        ),
        const SizedBox(height: 14),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 5,
              child: _buildDropdown<String>(
                label: 'AFP / Gestora (opcional)',
                value: _selectedAfpName,
                hint: 'Seleccionar AFP',
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      '(Ninguna seleccionada)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ..._afps.map(
                    (e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedAfpName = val),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 4,
              child: _buildTextField(
                controller: _afpNumberController,
                label: 'Nº asegurado AFP (opcional)',
                hint: 'Ej: GP-1234567',
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 5,
              child: _buildDropdown<String>(
                label: 'Caja médica / Seguro de salud',
                value: _selectedHealthInsurance,
                hint: 'Seleccionar caja o seguro',
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      '(Ninguno seleccionado)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ..._healthInsurances.map(
                    (e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) =>
                    setState(() => _selectedHealthInsurance = val),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── BLOQUE D: Datos Bancarios ──
  Widget _buildBlockD() {
    return _buildCardContainer(
      children: [
        _buildSectionTitle(
          'BLOQUE D — DATOS BANCARIOS',
          Icons.account_balance_outlined,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              flex: 5,
              child: _buildDropdown<String>(
                label: 'Banco (opcional)',
                value: _selectedBankName,
                hint: 'Seleccionar banco',
                items: [
                  const DropdownMenuItem(
                    value: null,
                    child: Text(
                      '(Sin banco asignado)',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ..._banks.map(
                    (e) => DropdownMenuItem(
                      value: e.name,
                      child: Text(e.name, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ],
                onChanged: (val) => setState(() => _selectedBankName = val),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 3,
              child: _buildDropdown<String>(
                label: 'Tipo de cuenta',
                value: _accountType,
                items: _accountTypeOptions
                    .map(
                      (e) => DropdownMenuItem(
                        value: e,
                        child: Text(e, overflow: TextOverflow.ellipsis),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _accountType = val);
                },
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              flex: 5,
              child: _buildTextField(
                controller: _accountNumberController,
                label: 'Número de cuenta (opcional)',
                hint: 'Ej: 10000012345678',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ── BLOQUE E: Notas Internas ──
  Widget _buildBlockE() {
    return _buildCardContainer(
      children: [
        _buildSectionTitle('BLOQUE E — NOTAS INTERNAS', Icons.notes_outlined),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _notesController,
          label: 'Notas internas / Observaciones de seguimiento (opcional)',
          hint:
              'Agrega anotaciones administrativas, seguimiento disciplinario o consideraciones especiales...',
          maxLines: 3,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              fontSize: 12.5,
              color: const Color(0xFF64748B),
            ),
            filled: true,
            fillColor: const Color(0xFF0F172A),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFEF4444)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    String? hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFFCBD5E1),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<T>(
          initialValue: value,
          isExpanded: true,
          items: items,
          onChanged: onChanged,
          hint: hint != null
              ? Text(
                  hint,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: GoogleFonts.inter(
                    fontSize: 12.5,
                    color: const Color(0xFF64748B),
                  ),
                )
              : null,
          dropdownColor: const Color(0xFF1E293B),
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF94A3B8)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF0F172A),
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 10,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFF334155)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: Color(0xFF2563EB),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF111827),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(14)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: _isSaving
                ? null
                : () => Navigator.of(context).pop(false),
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF94A3B8),
              side: const BorderSide(color: Color(0xFF334155)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
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
          const SizedBox(width: 12),
          ElevatedButton.icon(
            onPressed: _isSaving ? null : _handleSave,
            icon: _isSaving
                ? const SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.save_outlined, size: 16),
            label: Text(
              _isSaving ? 'Guardando...' : 'Guardar cambios',
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 11),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
