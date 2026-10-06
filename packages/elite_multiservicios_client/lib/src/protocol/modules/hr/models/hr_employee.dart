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

abstract class HrEmployee implements _i1.SerializableModel {
  HrEmployee._({
    this.id,
    required this.name,
    required this.position,
    required this.baseSalary,
    required this.joinDate,
    bool? isActive,
    required this.createdAt,
    required this.updatedAt,
  }) : isActive = isActive ?? true;

  factory HrEmployee({
    int? id,
    required String name,
    required String position,
    required double baseSalary,
    required DateTime joinDate,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _HrEmployeeImpl;

  factory HrEmployee.fromJson(Map<String, dynamic> jsonSerialization) {
    return HrEmployee(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      position: jsonSerialization['position'] as String,
      baseSalary: (jsonSerialization['baseSalary'] as num).toDouble(),
      joinDate: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['joinDate'],
      ),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _i1.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
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

  String name;

  String position;

  double baseSalary;

  DateTime joinDate;

  bool isActive;

  DateTime createdAt;

  DateTime updatedAt;

  /// Returns a shallow copy of this [HrEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  HrEmployee copyWith({
    int? id,
    String? name,
    String? position,
    double? baseSalary,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'HrEmployee',
      if (id != null) 'id': id,
      'name': name,
      'position': position,
      'baseSalary': baseSalary,
      'joinDate': joinDate.toJson(),
      'isActive': isActive,
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

class _HrEmployeeImpl extends HrEmployee {
  _HrEmployeeImpl({
    int? id,
    required String name,
    required String position,
    required double baseSalary,
    required DateTime joinDate,
    bool? isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) : super._(
         id: id,
         name: name,
         position: position,
         baseSalary: baseSalary,
         joinDate: joinDate,
         isActive: isActive,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [HrEmployee]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  HrEmployee copyWith({
    Object? id = _Undefined,
    String? name,
    String? position,
    double? baseSalary,
    DateTime? joinDate,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return HrEmployee(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      baseSalary: baseSalary ?? this.baseSalary,
      joinDate: joinDate ?? this.joinDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
