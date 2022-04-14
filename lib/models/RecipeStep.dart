// ignore_for_file: file_names

import 'dart:convert';

RecipeStepModel recipeStepModelFromJson(String str) =>
    RecipeStepModel.fromJson(json.decode(str));

String recipeStepModelToJson(RecipeStepModel data) =>
    json.encode(data.toJson());

class RecipeStepModel {
  RecipeStepModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final List<RecipeStepData> data;

  factory RecipeStepModel.fromJson(Map<String, dynamic> json) =>
      RecipeStepModel(
        success: json["success"],
        message: json["message"],
        data: List<RecipeStepData>.from(
            json["data"].map((x) => RecipeStepData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class RecipeStepData {
  RecipeStepData({
    required this.stepOrder,
    required this.description,
  });

  final int stepOrder;
  final String description;

  factory RecipeStepData.fromJson(Map<String, dynamic> json) => RecipeStepData(
        stepOrder: json["stepOrder"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "stepOrder": stepOrder,
        "description": description,
      };
}
