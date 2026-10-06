import 'package:elite_multiservicios_flutter/features/rrhh/presentation/widgets/rrhh_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/models/rrhh_applicant_companion.dart';

/// Modal para registrar o editar una entrevista formal con el postulante.
class RrhhInterviewRecordDialog extends StatefulWidget {
  final String applicantCode;
  final String applicantName;
  final RrhhInterviewRecord? initialRecord;

  const RrhhInterviewRecordDialog({
    super.key,
    required this.applicantCode,
    required this.applicantName,
    this.initialRecord,
  });

  static Future<RrhhInterviewRecord?> show(
    BuildContext context, {
    required String applicantCode,
    required String applicantName,
    RrhhInterviewRecord? initialRecord,
  }) {
    return showDialog<RrhhInterviewRecord>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RrhhInterviewRecordDialog(
        applicantCode: applicantCode,
        applicantName: applicantName,
        initialRecord: initialRecord,
      ),
    );
  }

  @override
  State<RrhhInterviewRecordDialog> createState() =>
      _RrhhInterviewRecordDialogState();
}

class _RrhhInterviewRecordDialogState extends State<RrhhInterviewRecordDialog> {
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate;
  late TimeOfDay _selectedTime;

  bool _interviewerDueno = false;
  bool _interviewerRrhh = true;
  bool _interviewerOther = false;
  final _otherInterviewerCtrl = TextEditingController();

  String _modality = 'Presencial';
  final List<String> _modalities = ['Presencial', 'Virtual', 'Telefónica'];

  final _notesCtrl = TextEditingController();
  String _result = 'Apto'; // 'Apto', 'No Apto', 'Dudoso'
  final _rejectionReasonCtrl = TextEditingController();
  final _attachedUrlCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final rec = widget.initialRecord;
    if (rec != null) {
      _selectedDate = rec.dateTime;
      _selectedTime = TimeOfDay.fromDateTime(rec.dateTime);
      _interviewerDueno = rec.interviewers.contains('Dueño');
      _interviewerRrhh = rec.interviewers.contains('Encargada de RRHH');
      final others = rec.interviewers
          .where((i) => i != 'Dueño' && i != 'Encargada de RRHH')
          .toList();
      if (others.isNotEmpty) {
        _interviewerOther = true;
        _otherInterviewerCtrl.text = others.join(', ');
      }
      _modality = rec.modality;
      _notesCtrl.text = rec.notes;
      _result = rec.result;
      _rejectionReasonCtrl.text = rec.rejectionReason ?? '';
      _attachedUrlCtrl.text = rec.attachedUrl ?? '';
    } else {
      _selectedDate = DateTime.now();
      _selectedTime = TimeOfDay.now();
    }
  }

  @override
  void dispose() {
    _otherInterviewerCtrl.dispose();
    _notesCtrl.dispose();
    _rejectionReasonCtrl.dispose();
    _attachedUrlCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    final interviewers = <String>[];
    if (_interviewerDueno) interviewers.add('Dueño');
    if (_interviewerRrhh) interviewers.add('Encargada de RRHH');
    if (_interviewerOther && _otherInterviewerCtrl.text.trim().isNotEmpty) {
      interviewers.add(_otherInterviewerCtrl.text.trim());
    }

    if (interviewers.isEmpty) {
      RrhhSnackBar.showError(
        context,
        'Debes seleccionar al menos un entrevistador',
      );
      return;
    }

    final combinedDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final record = RrhhInterviewRecord(
      dateTime: combinedDateTime,
      interviewers: interviewers,
      modality: _modality,
      notes: _notesCtrl.text.trim(),
      result: _result,
      rejectionReason: _result == 'No Apto'
          ? _rejectionReasonCtrl.text.trim()
          : null,
      attachedUrl: _attachedUrlCtrl.text.trim().isEmpty
          ? null
          : _attachedUrlCtrl.text.trim(),
    );

    Navigator.of(context).pop(record);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0F172A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFF334155)),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 620, maxHeight: 720),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
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
                        color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFF59E0B).withValues(alpha: 0.3),
                        ),
                      ),
                      child: const Icon(
                        Icons.record_voice_over_outlined,
                        color: Color(0xFFF59E0B),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Registro de Entrevista',
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
                const SizedBox(height: 16),

                // Form Scrollable Body
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Fecha y hora
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('FECHA DE ENTREVISTA *'),
                                  InkWell(
                                    onTap: () async {
                                      final d = await showDatePicker(
                                        context: context,
                                        initialDate: _selectedDate,
                                        firstDate: DateTime(2025),
                                        lastDate: DateTime(2030),
                                      );
                                      if (d != null)
                                        setState(() => _selectedDate = d);
                                    },
                                    child: _boxPicker(
                                      Icons.calendar_today_outlined,
                                      '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _label('HORA *'),
                                  InkWell(
                                    onTap: () async {
                                      final t = await showTimePicker(
                                        context: context,
                                        initialTime: _selectedTime,
                                      );
                                      if (t != null)
                                        setState(() => _selectedTime = t);
                                    },
                                    child: _boxPicker(
                                      Icons.access_time_outlined,
                                      '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Modalidad
                        _label('MODALIDAD *'),
                        Row(
                          children: _modalities.map((m) {
                            final isSel = _modality == m;
                            return Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: ChoiceChip(
                                label: Text(m),
                                selected: isSel,
                                selectedColor: const Color(
                                  0xFF0284C7,
                                ).withValues(alpha: 0.3),
                                backgroundColor: const Color(0xFF1E293B),
                                labelStyle: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: isSel
                                      ? FontWeight.w600
                                      : FontWeight.w400,
                                  color: isSel
                                      ? const Color(0xFF38BDF8)
                                      : const Color(0xFF94A3B8),
                                ),
                                side: BorderSide(
                                  color: isSel
                                      ? const Color(0xFF0284C7)
                                      : const Color(0xFF334155),
                                ),
                                onSelected: (sel) {
                                  if (sel) setState(() => _modality = m);
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 14),

                        // Entrevistadores (Multi-select)
                        _label('ENTREVISTADOR(ES) PARTICIPANTES *'),
                        Material(
                          color: const Color(0xFF1E293B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: const BorderSide(color: Color(0xFF334155)),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: CheckboxListTile(
                                        value: _interviewerDueno,
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: const Color(0xFF0284C7),
                                        title: Text(
                                          'Dueño',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onChanged: (v) => setState(
                                          () => _interviewerDueno = v ?? false,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: CheckboxListTile(
                                        value: _interviewerRrhh,
                                        dense: true,
                                        contentPadding: EdgeInsets.zero,
                                        activeColor: const Color(0xFF0284C7),
                                        title: Text(
                                          'Encargada de RRHH',
                                          style: GoogleFonts.inter(
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onChanged: (v) => setState(
                                          () => _interviewerRrhh = v ?? false,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                CheckboxListTile(
                                  value: _interviewerOther,
                                  dense: true,
                                  contentPadding: EdgeInsets.zero,
                                  activeColor: const Color(0xFF0284C7),
                                  title: Text(
                                    'Otro evaluador',
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onChanged: (v) => setState(
                                    () => _interviewerOther = v ?? false,
                                  ),
                                ),
                                if (_interviewerOther) ...[
                                  const SizedBox(height: 4),
                                  TextFormField(
                                    controller: _otherInterviewerCtrl,
                                    style: GoogleFonts.inter(
                                      fontSize: 12,
                                      color: Colors.white,
                                    ),
                                    decoration: InputDecoration(
                                      hintText:
                                          'Nombre y cargo del otro entrevistador...',
                                      hintStyle: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: const Color(0xFF64748B),
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFF0F172A),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 8,
                                          ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(6),
                                        borderSide: const BorderSide(
                                          color: Color(0xFF334155),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Notas de la entrevista
                        _label('NOTAS Y CONCLUSIONES DE LA ENTREVISTA *'),
                        TextFormField(
                          controller: _notesCtrl,
                          maxLines: 4,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) {
                              return 'Por favor registra las observaciones principales de la entrevista.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            hintText:
                                'Habilidades observadas, puntualidad, actitud, expectativas...',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                            contentPadding: const EdgeInsets.all(12),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF334155),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),

                        // Resultado de la entrevista
                        _label('RESULTADO FINAL DE LA ENTREVISTA *'),
                        Row(
                          children: [
                            _buildResultOption(
                              'Apto',
                              const Color(0xFF10B981),
                              Icons.check_circle_outline,
                            ),
                            const SizedBox(width: 8),
                            _buildResultOption(
                              'Dudoso',
                              const Color(0xFFF59E0B),
                              Icons.help_outline,
                            ),
                            const SizedBox(width: 8),
                            _buildResultOption(
                              'No Apto',
                              const Color(0xFFEF4444),
                              Icons.cancel_outlined,
                            ),
                          ],
                        ),

                        // Si es No Apto, motivo obligatorio
                        if (_result == 'No Apto') ...[
                          const SizedBox(height: 12),
                          _label('MOTIVO DE EVALUACIÓN NO APTO *'),
                          TextFormField(
                            controller: _rejectionReasonCtrl,
                            maxLines: 2,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white,
                            ),
                            validator: (val) {
                              if (_result == 'No Apto' &&
                                  (val == null || val.trim().isEmpty)) {
                                return 'Especifica obligatoriamente por qué se evaluó como No Apto.';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              hintText:
                                  'Detalla las deficiencias críticas o motivos de descarte...',
                              hintStyle: GoogleFonts.inter(
                                fontSize: 12,
                                color: const Color(0xFF64748B),
                              ),
                              filled: true,
                              fillColor: const Color(0xFF1E293B),
                              contentPadding: const EdgeInsets.all(12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Color(0xFFEF4444),
                                ),
                              ),
                            ),
                          ),
                        ],

                        const SizedBox(height: 14),
                        // Adjunto opcional
                        _label('DOCUMENTO / ENLACE ADJUNTO (OPCIONAL)'),
                        TextFormField(
                          controller: _attachedUrlCtrl,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Icons.link,
                              color: Color(0xFF64748B),
                              size: 16,
                            ),
                            hintText: 'https://storage/informe_entrevista.pdf',
                            hintStyle: GoogleFonts.inter(
                              fontSize: 12,
                              color: const Color(0xFF64748B),
                            ),
                            filled: true,
                            fillColor: const Color(0xFF1E293B),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF334155),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Color(0xFF334155),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),
                // Botones footer
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
                        backgroundColor: const Color(0xFF0284C7),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _save,
                      icon: const Icon(Icons.check, size: 16),
                      label: Text(
                        'Guardar Entrevista',
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

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  Widget _boxPicker(IconData icon, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF38BDF8), size: 16),
          const SizedBox(width: 8),
          Text(
            value,
            style: GoogleFonts.inter(fontSize: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildResultOption(String label, Color color, IconData icon) {
    final isSelected = _result == label;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _result = label),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withValues(alpha: 0.2)
                : const Color(0xFF1E293B),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? color : const Color(0xFF334155),
              width: isSelected ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? color : const Color(0xFF64748B),
                size: 16,
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
      ),
    );
  }
}
