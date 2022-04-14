// ignore_for_file: file_names

import 'dart:convert';

RecipeDetailModel recipeDetailModelFromJson(String str) =>
    RecipeDetailModel.fromJson(json.decode(str));

String recipeDetailModelToJson(RecipeDetailModel data) =>
    json.encode(data.toJson());

class RecipeDetailModel {
  RecipeDetailModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final RecipeData data;

  factory RecipeDetailModel.fromJson(Map<String, dynamic> json) =>
      RecipeDetailModel(
        success: json["success"],
        message: json["message"],
        data: RecipeData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class RecipeData {
  RecipeData({
    required this.id,
    required this.name,
    required this.recipeCategoryId,
    required this.image,
    required this.nReactionLike,
    required this.nReactionNeutral,
    required this.nReactionDislike,
    required this.nServing,
    required this.ingredientsPerServing,
    required this.createdAt,
    required this.updatedAt,
    required this.recipeCategory,
  });

  final int id;
  final String name;
  final int recipeCategoryId;
  final String image;
  final int nReactionLike;
  final int nReactionNeutral;
  final int nReactionDislike;
  final int nServing;
  final List<IngredientsPerServing> ingredientsPerServing;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecipeCategory recipeCategory;

  factory RecipeData.fromJson(Map<String, dynamic> json) => RecipeData(
        id: json["id"],
        name: json["name"],
        recipeCategoryId: json["recipeCategoryId"],
        image: json["image"],
        nReactionLike: json["nReactionLike"],
        nReactionNeutral: json["nReactionNeutral"],
        nReactionDislike: json["nReactionDislike"],
        nServing: json["nServing"],
        ingredientsPerServing: List<IngredientsPerServing>.from(
            json["ingredientsPerServing"]
                .map((x) => IngredientsPerServing.fromJson(x))),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        recipeCategory: RecipeCategory.fromJson(json["recipeCategory"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "recipeCategoryId": recipeCategoryId,
        "image": image,
        "nReactionLike": nReactionLike,
        "nReactionNeutral": nReactionNeutral,
        "nReactionDislike": nReactionDislike,
        "nServing": nServing,
        "ingredientsPerServing":
            List<dynamic>.from(ingredientsPerServing.map((x) => x.toJson())),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "recipeCategory": recipeCategory.toJson(),
      };
}

class IngredientsPerServing {
  IngredientsPerServing({
    required this.item,
    required this.unit,
    required this.value,
  });

  final String item;
  final String unit;
  final double value;

  factory IngredientsPerServing.fromJson(Map<String, dynamic> json) =>
      IngredientsPerServing(
        item: json["item"],
        unit: json["unit"],
        value: json["value"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "item": item,
        "unit": unit,
        "value": value,
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
