// ignore_for_file: file_names

import 'dart:convert';

List<HistoryElement> historyElementModelFromJson(json) =>
    List<HistoryElement>.from(json.map((x) => HistoryElement.fromJson(x)));
HistoryModel historyFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
    required this.success,
    required this.message,
    required this.data,
  });

  final bool success;
  final String message;
  final DataHistory data;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        success: json["success"],
        message: json["message"],
        data: DataHistory.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data.toJson(),
      };
}

class DataHistory {
  DataHistory({
    required this.total,
    required this.history,
  });

  final int total;
  final List<HistoryElement> history;

  factory DataHistory.fromJson(Map<String, dynamic> json) => DataHistory(
        total: json["total"],
        history: List<HistoryElement>.from(
            json["history"].map((x) => HistoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "history": List<dynamic>.from(history.map((x) => x.toJson())),
      };
}

class HistoryElement {
  HistoryElement({
    required this.id,
    required this.nServing,
    required this.reaction,
    required this.status,
    required this.recipeId,
    required this.recipeName,
    required this.recipeCategoryName,
    required this.recipeImage,
    required this.nStep,
    required this.nStepDone,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final int nServing;
  final String reaction;
  final String status;
  final int recipeId;
  final String recipeName;
  final String recipeCategoryName;
  final String recipeImage;
  final int nStep;
  final int nStepDone;
  final DateTime createdAt;
  final DateTime updatedAt;

  factory HistoryElement.fromJson(Map<String, dynamic> json) => HistoryElement(
        id: json["id"],
        nServing: json["nServing"],
        reaction: json["reaction"] ?? "",
        status: json["status"],
        recipeId: json["recipeId"],
        recipeName: json["recipeName"],
        recipeCategoryName: json["recipeCategoryName"],
        recipeImage: json["recipeImage"],
        nStep: json["nStep"],
        nStepDone: json["nStepDone"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nServing": nServing,
        "reaction": reaction,
        "status": status,
        "recipeId": recipeId,
        "recipeName": recipeName,
        "recipeCategoryName": recipeCategoryName,
        "recipeImage": recipeImage,
        "nStep": nStep,
        "nStepDone": nStepDone,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
