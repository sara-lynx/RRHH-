import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Resultado estructurado del modal de rechazo de candidatura.
class RrhhRejectionResult {
  final String reason;
  final String? detail;
  final bool isEligibleForRehire;

  const RrhhRejectionResult({
    required this.reason,
    this.detail,
    this.isEligibleForRehire = true,
  });

  String get fullReasonText {
    if (detail != null && detail!.trim().isNotEmpty) {
      return '$reason: ${detail!.trim()}';
    }
    return reason;
  }
}

/// Modal obligatorio para descartar / rechazar a un postulante en cualquier etapa.
class RrhhRejectionDialog extends StatefulWidget {
  final String applicantCode;
  final String applicantName;

  const RrhhRejectionDialog({
    super.key,
    required this.applicantCode,
    required this.applicantName,
  });

  static Future<RrhhRejectionResult?> show(
    BuildContext context, {
    required String applicantCode,
    required String applicantName,
  }) {
    return showDialog<RrhhRejectionResult>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhRejectionDialog(
        applicantCode: applicantCode,
        applicantName: applicantName,
      ),
    );
  }

  @override
  State<RrhhRejectionDialog> createState() => _RrhhRejectionDialogState();
}

class _RrhhRejectionDialogState extends State<RrhhRejectionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _detailCtrl = TextEditingController();

  static const List<String> _reasons = [
    'No cumple requisitos mínimos',
    'No se presentó a la entrevista',
    'No pasó la entrevista',
    'No pasó las pruebas técnicas',
    'Pretensión salarial fuera de rango',
    'Retiró su candidatura',
    'Otro',
  ];

  String _selectedReason = _reasons.first;
  bool _isEligibleForRehire = true;

  @override
  void dispose() {
    _detailCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.of(context).pop(
      RrhhRejectionResult(
        reason: _selectedReason,
        detail: _detailCtrl.text.trim().isEmpty
            ? null
            : _detailCtrl.text.trim(),
        isEligibleForRehire: _isEligibleForRehire,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOther = _selectedReason == 'Otro';

    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
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
                        color: const Color(0xFFEF4444).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.person_off_outlined,
                        color: Color(0xFFEF4444),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Descartar Candidatura',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${widget.applicantCode} • ${widget.applicantName}',
                            style: GoogleFonts.inter(
                              fontSize: 13,
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
                      onPressed: () => Navigator.of(context).pop(null),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Selector de motivo
                Text(
                  'MOTIVO DEL RECHAZO *',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  initialValue: _selectedReason,
                  dropdownColor: const Color(0xFF1E293B),
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.list_alt,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
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
                      borderSide: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                  ),
                  items: _reasons
                      .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedReason = val);
                  },
                ),
                const SizedBox(height: 14),

                // Detalle del motivo
                Text(
                  isOther
                      ? 'DETALLE DEL MOTIVO *'
                      : 'OBSERVACIONES O DETALLE (OPCIONAL)',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _detailCtrl,
                  maxLines: 3,
                  style: GoogleFonts.inter(fontSize: 13, color: Colors.white),
                  validator: (val) {
                    if (isOther && (val == null || val.trim().isEmpty)) {
                      return 'Por favor especifica el motivo del rechazo.';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: isOther
                        ? 'Explica claramente por qué se rechaza la postulación...'
                        : 'Notas adicionales sobre el descarte...',
                    hintStyle: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF64748B),
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    contentPadding: const EdgeInsets.all(12),
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
                      borderSide: const BorderSide(color: Color(0xFFEF4444)),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Checkbox elegible para rehire
                Material(
                  color: const Color(0xFF1E293B).withValues(alpha: 0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    child: CheckboxListTile(
                      value: _isEligibleForRehire,
                      contentPadding: EdgeInsets.zero,
                      dense: true,
                      activeColor: const Color(0xFF0284C7),
                      title: Text(
                        '¿Es elegible para re-postular en futuras convocatorias?',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        'Si se desmarca, se emitirá una alerta preventiva si vuelve a postular.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      onChanged: (val) =>
                          setState(() => _isEligibleForRehire = val ?? true),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                // Botones de acción
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
                      onPressed: () => Navigator.of(context).pop(null),
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
                        backgroundColor: const Color(0xFFDC2626),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _submit,
                      icon: const Icon(Icons.person_off, size: 16),
                      label: Text(
                        'Confirmar Rechazo',
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
}
