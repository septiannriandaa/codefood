// ignore_for_file: file_names

import 'dart:convert';

RecipesListModel recipesListModelFromJson(String str) =>
    RecipesListModel.fromJson(json.decode(str));

String recipesListModelToJson(RecipesListModel data) =>
    json.encode(data.toJson());

class RecipesListModel {
  RecipesListModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final RecipesList data;

  factory RecipesListModel.fromJson(Map<String, dynamic> json) =>
      RecipesListModel(
        success: json["success"],
        message: json["message"],
        data: RecipesList.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class RecipesList {
  RecipesList({
    required this.total,
    required this.recipes,
  });

  final int total;
  final List<Recipe> recipes;

  factory RecipesList.fromJson(Map<String, dynamic> json) => RecipesList(
        total: json["total"],
        recipes:
            List<Recipe>.from(json["recipes"].map((x) => Recipe.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "recipes": List<dynamic>.from(recipes.map((x) => x.toJson())),
      };
}

class Recipe {
  Recipe({
    required this.id,
    required this.name,
    required this.recipeCategoryId,
    required this.image,
    required this.nReactionLike,
    required this.nReactionNeutral,
    required this.nReactionDislike,
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
  final DateTime createdAt;
  final DateTime updatedAt;
  final RecipeCategory recipeCategory;

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
        id: json["id"],
        name: json["name"],
        recipeCategoryId: json["recipeCategoryId"],
        image: json["image"],
        nReactionLike: json["nReactionLike"],
        nReactionNeutral: json["nReactionNeutral"],
        nReactionDislike: json["nReactionDislike"],
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
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "recipeCategory": recipeCategory.toJson(),
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
