import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class CategoryModel extends Equatable {
  final String id;
  final String name;
  final String displayName;
  final IconData icon;
  final bool isActive;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.displayName,
    required this.icon,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, name, displayName, icon, isActive];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'displayName': displayName,
      'icon': icon.codePoint,
      'isActive': isActive,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] as String,
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      icon: IconData(map['icon'] as int, fontFamily: 'MaterialIcons'),
      isActive: map['isActive'] as bool? ?? true,
    );
  }

  CategoryModel copyWith({
    String? name,
    String? displayName,
    IconData? icon,
    bool? isActive,
  }) {
    return CategoryModel(
      id: id,
      name: name ?? this.name,
      displayName: displayName ?? this.displayName,
      icon: icon ?? this.icon,
      isActive: isActive ?? this.isActive,
    );
  }
}
