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

abstract class HrAttendance implements _i1.SerializableModel {
  HrAttendance._({
    this.id,
    required this.employeeId,
    required this.date,
    this.checkIn,
    this.checkOut,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory HrAttendance({
    int? id,
    required int employeeId,
    required DateTime date,
    DateTime? checkIn,
    DateTime? checkOut,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrAttendanceImpl;

  factory HrAttendance.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrAttendance(
      id: jsonSerialization['id'] as int?,
      employeeId: jsonSerialization['employeeId'] as int,
      date: _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
      checkIn: jsonSerialization['checkIn'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkIn']),
      checkOut: jsonSerialization['checkOut'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['checkOut']),
      status: jsonSerialization['status'] as String,
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

  int employeeId;

  DateTime date;

  DateTime? checkIn;

  DateTime? checkOut;

  String status;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [HrAttendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrAttendance copyWith({
    int? id,
    int? employeeId,
    DateTime? date,
    DateTime? checkIn,
    DateTime? checkOut,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrAttendance',
      if (id != null) 'id': id,
      'employeeId': employeeId,
      'date': date.toJson(),
      if (checkIn != null) 'checkIn': checkIn?.toJson(),
      if (checkOut != null) 'checkOut': checkOut?.toJson(),
      'status': status,
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

class _HrAttendanceImpl extends HrAttendance {
  _HrAttendanceImpl({
    int? id,
    required int employeeId,
    required DateTime date,
    DateTime? checkIn,
    DateTime? checkOut,
    required String status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         employeeId: employeeId,
         date: date,
         checkIn: checkIn,
         checkOut: checkOut,
         status: status,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrAttendance]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrAttendance copyWith({
    Object? id = _Undefined,
    int? employeeId,
    DateTime? date,
    Object? checkIn = _Undefined,
    Object? checkOut = _Undefined,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrAttendance(
      id: id is int? ? id : this.id,
      employeeId: employeeId ?? this.employeeId,
      date: date ?? this.date,
      checkIn: checkIn is DateTime? ? checkIn : this.checkIn,
      checkOut: checkOut is DateTime? ? checkOut : this.checkOut,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
