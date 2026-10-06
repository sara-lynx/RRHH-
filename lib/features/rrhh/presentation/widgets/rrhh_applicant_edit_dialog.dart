import 'package:elite_multiservicios_client/elite_multiservicios_client.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_companion.dart';
import '../../data/repositories/rrhh_repository.dart';
import 'rrhh_duplicate_applicant_dialog.dart';

/// Modal de Registro Inicial (Fase 1) de Postulantes.
/// Formulario conciso adaptado según el perfil (CAMPO u OFICINA)
/// con detección preventiva automática de duplicados por Cédula de Identidad (CI).
class RrhhApplicantEditDialog extends StatefulWidget {
  final RrhhApplicant? applicant;

  const RrhhApplicantEditDialog({super.key, this.applicant});

  static Future<bool?> show(BuildContext context, {RrhhApplicant? applicant}) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhApplicantEditDialog(applicant: applicant),
    );
  }

  @override
  State<RrhhApplicantEditDialog> createState() =>
      _RrhhApplicantEditDialogState();
}

class _RrhhApplicantEditDialogState extends State<RrhhApplicantEditDialog> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = true;
  bool _isSaving = false;
  String? _errorMsg;

  // Controladores Fase 1
  late final TextEditingController _nameCtrl;
  late final TextEditingController _ciCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;

  String _ciExt = 'SC';
  String _targetType = 'CAMPO'; // 'CAMPO' | 'OFICINA'
  DateTime? _birthDate;
  bool _showAdvancedSpecialty = false;

  List<RrhhArea> _allAreas = [];
  List<RrhhSpecialty> _allSpecialties = [];
  RrhhArea? _selectedArea;
  RrhhSpecialty? _selectedSpecialty;

  static const List<String> _ciExtList = [
    'SC',
    'LP',
    'CB',
    'OR',
    'PT',
    'TJ',
    'CH',
    'BE',
    'PD',
  ];

  @override
  void initState() {
    super.initState();
    final a = widget.applicant;
    _nameCtrl = TextEditingController(text: a?.fullName ?? '');

    final ciParts = (a?.identityCard ?? '').split(' ');
    _ciCtrl = TextEditingController(text: ciParts.isNotEmpty ? ciParts[0] : '');
    if (ciParts.length > 1 && _ciExtList.contains(ciParts[1].toUpperCase())) {
      _ciExt = ciParts[1].toUpperCase();
    }

    _phoneCtrl = TextEditingController(text: a?.phone ?? '');
    _emailCtrl = TextEditingController(text: a?.email ?? '');
    _targetType = a?.targetType ?? 'CAMPO';
    _birthDate = a?.birthDate;

    _loadCatalogs();
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ciCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _loadCatalogs() async {
    try {
      final repo = RrhhRepository.current;
      final areas = await repo.listAreas();
      final specs = await repo.listSpecialties();

      if (!mounted) return;
      setState(() {
        _allAreas = areas;
        _allSpecialties = specs;
        _syncDropdowns();
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMsg = 'Error al cargar catálogos: $e';
        _isLoading = false;
      });
    }
  }

  void _syncDropdowns() {
    final areas = _filteredAreas;
    if (widget.applicant != null) {
      _selectedArea =
          areas.where((a) => a.id == widget.applicant!.areaId).firstOrNull ??
          areas.firstOrNull;
    } else {
      _selectedArea = areas.firstOrNull;
    }

    final specs = _filteredSpecialties;
    if (widget.applicant != null) {
      _selectedSpecialty =
          specs
              .where((s) => s.id == widget.applicant!.specialtyId)
              .firstOrNull ??
          specs.firstOrNull;
    } else {
      _selectedSpecialty = specs.firstOrNull;
    }
  }

  List<RrhhArea> get _filteredAreas {
    if (_targetType == 'CAMPO') {
      return _allAreas
          .where(
            (a) =>
                a.name.toLowerCase().contains('operac') ||
                a.name.toLowerCase().contains('servici'),
          )
          .toList();
    } else {
      return _allAreas
          .where(
            (a) =>
                !a.name.toLowerCase().contains('operac') ||
                a.name.toLowerCase().contains('admin'),
          )
          .toList();
    }
  }

  List<RrhhSpecialty> get _filteredSpecialties {
    return _allSpecialties.where((s) => s.isActive).toList();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    if (_birthDate == null) {
      setState(() => _errorMsg = 'Debes ingresar la fecha de nacimiento.');
      return;
    }

    // Validación de edad mínima (18 años)
    final now = DateTime.now();
    final age =
        now.year -
        _birthDate!.year -
        ((now.month < _birthDate!.month ||
                (now.month == _birthDate!.month && now.day < _birthDate!.day))
            ? 1
            : 0);
    if (age < 18) {
      setState(
        () => _errorMsg =
            'El postulante debe ser mayor de edad (mínimo 18 años). Edad calculada: $age años.',
      );
      return;
    }

    if (_selectedArea == null) {
      setState(() => _errorMsg = 'Debes seleccionar el área aspirada.');
      return;
    }

    if (_targetType == 'CAMPO' && _selectedSpecialty == null) {
      setState(
        () => _errorMsg =
            'Para personal de CAMPO, la especialidad técnica es obligatoria.',
      );
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMsg = null;
    });

    try {
      final repo = RrhhRepository.current;
      final fullCi = '${_ciCtrl.text.trim()} $_ciExt';

      // CAMBIO 9: Detección automática por CI
      List<int> previousIds = [];
      if (widget.applicant == null) {
        final matches = await repo.findApplicantsByCi(fullCi);
        if (matches.isNotEmpty) {
          if (!mounted) return;
          final proceed = await RrhhDuplicateApplicantDialog.show(
            context,
            identityCard: fullCi,
            existingApplicants: matches,
          );

          if (proceed != true) {
            setState(() => _isSaving = false);
            return;
          }
          previousIds = matches
              .map((m) => m.id ?? 0)
              .where((id) => id > 0)
              .toList();
        }
      }

      final applicant = RrhhApplicant(
        id: widget.applicant?.id,
        code: widget.applicant?.code ?? '',
        fullName: _nameCtrl.text.trim(),
        identityCard: fullCi,
        phone: _phoneCtrl.text.trim(),
        email: _emailCtrl.text.trim().isEmpty ? null : _emailCtrl.text.trim(),
        birthDate: _birthDate,
        targetType: _targetType,
        targetArea: _selectedArea!.name,
        areaId: _selectedArea!.id,
        targetPosition: _selectedSpecialty?.name ?? _selectedArea!.name,
        positionId: 1,
        specialty: _selectedSpecialty?.name ?? 'General',
        specialtyId: _selectedSpecialty?.id,
        applicationDate: widget.applicant?.applicationDate ?? DateTime.now(),
        status: widget.applicant?.status ?? 'NUEVO',
        createdAt: widget.applicant?.createdAt ?? DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final companion = RrhhApplicantCompanion(
        applicantId: widget.applicant?.id ?? 0,
        previousApplicationIds: previousIds,
      );

      await repo.createApplicant(applicant, companion: companion);

      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMsg = 'Error al guardar postulante: $e';
          _isSaving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: _isLoading
              ? const SizedBox(
                  height: 200,
                  child: Center(
                    child: CircularProgressIndicator(color: Color(0xFF0284C7)),
                  ),
                )
              : Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              color: const Color(
                                0xFF0284C7,
                              ).withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(
                                  0xFF0284C7,
                                ).withValues(alpha: 0.3),
                              ),
                            ),
                            child: const Icon(
                              Icons.person_add_alt_1_outlined,
                              color: Color(0xFF38BDF8),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Registro Inicial de Postulante',
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Fase 1 — Datos mínimos esenciales de postulación',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF64748B),
                              size: 20,
                            ),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      if (_errorMsg != null) ...[
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFEF4444,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color(
                                0xFFEF4444,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: Color(0xFFEF4444),
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  _errorMsg!,
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: const Color(0xFFFCA5A5),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Selector de Tipo de Trabajador (CAMPO vs OFICINA)
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTypeButton(
                                type: 'CAMPO',
                                label: 'Operativo / Campo',
                                icon: Icons.engineering_outlined,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: _buildTypeButton(
                                type: 'OFICINA',
                                label: 'Administrativo / Oficina',
                                icon: Icons.badge_outlined,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Campos de Formulario
                      // Nombre Completo
                      _buildTextField(
                        controller: _nameCtrl,
                        label: 'NOMBRE COMPLETO *',
                        hint: 'Ej: Juan Carlos Pérez Mamani',
                        icon: Icons.person_outline,
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Ingresa el nombre completo.'
                            : null,
                      ),
                      const SizedBox(height: 12),

                      // CI y Teléfono
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _ciCtrl,
                              label: 'CÉDULA DE IDENTIDAD *',
                              hint: 'Ej: 8899001',
                              icon: Icons.credit_card_outlined,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Requerido.'
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('EXTENSIÓN *'),
                                DropdownButtonFormField<String>(
                                  initialValue: _ciExt,
                                  isExpanded: true,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                  decoration: _inputDecoration(),
                                  items: _ciExtList
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e,
                                          child: Text(e),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (v) {
                                    if (v != null) setState(() => _ciExt = v);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: _buildTextField(
                              controller: _phoneCtrl,
                              label: 'TELÉFONO / CELULAR *',
                              hint: 'Ej: 78912345',
                              icon: Icons.phone_outlined,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Requerido.'
                                  : null,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Email (Obligatorio para OFICINA, opcional para CAMPO) + Fecha de Nacimiento
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _emailCtrl,
                              label: _targetType == 'OFICINA'
                                  ? 'CORREO ELECTRÓNICO *'
                                  : 'CORREO ELECTRÓNICO (OPCIONAL)',
                              hint: 'ejemplo@correo.com',
                              icon: Icons.email_outlined,
                              validator: (v) {
                                if (_targetType == 'OFICINA' &&
                                    (v == null || v.trim().isEmpty)) {
                                  return 'El correo es obligatorio para personal de oficina.';
                                }
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('FECHA DE NACIMIENTO *'),
                                InkWell(
                                  onTap: () async {
                                    final d = await showDatePicker(
                                      context: context,
                                      initialDate:
                                          _birthDate ?? DateTime(2000, 1, 1),
                                      firstDate: DateTime(1950),
                                      lastDate: DateTime.now().subtract(
                                        const Duration(days: 365 * 18),
                                      ),
                                    );
                                    if (d != null)
                                      setState(() => _birthDate = d);
                                  },
                                  child: Container(
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1E293B),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                        color: const Color(0xFF334155),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          color: Color(0xFF38BDF8),
                                          size: 16,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          _birthDate == null
                                              ? 'Seleccionar fecha...'
                                              : '${_birthDate!.day.toString().padLeft(2, '0')}/${_birthDate!.month.toString().padLeft(2, '0')}/${_birthDate!.year}',
                                          style: GoogleFonts.inter(
                                            fontSize: 13,
                                            color: _birthDate == null
                                                ? const Color(0xFF64748B)
                                                : Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Área Aspirada y Especialidad
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _fieldLabel('ÁREA ASPIRADA *'),
                                DropdownButtonFormField<RrhhArea>(
                                  initialValue: _selectedArea,
                                  isExpanded: true,
                                  dropdownColor: const Color(0xFF1E293B),
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Colors.white,
                                  ),
                                  decoration: _inputDecoration(),
                                  items: _filteredAreas
                                      .map(
                                        (a) => DropdownMenuItem(
                                          value: a,
                                          child: Text(
                                            a.name,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (a) {
                                    setState(() {
                                      _selectedArea = a;
                                      final specs = _filteredSpecialties;
                                      _selectedSpecialty = specs.isNotEmpty
                                          ? specs.first
                                          : null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          if (_targetType == 'CAMPO' ||
                              _showAdvancedSpecialty) ...[
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _fieldLabel(
                                    _targetType == 'CAMPO'
                                        ? 'ESPECIALIDAD *'
                                        : 'ESPECIALIDAD (OPCIONAL)',
                                  ),
                                  DropdownButtonFormField<RrhhSpecialty>(
                                    initialValue: _selectedSpecialty,
                                    isExpanded: true,
                                    dropdownColor: const Color(0xFF1E293B),
                                    style: GoogleFonts.inter(
                                      fontSize: 13,
                                      color: Colors.white,
                                    ),
                                    decoration: _inputDecoration(),
                                    items: _filteredSpecialties
                                        .map(
                                          (s) => DropdownMenuItem(
                                            value: s,
                                            child: Text(
                                              s.name,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    onChanged: (s) =>
                                        setState(() => _selectedSpecialty = s),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),

                      if (_targetType == 'OFICINA' &&
                          !_showAdvancedSpecialty) ...[
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () =>
                              setState(() => _showAdvancedSpecialty = true),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFF38BDF8),
                                size: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Mostrar especialidad técnica avanzada',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: const Color(0xFF38BDF8),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 24),
                      // Acciones
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF94A3B8),
                              side: const BorderSide(color: Color(0xFF334155)),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isSaving
                                ? null
                                : () => Navigator.of(context).pop(false),
                            child: Text(
                              'Cancelar',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF0284C7),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: _isSaving ? null : _handleSave,
                            icon: _isSaving
                                ? const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.check, size: 16),
                            label: Text(
                              _isSaving
                                  ? 'Verificando...'
                                  : 'Registrar Postulante',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String type,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _targetType == type;
    return InkWell(
      onTap: () {
        if (_targetType != type) {
          setState(() {
            _targetType = type;
            _syncDropdowns();
          });
        }
      },
      borderRadius: BorderRadius.circular(6),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF0284C7) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : const Color(0xFF94A3B8),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? Colors.white : const Color(0xFF94A3B8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.6,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel(label),
        TextFormField(
          controller: controller,
          validator: validator,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
          decoration: _inputDecoration(
            hint: hint,
            prefixIcon: Icon(icon, color: const Color(0xFF38BDF8), size: 16),
          ),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      hintText: hint,
      prefixIcon: prefixIcon,
      hintStyle: GoogleFonts.inter(
        fontSize: 12,
        color: const Color(0xFF64748B),
      ),
      filled: true,
      fillColor: const Color(0xFF1E293B),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
        borderSide: const BorderSide(color: Color(0xFF0284C7)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFEF4444)),
      ),
    );
  }
}
