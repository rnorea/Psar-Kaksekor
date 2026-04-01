import 'package:flutter/material.dart';

enum UserRole { buyer, seller }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String location;
  final UserRole role;
  final String avatarInitial;

  // Seller-only fields
  final String? farmName;
  final String? produceType;
  final String? province;
  final bool isOrganic;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.role,
    required this.avatarInitial,
    this.farmName,
    this.produceType,
    this.province,
    this.isOrganic = false,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? location,
    UserRole? role,
    String? avatarInitial,
    String? farmName,
    String? produceType,
    String? province,
    bool? isOrganic,
  }) {
    return UserModel(
      id:            id            ?? this.id,
      name:          name          ?? this.name,
      email:         email         ?? this.email,
      phone:         phone         ?? this.phone,
      location:      location      ?? this.location,
      role:          role          ?? this.role,
      avatarInitial: avatarInitial ?? this.avatarInitial,
      farmName:      farmName      ?? this.farmName,
      produceType:   produceType   ?? this.produceType,
      province:      province      ?? this.province,
      isOrganic:     isOrganic     ?? this.isOrganic,
    );
  }
}