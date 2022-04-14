// ignore_for_file: file_names

import 'dart:convert';

RecipeCategoryModel recipeCategoryModelFromJson(String str) =>
    RecipeCategoryModel.fromJson(jsonDecode(str));

String recipeCategoryModelToJson(RecipeCategoryModel data) =>
    json.encode(data.toJson());

class RecipeCategoryModel {
  RecipeCategoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<RecipeCategory> data;

  factory RecipeCategoryModel.fromJson(Map<String, dynamic> json) =>
      RecipeCategoryModel(
        success: json["success"],
        message: json["message"],
        data: List<RecipeCategory>.from(
            json["data"].map((x) => RecipeCategory.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RecipeCategory {
  RecipeCategory({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory RecipeCategory.fromJson(Map<String, dynamic> json) => RecipeCategory(
        id: json["id"],
        name: json["name"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
