/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Documento de checklist de un expediente de contratación (FASE C).
abstract class RrhhDossierDocument implements _i1.SerializableModel {
  RrhhDossierDocument._({
    required this.code,
    required this.name,
    required this.isRequired,
    String? status,
    this.receivedAt,
    this.notes,
    this.scannedFileUrl,
    bool? validatedInRecruitment,
  }) : status = status ?? 'pendiente',
       validatedInRecruitment = validatedInRecruitment ?? false;

  factory RrhhDossierDocument({
    required String code,
    required String name,
    required bool isRequired,
    String? status,
    DateTime? receivedAt,
    String? notes,
    String? scannedFileUrl,
    bool? validatedInRecruitment,
  }) = _RrhhDossierDocumentImpl;

  factory RrhhDossierDocument.fromJson(Map<String, dynamic> jsonSerialization) {
    return RrhhDossierDocument(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      isRequired: _i1.BoolJsonExtension.fromJson(
        jsonSerialization['isRequired'],
      ),
      status: jsonSerialization['status'] as String?,
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      notes: jsonSerialization['notes'] as String?,
      scannedFileUrl: jsonSerialization['scannedFileUrl'] as String?,
      validatedInRecruitment:
          jsonSerialization['validatedInRecruitment'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(
              jsonSerialization['validatedInRecruitment'],
            ),
    );
  }

  /// Código identificador técnico del documento ('CI', 'FELCC', 'AVISO', etc.).
  String code;

  /// Nombre descriptivo legible del documento.
  String name;

  /// Si el documento es de presentación obligatoria para el cargo y tipo de puesto.
  bool isRequired;

  /// Estado: 'pendiente' | 'recibido' | 'validado' | 'rechazado'.
  String status;

  /// Fecha y hora en que se recibió formalmente el documento físico o digital.
  DateTime? receivedAt;

  /// Notas u observaciones del revisor.
  String? notes;

  /// URL del documento digitalizado o escaneado en el almacenamiento.
  String? scannedFileUrl;

  /// Indica si el documento ya fue validado en la etapa previa de reclutamiento.
  bool validatedInRecruitment;

  /// Returns a shallow copy of this [RrhhDossierDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhDossierDocument copyWith({
    String? code,
    String? name,
    bool? isRequired,
    String? status,
    DateTime? receivedAt,
    String? notes,
    String? scannedFileUrl,
    bool? validatedInRecruitment,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhDossierDocument',
      'code': code,
      'name': name,
      'isRequired': isRequired,
      'status': status,
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (notes != null) 'notes': notes,
      if (scannedFileUrl != null) 'scannedFileUrl': scannedFileUrl,
      'validatedInRecruitment': validatedInRecruitment,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhDossierDocumentImpl extends RrhhDossierDocument {
  _RrhhDossierDocumentImpl({
    required String code,
    required String name,
    required bool isRequired,
    String? status,
    DateTime? receivedAt,
    String? notes,
    String? scannedFileUrl,
    bool? validatedInRecruitment,
  }) : super._(
         code: code,
         name: name,
         isRequired: isRequired,
         status: status,
         receivedAt: receivedAt,
         notes: notes,
         scannedFileUrl: scannedFileUrl,
         validatedInRecruitment: validatedInRecruitment,
       );

  /// Returns a shallow copy of this [RrhhDossierDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhDossierDocument copyWith({
    String? code,
    String? name,
    bool? isRequired,
    String? status,
    Object? receivedAt = _Undefined,
    Object? notes = _Undefined,
    Object? scannedFileUrl = _Undefined,
    bool? validatedInRecruitment,
  }) {
    return RrhhDossierDocument(
      code: code ?? this.code,
      name: name ?? this.name,
      isRequired: isRequired ?? this.isRequired,
      status: status ?? this.status,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      notes: notes is String? ? notes : this.notes,
      scannedFileUrl: scannedFileUrl is String?
          ? scannedFileUrl
          : this.scannedFileUrl,
      validatedInRecruitment:
          validatedInRecruitment ?? this.validatedInRecruitment,
    );
  }
}
