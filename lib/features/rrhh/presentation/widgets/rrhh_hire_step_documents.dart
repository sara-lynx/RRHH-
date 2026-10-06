import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'rrhh_hire_form_state.dart';
import 'rrhh_hire_ui_helpers.dart';

/// Paso 3 del Wizard: Datos Personales Obligatorios y Validación Documental Adaptativa (Opción C).
class RrhhHireStepDocuments extends StatefulWidget {
  final RrhhHireFormState formState;
  final VoidCallback onChanged;

  const RrhhHireStepDocuments({
    super.key,
    required this.formState,
    required this.onChanged,
  });

  @override
  State<RrhhHireStepDocuments> createState() => _RrhhHireStepDocumentsState();
}

class _RrhhHireStepDocumentsState extends State<RrhhHireStepDocuments> {
  late final TextEditingController _nameController;
  late final TextEditingController _ciController;
  late final TextEditingController _birthPlaceController;
  late final TextEditingController _phoneController;
  late final TextEditingController _addressController;
  late final TextEditingController _refPersonController;
  late final TextEditingController _refPhoneController;

  @override
  void initState() {
    super.initState();
    final f = widget.formState;
    _nameController = TextEditingController(text: f.fullName);
    _ciController = TextEditingController(text: f.identityCard);
    _birthPlaceController = TextEditingController(text: f.birthPlace);
    _phoneController = TextEditingController(text: f.phone);
    _addressController = TextEditingController(text: f.address);
    _refPersonController = TextEditingController(text: f.personalReference);
    _refPhoneController = TextEditingController(text: f.referencePhone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ciController.dispose();
    _birthPlaceController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _refPersonController.dispose();
    _refPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = widget.formState;
    final isCampo = form.employeeType == 'CAMPO';
    final isSecurity = form.isSecurityPosition();
    final isFelccMandatory = isCampo || isSecurity;
    final isFelccMissing = isFelccMandatory && !form.hasFelccRecord;

    final checkedCount = form.getCheckedRequiredDocsCount();
    final totalRequired = form.getTotalRequiredDocs();
    final allDocsValid = checkedCount >= totalRequired;

    final indicatorText = isCampo
        ? '$checkedCount de 6 documentos obligatorios para personal de campo'
        : (isSecurity
              ? '$checkedCount de 6 documentos requeridos (FELCC exigido para seguridad)'
              : '$checkedCount de 5 documentos requeridos para personal de oficina');

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildHireSectionHeader('SECCIÓN A — DATOS PERSONALES OBLIGATORIOS'),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 14) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 14,
                runSpacing: 14,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Nombre Completo *',
                      controller: _nameController,
                      icon: Icons.person_outline,
                      hint: 'Ej: Juan Pérez',
                      onChanged: (v) {
                        form.fullName = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Cédula de Identidad (CI) *',
                      controller: _ciController,
                      icon: Icons.badge_outlined,
                      hint: 'Ej: 5489623 SC',
                      onChanged: (v) {
                        form.identityCard = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDatePickerField(
                      context: context,
                      label: 'Fecha de Nacimiento',
                      currentDate: form.birthDate ?? DateTime(1995, 1, 1),
                      icon: Icons.cake_outlined,
                      firstDate: DateTime(1940),
                      lastDate: DateTime.now(),
                      onDateSelected: (d) {
                        form.birthDate = d;
                        widget.onChanged();
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Lugar de Nacimiento / Radicatoria *',
                      controller: _birthPlaceController,
                      icon: Icons.location_city_outlined,
                      hint: 'Ej: Santa Cruz',
                      onChanged: (v) {
                        form.birthPlace = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Teléfono Personal *',
                      controller: _phoneController,
                      icon: Icons.phone_outlined,
                      hint: 'Ej: 71023456',
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        form.phone = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Dirección Domiciliaria *',
                      controller: _addressController,
                      icon: Icons.home_outlined,
                      hint: 'Ej: B/ Las Palmas #12',
                      onChanged: (v) {
                        form.address = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Referencia Personal / Familiar *',
                      controller: _refPersonController,
                      icon: Icons.family_restroom_outlined,
                      hint: 'Ej: María Mendoza',
                      onChanged: (v) {
                        form.personalReference = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireInputField(
                      label: 'Teléfono de Referencia *',
                      controller: _refPhoneController,
                      icon: Icons.contact_phone_outlined,
                      hint: 'Ej: 78899001',
                      keyboardType: TextInputType.phone,
                      onChanged: (v) {
                        form.referencePhone = v;
                        widget.onChanged();
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          buildHireSectionHeader(
            'SECCIÓN B — VALIDACIÓN LEGAL DE DOCUMENTOS FÍSICOS',
          ),
          const SizedBox(height: 8),

          // Indicador de avance documental
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: allDocsValid
                  ? const Color(0xFF10B981).withValues(alpha: 0.12)
                  : const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: allDocsValid
                    ? const Color(0xFF10B981).withValues(alpha: 0.3)
                    : const Color(0xFF334155),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  allDocsValid
                      ? Icons.check_circle
                      : Icons.rule_folder_outlined,
                  size: 16,
                  color: allDocsValid
                      ? const Color(0xFF10B981)
                      : const Color(0xFF60A5FA),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    indicatorText,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: allDocsValid
                          ? const Color(0xFF34D399)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Banner de alerta si falta FELCC obligatorio
          if (isFelccMissing) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFDC2626).withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFDC2626).withValues(alpha: 0.4),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.gavel_outlined,
                    size: 18,
                    color: Color(0xFFF87171),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      isSecurity
                          ? 'BLOQUEO LEGAL: El puesto asignado es de Seguridad/Guardia. El Certificado FELCC es OBLIGATORIO por ley para formalizar la contratación.'
                          : 'REQUISITO OBLIGATORIO: Todo personal de campo operativo debe contar con Certificado FELCC verificado para ingresar a sedes de clientes.',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFFFCA5A5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],

          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 580;
              final colWidth = isWide
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;

              return Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Fotocopia de C.I.',
                      value: form.hasCiCopy,
                      onChanged: (v) {
                        form.hasCiCopy = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: 'OBLIGATORIO',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Certificado FELCC (Antecedentes)',
                      value: form.hasFelccRecord,
                      onChanged: (v) {
                        form.hasFelccRecord = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: isFelccMandatory
                          ? 'OBLIGATORIO'
                          : 'OPCIONAL (OFICINA)',
                      isWarningBorder: isFelccMissing,
                      isOptionalBadge: !isFelccMandatory,
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Factura de Luz o Agua (Domicilio)',
                      value: form.hasUtilityBill,
                      onChanged: (v) {
                        form.hasUtilityBill = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: 'OBLIGATORIO',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Croquis Domiciliario de Ubicación',
                      value: form.hasHomeSketch,
                      onChanged: (v) {
                        form.hasHomeSketch = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: 'OBLIGATORIO',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Fotografía 3x4 Fondo Rojo',
                      value: form.hasPhoto3x4,
                      onChanged: (v) {
                        form.hasPhoto3x4 = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: 'OBLIGATORIO',
                    ),
                  ),
                  SizedBox(
                    width: colWidth,
                    child: buildHireDocumentCheckTile(
                      label: 'Constancia Afiliación Seguro SUS',
                      value: form.hasSusInsurance,
                      onChanged: (v) {
                        form.hasSusInsurance = v ?? false;
                        widget.onChanged();
                        setState(() {});
                      },
                      badgeText: 'OBLIGATORIO',
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
