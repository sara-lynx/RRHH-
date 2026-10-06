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
import '../../../modules/security/models/audit_log.dart' as _i2;
import 'package:elite_multiservicios_client/src/protocol/protocol.dart' as _i3;

abstract class AuditLogPageResponse implements _i1.SerializableModel {
  AuditLogPageResponse._({
    required this.items,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.pageSize,
  });

  factory AuditLogPageResponse({
    required List<_i2.AuditLog> items,
    required int totalCount,
    required int page,
    required int totalPages,
    required int pageSize,
  }) = _AuditLogPageResponseImpl;

  factory AuditLogPageResponse.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return AuditLogPageResponse(
      items: _i3.Protocol().deserialize<List<_i2.AuditLog>>(
        jsonSerialization['items'],
      ),
      totalCount: jsonSerialization['totalCount'] as int,
      page: jsonSerialization['page'] as int,
      totalPages: jsonSerialization['totalPages'] as int,
      pageSize: jsonSerialization['pageSize'] as int,
    );
  }

  List<_i2.AuditLog> items;

  int totalCount;

  int page;

  int totalPages;

  int pageSize;

  /// Returns a shallow copy of this [AuditLogPageResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  AuditLogPageResponse copyWith({
    List<_i2.AuditLog>? items,
    int? totalCount,
    int? page,
    int? totalPages,
    int? pageSize,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AuditLogPageResponse',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'totalCount': totalCount,
      'page': page,
      'totalPages': totalPages,
      'pageSize': pageSize,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _AuditLogPageResponseImpl extends AuditLogPageResponse {
  _AuditLogPageResponseImpl({
    required List<_i2.AuditLog> items,
    required int totalCount,
    required int page,
    required int totalPages,
    required int pageSize,
  }) : super._(
         items: items,
         totalCount: totalCount,
         page: page,
         totalPages: totalPages,
         pageSize: pageSize,
       );

  /// Returns a shallow copy of this [AuditLogPageResponse]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  AuditLogPageResponse copyWith({
    List<_i2.AuditLog>? items,
    int? totalCount,
    int? page,
    int? totalPages,
    int? pageSize,
  }) {
    return AuditLogPageResponse(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      totalCount: totalCount ?? this.totalCount,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}
