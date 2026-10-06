import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Encabezado estándar para secciones de los pasos del Wizard de Contratación.
Widget buildHireSectionHeader(String title) {
  return Row(
    children: [
      Container(
        width: 3,
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB),
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 8),
      Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF94A3B8),
          letterSpacing: 0.6,
        ),
      ),
    ],
  );
}

/// Selector Dropdown estándar para formularios del Wizard.
Widget buildHireDropdownField<T>({
  required String label,
  required T? value,
  required List<DropdownMenuItem<T>> items,
  required IconData icon,
  required ValueChanged<T?> onChanged,
  String? hint,
  bool enabled = true,
}) {
  final hasMatch = items.any((item) => item.value == value);
  final safeValue = hasMatch ? value : null;
  final isSelectable = enabled && items.isNotEmpty;

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
      ),
      const SizedBox(height: 6),
      DropdownButtonFormField<T>(
        key: ValueKey(safeValue),
        initialValue: safeValue,
        items: items,
        onChanged: isSelectable ? onChanged : null,
        isExpanded: true,
        hint: hint != null
            ? Text(
                hint,
                style: GoogleFonts.inter(
                  fontSize: 12.5,
                  color: const Color(0xFF475569),
                ),
              )
            : null,
        dropdownColor: const Color(0xFF0F172A),
        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFF8FAFC)),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 16, color: const Color(0xFF64748B)),
          filled: true,
          fillColor: enabled
              ? const Color(0xFF111827)
              : const Color(0xFF0F172A),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1E293B)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1E293B)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
        ),
      ),
    ],
  );
}

/// Selector de fecha con DatePicker para el Wizard.
Widget buildHireDatePickerField({
  required BuildContext context,
  required String label,
  required DateTime currentDate,
  required IconData icon,
  required ValueChanged<DateTime> onDateSelected,
  DateTime? firstDate,
  DateTime? lastDate,
}) {
  final formatted =
      '${currentDate.day.toString().padLeft(2, '0')}/${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}';
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
      ),
      const SizedBox(height: 6),
      InkWell(
        onTap: () async {
          final effectiveFirst = firstDate ?? DateTime(1950);
          final effectiveLast = lastDate ?? DateTime(2035);
          DateTime effectiveInitial = currentDate;
          if (effectiveInitial.isBefore(effectiveFirst)) {
            effectiveInitial = effectiveFirst;
          } else if (effectiveInitial.isAfter(effectiveLast)) {
            effectiveInitial = effectiveLast;
          }
          final picked = await showDatePicker(
            context: context,
            initialDate: effectiveInitial,
            firstDate: effectiveFirst,
            lastDate: effectiveLast,
          );
          if (picked != null) onDateSelected(picked);
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: const Color(0xFF111827),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF1E293B)),
          ),
          child: Row(
            children: [
              Icon(icon, size: 16, color: const Color(0xFF64748B)),
              const SizedBox(width: 10),
              Text(
                formatted,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: const Color(0xFFF8FAFC),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.calendar_today_outlined,
                size: 15,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

/// Campo de texto de entrada estándar para el Wizard.
Widget buildHireInputField({
  required String label,
  required TextEditingController controller,
  required IconData icon,
  required ValueChanged<String> onChanged,
  String? hint,
  TextInputType? keyboardType,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11.5,
          fontWeight: FontWeight.w500,
          color: const Color(0xFF94A3B8),
        ),
      ),
      const SizedBox(height: 6),
      TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFF8FAFC)),
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, size: 16, color: const Color(0xFF64748B)),
          hintText: hint,
          hintStyle: GoogleFonts.inter(
            fontSize: 12.5,
            color: const Color(0xFF475569),
          ),
          filled: true,
          fillColor: const Color(0xFF111827),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1E293B)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1E293B)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF2563EB)),
          ),
        ),
      ),
    ],
  );
}

/// Tarjeta de checklist de verificación de documentos físicos.
Widget buildHireDocumentCheckTile({
  required String label,
  required bool value,
  required ValueChanged<bool?> onChanged,
  String badgeText = '',
  bool isWarningBorder = false,
  bool isOptionalBadge = false,
}) {
  return Material(
    color: const Color(0xFF111827),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: isWarningBorder
            ? const Color(0xFFDC2626)
            : (value
                  ? const Color(0xFF10B981).withValues(alpha: 0.3)
                  : const Color(0xFF1E293B)),
      ),
    ),
    clipBehavior: Clip.antiAlias,
    child: CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF10B981),
      dense: true,
      controlAffinity: ListTileControlAffinity.leading,
      title: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                fontWeight: value ? FontWeight.w600 : FontWeight.w400,
                color: value
                    ? const Color(0xFFF8FAFC)
                    : const Color(0xFF94A3B8),
              ),
            ),
          ),
          if (badgeText.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isWarningBorder
                    ? const Color(0xFFDC2626).withValues(alpha: 0.2)
                    : (isOptionalBadge
                          ? const Color(0xFF334155)
                          : const Color(0xFF10B981).withValues(alpha: 0.2)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 8.5,
                  fontWeight: FontWeight.w700,
                  color: isWarningBorder
                      ? const Color(0xFFF87171)
                      : (isOptionalBadge
                            ? const Color(0xFF94A3B8)
                            : const Color(0xFF34D399)),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

/// Barra de progreso del stepper de 3 pasos para el Wizard.
Widget buildHireStepperBar({
  required int currentStep,
  required ValueChanged<int> onStepTapped,
}) {
  const steps = [
    '1. Datos Laborales',
    '2. Contrato & Sueldo',
    '3. Validación Legal',
  ];
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
    color: const Color(0xFF0B1120),
    child: Row(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          final isPassed = currentStep > (index ~/ 2);
          return Expanded(
            child: Container(
              height: 2,
              color: isPassed
                  ? const Color(0xFF2563EB)
                  : const Color(0xFF1E293B),
            ),
          );
        }
        final stepIdx = index ~/ 2;
        final isActive = currentStep == stepIdx;
        final isCompleted = currentStep > stepIdx;

        return InkWell(
          onTap: isCompleted ? () => onStepTapped(stepIdx) : null,
          borderRadius: BorderRadius.circular(20),
          child: Row(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0xFF10B981)
                      : (isActive
                            ? const Color(0xFF2563EB)
                            : const Color(0xFF1E293B)),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: isCompleted
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : Text(
                          '${stepIdx + 1}',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isActive
                                ? Colors.white
                                : const Color(0xFF94A3B8),
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                steps[stepIdx],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: isActive
                      ? const Color(0xFFF8FAFC)
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        );
      }),
    ),
  );
}
