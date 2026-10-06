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

/// Documento adjunto al expediente digital del empleado (CI, Finiquito, Contrato, etc.).
abstract class RrhhEmployeeDocument implements _i1.SerializableModel {
  RrhhEmployeeDocument._({
    this.id,
    required this.employeeId,
    required this.documentType,
    required this.title,
    required this.fileUrl,
    required this.fileName,
    int? fileSizeBytes,
    this.mimeType,
    bool? isVerified,
    this.verifiedBy,
    this.verifiedAt,
    bool? isDeleted,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  }) : fileSizeBytes = fileSizeBytes ?? 0,
       isVerified = isVerified ?? true,
       isDeleted = isDeleted ?? false;

  factory RrhhEmployeeDocument({
    int? id,
    required int employeeId,
    required String documentType,
    required String title,
    required String fileUrl,
    required String fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _RrhhEmployeeDocumentImpl;

  factory RrhhEmployeeDocument.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return RrhhEmployeeDocument(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      documentType: jsonSerialization['documentType'] as String,
      title: jsonSerialization['title'] as String,
      fileUrl: jsonSerialization['fileUrl'] as String,
      fileName: jsonSerialization['fileName'] as String,
      fileSizeBytes: jsonSerialization['fileSizeBytes'] as int?,
      mimeType: jsonSerialization['mimeType'] as String?,
      isVerified: jsonSerialization['isVerified'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isVerified']),
      verifiedBy: jsonSerialization['verifiedBy'] as String?,
      verifiedAt: jsonSerialization['verifiedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['verifiedAt']),
      isDeleted: jsonSerialization['isDeleted'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isDeleted']),
      deletedAt: jsonSerialization['deletedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['deletedAt']),
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
      updatedAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['updatedAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// Empleado al que pertenece el documento.
  int employeeId;

  /// Tipo de documento: 'CI', 'AVISO_LUZ_AGUA', 'CROQUIS', 'FELCC', 'FOTO', 'SEGURO_SUS', 'CONTRATO_FIRMADO', 'FINIQUITO', 'OTRO'.
  String documentType;

  /// Título descriptivo del documento.
  String title;

  /// Ruta o URL de almacenamiento del archivo.
  String fileUrl;

  /// Nombre original del archivo.
  String fileName;

  /// Tamaño del archivo en bytes.
  int? fileSizeBytes;

  /// Tipo MIME del archivo (ej: application/pdf, image/jpeg).
  String? mimeType;

  /// Estado de verificación por parte de RRHH.
  bool isVerified;

  /// Usuario que verificó el documento.
  String? verifiedBy;

  /// Fecha de verificación.
  DateTime? verifiedAt;

  /// Eliminación lógica y auditoría
  bool isDeleted;

  DateTime? deletedAt;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [RrhhEmployeeDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  RrhhEmployeeDocument copyWith({
    int? id,
    int? employeeId,
    String? documentType,
    String? title,
    String? fileUrl,
    String? fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'RrhhEmployeeDocument',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'documentType': documentType,
      'title': title,
      'fileUrl': fileUrl,
      'fileName': fileName,
      if (fileSizeBytes != null) 'fileSizeBytes': fileSizeBytes,
      if (mimeType != null) 'mimeType': mimeType,
      'isVerified': isVerified,
      if (verifiedBy != null) 'verifiedBy': verifiedBy,
      if (verifiedAt != null) 'verifiedAt': verifiedAt?.toJson(),
      'isDeleted': isDeleted,
      if (deletedAt != null) 'deletedAt': deletedAt?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _RrhhEmployeeDocumentImpl extends RrhhEmployeeDocument {
  _RrhhEmployeeDocumentImpl({
    int? id,
    required int employeeId,
    required String documentType,
    required String title,
    required String fileUrl,
    required String fileName,
    int? fileSizeBytes,
    String? mimeType,
    bool? isVerified,
    String? verifiedBy,
    DateTime? verifiedAt,
    bool? isDeleted,
    DateTime? deletedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         documentType: documentType,
         title: title,
         fileUrl: fileUrl,
         fileName: fileName,
         fileSizeBytes: fileSizeBytes,
         mimeType: mimeType,
         isVerified: isVerified,
         verifiedBy: verifiedBy,
         verifiedAt: verifiedAt,
         isDeleted: isDeleted,
         deletedAt: deletedAt,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [RrhhEmployeeDocument]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  RrhhEmployeeDocument copyWith({
    Object? id = _Undefined,
    int? employeeId,
    String? documentType,
    String? title,
    String? fileUrl,
    String? fileName,
    Object? fileSizeBytes = _Undefined,
    Object? mimeType = _Undefined,
    bool? isVerified,
    Object? verifiedBy = _Undefined,
    Object? verifiedAt = _Undefined,
    bool? isDeleted,
    Object? deletedAt = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RrhhEmployeeDocument(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      documentType: documentType ?? this.documentType,
      title: title ?? this.title,
      fileUrl: fileUrl ?? this.fileUrl,
      fileName: fileName ?? this.fileName,
      fileSizeBytes: fileSizeBytes is int? ? fileSizeBytes : this.fileSizeBytes,
      mimeType: mimeType is String? ? mimeType : this.mimeType,
      isVerified: isVerified ?? this.isVerified,
      verifiedBy: verifiedBy is String? ? verifiedBy : this.verifiedBy,
      verifiedAt: verifiedAt is DateTime? ? verifiedAt : this.verifiedAt,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt is DateTime? ? deletedAt : this.deletedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
